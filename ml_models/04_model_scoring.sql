/*******************************************************************************
 * AI-DRIVEN GRID RELIABILITY & PREDICTIVE MAINTENANCE
 * ML Pipeline - Part 4: Model Scoring (Inference)
 * 
 * Purpose: Apply trained models to current asset data to generate predictions
 * Generates risk scores and alerts for high-risk assets
 * 
 * Author: Grid Reliability AI/ML Team
 * Date: 2025-11-15
 * Version: 1.0
 ******************************************************************************/

USE DATABASE UTILITIES_GRID_RELIABILITY;
USE WAREHOUSE GRID_RELIABILITY_WH;
USE SCHEMA ML;

-- =============================================================================
-- SECTION 1: MODEL SCORING STORED PROCEDURE
-- =============================================================================

CREATE OR REPLACE PROCEDURE SCORE_ASSETS()
RETURNS VARCHAR
LANGUAGE PYTHON
RUNTIME_VERSION = '3.11'
PACKAGES = ('snowflake-snowpark-python', 'scikit-learn', 'xgboost', 'numpy', 'pandas')
HANDLER = 'score_assets'
AS
$$
import snowflake.snowpark as snowpark
from snowflake.snowpark import functions as F
import json
import pickle
import base64
from datetime import datetime
import numpy as np

def score_assets(session: snowpark.Session) -> str:
    """
    Score all active assets using trained models
    
    Returns: JSON string with scoring results
    """
    
    results = {
        "status": "started",
        "timestamp": datetime.now().isoformat(),
        "assets_scored": 0
    }
    
    try:
        # =====================================================================
        # STEP 1: LOAD PRODUCTION MODELS
        # =====================================================================
        
        # Get latest production models
        models_df = session.sql("""
            SELECT MODEL_ID, MODEL_TYPE, ALGORITHM, MODEL_OBJECT, FEATURE_SCHEMA
            FROM ML.MODEL_REGISTRY
            WHERE STATUS = 'PRODUCTION'
            ORDER BY TRAINING_DATE DESC
        """).to_pandas()
        
        # Load models by type
        xgb_model = None
        iso_model = None
        rul_model = None
        feature_columns = None
        
        for _, row in models_df.iterrows():
            model_bytes = base64.b64decode(row['MODEL_OBJECT'])
            model = pickle.loads(model_bytes)
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
        
        # =====================================================================
        # STEP 2: GET CURRENT ASSET FEATURES
        # =====================================================================
        
        # Get latest features for all active assets
        features_df = session.sql("""
            SELECT 
                di.ASSET_ID,
                di.OIL_QUALITY_INDEX,
                di.THERMAL_STRESS_INDEX,
                di.ELECTRICAL_STRESS_INDEX,
                di.MECHANICAL_STRESS_INDEX,
                di.MAINTENANCE_EFFECTIVENESS,
                di.OVERALL_HEALTH_INDEX,
                di.OIL_TEMP_TREND_PCT,
                di.H2_TREND_PCT,
                df.OIL_TEMP_DAILY_AVG,
                df.OIL_TEMP_DAILY_MAX,
                df.H2_DAILY_AVG,
                df.H2_DAILY_MAX,
                df.VIBRATION_DAILY_AVG,
                df.LOAD_UTILIZATION_DAILY_AVG,
                df.LOAD_UTILIZATION_DAILY_PEAK,
                df.THERMAL_RISE_DAILY_AVG,
                df.COMBUSTIBLE_GASES_DAILY_AVG,
                df.OPERATING_HOURS,
                df.ASSET_AGE_YEARS,
                df.DAYS_SINCE_MAINTENANCE,
                df.CAPACITY_MVA,
                df.CRITICALITY_SCORE,
                df.CUSTOMERS_AFFECTED
            FROM ML.VW_DEGRADATION_INDICATORS di
            JOIN ML.VW_ASSET_FEATURES_DAILY df 
                ON di.ASSET_ID = df.ASSET_ID 
                AND di.INDICATOR_DATE = df.FEATURE_DATE
            WHERE di.INDICATOR_DATE = CURRENT_DATE() - 1  -- Yesterday's data
              AND df.ASSET_ID IN (SELECT ASSET_ID FROM RAW.ASSET_MASTER WHERE STATUS = 'ACTIVE')
        """).to_pandas()
        
        if len(features_df) == 0:
            return json.dumps({"status": "error", "message": "No current features found"})
        
        # Prepare feature matrix
        feature_mapping = {
            'oil_temp_avg': 'OIL_TEMP_DAILY_AVG',
            'oil_temp_max': 'OIL_TEMP_DAILY_MAX',
            'h2_avg': 'H2_DAILY_AVG',
            'h2_max': 'H2_DAILY_MAX',
            'vibration_avg': 'VIBRATION_DAILY_AVG',
            'load_util_avg': 'LOAD_UTILIZATION_DAILY_AVG',
            'load_util_peak': 'LOAD_UTILIZATION_DAILY_PEAK',
            'thermal_rise_avg': 'THERMAL_RISE_DAILY_AVG',
            'combustible_gases': 'COMBUSTIBLE_GASES_DAILY_AVG',
            'operating_hours': 'OPERATING_HOURS',
            'asset_age_years': 'ASSET_AGE_YEARS',
            'days_since_maintenance': 'DAYS_SINCE_MAINTENANCE',
            'capacity_mva': 'CAPACITY_MVA',
            'criticality_score': 'CRITICALITY_SCORE',
            'customers_affected': 'CUSTOMERS_AFFECTED',
            'oil_quality_index': 'OIL_QUALITY_INDEX',
            'thermal_stress_index': 'THERMAL_STRESS_INDEX',
            'electrical_stress_index': 'ELECTRICAL_STRESS_INDEX',
            'mechanical_stress_index': 'MECHANICAL_STRESS_INDEX',
            'maintenance_effectiveness': 'MAINTENANCE_EFFECTIVENESS',
            'overall_health_index': 'OVERALL_HEALTH_INDEX',
            'oil_temp_trend_pct': 'OIL_TEMP_TREND_PCT',
            'h2_trend_pct': 'H2_TREND_PCT'
        }
        
        X = features_df[[feature_mapping[col] for col in feature_columns]].fillna(0)
        
        # =====================================================================
        # STEP 3: GENERATE PREDICTIONS
        # =====================================================================
        
        # XGBoost failure probability
        failure_prob = xgb_model.predict_proba(X)[:, 1]
        
        # Isolation Forest anomaly scores
        anomaly_scores_raw = iso_model.score_samples(X)
        # Normalize to 0-1 (higher = more anomalous)
        anomaly_scores = 1 - ((anomaly_scores_raw - anomaly_scores_raw.min()) / 
                              (anomaly_scores_raw.max() - anomaly_scores_raw.min()))
        
        # RUL prediction (only for high-risk assets)
        if rul_model:
            rul_predictions = rul_model.predict(X)
            rul_predictions = np.clip(rul_predictions, 1, 365)  # Bound between 1-365 days
        else:
            # Estimate RUL from failure probability
            rul_predictions = 30 * (1 - failure_prob)
        
        # =====================================================================
        # STEP 4: CALCULATE COMPOSITE RISK SCORE
        # =====================================================================
        
        # Composite risk score (0-100)
        risk_scores = (
            anomaly_scores * 30 +  # Anomaly contributes 30%
            failure_prob * 50 +     # Failure probability contributes 50%
            ((365 - rul_predictions) / 365) * 20  # RUL contributes 20%
        ) * 100
        
        risk_scores = np.clip(risk_scores, 0, 100)
        
        # Confidence score (based on model agreement)
        model_agreement = np.minimum(
            np.abs(anomaly_scores - failure_prob),
            1.0
        )
        confidence_scores = 1 - model_agreement
        
        # =====================================================================
        # STEP 5: SAVE PREDICTIONS TO DATABASE
        # =====================================================================
        
        predictions = []
        for idx, row in features_df.iterrows():
            asset_id = row['ASSET_ID']
            
            pred = {
                "asset_id": asset_id,
                "anomaly_score": float(anomaly_scores[idx]),
                "failure_probability": float(failure_prob[idx]),
                "predicted_rul_days": float(rul_predictions[idx]),
                "risk_score": float(risk_scores[idx]),
                "confidence": float(confidence_scores[idx]),
                "alert_level": (
                    "CRITICAL" if risk_scores[idx] >= 86 else
                    "HIGH" if risk_scores[idx] >= 71 else
                    "MEDIUM" if risk_scores[idx] >= 41 else
                    "LOW"
                ),
                "features": {k: float(row[v]) for k, v in feature_mapping.items() if v in row.index}
            }
            
            predictions.append(pred)
            
            # Insert into database
            feature_json = json.dumps(pred["features"]).replace("'", "''")
            
            session.sql(f"""
                INSERT INTO ML.MODEL_PREDICTIONS (
                    ASSET_ID, PREDICTION_TIMESTAMP, MODEL_ID,
                    ANOMALY_SCORE, FAILURE_PROBABILITY, PREDICTED_RUL_DAYS,
                    RISK_SCORE, CONFIDENCE, FEATURE_VALUES,
                    ALERT_GENERATED, ALERT_LEVEL
                )
                VALUES (
                    '{pred["asset_id"]}',
                    CURRENT_TIMESTAMP(),
                    '{xgb_model_id}',
                    {pred["anomaly_score"]},
                    {pred["failure_probability"]},
                    {pred["predicted_rul_days"]},
                    {pred["risk_score"]},
                    {pred["confidence"]},
                    PARSE_JSON('{feature_json}'),
                    {pred["risk_score"] >= 41},
                    '{pred["alert_level"]}'
                )
            """).collect()
        
        results["assets_scored"] = len(predictions)
        results["high_risk_count"] = sum(1 for p in predictions if p["risk_score"] >= 71)
        results["critical_count"] = sum(1 for p in predictions if p["risk_score"] >= 86)
        results["avg_risk_score"] = float(np.mean(risk_scores))
        results["status"] = "completed"
        
        return json.dumps(results, indent=2)
        
    except Exception as e:
        results["status"] = "failed"
        results["error"] = str(e)
        return json.dumps(results, indent=2)

$$;

-- =============================================================================
-- SECTION 2: EXECUTE SCORING
-- =============================================================================

-- Run scoring on all assets
CALL SCORE_ASSETS();

-- =============================================================================
-- SECTION 3: VIEW LATEST PREDICTIONS
-- =============================================================================

-- Create view for latest predictions
CREATE OR REPLACE VIEW VW_LATEST_PREDICTIONS AS
SELECT 
    p.ASSET_ID,
    p.PREDICTION_TIMESTAMP,
    p.ANOMALY_SCORE,
    p.FAILURE_PROBABILITY,
    p.PREDICTED_RUL_DAYS,
    p.RISK_SCORE,
    p.CONFIDENCE,
    p.ALERT_LEVEL,
    p.ALERT_GENERATED
FROM ML.MODEL_PREDICTIONS p
INNER JOIN (
    SELECT ASSET_ID, MAX(PREDICTION_TIMESTAMP) as MAX_TS
    FROM ML.MODEL_PREDICTIONS
    GROUP BY ASSET_ID
) latest ON p.ASSET_ID = latest.ASSET_ID AND p.PREDICTION_TIMESTAMP = latest.MAX_TS;

-- Show high-risk assets
SELECT 
    p.ASSET_ID,
    p.RISK_SCORE,
    p.FAILURE_PROBABILITY,
    p.PREDICTED_RUL_DAYS,
    p.ALERT_LEVEL,
    a.LOCATION_SUBSTATION,
    a.LOCATION_CITY,
    a.CUSTOMERS_AFFECTED,
    p.PREDICTION_TIMESTAMP
FROM VW_LATEST_PREDICTIONS p
JOIN RAW.ASSET_MASTER a ON p.ASSET_ID = a.ASSET_ID
WHERE p.RISK_SCORE >= 71
ORDER BY p.RISK_SCORE DESC;

-- =============================================================================
-- SECTION 4: ANALYTICS VIEWS FOR DASHBOARD
-- =============================================================================

USE SCHEMA ANALYTICS;

-- -----------------------------------------------------------------------------
-- View: VW_ASSET_HEALTH_DASHBOARD
-- Purpose: Real-time asset health summary
-- -----------------------------------------------------------------------------
CREATE OR REPLACE VIEW VW_ASSET_HEALTH_DASHBOARD AS
SELECT 
    a.ASSET_ID,
    a.ASSET_TYPE,
    a.LOCATION_SUBSTATION,
    a.LOCATION_CITY,
    a.LOCATION_COUNTY,
    a.LOCATION_LAT,
    a.LOCATION_LON,
    a.CUSTOMERS_AFFECTED,
    a.CRITICALITY_SCORE,
    p.RISK_SCORE,
    p.FAILURE_PROBABILITY,
    p.PREDICTED_RUL_DAYS,
    p.CONFIDENCE,
    p.ALERT_LEVEL,
    p.PREDICTION_TIMESTAMP,
    CASE 
        WHEN p.RISK_SCORE >= 86 THEN 'CRITICAL'
        WHEN p.RISK_SCORE >= 71 THEN 'HIGH'
        WHEN p.RISK_SCORE >= 41 THEN 'MEDIUM'
        ELSE 'LOW'
    END as RISK_CATEGORY,
    DATEDIFF(day, a.LAST_MAINTENANCE_DATE, CURRENT_DATE()) as DAYS_SINCE_MAINTENANCE,
    DATEDIFF(day, a.INSTALL_DATE, CURRENT_DATE()) / 365.25 as ASSET_AGE_YEARS
FROM RAW.ASSET_MASTER a
LEFT JOIN ML.VW_LATEST_PREDICTIONS p ON a.ASSET_ID = p.ASSET_ID
WHERE a.STATUS = 'ACTIVE';

-- -----------------------------------------------------------------------------
-- View: VW_HIGH_RISK_ASSETS
-- Purpose: Prioritized list of assets requiring attention
-- -----------------------------------------------------------------------------
CREATE OR REPLACE VIEW VW_HIGH_RISK_ASSETS AS
SELECT 
    d.ASSET_ID,
    d.LOCATION_SUBSTATION,
    d.LOCATION_CITY,
    d.LOCATION_COUNTY,
    d.RISK_SCORE,
    d.FAILURE_PROBABILITY,
    d.PREDICTED_RUL_DAYS,
    d.ALERT_LEVEL,
    d.CUSTOMERS_AFFECTED,
    d.CRITICALITY_SCORE,
    d.DAYS_SINCE_MAINTENANCE,
    
    -- Estimated SAIDI impact if failure occurs
    ROUND((d.CUSTOMERS_AFFECTED * 4.2 * 60) / 5800000.0, 4) as ESTIMATED_SAIDI_IMPACT,
    
    -- Recommended action timeline
    CASE 
        WHEN d.RISK_SCORE >= 86 THEN 'IMMEDIATE (0-7 days)'
        WHEN d.RISK_SCORE >= 71 THEN 'URGENT (7-14 days)'
        ELSE 'SCHEDULED (14-30 days)'
    END as RECOMMENDED_ACTION_TIMELINE,
    
    -- Work order priority
    CASE 
        WHEN d.RISK_SCORE >= 86 THEN 1
        WHEN d.RISK_SCORE >= 71 THEN 2
        ELSE 3
    END as WORK_ORDER_PRIORITY,
    
    d.PREDICTION_TIMESTAMP
    
FROM VW_ASSET_HEALTH_DASHBOARD d
WHERE d.RISK_SCORE >= 71
ORDER BY d.RISK_SCORE DESC, d.CUSTOMERS_AFFECTED DESC;

-- -----------------------------------------------------------------------------
-- View: VW_RELIABILITY_METRICS
-- Purpose: SAIDI/SAIFI calculations
-- -----------------------------------------------------------------------------
CREATE OR REPLACE VIEW VW_RELIABILITY_METRICS AS
WITH current_risk AS (
    SELECT 
        SUM(CUSTOMERS_AFFECTED) as TOTAL_CUSTOMERS_AT_RISK,
        COUNT(*) as HIGH_RISK_ASSET_COUNT,
        SUM(CUSTOMERS_AFFECTED * 4.2 * 60) / 5800000.0 as POTENTIAL_SAIDI_IMPACT
    FROM VW_HIGH_RISK_ASSETS
)
SELECT 
    'PREDICTED_IMPACT' as METRIC_TYPE,
    TOTAL_CUSTOMERS_AT_RISK,
    HIGH_RISK_ASSET_COUNT,
    ROUND(POTENTIAL_SAIDI_IMPACT, 4) as POTENTIAL_SAIDI_POINTS,
    CURRENT_TIMESTAMP() as CALCULATION_TIMESTAMP
FROM current_risk;

-- -----------------------------------------------------------------------------
-- View: VW_COST_AVOIDANCE_REPORT
-- Purpose: Financial impact analysis
-- -----------------------------------------------------------------------------
CREATE OR REPLACE VIEW VW_COST_AVOIDANCE_REPORT AS
SELECT 
    COUNT(*) as HIGH_RISK_ASSETS,
    SUM(CUSTOMERS_AFFECTED) as TOTAL_CUSTOMERS_PROTECTED,
    
    -- Emergency repair cost avoidance
    SUM(450000) as EMERGENCY_REPAIR_COST_AVOIDANCE,
    
    -- Preventive maintenance cost
    SUM(45000) as PREVENTIVE_MAINTENANCE_COST,
    
    -- Net cost avoidance
    SUM(450000 - 45000) as NET_COST_AVOIDANCE,
    
    -- SAIDI impact prevention value
    SUM(ESTIMATED_SAIDI_IMPACT) as SAIDI_IMPACT_PREVENTED,
    
    CURRENT_TIMESTAMP() as REPORT_TIMESTAMP
    
FROM VW_HIGH_RISK_ASSETS;

-- =============================================================================
-- SECTION 5: SCORING TASK SETUP
-- =============================================================================

-- Update the scoring task created earlier
USE SCHEMA ML;

CREATE OR REPLACE TASK TASK_SCORE_ASSETS
    WAREHOUSE = GRID_RELIABILITY_WH
    SCHEDULE = 'USING CRON 0 * * * * America/New_York' -- Every hour
    COMMENT = 'Run predictive models on all active assets hourly'
AS
CALL ML.SCORE_ASSETS();

-- Task starts suspended - resume it when ready
-- ALTER TASK TASK_SCORE_ASSETS RESUME;

-- =============================================================================
-- SCRIPT COMPLETE
-- =============================================================================

SELECT 'Model scoring complete!' as STATUS;
SELECT 'Predictions generated for ' || (SELECT COUNT(*) FROM ML.VW_LATEST_PREDICTIONS)::VARCHAR || ' assets' as PREDICTIONS;
SELECT 'High-risk assets: ' || (SELECT COUNT(*) FROM ANALYTICS.VW_HIGH_RISK_ASSETS)::VARCHAR as HIGH_RISK;
SELECT 'Check ANALYTICS schema views for dashboard data' as ANALYTICS;
SELECT 'ML Pipeline Complete - Ready for Dashboard' as READY;

