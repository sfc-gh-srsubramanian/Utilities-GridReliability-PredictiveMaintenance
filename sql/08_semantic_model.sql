/*******************************************************************************
 * AI-DRIVEN GRID RELIABILITY & PREDICTIVE MAINTENANCE
 * Semantic Model Setup
 * 
 * Purpose: Create semantic view and upload semantic model for Cortex Analyst
 * Prerequisites: All ANALYTICS views must be created
 * 
 * Author: Grid Reliability AI/ML Team
 * Date: 2025-11-15
 * Version: 1.0
 ******************************************************************************/

USE DATABASE UTILITIES_GRID_RELIABILITY;
USE WAREHOUSE GRID_RELIABILITY_WH;
USE SCHEMA ANALYTICS;

-- =============================================================================
-- SECTION 1: CREATE SEMANTIC VIEW
-- =============================================================================

-- Following the user's preferred syntax for semantic views
CREATE OR REPLACE SEMANTIC VIEW GRID_RELIABILITY_ANALYTICS
TABLES (
  ASSET_HEALTH AS UTILITIES_GRID_RELIABILITY.ANALYTICS.VW_ASSET_HEALTH_DASHBOARD 
    PRIMARY KEY (ASSET_ID),
  HIGH_RISK AS UTILITIES_GRID_RELIABILITY.ANALYTICS.VW_HIGH_RISK_ASSETS 
    PRIMARY KEY (ASSET_ID),
  ASSET_MASTER AS UTILITIES_GRID_RELIABILITY.RAW.ASSET_MASTER 
    PRIMARY KEY (ASSET_ID)
)
RELATIONSHIPS (
  HEALTH_TO_MASTER AS ASSET_HEALTH(ASSET_ID) REFERENCES ASSET_MASTER(ASSET_ID),
  HIGH_RISK_TO_MASTER AS HIGH_RISK(ASSET_ID) REFERENCES ASSET_MASTER(ASSET_ID)
)
FACTS (
  PUBLIC ASSET_HEALTH.RISK_SCORE AS risk_score,
  PUBLIC ASSET_HEALTH.FAILURE_PROBABILITY AS failure_probability,
  PUBLIC ASSET_HEALTH.PREDICTED_RUL_DAYS AS predicted_rul_days,
  PUBLIC HIGH_RISK.ESTIMATED_SAIDI_IMPACT AS estimated_saidi_impact,
  PUBLIC ASSET_MASTER.REPLACEMENT_COST_USD AS replacement_cost
)
DIMENSIONS (
  PUBLIC ASSET_HEALTH.ASSET_ID AS asset_id,
  PUBLIC ASSET_HEALTH.ASSET_TYPE AS asset_type,
  PUBLIC ASSET_HEALTH.LOCATION_SUBSTATION AS location_substation,
  PUBLIC ASSET_HEALTH.LOCATION_CITY AS location_city,
  PUBLIC ASSET_HEALTH.LOCATION_COUNTY AS location_county,
  PUBLIC ASSET_HEALTH.LOCATION_LAT AS location_lat,
  PUBLIC ASSET_HEALTH.LOCATION_LON AS location_lon,
  PUBLIC ASSET_HEALTH.RISK_CATEGORY AS risk_category,
  PUBLIC ASSET_HEALTH.ALERT_LEVEL AS alert_level,
  PUBLIC ASSET_HEALTH.CUSTOMERS_AFFECTED AS customers_affected,
  PUBLIC ASSET_HEALTH.CRITICALITY_SCORE AS criticality_score,
  PUBLIC ASSET_HEALTH.DAYS_SINCE_MAINTENANCE AS days_since_maintenance,
  PUBLIC ASSET_HEALTH.ASSET_AGE_YEARS AS asset_age_years,
  PUBLIC HIGH_RISK.RECOMMENDED_ACTION_TIMELINE AS recommended_timeline,
  PUBLIC HIGH_RISK.WORK_ORDER_PRIORITY AS work_order_priority,
  PUBLIC ASSET_MASTER.MANUFACTURER AS manufacturer,
  PUBLIC ASSET_MASTER.MODEL AS model,
  PUBLIC ASSET_MASTER.INSTALL_DATE AS install_date,
  PUBLIC ASSET_MASTER.CAPACITY_MVA AS capacity_mva,
  PUBLIC ASSET_MASTER.VOLTAGE_RATING_KV AS voltage_rating_kv
)
METRICS (
  PUBLIC ASSET_HEALTH.TOTAL_ASSETS AS COUNT(DISTINCT asset_health.asset_id),
  PUBLIC ASSET_HEALTH.AVG_RISK_SCORE AS AVG(risk_score),
  PUBLIC ASSET_HEALTH.MAX_RISK_SCORE AS MAX(risk_score),
  PUBLIC ASSET_HEALTH.HIGH_RISK_COUNT AS COUNT_IF(risk_score >= 71),
  PUBLIC ASSET_HEALTH.CRITICAL_COUNT AS COUNT_IF(risk_score >= 86),
  PUBLIC ASSET_HEALTH.TOTAL_CUSTOMERS_AT_RISK AS SUM(customers_affected),
  PUBLIC HIGH_RISK.TOTAL_SAIDI_IMPACT AS SUM(estimated_saidi_impact)
);

-- =============================================================================
-- SECTION 2: UPLOAD SEMANTIC MODEL YAML
-- =============================================================================

-- First, upload the YAML file to the stage
/*
Instructions:
1. Upload the semantic model YAML file:
   
   PUT file:///path/to/grid_reliability_semantic.yaml @ANALYTICS.SEMANTIC_MODEL_STAGE 
   AUTO_COMPRESS=FALSE OVERWRITE=TRUE;

2. Verify the upload:
   
   LIST @ANALYTICS.SEMANTIC_MODEL_STAGE;

3. The semantic model will be available at:
   @ANALYTICS.SEMANTIC_MODEL_STAGE/grid_reliability_semantic.yaml
*/

-- =============================================================================
-- SECTION 3: TEST SEMANTIC VIEW
-- =============================================================================

-- Query the semantic view to verify it works
SELECT 
    ASSET_ID,
    LOCATION_SUBSTATION,
    LOCATION_COUNTY,
    RISK_SCORE,
    FAILURE_PROBABILITY,
    CUSTOMERS_AFFECTED,
    ALERT_LEVEL
FROM GRID_RELIABILITY_ANALYTICS.ASSET_HEALTH
WHERE RISK_SCORE >= 71
ORDER BY RISK_SCORE DESC
LIMIT 10;

-- Test aggregation through semantic view
SELECT 
    LOCATION_COUNTY,
    COUNT(DISTINCT ASSET_ID) as ASSET_COUNT,
    AVG(RISK_SCORE) as AVG_RISK,
    SUM(CUSTOMERS_AFFECTED) as TOTAL_CUSTOMERS
FROM GRID_RELIABILITY_ANALYTICS.ASSET_HEALTH
GROUP BY LOCATION_COUNTY
ORDER BY AVG_RISK DESC;

-- =============================================================================
-- SECTION 4: GRANT PERMISSIONS
-- =============================================================================

-- Grant usage on semantic view
USE ROLE ACCOUNTADMIN;

GRANT USAGE ON SEMANTIC VIEW ANALYTICS.GRID_RELIABILITY_ANALYTICS TO ROLE GRID_ANALYST;
GRANT USAGE ON SEMANTIC VIEW ANALYTICS.GRID_RELIABILITY_ANALYTICS TO ROLE GRID_OPERATOR;
GRANT USAGE ON SEMANTIC VIEW ANALYTICS.GRID_RELIABILITY_ANALYTICS TO ROLE GRID_ML_ENGINEER;

-- Grant read access to semantic model stage
GRANT READ ON STAGE ANALYTICS.SEMANTIC_MODEL_STAGE TO ROLE GRID_ANALYST;
GRANT READ ON STAGE ANALYTICS.SEMANTIC_MODEL_STAGE TO ROLE GRID_OPERATOR;

-- =============================================================================
-- SECTION 5: CREATE CORTEX ANALYST FUNCTION (OPTIONAL)
-- =============================================================================

-- This function can be used to query the semantic model using natural language
CREATE OR REPLACE FUNCTION ANALYTICS.ASK_GRID_ANALYST(QUESTION VARCHAR)
RETURNS TABLE (RESPONSE VARCHAR)
LANGUAGE SQL
AS
$$
    -- This is a placeholder for Cortex Analyst integration
    -- Will be replaced with actual CORTEX_ANALYST() function when available
    SELECT 'Cortex Analyst integration pending. Use Snowflake Intelligence Agent instead.' as RESPONSE
$$;

-- =============================================================================
-- SECTION 6: VERIFICATION AND DOCUMENTATION
-- =============================================================================

-- Show semantic view structure
DESCRIBE SEMANTIC VIEW GRID_RELIABILITY_ANALYTICS;

-- Show all tables in semantic view
SHOW TABLES IN SEMANTIC VIEW GRID_RELIABILITY_ANALYTICS;

-- Documentation for users
SELECT 
    'Semantic View Created Successfully' as STATUS,
    'GRID_RELIABILITY_ANALYTICS' as VIEW_NAME,
    'Use Snowflake Intelligence Agent for natural language queries' as USAGE,
    '@ANALYTICS.SEMANTIC_MODEL_STAGE/grid_reliability_semantic.yaml' as SEMANTIC_MODEL_PATH;

-- =============================================================================
-- SAMPLE NATURAL LANGUAGE QUERIES
-- =============================================================================

/*
Once the Intelligence Agent is configured, users can ask questions like:

1. "Which substations have the highest risk?"
2. "How many critical assets are there in Miami-Dade county?"
3. "What is the total SAIDI impact if all high-risk assets fail?"
4. "Show me assets that need maintenance in the next 7 days"
5. "What is the average failure probability by county?"
6. "How much money are we saving with predictive maintenance?"
7. "List all transformers with risk score above 80"
8. "Which 5 assets affect the most customers?"
9. "Show me the trend of risk scores over the last month"
10. "What is the predicted remaining life of transformer T-SS047-001?"
*/

-- =============================================================================
-- SCRIPT COMPLETE
-- =============================================================================

SELECT 'Semantic view creation complete!' as STATUS;
SELECT 'View: ANALYTICS.GRID_RELIABILITY_ANALYTICS' as SEMANTIC_VIEW;
SELECT 'Upload YAML file: PUT file:///.../grid_reliability_semantic.yaml @ANALYTICS.SEMANTIC_MODEL_STAGE' as NEXT_STEP;
SELECT 'Then run: agents/create_grid_intelligence_agent.sql' as FINAL_STEP;


