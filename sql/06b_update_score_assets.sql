/*******************************************************************************
 * UPDATE SCORE_ASSETS PROCEDURE
 * Fix column name handling for predictions
 *******************************************************************************/

USE DATABASE UTILITIES_GRID_RELIABILITY;
USE SCHEMA ML;

CREATE OR REPLACE PROCEDURE SCORE_ASSETS()
RETURNS VARCHAR
LANGUAGE PYTHON
RUNTIME_VERSION = '3.11'
PACKAGES = ('snowflake-snowpark-python', 'scikit-learn', 'xgboost', 'numpy', 'pandas')
HANDLER = 'score_assets'
AS
$$
import snowflake.snowpark as snowpark
import json
import pickle
import base64
from datetime import datetime
import numpy as np

def score_assets(session: snowpark.Session) -> str:
    results = {
        "status": "started",
        "timestamp": datetime.now().isoformat(),
        "assets_scored": 0
    }
    
    try:
        # STEP 1: LOAD MODELS
        models_df = session.sql("""
            SELECT MODEL_ID, ALGORITHM, MODEL_OBJECT, FEATURE_SCHEMA
            FROM ML.MODEL_REGISTRY
            WHERE STATUS = 'PRODUCTION'
            ORDER BY TRAINING_DATE DESC
        """).to_pandas()
        
        xgb_model = None
        iso_model = None
        rul_model = None
        feature_columns = None
        
        for _, row in models_df.iterrows():
            model = pickle.loads(base64.b64decode(row['MODEL_OBJECT']))
            feature_columns = json.loads(row['FEATURE_SCHEMA'])
            
            if row['ALGORITHM'] == 'XGBoost':
                xgb_model = model
                xgb_model_id = row['MODEL_ID']
            elif row['ALGORITHM'] == 'IsolationForest':
                iso_model = model
                iso_model_id = row['MODEL_ID']
            elif row['ALGORITHM'] == 'LinearRegression':
                rul_model = model
                rul_model_id = row['MODEL_ID']
        
        if not xgb_model or not iso_model:
            return json.dumps({"status": "error", "message": "Required models not found"})
        
        # STEP 2: GET FEATURES (using latest available date)
        features_df = session.sql("""
            WITH latest_date AS (
                SELECT MAX(FEATURE_DATE) as MAX_DATE
                FROM ML.VW_ASSET_FEATURES_DAILY
            )
            SELECT 
                di.ASSET_ID,
                df.OIL_TEMP_DAILY_AVG as oil_temp_avg,
                df.OIL_TEMP_DAILY_MAX as oil_temp_max,
                df.H2_DAILY_AVG as h2_avg,
                df.H2_DAILY_MAX as h2_max,
                df.VIBRATION_DAILY_AVG as vibration_avg,
                df.LOAD_UTILIZATION_DAILY_AVG as load_util_avg,
                df.LOAD_UTILIZATION_DAILY_PEAK as load_util_peak,
                df.THERMAL_RISE_DAILY_AVG as thermal_rise_avg,
                df.COMBUSTIBLE_GASES_DAILY_AVG as combustible_gases,
                df.OPERATING_HOURS as operating_hours,
                df.ASSET_AGE_YEARS as asset_age_years,
                df.DAYS_SINCE_MAINTENANCE as days_since_maintenance,
                df.CAPACITY_MVA as capacity_mva,
                df.CRITICALITY_SCORE as criticality_score,
                df.CUSTOMERS_AFFECTED as customers_affected,
                di.OIL_QUALITY_INDEX as oil_quality_index,
                di.THERMAL_STRESS_INDEX as thermal_stress_index,
                di.ELECTRICAL_STRESS_INDEX as electrical_stress_index,
                di.MECHANICAL_STRESS_INDEX as mechanical_stress_index,
                di.MAINTENANCE_EFFECTIVENESS as maintenance_effectiveness,
                di.OVERALL_HEALTH_INDEX as overall_health_index,
                di.OIL_TEMP_TREND_PCT as oil_temp_trend_pct,
                di.H2_TREND_PCT as h2_trend_pct,
                ld.MAX_DATE as prediction_date
            FROM ML.VW_DEGRADATION_INDICATORS di
            JOIN ML.VW_ASSET_FEATURES_DAILY df 
                ON di.ASSET_ID = df.ASSET_ID 
                AND di.INDICATOR_DATE = df.FEATURE_DATE
            CROSS JOIN latest_date ld
            WHERE di.INDICATOR_DATE = ld.MAX_DATE
              AND df.ASSET_ID IN (SELECT ASSET_ID FROM RAW.ASSET_MASTER WHERE STATUS = 'ACTIVE')
        """).to_pandas()
        
        if len(features_df) == 0:
            return json.dumps({"status": "error", "message": "No features found"})
        
        # Snowflake returns column names in UPPERCASE, so convert to lowercase
        features_df.columns = features_df.columns.str.lower()
        
        # Use feature columns
        X = features_df[feature_columns].fillna(0)
        
        # STEP 3: GENERATE PREDICTIONS
        failure_prob = xgb_model.predict_proba(X)[:, 1]
        anomaly_scores_raw = iso_model.score_samples(X)
        anomaly_scores = 1 - ((anomaly_scores_raw - anomaly_scores_raw.min()) / 
                              (anomaly_scores_raw.max() - anomaly_scores_raw.min() + 0.0001))
        
        if rul_model:
            rul_predictions = rul_model.predict(X)
            rul_predictions = np.clip(rul_predictions, 1, 365)
        else:
            rul_predictions = 30 * (1 - failure_prob)
        
        # STEP 4: COMPOSITE RISK SCORE
        risk_scores = (
            anomaly_scores * 30 +
            failure_prob * 50 +
            ((365 - rul_predictions) / 365) * 20
        ) * 100
        risk_scores = np.clip(risk_scores, 0, 100)
        
        confidence_scores = 1 - np.minimum(np.abs(anomaly_scores - failure_prob), 1.0)
        
        # STEP 5: SAVE PREDICTIONS
        session.sql("TRUNCATE TABLE ML.MODEL_PREDICTIONS").collect()
        
        for idx, row in features_df.iterrows():
            alert_level = 'CRITICAL' if risk_scores[idx] >= 75 else 'HIGH' if risk_scores[idx] >= 50 else 'MEDIUM' if risk_scores[idx] >= 25 else 'LOW'
            alert_generated = True if risk_scores[idx] >= 50 else False
            
            session.sql(f"""
                INSERT INTO ML.MODEL_PREDICTIONS (
                    ASSET_ID, PREDICTION_TIMESTAMP, MODEL_ID,
                    ANOMALY_SCORE, FAILURE_PROBABILITY, PREDICTED_RUL_DAYS,
                    RISK_SCORE, CONFIDENCE, ALERT_GENERATED, ALERT_LEVEL
                )
                VALUES (
                    '{row['asset_id']}',
                    '{row['prediction_date']}',
                    '{xgb_model_id}',
                    {anomaly_scores[idx]},
                    {failure_prob[idx]},
                    {rul_predictions[idx]},
                    {risk_scores[idx]},
                    {confidence_scores[idx]},
                    {alert_generated},
                    '{alert_level}'
                )
            """).collect()
        
        results["status"] = "success"
        results["assets_scored"] = len(features_df)
        results["high_risk_count"] = int((risk_scores >= 50).sum())
        
    except Exception as e:
        results["status"] = "failed"
        results["error"] = str(e)
    
    return json.dumps(results)
$$;

-- Test the procedure
SELECT 'SCORE_ASSETS procedure updated!' AS STATUS;

