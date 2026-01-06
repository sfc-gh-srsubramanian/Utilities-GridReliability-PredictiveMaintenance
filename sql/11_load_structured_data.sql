/*******************************************************************************
 * GRID RELIABILITY & PREDICTIVE MAINTENANCE - Load Structured Data
 * 
 * Purpose: Load structured data (assets, sensors, maintenance history, failures)
 * Prerequisites: 
 *   1. Run scripts 01-10 first
 *   2. Generate data files: python3 python/data_generators/generate_asset_data.py
 *   3. Upload files to stages (see instructions below)
 * 
 * Author: Grid Reliability AI/ML Team
 * Version: 3.0 (Production Ready)
 ******************************************************************************/

USE DATABASE UTILITIES_GRID_RELIABILITY;
USE WAREHOUSE GRID_RELIABILITY_WH;
USE SCHEMA RAW;

-- =============================================================================
-- INSTRUCTIONS: Upload data files before running this script
-- =============================================================================
-- Run these commands in SnowSQL or Snowflake CLI from the project root:
--
-- cd generated_data
-- PUT file://asset_master.csv @RAW.ASSET_DATA_STAGE AUTO_COMPRESS=TRUE OVERWRITE=TRUE;
-- PUT file://maintenance_history.csv @RAW.ASSET_DATA_STAGE AUTO_COMPRESS=TRUE OVERWRITE=TRUE;
-- PUT file://failure_events.csv @RAW.ASSET_DATA_STAGE AUTO_COMPRESS=TRUE OVERWRITE=TRUE;
-- PUT file://sensor_readings_batch_*.json @RAW.SENSOR_DATA_STAGE AUTO_COMPRESS=TRUE OVERWRITE=TRUE;
-- cd ..
--
-- Or use the snow CLI:
-- export PATH="/Library/Frameworks/Python.framework/Versions/3.11/bin:$PATH"
-- cd generated_data && snow sql -c <connection> -q "USE DATABASE UTILITIES_GRID_RELIABILITY; USE SCHEMA RAW; PUT file://asset_master.csv @ASSET_DATA_STAGE AUTO_COMPRESS=TRUE OVERWRITE=TRUE;" && cd ..
-- =============================================================================

-- =============================================================================
-- SECTION 1: LOAD ASSET MASTER DATA
-- =============================================================================

COPY INTO ASSET_MASTER
FROM (
    SELECT 
        $1::VARCHAR AS ASSET_ID,
        $2::VARCHAR AS ASSET_TYPE,
        $3::VARCHAR AS ASSET_SUBTYPE,
        $4::VARCHAR AS MANUFACTURER,
        $5::VARCHAR AS MODEL,
        $6::VARCHAR AS SERIAL_NUMBER,
        $7::DATE AS INSTALL_DATE,
        $8::NUMBER AS EXPECTED_LIFE_YEARS,
        $9::VARCHAR AS LOCATION_SUBSTATION,
        $10::VARCHAR AS LOCATION_CITY,
        $11::VARCHAR AS LOCATION_COUNTY,
        $12::NUMBER(10,6) AS LOCATION_LAT,
        $13::NUMBER(10,6) AS LOCATION_LON,
        $14::NUMBER(10,2) AS VOLTAGE_RATING_KV,
        $15::NUMBER(10,2) AS CAPACITY_MVA,
        $16::NUMBER(3) AS CRITICALITY_SCORE,
        $17::NUMBER(10) AS CUSTOMERS_AFFECTED,
        $18::NUMBER(12,2) AS REPLACEMENT_COST_USD,
        $19::DATE AS LAST_MAINTENANCE_DATE,
        $20::VARCHAR AS STATUS
    FROM @ASSET_DATA_STAGE/asset_master.csv.gz
)
FILE_FORMAT = (
    TYPE = CSV
    SKIP_HEADER = 1
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'
    NULL_IF = ('NULL', 'null', '')
)
ON_ERROR = 'CONTINUE'
FORCE = TRUE;

SELECT 'Asset Master loaded: ' || COUNT(*) || ' records' AS STATUS FROM ASSET_MASTER;

-- =============================================================================
-- SECTION 2: LOAD SENSOR READINGS (JSON format - may take 2-3 minutes)
-- =============================================================================

COPY INTO SENSOR_READINGS
FROM @SENSOR_DATA_STAGE
FILE_FORMAT = (
    TYPE = JSON
    STRIP_OUTER_ARRAY = FALSE
)
PATTERN = '.*sensor_readings.*\\.json\\.gz'
MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE
ON_ERROR = 'CONTINUE'
FORCE = TRUE;

SELECT 'Sensor Readings loaded: ' || COUNT(*) || ' records' AS STATUS FROM SENSOR_READINGS;

-- =============================================================================
-- SECTION 3: LOAD MAINTENANCE HISTORY
-- =============================================================================

COPY INTO MAINTENANCE_HISTORY
FROM (
    SELECT 
        NULL AS MAINTENANCE_ID, -- AUTOINCREMENT
        $1::VARCHAR AS ASSET_ID,
        $2::DATE AS MAINTENANCE_DATE,
        $3::VARCHAR AS MAINTENANCE_TYPE,
        $4::VARCHAR AS DESCRIPTION,
        $5::VARCHAR AS TECHNICIAN,
        $6::NUMBER(12,2) AS COST_USD,
        $7::NUMBER(5,2) AS DOWNTIME_HOURS,
        $8::VARCHAR AS OUTCOME,
        NULL AS PARTS_REPLACED, -- Not in CSV
        NULL AS FINDINGS -- Not in CSV
    FROM @ASSET_DATA_STAGE/maintenance_history.csv.gz
)
FILE_FORMAT = (
    TYPE = CSV
    SKIP_HEADER = 1
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'
    NULL_IF = ('NULL', 'null', '')
)
ON_ERROR = 'CONTINUE'
FORCE = TRUE;

SELECT 'Maintenance History loaded: ' || COUNT(*) || ' records' AS STATUS FROM MAINTENANCE_HISTORY;

-- =============================================================================
-- SECTION 4: LOAD FAILURE EVENTS
-- =============================================================================

COPY INTO FAILURE_EVENTS
FROM (
    SELECT 
        NULL AS FAILURE_ID, -- AUTOINCREMENT
        $1::VARCHAR AS EVENT_ID,
        $2::VARCHAR AS ASSET_ID,
        $3::TIMESTAMP_NTZ AS FAILURE_TIMESTAMP,
        $4::VARCHAR AS FAILURE_TYPE,
        $5::VARCHAR AS ROOT_CAUSE,
        $6::NUMBER(10) AS CUSTOMERS_AFFECTED,
        $7::NUMBER(5,2) AS OUTAGE_DURATION_HOURS,
        $8::NUMBER(12,2) AS REPAIR_COST_USD,
        $9::BOOLEAN AS REPLACEMENT_FLAG,
        $10::BOOLEAN AS PREVENTABLE_FLAG,
        $11::NUMBER(5) AS ADVANCED_WARNING_DAYS
    FROM @ASSET_DATA_STAGE/failure_events.csv.gz
)
FILE_FORMAT = (
    TYPE = CSV
    SKIP_HEADER = 1
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'
    NULL_IF = ('NULL', 'null', '')
)
ON_ERROR = 'CONTINUE'
FORCE = TRUE;

SELECT 'Failure Events loaded: ' || COUNT(*) || ' records' AS STATUS FROM FAILURE_EVENTS;

-- =============================================================================
-- SECTION 5: COMPREHENSIVE VERIFICATION
-- =============================================================================

SELECT 
    'ASSET_MASTER' AS TABLE_NAME, 
    COUNT(*) AS ROW_COUNT,
    MIN(CREATED_TS) AS MIN_TIMESTAMP,
    MAX(CREATED_TS) AS MAX_TIMESTAMP
FROM ASSET_MASTER
UNION ALL
SELECT 
    'SENSOR_READINGS', 
    COUNT(*),
    MIN(INGESTION_TS),
    MAX(INGESTION_TS)
FROM SENSOR_READINGS
UNION ALL
SELECT 
    'MAINTENANCE_HISTORY', 
    COUNT(*),
    MIN(CREATED_TS),
    MAX(CREATED_TS)
FROM MAINTENANCE_HISTORY
UNION ALL
SELECT 
    'FAILURE_EVENTS', 
    COUNT(*),
    MIN(CREATED_TS),
    MAX(CREATED_TS)
FROM FAILURE_EVENTS
ORDER BY TABLE_NAME;

-- Expected row counts (demo data):
-- ASSET_MASTER: 100
-- SENSOR_READINGS: ~432,000 (100 assets × 72 readings/day × 60 days)
-- MAINTENANCE_HISTORY: ~100-200
-- FAILURE_EVENTS: ~15

-- Verify sample data
SELECT 'Sample Asset Data:' AS INFO;
SELECT ASSET_ID, ASSET_TYPE, LOCATION_SUBSTATION, STATUS FROM ASSET_MASTER LIMIT 5;

SELECT 'Sample Sensor Data:' AS INFO;
SELECT ASSET_ID, READING_TIMESTAMP, OIL_TEMPERATURE_C, LOAD_CURRENT_A FROM SENSOR_READINGS LIMIT 5;

SELECT 'Structured data loading complete!' AS STATUS;

-- Next Step: Run 12_load_unstructured_data.sql
