-- ========================================================
-- Grid Reliability: Retrain ML Models & Generate Predictions
-- ========================================================
-- Run this after loading the full sensor dataset
-- ========================================================

USE DATABASE UTILITIES_GRID_RELIABILITY;
USE SCHEMA ML;
USE WAREHOUSE COMPUTE_WH;

-- ========================================================
-- Step 1: Verify we have sufficient data for training
-- ========================================================
SELECT 
    'ASSETS' AS DATA_TYPE,
    COUNT(*) AS COUNT 
FROM RAW.ASSET_MASTER
UNION ALL
SELECT 'SENSOR_READINGS', COUNT(*) FROM RAW.SENSOR_READINGS
UNION ALL
SELECT 'MAINTENANCE_RECORDS', COUNT(*) FROM RAW.MAINTENANCE_HISTORY;

-- Check feature engineering views are working with full data
SELECT 
    COUNT(*) AS FEATURE_ROWS,
    COUNT(DISTINCT ASSET_ID) AS UNIQUE_ASSETS,
    MIN(FEATURE_TIMESTAMP) AS EARLIEST,
    MAX(FEATURE_TIMESTAMP) AS LATEST
FROM VW_ASSET_FEATURES_DAILY;

-- ========================================================
-- Step 2: Rebuild Training Data with Full Dataset
-- ========================================================
-- Clear old demo training data
TRUNCATE TABLE TRAINING_DATA;

-- Rebuild with full sensor data
INSERT INTO TRAINING_DATA (
    ASSET_ID,
    FEATURE_TIMESTAMP,
    FEATURES,
    LABEL_FAILURE_30D,
    LABEL_FAILURE_7D,
    LABEL_RUL_DAYS
)
WITH failure_events AS (
    -- Get failure events from maintenance history
    SELECT 
        ASSET_ID,
        MAINTENANCE_DATE AS FAILURE_DATE
    FROM RAW.MAINTENANCE_HISTORY
    WHERE MAINTENANCE_TYPE = 'FAILURE_REPAIR'
),
labeled_features AS (
    SELECT 
        f.ASSET_ID,
        f.FEATURE_TIMESTAMP,
        OBJECT_CONSTRUCT(
            'temp_7d_mean', f.TEMP_7D_MEAN,
            'temp_7d_std', f.TEMP_7D_STD,
            'temp_30d_mean', f.TEMP_30D_MEAN,
            'current_7d_mean', f.CURRENT_7D_MEAN,
            'vibration_7d_mean', f.VIBRATION_7D_MEAN,
            'vibration_7d_max', f.VIBRATION_7D_MAX,
            'dga_h2_7d_mean', f.DGA_H2_7D_MEAN,
            'asset_age_years', DATEDIFF(day, am.INSTALL_DATE, f.FEATURE_TIMESTAMP::DATE) / 365.25
        ) AS FEATURES,
        -- Label: Failure within 30 days
        CASE WHEN MIN(DATEDIFF(day, f.FEATURE_TIMESTAMP::DATE, fe.FAILURE_DATE)) <= 30 
             THEN 1 ELSE 0 END AS LABEL_FAILURE_30D,
        -- Label: Failure within 7 days
        CASE WHEN MIN(DATEDIFF(day, f.FEATURE_TIMESTAMP::DATE, fe.FAILURE_DATE)) <= 7 
             THEN 1 ELSE 0 END AS LABEL_FAILURE_7D,
        -- Label: Remaining Useful Life in days
        COALESCE(MIN(DATEDIFF(day, f.FEATURE_TIMESTAMP::DATE, fe.FAILURE_DATE)), 365) AS LABEL_RUL_DAYS
    FROM VW_ASSET_FEATURES_DAILY f
    JOIN RAW.ASSET_MASTER am ON f.ASSET_ID = am.ASSET_ID
    LEFT JOIN failure_events fe ON f.ASSET_ID = fe.ASSET_ID 
        AND fe.FAILURE_DATE > f.FEATURE_TIMESTAMP::DATE
    GROUP BY f.ASSET_ID, f.FEATURE_TIMESTAMP, f.TEMP_7D_MEAN, f.TEMP_7D_STD, 
             f.TEMP_30D_MEAN, f.CURRENT_7D_MEAN, f.VIBRATION_7D_MEAN, 
             f.VIBRATION_7D_MAX, f.DGA_H2_7D_MEAN, am.INSTALL_DATE
)
SELECT * FROM labeled_features
WHERE FEATURE_TIMESTAMP >= '2025-06-01'  -- Start after initial burn-in period
LIMIT 10000;  -- Use 10K samples for training (adjust as needed)

-- Verify training data
SELECT 
    COUNT(*) AS TOTAL_SAMPLES,
    SUM(LABEL_FAILURE_30D) AS FAILURE_SAMPLES,
    COUNT(*) - SUM(LABEL_FAILURE_30D) AS NON_FAILURE_SAMPLES,
    ROUND(SUM(LABEL_FAILURE_30D) * 100.0 / COUNT(*), 2) AS FAILURE_RATE_PCT
FROM TRAINING_DATA;

-- ========================================================
-- Step 3: Train ML Models
-- ========================================================
CALL TRAIN_FAILURE_PREDICTION_MODELS();

-- Check model registry
SELECT 
    MODEL_NAME,
    MODEL_TYPE,
    MODEL_VERSION,
    TRAINED_AT,
    IS_ACTIVE
FROM MODEL_REGISTRY
ORDER BY TRAINED_AT DESC;

-- ========================================================
-- Step 4: Generate Predictions for All Assets
-- ========================================================
CALL SCORE_ASSETS();

-- Verify predictions
SELECT 
    COUNT(*) AS TOTAL_PREDICTIONS,
    COUNT(DISTINCT ASSET_ID) AS UNIQUE_ASSETS,
    ROUND(AVG(FAILURE_PROBABILITY), 4) AS AVG_FAILURE_PROB,
    ROUND(AVG(PREDICTED_RUL_DAYS), 2) AS AVG_RUL_DAYS
FROM MODEL_PREDICTIONS;

-- ========================================================
-- Step 5: View High-Risk Assets
-- ========================================================
SELECT 
    ASSET_ID,
    ASSET_TYPE,
    LOCATION_SUBSTATION,
    RISK_SCORE,
    FAILURE_PROBABILITY,
    PREDICTED_RUL_DAYS,
    ANOMALY_SCORE,
    HEALTH_STATUS,
    RECOMMENDED_ACTION
FROM ANALYTICS.VW_HIGH_RISK_ASSETS
ORDER BY RISK_SCORE DESC
LIMIT 20;

-- ========================================================
-- Step 6: Check Asset Health Dashboard
-- ========================================================
SELECT 
    HEALTH_STATUS,
    COUNT(*) AS ASSET_COUNT,
    ROUND(AVG(RISK_SCORE), 2) AS AVG_RISK_SCORE,
    ROUND(AVG(FAILURE_PROBABILITY), 3) AS AVG_FAILURE_PROB
FROM ANALYTICS.VW_ASSET_HEALTH_DASHBOARD
GROUP BY HEALTH_STATUS
ORDER BY AVG_RISK_SCORE DESC;

-- ========================================================
-- ✅ ML Pipeline Complete!
-- ========================================================
-- Next Steps:
-- 1. Deploy Streamlit Dashboard (dashboard/grid_reliability_dashboard.py)
-- 2. Create Intelligence Agent (agents/create_grid_intelligence_agent.sql)
-- 3. Set up automation (database/04_create_streams_tasks.sql)
-- ========================================================

