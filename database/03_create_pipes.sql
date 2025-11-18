/*******************************************************************************
 * AI-DRIVEN GRID RELIABILITY & PREDICTIVE MAINTENANCE
 * Database Setup Script - Part 3: Snowpipe Configuration
 * 
 * Purpose: Create Snowpipes for continuous data ingestion
 * Prerequisites: 01_setup_database_schema.sql and 02_create_stages.sql
 * 
 * Author: FPL AI/ML Team
 * Date: 2025-11-15
 * Version: 1.0
 ******************************************************************************/

USE DATABASE UTILITIES_GRID_RELIABILITY;
USE WAREHOUSE GRID_RELIABILITY_WH;
USE SCHEMA RAW;

-- =============================================================================
-- SECTION 1: SENSOR DATA SNOWPIPE
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Pipe: SENSOR_READINGS_PIPE
-- Purpose: Continuous ingestion of sensor readings from IoT/SCADA systems
-- -----------------------------------------------------------------------------
CREATE OR REPLACE PIPE SENSOR_READINGS_PIPE
    AUTO_INGEST = TRUE
    COMMENT = 'Auto-ingest sensor readings from JSON files'
AS
COPY INTO RAW.SENSOR_READINGS (
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
        $1:asset_id::VARCHAR,
        $1:reading_timestamp::TIMESTAMP_NTZ,
        $1:oil_temperature_c::NUMBER(5,2),
        $1:winding_temperature_c::NUMBER(5,2),
        $1:load_current_a::NUMBER(10,2),
        $1:load_voltage_kv::NUMBER(10,2),
        $1:ambient_temp_c::NUMBER(5,2),
        $1:humidity_pct::NUMBER(5,2),
        $1:vibration_mm_s::NUMBER(8,4),
        $1:acoustic_db::NUMBER(5,2),
        $1:dissolved_h2_ppm::NUMBER(10,2),
        $1:dissolved_co_ppm::NUMBER(10,2),
        $1:dissolved_co2_ppm::NUMBER(10,2),
        $1:dissolved_ch4_ppm::NUMBER(10,2),
        $1:bushing_temp_c::NUMBER(5,2),
        $1:tap_position::NUMBER(3),
        $1:partial_discharge_pc::NUMBER(8,2),
        $1:power_factor::NUMBER(5,4)
    FROM @RAW.SENSOR_DATA_STAGE
)
FILE_FORMAT = (FORMAT_NAME = 'JSON_FORMAT')
ON_ERROR = 'CONTINUE';

-- =============================================================================
-- SECTION 2: ASSET MASTER DATA PIPE
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Pipe: ASSET_MASTER_PIPE
-- Purpose: Ingest asset master data updates from IT systems
-- -----------------------------------------------------------------------------
CREATE OR REPLACE PIPE ASSET_MASTER_PIPE
    AUTO_INGEST = TRUE
    COMMENT = 'Auto-ingest asset master data updates from CSV files'
AS
COPY INTO STAGING.ASSET_STAGING (RAW_DATA, SOURCE_FILE)
FROM (
    SELECT 
        OBJECT_CONSTRUCT(*),
        METADATA$FILENAME
    FROM @RAW.ASSET_DATA_STAGE
)
FILE_FORMAT = (FORMAT_NAME = 'CSV_FORMAT')
ON_ERROR = 'CONTINUE';

-- =============================================================================
-- SECTION 3: MAINTENANCE HISTORY PIPE
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Pipe: MAINTENANCE_HISTORY_PIPE
-- Purpose: Ingest maintenance work order data
-- -----------------------------------------------------------------------------
CREATE OR REPLACE PIPE MAINTENANCE_HISTORY_PIPE
    AUTO_INGEST = TRUE
    COMMENT = 'Auto-ingest maintenance history from work order system'
AS
COPY INTO RAW.MAINTENANCE_HISTORY (
    MAINTENANCE_ID,
    ASSET_ID,
    MAINTENANCE_DATE,
    MAINTENANCE_TYPE,
    DESCRIPTION,
    TECHNICIAN,
    COST_USD,
    DOWNTIME_HOURS,
    OUTCOME
)
FROM (
    SELECT 
        $1::VARCHAR,
        $2::VARCHAR,
        $3::DATE,
        $4::VARCHAR,
        $5::VARCHAR,
        $6::VARCHAR,
        $7::NUMBER(12,2),
        $8::NUMBER(5,2),
        $9::VARCHAR
    FROM @RAW.MAINTENANCE_DATA_STAGE
)
FILE_FORMAT = (FORMAT_NAME = 'CSV_FORMAT')
ON_ERROR = 'CONTINUE';

-- =============================================================================
-- SECTION 4: WEATHER DATA PIPE
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Pipe: WEATHER_DATA_PIPE
-- Purpose: Ingest weather station data
-- -----------------------------------------------------------------------------
CREATE OR REPLACE PIPE WEATHER_DATA_PIPE
    AUTO_INGEST = TRUE
    COMMENT = 'Auto-ingest weather data from external sources'
AS
COPY INTO RAW.WEATHER_DATA (
    LOCATION_LAT,
    LOCATION_LON,
    OBSERVATION_TIMESTAMP,
    TEMPERATURE_C,
    HUMIDITY_PCT,
    WIND_SPEED_MPS,
    PRECIPITATION_MM,
    SOLAR_RADIATION_WM2,
    HEAT_INDEX_C
)
FROM (
    SELECT 
        $1::NUMBER(10,6),
        $2::NUMBER(10,6),
        $3::TIMESTAMP_NTZ,
        $4::NUMBER(5,2),
        $5::NUMBER(5,2),
        $6::NUMBER(5,2),
        $7::NUMBER(5,2),
        $8::NUMBER(8,2),
        $9::NUMBER(5,2)
    FROM @RAW.WEATHER_DATA_STAGE
)
FILE_FORMAT = (FORMAT_NAME = 'CSV_FORMAT')
ON_ERROR = 'CONTINUE';

-- =============================================================================
-- SECTION 5: SNOWPIPE MONITORING VIEWS
-- =============================================================================

-- -----------------------------------------------------------------------------
-- View: VW_PIPE_STATUS
-- Purpose: Monitor Snowpipe execution status
-- -----------------------------------------------------------------------------
CREATE OR REPLACE VIEW RAW.VW_PIPE_STATUS AS
SELECT 
    PIPE_NAME,
    PIPE_SCHEMA,
    DEFINITION,
    NOTIFICATION_CHANNEL_NAME,
    ERROR_INTEGRATION
FROM TABLE(INFORMATION_SCHEMA.PIPES)
WHERE PIPE_SCHEMA = 'RAW';

-- -----------------------------------------------------------------------------
-- View: VW_PIPE_USAGE_HISTORY
-- Purpose: Track Snowpipe execution history and metrics
-- -----------------------------------------------------------------------------
CREATE OR REPLACE VIEW RAW.VW_PIPE_USAGE_HISTORY AS
SELECT 
    PIPE_NAME,
    START_TIME,
    END_TIME,
    CREDITS_USED,
    BYTES_INSERTED,
    FILES_INSERTED
FROM TABLE(INFORMATION_SCHEMA.PIPE_USAGE_HISTORY(
    DATE_RANGE_START => DATEADD('day', -7, CURRENT_DATE()),
    DATE_RANGE_END => CURRENT_DATE()
));

-- =============================================================================
-- SECTION 6: SNOWPIPE UTILITY PROCEDURES
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Procedure: REFRESH_PIPE
-- Purpose: Manually trigger a pipe refresh for specific files
-- -----------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE REFRESH_PIPE(PIPE_NAME VARCHAR, FILE_PATH VARCHAR)
RETURNS VARCHAR
LANGUAGE SQL
AS
$$
BEGIN
    LET query VARCHAR := 'ALTER PIPE ' || PIPE_NAME || ' REFRESH PREFIX = ''' || FILE_PATH || '''';
    EXECUTE IMMEDIATE :query;
    RETURN 'Pipe ' || PIPE_NAME || ' refreshed for path: ' || FILE_PATH;
END;
$$;

-- -----------------------------------------------------------------------------
-- Procedure: PAUSE_PIPE
-- Purpose: Pause a Snowpipe
-- -----------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE PAUSE_PIPE(PIPE_NAME VARCHAR)
RETURNS VARCHAR
LANGUAGE SQL
AS
$$
BEGIN
    LET query VARCHAR := 'ALTER PIPE ' || PIPE_NAME || ' SET PIPE_EXECUTION_PAUSED = TRUE';
    EXECUTE IMMEDIATE :query;
    RETURN 'Pipe ' || PIPE_NAME || ' paused successfully';
END;
$$;

-- -----------------------------------------------------------------------------
-- Procedure: RESUME_PIPE
-- Purpose: Resume a paused Snowpipe
-- -----------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE RESUME_PIPE(PIPE_NAME VARCHAR)
RETURNS VARCHAR
LANGUAGE SQL
AS
$$
BEGIN
    LET query VARCHAR := 'ALTER PIPE ' || PIPE_NAME || ' SET PIPE_EXECUTION_PAUSED = FALSE';
    EXECUTE IMMEDIATE :query;
    RETURN 'Pipe ' || PIPE_NAME || ' resumed successfully';
END;
$$;

-- -----------------------------------------------------------------------------
-- Procedure: GET_PIPE_STATUS
-- Purpose: Get detailed status of a specific pipe
-- -----------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE GET_PIPE_STATUS(PIPE_NAME VARCHAR)
RETURNS TABLE(STATUS VARCHAR, LAST_RECEIVED_MESSAGE_TIMESTAMP TIMESTAMP_LTZ, LAST_FORWARDED_MESSAGE_TIMESTAMP TIMESTAMP_LTZ)
LANGUAGE SQL
AS
$$
BEGIN
    LET query VARCHAR := 'SELECT SYSTEM$PIPE_STATUS(''' || PIPE_NAME || ''')';
    LET res RESULTSET := (EXECUTE IMMEDIATE :query);
    RETURN TABLE(res);
END;
$$;

-- =============================================================================
-- SECTION 7: ERROR HANDLING AND MONITORING
-- =============================================================================

-- -----------------------------------------------------------------------------
-- View: VW_PIPE_ERRORS
-- Purpose: Monitor and track Snowpipe errors
-- -----------------------------------------------------------------------------
CREATE OR REPLACE VIEW RAW.VW_PIPE_ERRORS AS
SELECT 
    PIPE_NAME,
    FILE_NAME,
    ERROR_MESSAGE,
    ERROR_TYPE,
    FIRST_ERROR_TIME,
    LAST_ERROR_TIME,
    ERROR_COUNT
FROM TABLE(VALIDATE_PIPE_LOAD(
    PIPE_NAME => 'RAW.SENSOR_READINGS_PIPE',
    START_TIME => DATEADD('hour', -24, CURRENT_TIMESTAMP())
));

-- =============================================================================
-- SECTION 8: GRANT PERMISSIONS
-- =============================================================================

USE ROLE ACCOUNTADMIN;

-- Grant pipe ownership and monitoring to admin role
GRANT OWNERSHIP ON PIPE RAW.SENSOR_READINGS_PIPE TO ROLE GRID_ADMIN;
GRANT OWNERSHIP ON PIPE RAW.ASSET_MASTER_PIPE TO ROLE GRID_ADMIN;
GRANT OWNERSHIP ON PIPE RAW.MAINTENANCE_HISTORY_PIPE TO ROLE GRID_ADMIN;
GRANT OWNERSHIP ON PIPE RAW.WEATHER_DATA_PIPE TO ROLE GRID_ADMIN;

-- Grant monitoring privileges
GRANT MONITOR ON PIPE RAW.SENSOR_READINGS_PIPE TO ROLE GRID_OPERATOR;
GRANT MONITOR ON PIPE RAW.ASSET_MASTER_PIPE TO ROLE GRID_OPERATOR;

-- =============================================================================
-- SECTION 9: SNOWPIPE VERIFICATION
-- =============================================================================

-- Show all pipes
SHOW PIPES;

-- Check pipe status for sensor readings pipe
SELECT SYSTEM$PIPE_STATUS('RAW.SENSOR_READINGS_PIPE');

-- View recent pipe execution history
SELECT * FROM RAW.VW_PIPE_USAGE_HISTORY;

-- =============================================================================
-- SECTION 10: EXTERNAL INTEGRATION (OPTIONAL)
-- =============================================================================

/*
-- For AWS S3 Event Notifications:
-- 1. Configure S3 bucket event notifications to send to SQS
-- 2. Get the SQS queue ARN for your Snowpipe

SHOW PIPES;
-- Copy the notification_channel value from the output

-- 3. Configure S3 bucket notifications to use this SQS queue
-- 4. The pipe will automatically trigger when new files arrive

-- For Azure Event Grid:
-- Similar process using Azure Event Grid integration

-- For Google Cloud Pub/Sub:
-- Similar process using GCP Pub/Sub integration
*/

-- =============================================================================
-- SECTION 11: TESTING COMMANDS
-- =============================================================================

/*
-- Test sensor data ingestion
-- 1. Upload a test file
PUT file:///path/to/test_sensor_data.json @RAW.SENSOR_DATA_STAGE;

-- 2. Manually refresh the pipe
ALTER PIPE RAW.SENSOR_READINGS_PIPE REFRESH;

-- 3. Wait a few seconds, then check the table
SELECT COUNT(*) as RECORD_COUNT, MAX(INGESTION_TS) as LATEST_INGESTION
FROM RAW.SENSOR_READINGS;

-- 4. Check for any errors
SELECT * FROM TABLE(VALIDATE_PIPE_LOAD(
    PIPE_NAME => 'RAW.SENSOR_READINGS_PIPE',
    START_TIME => DATEADD('hour', -1, CURRENT_TIMESTAMP())
));
*/

-- =============================================================================
-- SCRIPT COMPLETE
-- =============================================================================

SELECT 'Snowpipe configuration complete!' as STATUS;
SELECT 'Pipes created: SENSOR_READINGS, ASSET_MASTER, MAINTENANCE_HISTORY, WEATHER_DATA' as PIPES;
SELECT 'AUTO_INGEST enabled - pipes will automatically process new files' as AUTO_INGEST;
SELECT 'Next Step: Run 04_create_streams_tasks.sql for change data capture' as NEXT_STEP;


