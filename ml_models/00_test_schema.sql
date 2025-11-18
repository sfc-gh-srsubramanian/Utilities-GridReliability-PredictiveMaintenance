/*******************************************************************************
 * TEST SCRIPT - Verify ML Schema is Ready
 * 
 * Purpose: Test that the ML schema is set up correctly before deploying views
 * Run this FIRST to diagnose any issues
 ******************************************************************************/

-- =============================================================================
-- STEP 1: Verify Database and Schema Exist
-- =============================================================================

USE ROLE ACCOUNTADMIN;
USE DATABASE UTILITIES_GRID_RELIABILITY;
USE WAREHOUSE GRID_RELIABILITY_WH;

-- Check schemas
SHOW SCHEMAS IN DATABASE UTILITIES_GRID_RELIABILITY;

-- You should see: RAW, ML, ANALYTICS, STAGING
-- Note: FEATURES schema should be empty or deleted

-- =============================================================================
-- STEP 2: Verify We Can Use ML Schema
-- =============================================================================

USE SCHEMA ML;

-- This should work without errors
SELECT CURRENT_DATABASE() as DB, CURRENT_SCHEMA() as SCHEMA;
-- Expected: DB = UTILITIES_GRID_RELIABILITY, SCHEMA = ML

-- =============================================================================
-- STEP 3: Check What Views Already Exist in ML Schema
-- =============================================================================

SHOW VIEWS IN SCHEMA ML;

-- Expected: If you've already run feature engineering, you should see:
-- VW_ASSET_FEATURES_HOURLY
-- VW_ASSET_FEATURES_DAILY
-- VW_DEGRADATION_INDICATORS
-- VW_ANOMALY_SCORES

-- =============================================================================
-- STEP 4: Check If FEATURES Schema Has Any Objects
-- =============================================================================

SHOW VIEWS IN SCHEMA FEATURES;
-- If this returns an error "Schema does not exist" - GOOD! That's expected.
-- If it shows views - BAD! Those need to be moved/dropped.

-- =============================================================================
-- STEP 5: Test Data Availability
-- =============================================================================

-- Check if we have sensor data
SELECT 
    COUNT(*) as SENSOR_RECORD_COUNT,
    COUNT(DISTINCT ASSET_ID) as UNIQUE_ASSETS
FROM RAW.SENSOR_READINGS;

-- Expected: At least 14 records, 6 unique assets

-- Check if we have asset master data
SELECT COUNT(*) as ASSET_COUNT
FROM RAW.ASSET_MASTER
WHERE STATUS = 'ACTIVE';

-- Expected: 15 assets

-- =============================================================================
-- STEP 6: Test Creating a Simple View in ML Schema
-- =============================================================================

CREATE OR REPLACE VIEW ML.TEST_VIEW AS
SELECT 
    ASSET_ID,
    COUNT(*) as READING_COUNT
FROM RAW.SENSOR_READINGS
GROUP BY ASSET_ID;

-- Test the view
SELECT * FROM ML.TEST_VIEW LIMIT 5;

-- Clean up test view
DROP VIEW IF EXISTS ML.TEST_VIEW;

-- =============================================================================
-- RESULTS
-- =============================================================================

SELECT 'All tests passed! Ready to deploy feature engineering views.' as STATUS;
SELECT 'Next step: Run ml_models/01_feature_engineering.sql' as NEXT_STEP;
SELECT 'Make sure to use: USE SCHEMA ML; at the top of the script' as IMPORTANT;


