/*******************************************************************************
 * AI-DRIVEN GRID RELIABILITY & PREDICTIVE MAINTENANCE
 * Database Setup Script - Part 2: Stages and File Formats
 * 
 * Purpose: Create external stages for data ingestion
 * Prerequisites: 01_setup_database_schema.sql must be run first
 * 
 * Author: Grid Reliability AI/ML Team
 * Date: 2025-11-15
 * Version: 1.0
 ******************************************************************************/

USE DATABASE UTILITIES_GRID_RELIABILITY;
USE WAREHOUSE GRID_RELIABILITY_WH;

-- =============================================================================
-- SECTION 1: FILE FORMATS
-- =============================================================================

USE SCHEMA RAW;

-- -----------------------------------------------------------------------------
-- CSV File Format for Asset Master Data
-- -----------------------------------------------------------------------------
CREATE OR REPLACE FILE FORMAT CSV_FORMAT
    TYPE = 'CSV'
    COMPRESSION = 'AUTO'
    FIELD_DELIMITER = ','
    RECORD_DELIMITER = '\n'
    SKIP_HEADER = 1
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'
    TRIM_SPACE = TRUE
    ERROR_ON_COLUMN_COUNT_MISMATCH = FALSE
    ESCAPE = 'NONE'
    ESCAPE_UNENCLOSED_FIELD = '\134'
    DATE_FORMAT = 'AUTO'
    TIMESTAMP_FORMAT = 'AUTO'
    NULL_IF = ('NULL', 'null', '');

-- -----------------------------------------------------------------------------
-- JSON File Format for Sensor Data
-- -----------------------------------------------------------------------------
CREATE OR REPLACE FILE FORMAT JSON_FORMAT
    TYPE = 'JSON'
    COMPRESSION = 'AUTO'
    ENABLE_OCTAL = FALSE
    ALLOW_DUPLICATE = FALSE
    STRIP_OUTER_ARRAY = TRUE
    STRIP_NULL_VALUES = FALSE
    IGNORE_UTF8_ERRORS = FALSE;

-- -----------------------------------------------------------------------------
-- Parquet File Format for Bulk Historical Data
-- -----------------------------------------------------------------------------
CREATE OR REPLACE FILE FORMAT PARQUET_FORMAT
    TYPE = 'PARQUET'
    COMPRESSION = 'SNAPPY';

-- =============================================================================
-- SECTION 2: INTERNAL STAGES
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Stage: SENSOR_DATA_STAGE
-- Purpose: Landing zone for sensor data files
-- -----------------------------------------------------------------------------
CREATE OR REPLACE STAGE SENSOR_DATA_STAGE
    FILE_FORMAT = JSON_FORMAT
    COMMENT = 'Internal stage for sensor data ingestion';

-- -----------------------------------------------------------------------------
-- Stage: ASSET_DATA_STAGE
-- Purpose: Landing zone for asset master data files
-- -----------------------------------------------------------------------------
CREATE OR REPLACE STAGE ASSET_DATA_STAGE
    FILE_FORMAT = CSV_FORMAT
    COMMENT = 'Internal stage for asset master data';

-- -----------------------------------------------------------------------------
-- Stage: MAINTENANCE_DATA_STAGE
-- Purpose: Landing zone for maintenance history files
-- -----------------------------------------------------------------------------
CREATE OR REPLACE STAGE MAINTENANCE_DATA_STAGE
    FILE_FORMAT = CSV_FORMAT
    COMMENT = 'Internal stage for maintenance records';

-- -----------------------------------------------------------------------------
-- Stage: WEATHER_DATA_STAGE
-- Purpose: Landing zone for weather data files
-- -----------------------------------------------------------------------------
CREATE OR REPLACE STAGE WEATHER_DATA_STAGE
    FILE_FORMAT = CSV_FORMAT
    COMMENT = 'Internal stage for weather data';

-- =============================================================================
-- SECTION 3: ML MODEL STAGES
-- =============================================================================

USE SCHEMA ML;

-- -----------------------------------------------------------------------------
-- Stage: MODEL_ARTIFACTS_STAGE
-- Purpose: Storage for trained ML model files
-- -----------------------------------------------------------------------------
CREATE OR REPLACE STAGE MODEL_ARTIFACTS_STAGE
    FILE_FORMAT = PARQUET_FORMAT
    COMMENT = 'Storage for serialized ML models and artifacts';

-- -----------------------------------------------------------------------------
-- Stage: TRAINING_DATA_STAGE
-- Purpose: Storage for training datasets
-- -----------------------------------------------------------------------------
CREATE OR REPLACE STAGE TRAINING_DATA_STAGE
    FILE_FORMAT = PARQUET_FORMAT
    COMMENT = 'Storage for ML training datasets';

-- =============================================================================
-- SECTION 4: SEMANTIC MODEL STAGE
-- =============================================================================

USE SCHEMA ANALYTICS;

-- Create Analytics schema if not exists (for semantic models)
CREATE SCHEMA IF NOT EXISTS ANALYTICS
    COMMENT = 'Gold layer - Business analytics and reliability metrics';

-- -----------------------------------------------------------------------------
-- Stage: SEMANTIC_MODEL_STAGE
-- Purpose: Storage for Cortex Analyst semantic model YAML files
-- -----------------------------------------------------------------------------
CREATE OR REPLACE STAGE SEMANTIC_MODEL_STAGE
    DIRECTORY = (ENABLE = TRUE)
    COMMENT = 'Storage for Cortex Analyst semantic models';

-- =============================================================================
-- SECTION 5: EXTERNAL STAGE CONFIGURATION (OPTIONAL)
-- =============================================================================

/*
-- Uncomment and configure if using external cloud storage (S3/Azure/GCS)
-- This example shows AWS S3 configuration

USE SCHEMA RAW;

-- Create external stage for S3
CREATE OR REPLACE STAGE S3_SENSOR_DATA_STAGE
    URL = 's3://your-bucket-name/sensor-data/'
    CREDENTIALS = (AWS_KEY_ID = 'your_key_id' AWS_SECRET_KEY = 'your_secret_key')
    FILE_FORMAT = JSON_FORMAT
    COMMENT = 'External S3 stage for sensor data ingestion';

-- Alternative: Using AWS IAM role (recommended)
CREATE OR REPLACE STAGE S3_SENSOR_DATA_STAGE
    URL = 's3://your-bucket-name/sensor-data/'
    STORAGE_INTEGRATION = YOUR_S3_INTEGRATION
    FILE_FORMAT = JSON_FORMAT
    COMMENT = 'External S3 stage for sensor data ingestion';
*/

-- =============================================================================
-- SECTION 6: STAGE UTILITY PROCEDURES
-- =============================================================================

USE SCHEMA RAW;

-- -----------------------------------------------------------------------------
-- Procedure: LIST_STAGE_FILES
-- Purpose: List files in a stage for monitoring
-- -----------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE LIST_STAGE_FILES(STAGE_NAME VARCHAR)
RETURNS TABLE()
LANGUAGE SQL
AS
$$
BEGIN
    LET query VARCHAR := 'LIST @' || STAGE_NAME;
    LET res RESULTSET := (EXECUTE IMMEDIATE :query);
    RETURN TABLE(res);
END;
$$;

-- -----------------------------------------------------------------------------
-- Procedure: PURGE_OLD_STAGE_FILES
-- Purpose: Clean up old files from stages
-- -----------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE PURGE_OLD_STAGE_FILES(
    STAGE_NAME VARCHAR,
    DAYS_OLD NUMBER
)
RETURNS VARCHAR
LANGUAGE SQL
AS
$$
BEGIN
    LET query VARCHAR := 'REMOVE @' || STAGE_NAME || ' PATTERN=''.*'' ' ||
                         'MODIFIED_BEFORE=(DATEADD(day, -' || DAYS_OLD || ', CURRENT_DATE()))';
    EXECUTE IMMEDIATE :query;
    RETURN 'Stage files older than ' || DAYS_OLD || ' days removed from ' || STAGE_NAME;
END;
$$;

-- =============================================================================
-- SECTION 7: STAGE VERIFICATION
-- =============================================================================

-- List all stages
SHOW STAGES;

-- Verify file formats
SHOW FILE FORMATS;

-- Grant permissions to stages
USE ROLE ACCOUNTADMIN;

GRANT READ ON STAGE RAW.SENSOR_DATA_STAGE TO ROLE GRID_ML_ENGINEER;
GRANT WRITE ON STAGE RAW.SENSOR_DATA_STAGE TO ROLE GRID_ADMIN;

GRANT READ ON STAGE ML.MODEL_ARTIFACTS_STAGE TO ROLE GRID_ML_ENGINEER;
GRANT WRITE ON STAGE ML.MODEL_ARTIFACTS_STAGE TO ROLE GRID_ML_ENGINEER;

GRANT READ ON STAGE ANALYTICS.SEMANTIC_MODEL_STAGE TO ROLE GRID_ANALYST;
GRANT WRITE ON STAGE ANALYTICS.SEMANTIC_MODEL_STAGE TO ROLE GRID_ADMIN;

-- =============================================================================
-- SECTION 8: SAMPLE DATA UPLOAD COMMANDS
-- =============================================================================

/*
-- Example: Upload sensor data from local file
PUT file:///path/to/sensor_data.json @RAW.SENSOR_DATA_STAGE AUTO_COMPRESS=TRUE;

-- Example: List uploaded files
LIST @RAW.SENSOR_DATA_STAGE;

-- Example: Remove specific file
REMOVE @RAW.SENSOR_DATA_STAGE/sensor_data.json.gz;

-- Example: Copy data from stage to table
COPY INTO RAW.SENSOR_READINGS
FROM (
    SELECT 
        $1:asset_id::VARCHAR,
        $1:timestamp::TIMESTAMP_NTZ,
        $1:oil_temp::NUMBER(5,2),
        -- ... other fields
    FROM @RAW.SENSOR_DATA_STAGE
)
FILE_FORMAT = JSON_FORMAT
ON_ERROR = 'CONTINUE';
*/

-- =============================================================================
-- SCRIPT COMPLETE
-- =============================================================================

SELECT 'Stage configuration complete!' as STATUS;
SELECT 'Internal stages created in RAW, ML, and ANALYTICS schemas' as STAGES;
SELECT 'Next Step: Run 03_create_pipes.sql for Snowpipe configuration' as NEXT_STEP;


