/*******************************************************************************
 * CORTEX SEARCH SETUP
 * 
 * Creates Cortex Search services for:
 * 1. Maintenance log documents
 * 2. Technical manuals
 * 
 * This enables semantic search across unstructured documents via Intelligence Agent
 ******************************************************************************/

USE DATABASE UTILITIES_GRID_RELIABILITY;
USE SCHEMA UNSTRUCTURED;
USE WAREHOUSE COMPUTE_WH;

-- =============================================================================
-- STEP 1: CREATE DOCUMENT SEARCH INDEX TABLE
-- =============================================================================

-- Optimized table for Cortex Search combining all document types
CREATE OR REPLACE TABLE DOCUMENT_SEARCH_INDEX AS
SELECT 
    DOCUMENT_ID as ID,
    'MAINTENANCE_LOG' as DOCUMENT_TYPE,
    ASSET_ID,
    DOCUMENT_DATE as DOC_DATE,
    TECHNICIAN_NAME as AUTHOR,
    MAINTENANCE_TYPE as CATEGORY,
    CONCAT_WS(' | ',
        'Asset: ' || ASSET_ID,
        'Type: ' || MAINTENANCE_TYPE,
        'Date: ' || DOCUMENT_DATE::VARCHAR,
        'Technician: ' || TECHNICIAN_NAME,
        'Severity: ' || SEVERITY_LEVEL,
        'Summary: ' || SUMMARY,
        'Root Causes: ' || ARRAY_TO_STRING(ROOT_CAUSE_KEYWORDS, ', '),
        'Recommendations: ' || ARRAY_TO_STRING(RECOMMENDED_ACTIONS, ', ')
    ) as SEARCH_TEXT,
    DOCUMENT_TEXT as FULL_TEXT,
    SEVERITY_LEVEL,
    FAILURE_OCCURRED,
    FILE_PATH
FROM MAINTENANCE_LOG_DOCUMENTS
UNION ALL
SELECT 
    MANUAL_ID as ID,
    'TECHNICAL_MANUAL' as DOCUMENT_TYPE,
    NULL as ASSET_ID,
    PUBLICATION_DATE as DOC_DATE,
    MANUFACTURER as AUTHOR,
    MANUAL_TYPE as CATEGORY,
    CONCAT_WS(' | ',
        'Manufacturer: ' || MANUFACTURER,
        'Model: ' || MODEL,
        'Type: ' || MANUAL_TYPE,
        'Equipment: ' || EQUIPMENT_TYPE,
        'Version: ' || VERSION
    ) as SEARCH_TEXT,
    DOCUMENT_TEXT as FULL_TEXT,
    NULL as SEVERITY_LEVEL,
    NULL as FAILURE_OCCURRED,
    FILE_PATH
FROM TECHNICAL_MANUALS;

SELECT COUNT(*) as DOCUMENTS_INDEXED FROM DOCUMENT_SEARCH_INDEX;

-- =============================================================================
-- STEP 2: CREATE CORTEX SEARCH SERVICE FOR ALL DOCUMENTS
-- =============================================================================

CREATE OR REPLACE CORTEX SEARCH SERVICE DOCUMENT_SEARCH_SERVICE
ON SEARCH_TEXT
ATTRIBUTES DOCUMENT_TYPE, ASSET_ID, AUTHOR, CATEGORY, SEVERITY_LEVEL, FAILURE_OCCURRED, DOC_DATE
WAREHOUSE = COMPUTE_WH
TARGET_LAG = '1 hour'
AS (
    SELECT 
        ID,
        SEARCH_TEXT,
        DOCUMENT_TYPE,
        ASSET_ID,
        AUTHOR,
        CATEGORY,
        SEVERITY_LEVEL,
        FAILURE_OCCURRED,
        DOC_DATE,
        FILE_PATH
    FROM DOCUMENT_SEARCH_INDEX
);

SELECT 'Cortex Search Service created: DOCUMENT_SEARCH_SERVICE' as STATUS;

-- =============================================================================
-- STEP 3: CREATE CORTEX SEARCH SERVICE FOR MAINTENANCE LOGS ONLY
-- =============================================================================

CREATE OR REPLACE CORTEX SEARCH SERVICE MAINTENANCE_LOG_SEARCH
ON SEARCH_TEXT
ATTRIBUTES ASSET_ID, MAINTENANCE_TYPE, SEVERITY_LEVEL, FAILURE_OCCURRED, TECHNICIAN_NAME, DOCUMENT_DATE
WAREHOUSE = COMPUTE_WH
TARGET_LAG = '30 minutes'
AS (
    SELECT 
        DOCUMENT_ID as ID,
        CONCAT_WS(' | ',
            'Asset: ' || ASSET_ID,
            'Type: ' || MAINTENANCE_TYPE,
            'Severity: ' || SEVERITY_LEVEL,
            'Failure: ' || IFF(FAILURE_OCCURRED, 'YES', 'NO'),
            'Summary: ' || SUMMARY,
            'Root Causes: ' || ARRAY_TO_STRING(ROOT_CAUSE_KEYWORDS, ', '),
            'Full Report: ' || DOCUMENT_TEXT
        ) as SEARCH_TEXT,
        ASSET_ID,
        MAINTENANCE_TYPE,
        SEVERITY_LEVEL,
        FAILURE_OCCURRED,
        TECHNICIAN_NAME,
        DOCUMENT_DATE,
        FILE_PATH
    FROM MAINTENANCE_LOG_DOCUMENTS
);

SELECT 'Cortex Search Service created: MAINTENANCE_LOG_SEARCH' as STATUS;

-- =============================================================================
-- STEP 4: CREATE CORTEX SEARCH SERVICE FOR TECHNICAL MANUALS
-- =============================================================================

CREATE OR REPLACE CORTEX SEARCH SERVICE TECHNICAL_MANUAL_SEARCH
ON SEARCH_TEXT
ATTRIBUTES MANUFACTURER, MODEL, MANUAL_TYPE, EQUIPMENT_TYPE
WAREHOUSE = COMPUTE_WH
TARGET_LAG = '6 hours'
AS (
    SELECT 
        MANUAL_ID as ID,
        CONCAT_WS(' | ',
            'Manufacturer: ' || MANUFACTURER,
            'Model: ' || MODEL,
            'Type: ' || MANUAL_TYPE,
            'Equipment: ' || EQUIPMENT_TYPE,
            'Content: ' || COALESCE(DOCUMENT_TEXT, 'Manual for ' || MODEL || ' ' || EQUIPMENT_TYPE)
        ) as SEARCH_TEXT,
        MANUFACTURER,
        MODEL,
        MANUAL_TYPE,
        EQUIPMENT_TYPE,
        FILE_PATH
    FROM TECHNICAL_MANUALS
);

SELECT 'Cortex Search Service created: TECHNICAL_MANUAL_SEARCH' as STATUS;

-- =============================================================================
-- STEP 5: TEST CORTEX SEARCH SERVICES
-- =============================================================================

-- Test general document search
SELECT 'Testing Document Search...' as INFO;

-- Search for high oil temperature issues
SELECT * FROM TABLE(
    DOCUMENT_SEARCH_SERVICE!SEARCH(
        QUERY => 'high oil temperature failure',
        LIMIT => 5
    )
);

-- Search for specific asset
SELECT * FROM TABLE(
    DOCUMENT_SEARCH_SERVICE!SEARCH(
        QUERY => 'T-SS047-001',
        FILTER => {'@eq': {'DOCUMENT_TYPE': 'MAINTENANCE_LOG'}},
        LIMIT => 3
    )
);

-- Test maintenance log search
SELECT 'Testing Maintenance Log Search...' as INFO;

-- Search for emergency maintenance
SELECT * FROM TABLE(
    MAINTENANCE_LOG_SEARCH!SEARCH(
        QUERY => 'emergency cooling system',
        FILTER => {'@eq': {'FAILURE_OCCURRED': true}},
        LIMIT => 5
    )
);

-- Test technical manual search
SELECT 'Testing Technical Manual Search...' as INFO;

-- Search for ABB transformer manuals
SELECT * FROM TABLE(
    TECHNICAL_MANUAL_SEARCH!SEARCH(
        QUERY => 'ABB transformer operation oil temperature',
        FILTER => {'@eq': {'MANUFACTURER': 'ABB'}},
        LIMIT => 3
    )
);

-- =============================================================================
-- STEP 6: GRANT PERMISSIONS
-- =============================================================================

GRANT USAGE ON CORTEX SEARCH SERVICE DOCUMENT_SEARCH_SERVICE TO ROLE GRID_ANALYST;
GRANT USAGE ON CORTEX SEARCH SERVICE DOCUMENT_SEARCH_SERVICE TO ROLE GRID_DATA_ENGINEER;
GRANT USAGE ON CORTEX SEARCH SERVICE DOCUMENT_SEARCH_SERVICE TO ROLE GRID_ML_ENGINEER;

GRANT USAGE ON CORTEX SEARCH SERVICE MAINTENANCE_LOG_SEARCH TO ROLE GRID_ANALYST;
GRANT USAGE ON CORTEX SEARCH SERVICE MAINTENANCE_LOG_SEARCH TO ROLE GRID_DATA_ENGINEER;

GRANT USAGE ON CORTEX SEARCH SERVICE TECHNICAL_MANUAL_SEARCH TO ROLE GRID_ANALYST;

-- =============================================================================
-- STEP 7: CREATE HELPER VIEWS FOR SEARCH RESULTS
-- =============================================================================

-- View to easily search and display maintenance logs
CREATE OR REPLACE VIEW VW_SEARCH_MAINTENANCE_LOGS AS
SELECT 
    ml.DOCUMENT_ID,
    ml.ASSET_ID,
    ml.DOCUMENT_DATE,
    ml.MAINTENANCE_TYPE,
    ml.SEVERITY_LEVEL,
    ml.FAILURE_OCCURRED,
    ml.SUMMARY,
    ml.ROOT_CAUSE_KEYWORDS,
    ml.RECOMMENDED_ACTIONS,
    ml.TECHNICIAN_NAME,
    ml.COST_USD,
    a.LOCATION_CITY,
    a.LOCATION_COUNTY,
    a.CUSTOMERS_AFFECTED
FROM MAINTENANCE_LOG_DOCUMENTS ml
LEFT JOIN UTILITIES_GRID_RELIABILITY.RAW.ASSET_MASTER a ON ml.ASSET_ID = a.ASSET_ID;

-- View to easily search and display technical manuals
CREATE OR REPLACE VIEW VW_SEARCH_TECHNICAL_MANUALS AS
SELECT 
    MANUAL_ID,
    MANUFACTURER,
    MODEL,
    MANUAL_TYPE,
    EQUIPMENT_TYPE,
    VERSION,
    PUBLICATION_DATE,
    PAGE_COUNT,
    FILE_PATH,
    ARRAY_SIZE(APPLICABLE_TO_ASSETS) as APPLICABLE_ASSET_COUNT
FROM TECHNICAL_MANUALS;

-- =============================================================================
-- SUMMARY
-- =============================================================================

SELECT 'CORTEX SEARCH SETUP COMPLETE!' as STATUS;
SELECT '---------------------------------------------------' as LINE;
SELECT '3 Cortex Search Services Created:' as INFO;
SELECT '  1. DOCUMENT_SEARCH_SERVICE (All documents)' as SERVICE_1;
SELECT '  2. MAINTENANCE_LOG_SEARCH (Maintenance logs only)' as SERVICE_2;
SELECT '  3. TECHNICAL_MANUAL_SEARCH (Technical manuals only)' as SERVICE_3;
SELECT '' as BLANK;
SELECT 'Ready for Intelligence Agent Integration' as NEXT_STEP;
SELECT 'Test searches above to verify functionality' as TEST;

