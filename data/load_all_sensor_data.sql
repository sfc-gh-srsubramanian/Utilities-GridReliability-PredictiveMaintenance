-- ========================================================
-- FPL Grid Reliability: Bulk Sensor Data Load
-- ========================================================
-- Purpose: Load all 432,000 sensor readings from JSON files
-- Estimated Time: 10-15 seconds with SnowSQL
-- Method: COPY INTO from internal stage
-- ========================================================

USE DATABASE UTILITIES_GRID_RELIABILITY;
USE SCHEMA RAW;
USE WAREHOUSE COMPUTE_WH;

-- Step 1: Create temporary file format for JSON
CREATE OR REPLACE FILE FORMAT JSON_FORMAT
  TYPE = 'JSON'
  COMPRESSION = 'AUTO'
  STRIP_OUTER_ARRAY = FALSE;

-- Step 2: Create internal stage for sensor data
CREATE OR REPLACE STAGE SENSOR_DATA_STAGE
  FILE_FORMAT = JSON_FORMAT
  COMMENT = 'Temporary stage for bulk sensor data load';

-- Step 3: Put files into stage (run this from command line first)
-- !!! IMPORTANT: Run this command BEFORE executing this script !!!
-- 
-- From project directory, run:
-- snowsql -c demo_tools -d UTILITIES_GRID_RELIABILITY -s RAW << 'EOF'
-- PUT file://generated_data/sensor_readings_batch_*.json @SENSOR_DATA_STAGE AUTO_COMPRESS=TRUE;
-- EOF

-- Step 4: Load data from JSON files using COPY INTO
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
        $1:ACOUSTIC_DB::NUMBER(5,2),
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

-- Step 5: Verify data load
SELECT 
    COUNT(*) AS TOTAL_READINGS,
    COUNT(DISTINCT ASSET_ID) AS UNIQUE_ASSETS,
    MIN(READING_TIMESTAMP) AS EARLIEST_READING,
    MAX(READING_TIMESTAMP) AS LATEST_READING
FROM SENSOR_READINGS;

-- Step 6: Check sample data
SELECT 
    ASSET_ID,
    READING_TIMESTAMP,
    OIL_TEMPERATURE_C,
    WINDING_TEMPERATURE_C,
    LOAD_CURRENT_A,
    LOAD_VOLTAGE_KV
FROM SENSOR_READINGS
ORDER BY READING_TIMESTAMP DESC
LIMIT 10;

-- Step 7: Clean up stage (optional - uncomment if desired)
-- DROP STAGE SENSOR_DATA_STAGE;
-- DROP FILE FORMAT JSON_FORMAT;

-- ========================================================
-- Load Complete!
-- ========================================================
-- Next Steps:
-- 1. Retrain ML models: CALL ML.TRAIN_FAILURE_PREDICTION_MODELS();
-- 2. Generate predictions: CALL ML.SCORE_ASSETS();
-- 3. View analytics: SELECT * FROM ANALYTICS.VW_HIGH_RISK_ASSETS;
-- ========================================================

