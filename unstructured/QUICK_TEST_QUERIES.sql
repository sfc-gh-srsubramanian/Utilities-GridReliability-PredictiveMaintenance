-- ============================================================
-- QUICK TEST QUERIES: Verify Unstructured Data Integration
-- ============================================================
-- Run these in Snowsight to verify everything is working
-- ============================================================

USE DATABASE UTILITIES_GRID_RELIABILITY;
USE SCHEMA UNSTRUCTURED;
USE WAREHOUSE GRID_RELIABILITY_WH;

-- ============================================================
-- TEST 1: Verify all data loaded
-- ============================================================
SELECT 'Maintenance Logs' AS Table_Name, COUNT(*) AS Count 
FROM MAINTENANCE_LOG_DOCUMENTS
UNION ALL
SELECT 'Technical Manuals', COUNT(*) 
FROM TECHNICAL_MANUALS
UNION ALL
SELECT 'Visual Inspections', COUNT(*) 
FROM VISUAL_INSPECTIONS
UNION ALL
SELECT 'CV Detections', COUNT(*) 
FROM CV_DETECTIONS;

-- Expected: 80, 15, 150, 281


-- ============================================================
-- TEST 2: Join structured + unstructured data
-- ============================================================
-- Show assets with both sensor readings AND maintenance logs
SELECT 
    a.ASSET_ID,
    a.ASSET_NAME,
    a.EQUIPMENT_TYPE,
    COUNT(DISTINCT sr.READING_TIMESTAMP) AS SENSOR_READINGS,
    COUNT(DISTINCT m.DOCUMENT_ID) AS MAINTENANCE_LOGS,
    COUNT(DISTINCT vi.INSPECTION_ID) AS VISUAL_INSPECTIONS
FROM RAW.ASSET_MASTER a
LEFT JOIN RAW.SENSOR_READINGS sr ON a.ASSET_ID = sr.ASSET_ID
LEFT JOIN UNSTRUCTURED.MAINTENANCE_LOG_DOCUMENTS m ON a.ASSET_ID = m.ASSET_ID
LEFT JOIN UNSTRUCTURED.VISUAL_INSPECTIONS vi ON a.ASSET_ID = vi.ASSET_ID
GROUP BY 1,2,3
HAVING COUNT(DISTINCT m.DOCUMENT_ID) > 0
ORDER BY MAINTENANCE_LOGS DESC
LIMIT 10;


-- ============================================================
-- TEST 3: Find assets with critical issues (all data sources)
-- ============================================================
SELECT DISTINCT
    a.ASSET_ID,
    a.ASSET_NAME,
    a.SUBSTATION_NAME,
    
    -- From predictions
    p.RISK_CATEGORY,
    p.FAILURE_PROBABILITY,
    
    -- From maintenance logs
    m.SEVERITY_LEVEL AS MAINTENANCE_SEVERITY,
    m.FINDING AS MAINTENANCE_FINDING,
    m.DOCUMENT_DATE,
    
    -- From CV detections
    cv.DETECTION_TYPE,
    cv.DETECTED_AT_COMPONENT,
    cv.CONFIDENCE_SCORE

FROM RAW.ASSET_MASTER a
LEFT JOIN ML.PREDICTIONS p 
    ON a.ASSET_ID = p.ASSET_ID
LEFT JOIN UNSTRUCTURED.MAINTENANCE_LOG_DOCUMENTS m 
    ON a.ASSET_ID = m.ASSET_ID
    AND m.SEVERITY_LEVEL IN ('HIGH', 'CRITICAL')
LEFT JOIN UNSTRUCTURED.VISUAL_INSPECTIONS vi 
    ON a.ASSET_ID = vi.ASSET_ID
LEFT JOIN UNSTRUCTURED.CV_DETECTIONS cv 
    ON vi.INSPECTION_ID = cv.INSPECTION_ID
    AND cv.SEVERITY_LEVEL IN ('HIGH', 'CRITICAL')

WHERE (p.RISK_CATEGORY IN ('HIGH', 'CRITICAL')
    OR m.SEVERITY_LEVEL IN ('HIGH', 'CRITICAL')
    OR cv.SEVERITY_LEVEL IN ('HIGH', 'CRITICAL'))

ORDER BY p.FAILURE_PROBABILITY DESC NULLS LAST
LIMIT 20;


-- ============================================================
-- TEST 4: Sample maintenance log text
-- ============================================================
-- Show actual maintenance log findings (text data)
SELECT 
    ASSET_ID,
    DOCUMENT_DATE,
    TECHNICIAN_NAME,
    FINDING,
    SEVERITY_LEVEL,
    CORRECTIVE_ACTION_REQUIRED
FROM MAINTENANCE_LOG_DOCUMENTS
WHERE SEVERITY_LEVEL IN ('HIGH', 'CRITICAL')
ORDER BY DOCUMENT_DATE DESC
LIMIT 5;


-- ============================================================
-- TEST 5: CV Detection summary by type
-- ============================================================
SELECT 
    DETECTION_TYPE,
    SEVERITY_LEVEL,
    COUNT(*) AS DETECTION_COUNT,
    AVG(CONFIDENCE_SCORE) AS AVG_CONFIDENCE,
    SUM(CASE WHEN REQUIRES_IMMEDIATE_ACTION THEN 1 ELSE 0 END) AS REQUIRES_ACTION_COUNT
FROM CV_DETECTIONS
GROUP BY 1,2
ORDER BY DETECTION_COUNT DESC;


-- ============================================================
-- TEST 6: Asset-level summary (comprehensive health view)
-- ============================================================
SELECT 
    a.ASSET_ID,
    a.ASSET_NAME,
    a.EQUIPMENT_TYPE,
    
    -- Sensor data
    MAX(sr.READING_TIMESTAMP) AS LAST_SENSOR_READING,
    
    -- ML predictions
    MAX(p.FAILURE_PROBABILITY) AS FAILURE_PROB,
    
    -- Maintenance logs
    COUNT(DISTINCT m.DOCUMENT_ID) AS TOTAL_MAINTENANCE_LOGS,
    SUM(CASE WHEN m.SEVERITY_LEVEL IN ('HIGH','CRITICAL') THEN 1 ELSE 0 END) AS CRITICAL_MAINTENANCE_EVENTS,
    
    -- Visual inspections
    COUNT(DISTINCT vi.INSPECTION_ID) AS TOTAL_INSPECTIONS,
    MAX(vi.INSPECTION_DATE) AS LAST_INSPECTION,
    
    -- CV detections
    COUNT(cv.DETECTION_ID) AS TOTAL_DETECTIONS,
    SUM(CASE WHEN cv.REQUIRES_IMMEDIATE_ACTION THEN 1 ELSE 0 END) AS URGENT_DETECTIONS

FROM RAW.ASSET_MASTER a
LEFT JOIN RAW.SENSOR_READINGS sr ON a.ASSET_ID = sr.ASSET_ID
LEFT JOIN ML.PREDICTIONS p ON a.ASSET_ID = p.ASSET_ID
LEFT JOIN UNSTRUCTURED.MAINTENANCE_LOG_DOCUMENTS m ON a.ASSET_ID = m.ASSET_ID
LEFT JOIN UNSTRUCTURED.VISUAL_INSPECTIONS vi ON a.ASSET_ID = vi.ASSET_ID
LEFT JOIN UNSTRUCTURED.CV_DETECTIONS cv ON vi.INSPECTION_ID = cv.INSPECTION_ID

GROUP BY 1,2,3
HAVING TOTAL_MAINTENANCE_LOGS > 0 OR TOTAL_INSPECTIONS > 0
ORDER BY CRITICAL_MAINTENANCE_EVENTS DESC, URGENT_DETECTIONS DESC
LIMIT 20;


-- ============================================================
-- TEST 7: Technical manual lookup
-- ============================================================
SELECT 
    EQUIPMENT_TYPE,
    MANUAL_TYPE,
    VERSION,
    TOTAL_PAGES,
    DOCUMENT_PATH
FROM TECHNICAL_MANUALS
ORDER BY EQUIPMENT_TYPE, MANUAL_TYPE;


-- ============================================================
-- ✅ If all queries return data, integration is successful!
-- ============================================================
