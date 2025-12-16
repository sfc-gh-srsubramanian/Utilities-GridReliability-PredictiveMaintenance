/*******************************************************************************
 * AI-DRIVEN GRID RELIABILITY & PREDICTIVE MAINTENANCE
 * ML Pipeline - Part 3: Model Training Stored Procedure
 * 
 * Purpose: Train ML models using Snowflake ML (Snowpark)
 * Models: XGBoost Classifier, Isolation Forest, Linear Regression
 * 
 * Note: This uses Snowflake's built-in ML capabilities
 * Requires Python 3.11 and Snowflake ML libraries
 * 
 * Author: Grid Reliability AI/ML Team
 * Date: 2025-11-15
 * Version: 1.0
 ******************************************************************************/

USE DATABASE UTILITIES_GRID_RELIABILITY;
USE WAREHOUSE GRID_RELIABILITY_WH;
USE SCHEMA ML;

-- =============================================================================
-- SECTION 1: MODEL TRAINING STORED PROCEDURE (Using Snowflake ML)
-- =============================================================================

CREATE OR REPLACE PROCEDURE TRAIN_FAILURE_PREDICTION_MODELS()
RETURNS VARCHAR
LANGUAGE PYTHON
RUNTIME_VERSION = '3.11'
PACKAGES = ('snowflake-snowpark-python', 'scikit-learn', 'xgboost', 'numpy', 'pandas')
HANDLER = 'train_models'
AS
$$
import snowflake.snowpark as snowpark
from snowflake.snowpark import functions as F
from sklearn.ensemble import IsolationForest, RandomForestClassifier
from xgboost import XGBClassifier
from sklearn.linear_model import LinearRegression
from sklearn.metrics import accuracy_score, precision_score, recall_score, f1_score, roc_auc_score, mean_absolute_error, mean_squared_error, r2_score
import json
import pickle
import base64
from datetime import datetime

def train_models(session: snowpark.Session) -> str:
    """
    Train ML models for transformer failure prediction
    
    Returns: JSON string with training results
    """
    
    results = {
        "status": "started",
        "timestamp": datetime.now().isoformat(),
        "models": {}
    }
    
    try:
        # =====================================================================
        # STEP 1: LOAD TRAINING DATA
        # =====================================================================
        
        training_df = session.table("ML.TRAINING_DATA")
        
        # Separate train and test sets
        train_data = training_df.filter(F.col("TRAINING_SET") == "TRAIN")
        test_data = training_df.filter(F.col("TRAINING_SET") == "TEST")
        
        # Convert to Pandas for sklearn
        train_pd = train_data.to_pandas()
        test_pd = test_data.to_pandas()
        
        # Extract features from VARIANT column
        feature_columns = [
            'oil_temp_avg', 'oil_temp_max', 'h2_avg', 'h2_max', 'vibration_avg',
            'load_util_avg', 'load_util_peak', 'thermal_rise_avg', 'combustible_gases',
            'operating_hours', 'asset_age_years', 'days_since_maintenance',
            'capacity_mva', 'criticality_score', 'customers_affected',
            'oil_quality_index', 'thermal_stress_index', 'electrical_stress_index',
            'mechanical_stress_index', 'maintenance_effectiveness', 'overall_health_index',
            'oil_temp_trend_pct', 'h2_trend_pct'
        ]
        
        # Parse features from JSON
        def extract_features(row):
            features = row['FEATURES']
            if isinstance(features, str):
                features = json.loads(features)
            return [features.get(col, 0) for col in feature_columns]
        
        X_train = train_pd.apply(extract_features, axis=1, result_type='expand')
        X_train.columns = feature_columns
        y_train = train_pd['FAILURE_WITHIN_30_DAYS'].astype(int)
        
        X_test = test_pd.apply(extract_features, axis=1, result_type='expand')
        X_test.columns = feature_columns
        y_test = test_pd['FAILURE_WITHIN_30_DAYS'].astype(int)
        
        results["training_records"] = len(X_train)
        results["test_records"] = len(X_test)
        results["failure_rate"] = float(y_train.mean())
        
        # =====================================================================
        # STEP 2: TRAIN XGBOOST CLASSIFIER (Failure Prediction)
        # =====================================================================
        
        # Calculate scale_pos_weight for imbalanced dataset
        scale_pos_weight = (y_train == 0).sum() / (y_train == 1).sum()
        
        xgb_model = XGBClassifier(
            n_estimators=100,
            max_depth=6,
            learning_rate=0.1,
            scale_pos_weight=scale_pos_weight,
            random_state=42,
            eval_metric='logloss'
        )
        
        xgb_model.fit(X_train, y_train)
        
        # Evaluate
        y_pred = xgb_model.predict(X_test)
        y_pred_proba = xgb_model.predict_proba(X_test)[:, 1]
        
        xgb_metrics = {
            "accuracy": float(accuracy_score(y_test, y_pred)),
            "precision": float(precision_score(y_test, y_pred, zero_division=0)),
            "recall": float(recall_score(y_test, y_pred, zero_division=0)),
            "f1_score": float(f1_score(y_test, y_pred, zero_division=0)),
            "roc_auc": float(roc_auc_score(y_test, y_pred_proba))
        }
        
        # Feature importance
        feature_importance = dict(zip(feature_columns, xgb_model.feature_importances_.tolist()))
        
        # Serialize model
        model_bytes = pickle.dumps(xgb_model)
        model_b64 = base64.b64encode(model_bytes).decode('utf-8')
        
        # Save to model registry
        model_id = f"XGB_CLASSIFIER_v{datetime.now().strftime('%Y%m%d_%H%M%S')}"
        
        session.sql(f"""
            INSERT INTO ML.MODEL_REGISTRY (
                MODEL_ID, MODEL_NAME, MODEL_TYPE, ALGORITHM, VERSION,
                TRAINING_DATE, MODEL_OBJECT, FEATURE_SCHEMA, HYPERPARAMETERS,
                TRAINING_METRICS, STATUS, CREATED_BY
            )
            VALUES (
                '{model_id}',
                'Transformer Failure Classifier',
                'CLASSIFICATION',
                'XGBoost',
                '1.0',
                CURRENT_TIMESTAMP(),
                '{model_b64}',
                PARSE_JSON('{json.dumps(feature_columns)}'),
                PARSE_JSON('{json.dumps({"n_estimators": 100, "max_depth": 6, "learning_rate": 0.1})}'),
                PARSE_JSON('{json.dumps(xgb_metrics)}'),
                'PRODUCTION',
                'TRAIN_PROCEDURE'
            )
        """).collect()
        
        # Save feature importance
        for feat, imp in feature_importance.items():
            session.sql(f"""
                INSERT INTO ML.FEATURE_IMPORTANCE (MODEL_ID, FEATURE_NAME, IMPORTANCE_SCORE, COMPUTATION_DATE)
                VALUES ('{model_id}', '{feat}', {imp}, CURRENT_DATE())
            """).collect()
        
        results["models"]["xgboost_classifier"] = {
            "model_id": model_id,
            "metrics": xgb_metrics,
            "status": "trained"
        }
        
        # =====================================================================
        # STEP 3: TRAIN ISOLATION FOREST (Anomaly Detection)
        # =====================================================================
        
        # Use only non-failure data for anomaly detection training
        X_train_normal = X_train[y_train == 0]
        
        iso_forest = IsolationForest(
            n_estimators=100,
            contamination=0.1,  # Assume 10% are anomalies
            random_state=42
        )
        
        iso_forest.fit(X_train_normal)
        
        # Predict anomaly scores (-1 = anomaly, 1 = normal)
        anomaly_pred = iso_forest.predict(X_test)
        anomaly_scores = iso_forest.score_samples(X_test)
        
        # Normalize scores to 0-1 range (higher = more anomalous)
        anomaly_scores_normalized = 1 - ((anomaly_scores - anomaly_scores.min()) / (anomaly_scores.max() - anomaly_scores.min()))
        
        # Evaluate (treat failures as anomalies)
        iso_accuracy = float(accuracy_score(y_test, (anomaly_pred == -1).astype(int)))
        
        iso_metrics = {
            "accuracy": iso_accuracy,
            "avg_anomaly_score": float(anomaly_scores_normalized.mean())
        }
        
        # Serialize model
        model_bytes = pickle.dumps(iso_forest)
        model_b64 = base64.b64encode(model_bytes).decode('utf-8')
        
        model_id = f"ISO_FOREST_v{datetime.now().strftime('%Y%m%d_%H%M%S')}"
        
        session.sql(f"""
            INSERT INTO ML.MODEL_REGISTRY (
                MODEL_ID, MODEL_NAME, MODEL_TYPE, ALGORITHM, VERSION,
                TRAINING_DATE, MODEL_OBJECT, FEATURE_SCHEMA, HYPERPARAMETERS,
                TRAINING_METRICS, STATUS, CREATED_BY
            )
            VALUES (
                '{model_id}',
                'Transformer Anomaly Detector',
                'ANOMALY',
                'IsolationForest',
                '1.0',
                CURRENT_TIMESTAMP(),
                '{model_b64}',
                PARSE_JSON('{json.dumps(feature_columns)}'),
                PARSE_JSON('{json.dumps({"n_estimators": 100, "contamination": 0.1})}'),
                PARSE_JSON('{json.dumps(iso_metrics)}'),
                'PRODUCTION',
                'TRAIN_PROCEDURE'
            )
        """).collect()
        
        results["models"]["isolation_forest"] = {
            "model_id": model_id,
            "metrics": iso_metrics,
            "status": "trained"
        }
        
        # =====================================================================
        # STEP 4: TRAIN LINEAR REGRESSION (RUL Prediction)
        # =====================================================================
        
        # Use only failure samples for RUL prediction
        train_failures = train_pd[train_pd['FAILURE_WITHIN_30_DAYS'] == True]
        test_failures = test_pd[test_pd['FAILURE_WITHIN_30_DAYS'] == True]
        
        if len(train_failures) > 10 and len(test_failures) > 5:
            X_train_rul = train_failures.apply(extract_features, axis=1, result_type='expand')
            X_train_rul.columns = feature_columns
            y_train_rul = train_failures['DAYS_TO_FAILURE']
            
            X_test_rul = test_failures.apply(extract_features, axis=1, result_type='expand')
            X_test_rul.columns = feature_columns
            y_test_rul = test_failures['DAYS_TO_FAILURE']
            
            lr_model = LinearRegression()
            lr_model.fit(X_train_rul, y_train_rul)
            
            y_pred_rul = lr_model.predict(X_test_rul)
            
            lr_metrics = {
                "mae": float(mean_absolute_error(y_test_rul, y_pred_rul)),
                "rmse": float(mean_squared_error(y_test_rul, y_pred_rul, squared=False)),
                "r2_score": float(r2_score(y_test_rul, y_pred_rul))
            }
            
            # Serialize model
            model_bytes = pickle.dumps(lr_model)
            model_b64 = base64.b64encode(model_bytes).decode('utf-8')
            
            model_id = f"LINEAR_RUL_v{datetime.now().strftime('%Y%m%d_%H%M%S')}"
            
            session.sql(f"""
                INSERT INTO ML.MODEL_REGISTRY (
                    MODEL_ID, MODEL_NAME, MODEL_TYPE, ALGORITHM, VERSION,
                    TRAINING_DATE, MODEL_OBJECT, FEATURE_SCHEMA, HYPERPARAMETERS,
                    TRAINING_METRICS, STATUS, CREATED_BY
                )
                VALUES (
                    '{model_id}',
                    'Transformer RUL Predictor',
                    'REGRESSION',
                    'LinearRegression',
                    '1.0',
                    CURRENT_TIMESTAMP(),
                    '{model_b64}',
                    PARSE_JSON('{json.dumps(feature_columns)}'),
                    PARSE_JSON('{{}}'),
                    PARSE_JSON('{json.dumps(lr_metrics)}'),
                    'PRODUCTION',
                    'TRAIN_PROCEDURE'
                )
            """).collect()
            
            results["models"]["linear_rul"] = {
                "model_id": model_id,
                "metrics": lr_metrics,
                "status": "trained"
            }
        else:
            results["models"]["linear_rul"] = {
                "status": "skipped",
                "reason": "insufficient failure samples"
            }
        
        # =====================================================================
        # FINALIZE
        # =====================================================================
        
        results["status"] = "completed"
        results["completion_time"] = datetime.now().isoformat()
        
        return json.dumps(results, indent=2)
        
    except Exception as e:
        results["status"] = "failed"
        results["error"] = str(e)
        return json.dumps(results, indent=2)

$$;

-- =============================================================================
-- SECTION 2: EXECUTE MODEL TRAINING
-- =============================================================================

-- Execute the training procedure
CALL TRAIN_FAILURE_PREDICTION_MODELS();

-- =============================================================================
-- SECTION 3: VIEW TRAINED MODELS
-- =============================================================================

-- Show all models in registry
SELECT 
    MODEL_ID,
    MODEL_NAME,
    MODEL_TYPE,
    ALGORITHM,
    VERSION,
    TRAINING_DATE,
    STATUS,
    TRAINING_METRICS
FROM MODEL_REGISTRY
WHERE STATUS = 'PRODUCTION'
ORDER BY TRAINING_DATE DESC;

-- Show feature importance for latest XGBoost model
SELECT 
    fi.FEATURE_NAME,
    ROUND(fi.IMPORTANCE_SCORE, 4) as IMPORTANCE_SCORE,
    fi.IMPORTANCE_RANK
FROM FEATURE_IMPORTANCE fi
JOIN MODEL_REGISTRY mr ON fi.MODEL_ID = mr.MODEL_ID
WHERE mr.ALGORITHM = 'XGBoost' 
  AND mr.STATUS = 'PRODUCTION'
ORDER BY fi.IMPORTANCE_SCORE DESC
LIMIT 10;

-- =============================================================================
-- SCRIPT COMPLETE
-- =============================================================================

SELECT 'Model training complete!' as STATUS;
SELECT 'Models trained: XGBoost Classifier, Isolation Forest, Linear RUL' as MODELS;
SELECT 'Check MODEL_REGISTRY table for details' as REGISTRY;
SELECT 'Next Step: Run 04_model_scoring.sql to generate predictions' as NEXT_STEP;


