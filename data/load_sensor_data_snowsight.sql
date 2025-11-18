-- ========================================================
-- FPL Grid Reliability: Sensor Data Load for Snowsight
-- ========================================================
-- Run this in Snowsight after uploading JSON files
-- ========================================================

USE DATABASE UTILITIES_GRID_RELIABILITY;
USE SCHEMA RAW;
USE WAREHOUSE COMPUTE_WH;

-- ========================================================
-- Fix column precision issues before loading
-- ========================================================
-- ACOUSTIC_DB has values > 999.99, need to expand from NUMBER(5,2) to NUMBER(6,2)
ALTER TABLE SENSOR_READINGS 
  ALTER COLUMN ACOUSTIC_DB SET DATA TYPE NUMBER(6,2);

-- Create file format for JSON
CREATE OR REPLACE FILE FORMAT JSON_FORMAT
  TYPE = 'JSON'
  COMPRESSION = 'AUTO'
  STRIP_OUTER_ARRAY = FALSE;

-- Create internal stage
CREATE OR REPLACE STAGE SENSOR_DATA_STAGE
  FILE_FORMAT = JSON_FORMAT;

-- ========================================================
-- IMPORTANT: Upload JSON files before running below
-- ========================================================
-- In Snowsight:
-- 1. Go to Data > Databases > UTILITIES_GRID_RELIABILITY > RAW > Stages
-- 2. Click on SENSOR_DATA_STAGE
-- 3. Click "+ Files" button
-- 4. Upload all files from generated_data/sensor_readings_batch_*.json
-- 
-- OR use SnowSQL command:
-- PUT file://generated_data/sensor_readings_batch_*.json @SENSOR_DATA_STAGE AUTO_COMPRESS=TRUE;
-- ========================================================

-- Verify files are uploaded
LIST @SENSOR_DATA_STAGE;

-- Load data from JSON files
COPY INTO SENSOR_READINGS (
    ASSET_ID,
    READING_TIMESTAMP,
    OIL_TEMPERATURE_C,
    WINDING_TEMPERATURE_C,
    LOAD_CURRENT_A,
    LOAD_VOLTAGE_KV,
    AMBIENT_TEMP_C,
    HUMIDITY_PCT,
    VIBRATION_MM_S,
    ACOUSTIC_DB,
    DISSOLVED_H2_PPM,
    DISSOLVED_CO_PPM,
    DISSOLVED_CO2_PPM,
    DISSOLVED_CH4_PPM,
    BUSHING_TEMP_C,
    TAP_POSITION,
    PARTIAL_DISCHARGE_PC,
    POWER_FACTOR
)
FROM (
    SELECT 
        $1:ASSET_ID::VARCHAR(50),
        $1:READING_TIMESTAMP::TIMESTAMP,
        $1:OIL_TEMPERATURE_C::NUMBER(5,2),
        $1:WINDING_TEMPERATURE_C::NUMBER(5,2),
        $1:LOAD_CURRENT_A::NUMBER(10,2),
        $1:LOAD_VOLTAGE_KV::NUMBER(10,2),
        $1:AMBIENT_TEMP_C::NUMBER(5,2),
        $1:HUMIDITY_PCT::NUMBER(5,2),
        $1:VIBRATION_MM_S::NUMBER(8,4),
        $1:ACOUSTIC_DB::NUMBER(6,2),
        $1:DISSOLVED_H2_PPM::NUMBER(10,2),
        $1:DISSOLVED_CO_PPM::NUMBER(10,2),
        $1:DISSOLVED_CO2_PPM::NUMBER(10,2),
        $1:DISSOLVED_CH4_PPM::NUMBER(10,2),
        $1:BUSHING_TEMP_C::NUMBER(5,2),
        $1:TAP_POSITION::NUMBER(3,0),
        $1:PARTIAL_DISCHARGE_PC::NUMBER(8,2),
        $1:POWER_FACTOR::NUMBER(5,4)
    FROM @SENSOR_DATA_STAGE
)
ON_ERROR = 'CONTINUE'
FORCE = TRUE;

-- Verify data load
SELECT 
    COUNT(*) AS TOTAL_READINGS,
    COUNT(DISTINCT ASSET_ID) AS UNIQUE_ASSETS,
    MIN(READING_TIMESTAMP) AS EARLIEST_READING,
    MAX(READING_TIMESTAMP) AS LATEST_READING,
    ROUND(COUNT(*) / COUNT(DISTINCT ASSET_ID), 0) AS AVG_READINGS_PER_ASSET
FROM SENSOR_READINGS;

-- Sample loaded data
SELECT 
    ASSET_ID,
    READING_TIMESTAMP,
    OIL_TEMPERATURE_C,
    WINDING_TEMPERATURE_C,
    LOAD_CURRENT_A,
    LOAD_VOLTAGE_KV,
    POWER_FACTOR
FROM SENSOR_READINGS
ORDER BY READING_TIMESTAMP DESC
LIMIT 20;

-- Check distribution by asset
SELECT 
    ASSET_ID,
    COUNT(*) AS READING_COUNT,
    MIN(READING_TIMESTAMP) AS FIRST_READING,
    MAX(READING_TIMESTAMP) AS LAST_READING
FROM SENSOR_READINGS
GROUP BY ASSET_ID
ORDER BY READING_COUNT DESC
LIMIT 10;

-- ========================================================
-- ✅ LOAD COMPLETE! Next Steps:
-- ========================================================
-- 1. Retrain ML models:
--    USE SCHEMA ML;
--    CALL TRAIN_FAILURE_PREDICTION_MODELS();
--
-- 2. Generate predictions:
--    CALL SCORE_ASSETS();
--
-- 3. View high-risk assets:
--    SELECT * FROM ANALYTICS.VW_HIGH_RISK_ASSETS
--    ORDER BY RISK_SCORE DESC;
-- ========================================================

