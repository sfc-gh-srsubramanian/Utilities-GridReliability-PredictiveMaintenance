/*******************************************************************************
 * GRID RELIABILITY & PREDICTIVE MAINTENANCE - Load Structured Data
 * 
 * Purpose: Load structured data (assets, sensors, maintenance history, failures)
 * Prerequisites: 01-10 must be run first
 * 
 * Author: Grid Reliability AI/ML Team
 * Version: 2.0 (Consolidated for Solution Page)
 ******************************************************************************/

USE DATABASE UTILITIES_GRID_RELIABILITY;
USE WAREHOUSE GRID_RELIABILITY_WH;
USE SCHEMA RAW;

-- =============================================================================
-- SECTION 1: LOAD ASSET MASTER DATA
-- =============================================================================

-- Option A: Load from generated CSV file
/*
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
    FROM @ASSET_DATA_STAGE/asset_master.csv
)
FILE_FORMAT = CSV_FORMAT
ON_ERROR = 'CONTINUE';
*/

-- Option B: Use Python data generator (recommended for demo)
-- Run: python3 python/data_generators/generate_asset_data.py
-- This generates 100 demo assets directly into the table

-- =============================================================================
-- SECTION 2: LOAD SENSOR READINGS
-- =============================================================================

-- Option A: Load from JSON files
/*
COPY INTO SENSOR_READINGS
FROM (
    SELECT 
        NULL AS READING_ID, -- AUTOINCREMENT
        $1:asset_id::VARCHAR AS ASSET_ID,
        $1:reading_timestamp::TIMESTAMP_NTZ AS READING_TIMESTAMP,
        $1:oil_temperature_c::NUMBER(5,2) AS OIL_TEMPERATURE_C,
        $1:winding_temperature_c::NUMBER(5,2) AS WINDING_TEMPERATURE_C,
        $1:ambient_temp_c::NUMBER(5,2) AS AMBIENT_TEMP_C,
        $1:bushing_temp_c::NUMBER(5,2) AS BUSHING_TEMP_C,
        $1:load_current_a::NUMBER(10,2) AS LOAD_CURRENT_A,
        $1:load_voltage_kv::NUMBER(10,2) AS LOAD_VOLTAGE_KV,
        $1:power_factor::NUMBER(5,4) AS POWER_FACTOR,
        $1:partial_discharge_pc::NUMBER(8,2) AS PARTIAL_DISCHARGE_PC,
        $1:humidity_pct::NUMBER(5,2) AS HUMIDITY_PCT,
        $1:vibration_mm_s::NUMBER(8,4) AS VIBRATION_MM_S,
        $1:acoustic_db::NUMBER(6,2) AS ACOUSTIC_DB,
        $1:dissolved_h2_ppm::NUMBER(10,2) AS DISSOLVED_H2_PPM,
        $1:dissolved_co_ppm::NUMBER(10,2) AS DISSOLVED_CO_PPM,
        $1:dissolved_co2_ppm::NUMBER(10,2) AS DISSOLVED_CO2_PPM,
        $1:dissolved_ch4_ppm::NUMBER(10,2) AS DISSOLVED_CH4_PPM,
        $1:tap_position::NUMBER(3) AS TAP_POSITION
    FROM @SENSOR_DATA_STAGE
)
FILE_FORMAT = JSON_FORMAT
PATTERN = '.*sensor_readings.*\\.json'
ON_ERROR = 'CONTINUE';
*/

-- Option B: Use Python data generator (recommended for demo)
-- Run: python3 python/data_generators/generate_sensor_data.py
-- This generates 432,000 sensor readings (30 days @ 5-min intervals)

-- =============================================================================
-- SECTION 3: LOAD MAINTENANCE HISTORY
-- =============================================================================

-- Option A: Load from CSV
/*
COPY INTO MAINTENANCE_HISTORY
FROM (
    SELECT 
        $1::VARCHAR AS MAINTENANCE_ID,
        $2::VARCHAR AS ASSET_ID,
        $3::DATE AS MAINTENANCE_DATE,
        $4::VARCHAR AS MAINTENANCE_TYPE,
        $5::VARCHAR AS DESCRIPTION,
        $6::VARCHAR AS TECHNICIAN,
        $7::NUMBER(12,2) AS COST_USD,
        $8::NUMBER(5,2) AS DOWNTIME_HOURS,
        $9::VARCHAR AS OUTCOME,
        PARSE_JSON($10) AS PARTS_REPLACED,
        PARSE_JSON($11) AS FINDINGS
    FROM @MAINTENANCE_DATA_STAGE/maintenance_history.csv
)
FILE_FORMAT = CSV_FORMAT
ON_ERROR = 'CONTINUE';
*/

-- Option B: Use data generator
-- Maintenance history is generated with asset data

-- =============================================================================
-- SECTION 4: LOAD FAILURE EVENTS
-- =============================================================================

-- Option A: Load from CSV
/*
COPY INTO FAILURE_EVENTS
FROM (
    SELECT 
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
    FROM @ASSET_DATA_STAGE/failure_events.csv
)
FILE_FORMAT = CSV_FORMAT
ON_ERROR = 'CONTINUE';
*/

-- Option B: Use data generator
-- Failure events are generated with asset data

-- =============================================================================
-- SECTION 5: VERIFICATION
-- =============================================================================

SELECT 
    'ASSET_MASTER' AS TABLE_NAME, 
    COUNT(*) AS ROW_COUNT,
    MIN(CREATED_TS) AS MIN_DATE,
    MAX(CREATED_TS) AS MAX_DATE
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
FROM FAILURE_EVENTS;

-- Expected row counts (demo data):
-- ASSET_MASTER: 100
-- SENSOR_READINGS: 432,000+
-- MAINTENANCE_HISTORY: 192
-- FAILURE_EVENTS: 10

SELECT '✅ Structured data loading complete!' AS STATUS;

-- Next Step: Run 12_load_unstructured_data.sql

