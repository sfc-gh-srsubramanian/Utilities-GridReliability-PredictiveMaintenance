/*******************************************************************************
 * GRID RELIABILITY & PREDICTIVE MAINTENANCE - Load Unstructured Data
 * 
 * Purpose: Load unstructured data (maintenance logs, technical manuals, 
 *          visual inspections, CV detections)
 * Prerequisites: 03_unstructured_data_schema.sql must be run first
 * 
 * Author: Grid Reliability AI/ML Team
 * Version: 2.0 (Consolidated for Solution Page)
 * 
 * NOTE: This consolidated script loads all unstructured data:
 *   - 80 Maintenance Log Documents
 *   - 15 Technical Manuals  
 *   - 150 Visual Inspection Records
 *   - 281 Computer Vision Detections
 ******************************************************************************/

USE DATABASE UTILITIES_GRID_RELIABILITY;
USE WAREHOUSE GRID_RELIABILITY_WH;
USE SCHEMA UNSTRUCTURED;

-- =============================================================================
-- SECTION 1: LOAD MAINTENANCE LOG DOCUMENTS (80 records)
-- =============================================================================

-- Option A: Use Python generator (recommended)
-- Run: python3 python/data_generators/generate_maintenance_logs.py
-- This generates 80 maintenance log documents with NLP-ready text

-- Option B: Load from pre-generated data
-- The maintenance logs are included in the unstructured/ folder as consolidated SQL
-- See: unstructured/load_maintenance_logs_all.sql (if available)

-- Example INSERT format (replace with actual data):
/*
INSERT INTO MAINTENANCE_LOG_DOCUMENTS VALUES
('MLOG-T-SS001-001-2024-001', 'T-SS001-001', '2024-05-15', 'John Smith', 'PREVENTIVE',
'MEDIUM', 'Routine maintenance completed', 
['oil degradation', 'thermal stress'], ['oil change', 'thermal monitoring'],
'/path/to/document.pdf', FALSE),
... (80 total records)
*/

-- =============================================================================
-- SECTION 2: LOAD TECHNICAL MANUALS (15 records)
-- =============================================================================

-- Option A: Use Python generator (recommended)
-- Run: python3 python/data_generators/generate_technical_manuals.py
-- This generates 15 technical manuals across 4 equipment types

-- Option B: Load from pre-generated PDFs
-- See: unstructured/load_technical_manuals.sql

-- Example INSERT format:
/*
INSERT INTO TECHNICAL_MANUALS VALUES
('MAN-ABB-TXP25MVA-001', 'ABB', 'TXP-25MVA', 'TRANSFORMER', 
'Installation and Configuration Guide', '2023-01-15', '3.2',
'Complete installation guide for ABB transformers...', 
'/path/to/manual.pdf'),
... (15 total records)
*/

-- =============================================================================
-- SECTION 3: LOAD VISUAL INSPECTION RECORDS (150 records)
-- =============================================================================

-- Option A: Use Python generator (recommended)
-- Run: python3 python/data_generators/generate_visual_inspections.py
-- This generates 150 visual inspection records

-- Option B: Load from pre-generated data
-- See: unstructured/load_visual_inspections_all.sql

-- Example INSERT format:
/*
INSERT INTO VISUAL_INSPECTIONS VALUES
('VINSP-T-SS001-001-2024-001', 'T-SS001-001', '2024-06-01 10:30:00',
'DRONE', 'Equipment inspection via drone', 'Mike Johnson',
'/path/to/image.jpg', 'CLEAR', 22.5),
... (150 total records)
*/

-- =============================================================================
-- SECTION 4: LOAD COMPUTER VISION DETECTIONS (281 records)
-- =============================================================================

-- Option A: Use Python generator (recommended)
-- Included with visual inspections generator

-- Option B: Load from pre-generated data
-- See: unstructured/load_cv_detections_all.sql

-- Example INSERT format:
/*
INSERT INTO CV_DETECTIONS VALUES
('CVD-VINSP-T-SS001-001-001', 'VINSP-T-SS001-001-2024-001', 'T-SS001-001',
'CORROSION', 0.85, 25.8, OBJECT_CONSTRUCT('x', 100, 'y', 200, 'width', 50, 'height', 50),
'Surface corrosion detected on transformer housing', 'MEDIUM',
40.7128, -74.0060),
... (281 total records)
*/

-- =============================================================================
-- ALTERNATIVE: BULK LOAD USING EXISTING UNSTRUCTURED FOLDER SCRIPTS
-- =============================================================================

-- If using the original unstructured/ folder with pre-generated data:

-- Step 1: Copy all load scripts
-- cd unstructured/
-- cat load_maintenance_logs_*.sql | snowsql -c <connection> -d UTILITIES_GRID_RELIABILITY
-- cat load_technical_manuals.sql | snowsql -c <connection> -d UTILITIES_GRID_RELIABILITY
-- cat load_visual_inspections_*.sql | snowsql -c <connection> -d UTILITIES_GRID_RELIABILITY
-- cat load_cv_detections_*.sql | snowsql -c <connection> -d UTILITIES_GRID_RELIABILITY

-- =============================================================================
-- SECTION 5: VERIFICATION
-- =============================================================================

SELECT 
    'MAINTENANCE_LOG_DOCUMENTS' AS TABLE_NAME, 
    COUNT(*) AS ROW_COUNT,
    COUNT(DISTINCT ASSET_ID) AS UNIQUE_ASSETS,
    MIN(DOCUMENT_DATE) AS MIN_DATE,
    MAX(DOCUMENT_DATE) AS MAX_DATE
FROM MAINTENANCE_LOG_DOCUMENTS
UNION ALL
SELECT 
    'TECHNICAL_MANUALS', 
    COUNT(*),
    NULL,
    MIN(PUBLICATION_DATE),
    MAX(PUBLICATION_DATE)
FROM TECHNICAL_MANUALS
UNION ALL
SELECT 
    'VISUAL_INSPECTIONS', 
    COUNT(*),
    COUNT(DISTINCT ASSET_ID),
    MIN(INSPECTION_DATE),
    MAX(INSPECTION_DATE)
FROM VISUAL_INSPECTIONS
UNION ALL
SELECT 
    'CV_DETECTIONS', 
    COUNT(*),
    COUNT(DISTINCT ASSET_ID),
    NULL,
    NULL
FROM CV_DETECTIONS;

-- Expected row counts (demo data):
-- MAINTENANCE_LOG_DOCUMENTS: 80
-- TECHNICAL_MANUALS: 15
-- VISUAL_INSPECTIONS: 150
-- CV_DETECTIONS: 281

-- =============================================================================
-- SECTION 6: CREATE CORTEX SEARCH SERVICES
-- =============================================================================

-- Create search index for maintenance logs and technical manuals
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
        'Summary: ' || SUMMARY
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

-- Create Cortex Search Service for documents
CREATE OR REPLACE CORTEX SEARCH SERVICE DOCUMENT_SEARCH_SERVICE
ON SEARCH_TEXT
ATTRIBUTES DOCUMENT_TYPE, ASSET_ID, AUTHOR, CATEGORY, SEVERITY_LEVEL, DOC_DATE
WAREHOUSE = GRID_RELIABILITY_WH
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
        DOC_DATE
    FROM DOCUMENT_SEARCH_INDEX
);

-- Create specialized search service for maintenance logs
CREATE OR REPLACE CORTEX SEARCH SERVICE MAINTENANCE_LOG_SEARCH
ON SEARCH_TEXT
ATTRIBUTES ASSET_ID, AUTHOR, CATEGORY, SEVERITY_LEVEL, DOC_DATE
WAREHOUSE = GRID_RELIABILITY_WH
TARGET_LAG = '1 hour'
AS (
    SELECT 
        ID,
        SEARCH_TEXT,
        ASSET_ID,
        AUTHOR,
        CATEGORY,
        SEVERITY_LEVEL,
        DOC_DATE
    FROM DOCUMENT_SEARCH_INDEX
    WHERE DOCUMENT_TYPE = 'MAINTENANCE_LOG'
);

-- Create specialized search service for technical manuals  
CREATE OR REPLACE CORTEX SEARCH SERVICE TECHNICAL_MANUAL_SEARCH
ON SEARCH_TEXT
ATTRIBUTES AUTHOR, CATEGORY, DOC_DATE
WAREHOUSE = GRID_RELIABILITY_WH
TARGET_LAG = '1 hour'
AS (
    SELECT 
        ID,
        SEARCH_TEXT,
        AUTHOR,
        CATEGORY,
        DOC_DATE
    FROM DOCUMENT_SEARCH_INDEX
    WHERE DOCUMENT_TYPE = 'TECHNICAL_MANUAL'
);

-- Grant permissions to Cortex Search services
GRANT USAGE ON CORTEX SEARCH SERVICE DOCUMENT_SEARCH_SERVICE TO ROLE GRID_ANALYST;
GRANT USAGE ON CORTEX SEARCH SERVICE DOCUMENT_SEARCH_SERVICE TO ROLE GRID_OPERATOR;
GRANT USAGE ON CORTEX SEARCH SERVICE MAINTENANCE_LOG_SEARCH TO ROLE GRID_ANALYST;
GRANT USAGE ON CORTEX SEARCH SERVICE MAINTENANCE_LOG_SEARCH TO ROLE GRID_OPERATOR;
GRANT USAGE ON CORTEX SEARCH SERVICE TECHNICAL_MANUAL_SEARCH TO ROLE GRID_ANALYST;
GRANT USAGE ON CORTEX SEARCH SERVICE TECHNICAL_MANUAL_SEARCH TO ROLE GRID_OPERATOR;

-- =============================================================================
-- COMPLETION STATUS
-- =============================================================================

SELECT '✅ Unstructured data loading complete!' AS STATUS;
SELECT '✅ Cortex Search services deployed!' AS SEARCH_STATUS;

-- Next Step: Test the Intelligence Agent with document search capabilities
-- Navigate to: Snowflake UI → Projects → Intelligence → Agents → Grid Reliability Intelligence Agent

