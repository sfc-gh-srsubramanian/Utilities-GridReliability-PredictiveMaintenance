/*******************************************************************************
 * SIMPLIFIED FEATURE ENGINEERING - Step-by-Step Deployment
 * 
 * Purpose: Deploy feature views ONE AT A TIME to isolate any errors
 * Run this if 01_feature_engineering.sql is giving you trouble
 * 
 * Instructions:
 * 1. Run STEP 1 first
 * 2. If it works, run STEP 2
 * 3. If it works, run STEP 3
 * 4. If all work, you can run the full 01_feature_engineering.sql
 ******************************************************************************/

-- =============================================================================
-- SETUP: Set Database and Schema
-- =============================================================================

USE DATABASE UTILITIES_GRID_RELIABILITY;
USE WAREHOUSE GRID_RELIABILITY_WH;
USE SCHEMA ML;  -- ← CRITICAL: Must be ML, not FEATURES

-- Verify we're in the right place
SELECT CURRENT_DATABASE() as DB, CURRENT_SCHEMA() as SCHEMA;

-- =============================================================================
-- STEP 1: Create VW_ASSET_FEATURES_HOURLY (Foundation View)
-- =============================================================================

CREATE OR REPLACE VIEW VW_ASSET_FEATURES_HOURLY AS
WITH sensor_stats AS (
    SELECT 
        ASSET_ID,
        DATE_TRUNC('hour', READING_TIMESTAMP) as FEATURE_TIMESTAMP,
        
        -- Current values (hourly average)
        AVG(OIL_TEMPERATURE_C) as OIL_TEMP_CURRENT,
        AVG(WINDING_TEMPERATURE_C) as WINDING_TEMP_CURRENT,
        AVG(LOAD_CURRENT_A) as LOAD_CURRENT_CURRENT,
        AVG(DISSOLVED_H2_PPM) as H2_CURRENT,
        AVG(DISSOLVED_CO_PPM) as CO_CURRENT,
        
        COUNT(*) as READING_COUNT
        
    FROM RAW.SENSOR_READINGS
    WHERE READING_TIMESTAMP >= DATEADD(hour, -24*90, CURRENT_TIMESTAMP()) -- Last 90 days
    GROUP BY ASSET_ID, DATE_TRUNC('hour', READING_TIMESTAMP)
)
SELECT 
    ASSET_ID,
    FEATURE_TIMESTAMP,
    OIL_TEMP_CURRENT,
    WINDING_TEMP_CURRENT,
    LOAD_CURRENT_CURRENT,
    H2_CURRENT,
    CO_CURRENT,
    READING_COUNT
FROM sensor_stats;

-- Test it
SELECT * FROM VW_ASSET_FEATURES_HOURLY LIMIT 5;

SELECT 'STEP 1 COMPLETE: VW_ASSET_FEATURES_HOURLY created' as STATUS;

-- =============================================================================
-- STEP 2: Create VW_ASSET_FEATURES_DAILY (Depends on Step 1)
-- =============================================================================

CREATE OR REPLACE VIEW VW_ASSET_FEATURES_DAILY AS
SELECT 
    ASSET_ID,
    DATE_TRUNC('day', FEATURE_TIMESTAMP) as FEATURE_DATE,
    
    -- Daily averages
    AVG(OIL_TEMP_CURRENT) as OIL_TEMP_DAILY_AVG,
    AVG(WINDING_TEMP_CURRENT) as WINDING_TEMP_DAILY_AVG,
    AVG(LOAD_CURRENT_CURRENT) as LOAD_CURRENT_DAILY_AVG,
    AVG(H2_CURRENT) as H2_DAILY_AVG,
    AVG(CO_CURRENT) as CO_DAILY_AVG,
    
    -- Daily max
    MAX(OIL_TEMP_CURRENT) as OIL_TEMP_DAILY_MAX,
    MAX(LOAD_CURRENT_CURRENT) as LOAD_CURRENT_DAILY_MAX,
    
    SUM(READING_COUNT) as DAILY_READING_COUNT

FROM VW_ASSET_FEATURES_HOURLY  -- ← References view from STEP 1
GROUP BY ASSET_ID, DATE_TRUNC('day', FEATURE_TIMESTAMP);

-- Test it
SELECT * FROM VW_ASSET_FEATURES_DAILY LIMIT 5;

SELECT 'STEP 2 COMPLETE: VW_ASSET_FEATURES_DAILY created' as STATUS;

-- =============================================================================
-- STEP 3: Add Asset Information
-- =============================================================================

CREATE OR REPLACE VIEW VW_ASSET_FEATURES_WITH_MASTER AS
SELECT 
    df.ASSET_ID,
    df.FEATURE_DATE,
    df.OIL_TEMP_DAILY_AVG,
    df.LOAD_CURRENT_DAILY_AVG,
    df.H2_DAILY_AVG,
    
    -- Asset information
    am.ASSET_TYPE,
    am.MANUFACTURER,
    am.CAPACITY_MVA,
    am.CRITICALITY_SCORE,
    am.CUSTOMERS_AFFECTED,
    
    -- Calculated fields
    DATEDIFF(day, am.INSTALL_DATE, df.FEATURE_DATE) / 365.25 as ASSET_AGE_YEARS,
    DATEDIFF(day, am.LAST_MAINTENANCE_DATE, df.FEATURE_DATE) as DAYS_SINCE_MAINTENANCE

FROM VW_ASSET_FEATURES_DAILY df  -- ← References view from STEP 2
JOIN RAW.ASSET_MASTER am ON df.ASSET_ID = am.ASSET_ID
WHERE am.STATUS = 'ACTIVE';

-- Test it
SELECT * FROM VW_ASSET_FEATURES_WITH_MASTER LIMIT 5;

SELECT 'STEP 3 COMPLETE: VW_ASSET_FEATURES_WITH_MASTER created' as STATUS;

-- =============================================================================
-- FINAL VERIFICATION
-- =============================================================================

-- Check all views were created
SHOW VIEWS IN SCHEMA ML;

-- Count records in each view
SELECT 'VW_ASSET_FEATURES_HOURLY' as VIEW_NAME, COUNT(*) as RECORD_COUNT 
FROM VW_ASSET_FEATURES_HOURLY
UNION ALL
SELECT 'VW_ASSET_FEATURES_DAILY' as VIEW_NAME, COUNT(*) as RECORD_COUNT 
FROM VW_ASSET_FEATURES_DAILY
UNION ALL
SELECT 'VW_ASSET_FEATURES_WITH_MASTER' as VIEW_NAME, COUNT(*) as RECORD_COUNT 
FROM VW_ASSET_FEATURES_WITH_MASTER;

SELECT '✅ ALL STEPS COMPLETE!' as STATUS;
SELECT 'All views created successfully in ML schema' as RESULT;
SELECT 'You can now run the full 01_feature_engineering.sql if desired' as NEXT_STEP;


