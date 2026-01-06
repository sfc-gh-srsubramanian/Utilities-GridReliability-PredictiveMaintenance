/*******************************************************************************
 * STREAMLIT IN SNOWFLAKE - GRID RELIABILITY DASHBOARD
 * 
 * This script creates a Streamlit application in Snowflake for the
 * Grid Reliability & Predictive Maintenance platform
 * 
 * Author: Grid Reliability AI/ML Team
 * Date: 2026-01-06
 * Version: 1.0
 *******************************************************************************/

USE DATABASE UTILITIES_GRID_RELIABILITY;
USE WAREHOUSE GRID_RELIABILITY_WH;
USE SCHEMA ANALYTICS;

-- ============================================================================
-- CREATE STAGE FOR STREAMLIT FILES
-- ============================================================================

CREATE STAGE IF NOT EXISTS STREAMLIT_STAGE
    COMMENT = 'Stage for Streamlit application files';

-- ============================================================================
-- INSTRUCTIONS TO UPLOAD FILES
-- ============================================================================

-- Upload the dashboard file:
-- PUT file://python/dashboard/grid_reliability_dashboard.py @UTILITIES_GRID_RELIABILITY.ANALYTICS.STREAMLIT_STAGE AUTO_COMPRESS=FALSE OVERWRITE=TRUE;

-- Note: The actual file upload will be done by deploy.sh script

-- ============================================================================
-- CREATE STREAMLIT APP
-- ============================================================================
-- Note: The environment.yml file specifies required Python packages (plotly, numpy, etc.)
-- It must be uploaded to the stage before creating the Streamlit app

CREATE OR REPLACE STREAMLIT UTILITIES_GRID_RELIABILITY.ANALYTICS.GRID_RELIABILITY_DASHBOARD
  ROOT_LOCATION = '@UTILITIES_GRID_RELIABILITY.ANALYTICS.STREAMLIT_STAGE'
  MAIN_FILE = 'grid_reliability_dashboard.py'
  QUERY_WAREHOUSE = GRID_RELIABILITY_WH
  TITLE = 'Grid Reliability & Predictive Maintenance'
  COMMENT = 'Interactive dashboard for monitoring transformer health and failure predictions';

-- ============================================================================
-- GRANT PERMISSIONS
-- ============================================================================

-- Grant access to roles
GRANT USAGE ON STREAMLIT UTILITIES_GRID_RELIABILITY.ANALYTICS.GRID_RELIABILITY_DASHBOARD TO ROLE GRID_OPERATOR;
GRANT USAGE ON STREAMLIT UTILITIES_GRID_RELIABILITY.ANALYTICS.GRID_RELIABILITY_DASHBOARD TO ROLE GRID_ANALYST;
GRANT USAGE ON STREAMLIT UTILITIES_GRID_RELIABILITY.ANALYTICS.GRID_RELIABILITY_DASHBOARD TO ROLE GRID_ADMIN;

SELECT '✅ Streamlit Dashboard Created Successfully!' AS STATUS;
SELECT 'Access URL: <your-snowflake-account>.snowflakecomputing.com/streamlit/UTILITIES_GRID_RELIABILITY.ANALYTICS.GRID_RELIABILITY_DASHBOARD' AS URL;
SELECT 'Note: Upload grid_reliability_dashboard.py to @UTILITIES_GRID_RELIABILITY.ANALYTICS.STREAMLIT_STAGE' AS NEXT_STEP;

