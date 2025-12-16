/*******************************************************************************
 * AI-DRIVEN GRID RELIABILITY & PREDICTIVE MAINTENANCE
 * Database Setup Script - Part 4: Streams and Tasks
 * 
 * Purpose: Create change data capture streams and scheduled tasks for automation
 * Prerequisites: Scripts 01, 02, and 03 must be run first
 * 
 * Author: Grid Reliability AI/ML Team
 * Date: 2025-11-15
 * Version: 1.0
 ******************************************************************************/

USE DATABASE UTILITIES_GRID_RELIABILITY;
USE WAREHOUSE GRID_RELIABILITY_WH;

-- =============================================================================
-- SECTION 1: STREAMS FOR CHANGE DATA CAPTURE
-- =============================================================================

USE SCHEMA RAW;

-- -----------------------------------------------------------------------------
-- Stream: SENSOR_READINGS_STREAM
-- Purpose: Capture new sensor readings for feature engineering
-- -----------------------------------------------------------------------------
CREATE OR REPLACE STREAM SENSOR_READINGS_STREAM ON TABLE SENSOR_READINGS
    COMMENT = 'Captures new sensor readings for downstream processing';

-- -----------------------------------------------------------------------------
-- Stream: ASSET_MASTER_STREAM
-- Purpose: Capture changes to asset master data
-- -----------------------------------------------------------------------------
CREATE OR REPLACE STREAM ASSET_MASTER_STREAM ON TABLE ASSET_MASTER
    COMMENT = 'Captures changes to asset master data';

-- -----------------------------------------------------------------------------
-- Stream: MAINTENANCE_HISTORY_STREAM
-- Purpose: Capture new maintenance records
-- -----------------------------------------------------------------------------
CREATE OR REPLACE STREAM MAINTENANCE_HISTORY_STREAM ON TABLE MAINTENANCE_HISTORY
    COMMENT = 'Captures new maintenance work orders';

-- =============================================================================
-- SECTION 2: TASK PREREQUISITES - ENABLE TASK EXECUTION
-- =============================================================================

-- Enable task execution at account level (requires ACCOUNTADMIN)
USE ROLE ACCOUNTADMIN;

-- Verify task execution is enabled
-- ALTER ACCOUNT SET TASK_AUTO_RETRY_ATTEMPTS = 3;

-- =============================================================================
-- SECTION 3: FEATURE ENGINEERING TASK
-- =============================================================================

USE SCHEMA FEATURES;

-- First, create a task that computes features from new sensor data
-- This runs every 15 minutes to keep features fresh

CREATE OR REPLACE TASK TASK_UPDATE_ASSET_FEATURES
    WAREHOUSE = GRID_RELIABILITY_WH
    SCHEDULE = '15 MINUTE'
    COMMENT = 'Update asset features every 15 minutes from new sensor readings'
WHEN
    SYSTEM$STREAM_HAS_DATA('RAW.SENSOR_READINGS_STREAM')
AS
-- This task will be implemented after feature views are created
-- Placeholder for now
SELECT 'Feature update task - to be implemented' as STATUS;

-- Suspend the task initially (will be resumed after feature views are created)
ALTER TASK TASK_UPDATE_ASSET_FEATURES SUSPEND;

-- =============================================================================
-- SECTION 4: MODEL SCORING TASK
-- =============================================================================

USE SCHEMA ML;

-- -----------------------------------------------------------------------------
-- Task: TASK_SCORE_ASSETS
-- Purpose: Run ML model predictions hourly on all active assets
-- -----------------------------------------------------------------------------
CREATE OR REPLACE TASK TASK_SCORE_ASSETS
    WAREHOUSE = GRID_RELIABILITY_WH
    SCHEDULE = 'USING CRON 0 * * * * America/New_York' -- Every hour
    COMMENT = 'Run predictive models on all active assets hourly'
AS
-- This task will call the model scoring stored procedure
-- Placeholder for now
SELECT 'Model scoring task - to be implemented' as STATUS;

-- Suspend initially
ALTER TASK TASK_SCORE_ASSETS SUSPEND;

-- =============================================================================
-- SECTION 5: ALERT GENERATION TASK
-- =============================================================================

USE SCHEMA ML;

-- -----------------------------------------------------------------------------
-- Task: TASK_GENERATE_ALERTS
-- Purpose: Check for high-risk predictions and generate alerts
-- Runs 5 minutes after scoring task
-- -----------------------------------------------------------------------------
CREATE OR REPLACE TASK TASK_GENERATE_ALERTS
    WAREHOUSE = GRID_RELIABILITY_WH
    SCHEDULE = 'USING CRON 5 * * * * America/New_York' -- 5 minutes past every hour
    COMMENT = 'Generate alerts for high-risk assets'
AS
-- Update alert flags in predictions table
UPDATE MODEL_PREDICTIONS
SET 
    ALERT_GENERATED = TRUE,
    ALERT_LEVEL = CASE 
        WHEN RISK_SCORE >= 86 THEN 'CRITICAL'
        WHEN RISK_SCORE >= 71 THEN 'HIGH'
        WHEN RISK_SCORE >= 41 THEN 'MEDIUM'
        ELSE 'LOW'
    END
WHERE PREDICTION_TIMESTAMP >= DATEADD(hour, -1, CURRENT_TIMESTAMP())
  AND RISK_SCORE >= 41
  AND ALERT_GENERATED = FALSE;

-- Suspend initially
ALTER TASK TASK_GENERATE_ALERTS SUSPEND;

-- =============================================================================
-- SECTION 6: MAINTENANCE UPDATE TASK
-- =============================================================================

USE SCHEMA RAW;

-- -----------------------------------------------------------------------------
-- Task: TASK_UPDATE_LAST_MAINTENANCE
-- Purpose: Update asset master with latest maintenance dates
-- Runs daily at 2 AM
-- -----------------------------------------------------------------------------
CREATE OR REPLACE TASK TASK_UPDATE_LAST_MAINTENANCE
    WAREHOUSE = GRID_RELIABILITY_WH
    SCHEDULE = 'USING CRON 0 2 * * * America/New_York' -- 2 AM daily
    COMMENT = 'Update last maintenance dates in asset master'
AS
MERGE INTO ASSET_MASTER am
USING (
    SELECT 
        ASSET_ID,
        MAX(MAINTENANCE_DATE) as LATEST_MAINTENANCE
    FROM MAINTENANCE_HISTORY
    WHERE MAINTENANCE_DATE >= DATEADD(day, -1, CURRENT_DATE())
    GROUP BY ASSET_ID
) mh
ON am.ASSET_ID = mh.ASSET_ID
WHEN MATCHED THEN UPDATE SET 
    am.LAST_MAINTENANCE_DATE = mh.LATEST_MAINTENANCE,
    am.UPDATED_TS = CURRENT_TIMESTAMP();

-- Suspend initially
ALTER TASK TASK_UPDATE_LAST_MAINTENANCE SUSPEND;

-- =============================================================================
-- SECTION 7: DATA QUALITY MONITORING TASK
-- =============================================================================

USE SCHEMA RAW;

-- Create a table to log data quality metrics
CREATE OR REPLACE TABLE DATA_QUALITY_LOG (
    LOG_ID NUMBER(38,0) AUTOINCREMENT PRIMARY KEY,
    CHECK_TIMESTAMP TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    TABLE_NAME VARCHAR(100),
    METRIC_NAME VARCHAR(100),
    METRIC_VALUE NUMBER(20,4),
    THRESHOLD_VALUE NUMBER(20,4),
    ALERT_FLAG BOOLEAN,
    DETAILS VARIANT
);

-- -----------------------------------------------------------------------------
-- Task: TASK_DATA_QUALITY_CHECK
-- Purpose: Monitor data quality metrics
-- Runs every 30 minutes
-- -----------------------------------------------------------------------------
CREATE OR REPLACE TASK TASK_DATA_QUALITY_CHECK
    WAREHOUSE = GRID_RELIABILITY_WH
    SCHEDULE = '30 MINUTE'
    COMMENT = 'Monitor data quality and freshness'
AS
BEGIN
    -- Check sensor data freshness
    INSERT INTO DATA_QUALITY_LOG (TABLE_NAME, METRIC_NAME, METRIC_VALUE, THRESHOLD_VALUE, ALERT_FLAG)
    SELECT 
        'SENSOR_READINGS' as TABLE_NAME,
        'DATA_FRESHNESS_MINUTES' as METRIC_NAME,
        DATEDIFF(minute, MAX(READING_TIMESTAMP), CURRENT_TIMESTAMP()) as METRIC_VALUE,
        15 as THRESHOLD_VALUE,
        CASE WHEN DATEDIFF(minute, MAX(READING_TIMESTAMP), CURRENT_TIMESTAMP()) > 15 
             THEN TRUE ELSE FALSE END as ALERT_FLAG
    FROM SENSOR_READINGS;
    
    -- Check for null values in critical fields
    INSERT INTO DATA_QUALITY_LOG (TABLE_NAME, METRIC_NAME, METRIC_VALUE, THRESHOLD_VALUE, ALERT_FLAG)
    SELECT 
        'SENSOR_READINGS' as TABLE_NAME,
        'NULL_PERCENTAGE_OIL_TEMP' as METRIC_NAME,
        (COUNT_IF(OIL_TEMPERATURE_C IS NULL) * 100.0 / COUNT(*)) as METRIC_VALUE,
        5.0 as THRESHOLD_VALUE,
        CASE WHEN (COUNT_IF(OIL_TEMPERATURE_C IS NULL) * 100.0 / COUNT(*)) > 5.0 
             THEN TRUE ELSE FALSE END as ALERT_FLAG
    FROM SENSOR_READINGS
    WHERE READING_TIMESTAMP >= DATEADD(hour, -1, CURRENT_TIMESTAMP());
    
    -- Check for duplicate readings
    INSERT INTO DATA_QUALITY_LOG (TABLE_NAME, METRIC_NAME, METRIC_VALUE, THRESHOLD_VALUE, ALERT_FLAG)
    SELECT 
        'SENSOR_READINGS' as TABLE_NAME,
        'DUPLICATE_READINGS_COUNT' as METRIC_NAME,
        COUNT(*) as METRIC_VALUE,
        10 as THRESHOLD_VALUE,
        CASE WHEN COUNT(*) > 10 THEN TRUE ELSE FALSE END as ALERT_FLAG
    FROM (
        SELECT ASSET_ID, READING_TIMESTAMP, COUNT(*) as CNT
        FROM SENSOR_READINGS
        WHERE READING_TIMESTAMP >= DATEADD(hour, -1, CURRENT_TIMESTAMP())
        GROUP BY ASSET_ID, READING_TIMESTAMP
        HAVING COUNT(*) > 1
    );
END;

-- Suspend initially
ALTER TASK TASK_DATA_QUALITY_CHECK SUSPEND;

-- =============================================================================
-- SECTION 8: MODEL RETRAINING TASK
-- =============================================================================

USE SCHEMA ML;

-- -----------------------------------------------------------------------------
-- Task: TASK_MODEL_RETRAINING
-- Purpose: Trigger weekly model retraining
-- Runs every Sunday at 3 AM
-- -----------------------------------------------------------------------------
CREATE OR REPLACE TASK TASK_MODEL_RETRAINING
    WAREHOUSE = GRID_RELIABILITY_WH
    SCHEDULE = 'USING CRON 0 3 * * 0 America/New_York' -- 3 AM every Sunday
    COMMENT = 'Trigger weekly model retraining with latest data'
AS
-- This will call the model training stored procedure
-- Placeholder for now
SELECT 'Model retraining task - to be implemented' as STATUS;

-- Suspend initially
ALTER TASK TASK_MODEL_RETRAINING SUSPEND;

-- =============================================================================
-- SECTION 9: TASK MONITORING VIEWS
-- =============================================================================

USE SCHEMA RAW;

-- -----------------------------------------------------------------------------
-- View: VW_TASK_HISTORY
-- Purpose: Monitor task execution history
-- -----------------------------------------------------------------------------
CREATE OR REPLACE VIEW VW_TASK_HISTORY AS
SELECT 
    NAME as TASK_NAME,
    DATABASE_NAME,
    SCHEMA_NAME,
    STATE,
    SCHEDULED_TIME,
    QUERY_START_TIME,
    COMPLETED_TIME,
    RETURN_VALUE,
    ERROR_CODE,
    ERROR_MESSAGE
FROM TABLE(INFORMATION_SCHEMA.TASK_HISTORY(
    SCHEDULED_TIME_RANGE_START => DATEADD('day', -7, CURRENT_TIMESTAMP())
))
ORDER BY SCHEDULED_TIME DESC;

-- -----------------------------------------------------------------------------
-- View: VW_ACTIVE_TASKS
-- Purpose: Show all active tasks and their schedules
-- -----------------------------------------------------------------------------
CREATE OR REPLACE VIEW VW_ACTIVE_TASKS AS
SELECT 
    NAME as TASK_NAME,
    DATABASE_NAME,
    SCHEMA_NAME,
    SCHEDULE,
    STATE,
    WAREHOUSE,
    CONDITION_TEXT,
    DEFINITION
FROM TABLE(INFORMATION_SCHEMA.TASKS)
WHERE DATABASE_NAME = 'UTILITIES_GRID_RELIABILITY'
ORDER BY SCHEMA_NAME, NAME;

-- =============================================================================
-- SECTION 10: TASK MANAGEMENT PROCEDURES
-- =============================================================================

USE SCHEMA RAW;

-- -----------------------------------------------------------------------------
-- Procedure: RESUME_ALL_TASKS
-- Purpose: Resume all suspended tasks (use after setup is complete)
-- -----------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE RESUME_ALL_TASKS()
RETURNS VARCHAR
LANGUAGE SQL
AS
$$
BEGIN
    ALTER TASK FEATURES.TASK_UPDATE_ASSET_FEATURES RESUME;
    ALTER TASK ML.TASK_SCORE_ASSETS RESUME;
    ALTER TASK ML.TASK_GENERATE_ALERTS RESUME;
    ALTER TASK RAW.TASK_UPDATE_LAST_MAINTENANCE RESUME;
    ALTER TASK RAW.TASK_DATA_QUALITY_CHECK RESUME;
    ALTER TASK ML.TASK_MODEL_RETRAINING RESUME;
    RETURN 'All tasks resumed successfully';
EXCEPTION
    WHEN OTHER THEN
        RETURN 'Error resuming tasks: ' || SQLERRM;
END;
$$;

-- -----------------------------------------------------------------------------
-- Procedure: SUSPEND_ALL_TASKS
-- Purpose: Suspend all tasks (useful for maintenance)
-- -----------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE SUSPEND_ALL_TASKS()
RETURNS VARCHAR
LANGUAGE SQL
AS
$$
BEGIN
    ALTER TASK FEATURES.TASK_UPDATE_ASSET_FEATURES SUSPEND;
    ALTER TASK ML.TASK_SCORE_ASSETS SUSPEND;
    ALTER TASK ML.TASK_GENERATE_ALERTS SUSPEND;
    ALTER TASK RAW.TASK_UPDATE_LAST_MAINTENANCE SUSPEND;
    ALTER TASK RAW.TASK_DATA_QUALITY_CHECK SUSPEND;
    ALTER TASK ML.TASK_MODEL_RETRAINING SUSPEND;
    RETURN 'All tasks suspended successfully';
EXCEPTION
    WHEN OTHER THEN
        RETURN 'Error suspending tasks: ' || SQLERRM;
END;
$$;

-- -----------------------------------------------------------------------------
-- Procedure: GET_TASK_STATUS
-- Purpose: Get current status of all tasks
-- -----------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE GET_TASK_STATUS()
RETURNS TABLE(TASK_NAME VARCHAR, STATE VARCHAR, LAST_RUN TIMESTAMP_LTZ, NEXT_RUN TIMESTAMP_LTZ)
LANGUAGE SQL
AS
$$
BEGIN
    LET res RESULTSET := (
        SELECT 
            NAME as TASK_NAME,
            STATE,
            LAST_COMMITTED_ON as LAST_RUN,
            SCHEDULED_FROM as NEXT_RUN
        FROM TABLE(INFORMATION_SCHEMA.TASKS)
        WHERE DATABASE_NAME = 'UTILITIES_GRID_RELIABILITY'
        ORDER BY SCHEMA_NAME, NAME
    );
    RETURN TABLE(res);
END;
$$;

-- =============================================================================
-- SECTION 11: STREAM MONITORING
-- =============================================================================

-- -----------------------------------------------------------------------------
-- View: VW_STREAM_STATUS
-- Purpose: Monitor stream lag and records pending
-- -----------------------------------------------------------------------------
CREATE OR REPLACE VIEW VW_STREAM_STATUS AS
SELECT 
    'SENSOR_READINGS_STREAM' as STREAM_NAME,
    COUNT(*) as PENDING_RECORDS,
    MIN(READING_TIMESTAMP) as OLDEST_PENDING,
    MAX(READING_TIMESTAMP) as NEWEST_PENDING
FROM RAW.SENSOR_READINGS_STREAM
UNION ALL
SELECT 
    'ASSET_MASTER_STREAM' as STREAM_NAME,
    COUNT(*) as PENDING_RECORDS,
    MIN(UPDATED_TS) as OLDEST_PENDING,
    MAX(UPDATED_TS) as NEWEST_PENDING
FROM RAW.ASSET_MASTER_STREAM
UNION ALL
SELECT 
    'MAINTENANCE_HISTORY_STREAM' as STREAM_NAME,
    COUNT(*) as PENDING_RECORDS,
    MIN(CREATED_TS) as OLDEST_PENDING,
    MAX(CREATED_TS) as NEWEST_PENDING
FROM RAW.MAINTENANCE_HISTORY_STREAM;

-- =============================================================================
-- SECTION 12: GRANT PERMISSIONS
-- =============================================================================

USE ROLE ACCOUNTADMIN;

-- Grant task execution privileges
GRANT EXECUTE TASK ON ACCOUNT TO ROLE GRID_ADMIN;
GRANT EXECUTE MANAGED TASK ON ACCOUNT TO ROLE GRID_ADMIN;

-- Grant stream privileges
GRANT SELECT ON STREAM RAW.SENSOR_READINGS_STREAM TO ROLE GRID_ML_ENGINEER;
GRANT SELECT ON STREAM RAW.ASSET_MASTER_STREAM TO ROLE GRID_ML_ENGINEER;

-- Grant view privileges
GRANT SELECT ON VIEW RAW.VW_TASK_HISTORY TO ROLE GRID_OPERATOR;
GRANT SELECT ON VIEW RAW.VW_ACTIVE_TASKS TO ROLE GRID_OPERATOR;
GRANT SELECT ON VIEW RAW.VW_STREAM_STATUS TO ROLE GRID_OPERATOR;

-- =============================================================================
-- SECTION 13: TASK DEPENDENCIES (OPTIONAL)
-- =============================================================================

/*
-- If you want to chain tasks (one depends on another), use this pattern:

CREATE OR REPLACE TASK TASK_CHILD
    WAREHOUSE = GRID_RELIABILITY_WH
    AFTER TASK_PARENT
AS
-- Task logic here
SELECT 'Child task executed' as STATUS;

-- Resume parent first, then child
ALTER TASK TASK_PARENT RESUME;
ALTER TASK TASK_CHILD RESUME;
*/

-- =============================================================================
-- SECTION 14: VERIFICATION
-- =============================================================================

-- Show all tasks
SHOW TASKS IN DATABASE UTILITIES_GRID_RELIABILITY;

-- Show all streams
SHOW STREAMS IN DATABASE UTILITIES_GRID_RELIABILITY;

-- Check task history
SELECT * FROM RAW.VW_TASK_HISTORY LIMIT 10;

-- Check active tasks
SELECT * FROM RAW.VW_ACTIVE_TASKS;

-- Check stream status
SELECT * FROM RAW.VW_STREAM_STATUS;

-- =============================================================================
-- SECTION 15: TESTING COMMANDS
-- =============================================================================

/*
-- Test stream functionality
-- 1. Insert test data
INSERT INTO RAW.SENSOR_READINGS (ASSET_ID, READING_TIMESTAMP, OIL_TEMPERATURE_C)
VALUES ('TEST-001', CURRENT_TIMESTAMP(), 85.5);

-- 2. Check if stream captured it
SELECT * FROM RAW.SENSOR_READINGS_STREAM WHERE ASSET_ID = 'TEST-001';

-- 3. Consume the stream (this would normally be done by a task)
BEGIN;
    CREATE OR REPLACE TEMP TABLE TEMP_CONSUMED AS 
    SELECT * FROM RAW.SENSOR_READINGS_STREAM;
    
    -- Process the data
    SELECT COUNT(*) FROM TEMP_CONSUMED;
COMMIT;

-- 4. Verify stream is now empty
SELECT * FROM RAW.SENSOR_READINGS_STREAM WHERE ASSET_ID = 'TEST-001';

-- Manual task execution (for testing)
EXECUTE TASK RAW.TASK_DATA_QUALITY_CHECK;

-- Check task execution status
SELECT * FROM TABLE(INFORMATION_SCHEMA.TASK_HISTORY())
WHERE NAME = 'TASK_DATA_QUALITY_CHECK'
ORDER BY SCHEDULED_TIME DESC
LIMIT 5;
*/

-- =============================================================================
-- SCRIPT COMPLETE
-- =============================================================================

SELECT 'Streams and Tasks configuration complete!' as STATUS;
SELECT 'Streams: SENSOR_READINGS, ASSET_MASTER, MAINTENANCE_HISTORY' as STREAMS;
SELECT 'Tasks: 6 tasks created (all suspended initially)' as TASKS;
SELECT 'Note: Tasks are suspended. Resume after ML models are deployed.' as IMPORTANT;
SELECT 'Use CALL RAW.RESUME_ALL_TASKS() to start automation.' as NEXT_ACTION;


