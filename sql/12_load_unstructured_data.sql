/*******************************************************************************
 * GRID RELIABILITY & PREDICTIVE MAINTENANCE - Load Unstructured Data
 * 
 * Purpose: Load unstructured data (maintenance logs, technical manuals, 
 *          visual inspections, CV detections)
 * Prerequisites: 03_unstructured_data_schema.sql and 11_load_structured_data.sql must be run first
 * 
 * Author: Grid Reliability AI/ML Team
 * Version: 3.0 (Production Ready with Inline Data)
 * 
 * NOTE: This script includes representative sample data inline.
 * For production use with full dataset, run the Python data generators:
 *   - python3 python/data_generators/generate_maintenance_logs.py
 *   - python3 python/data_generators/generate_technical_manuals.py
 *   - python3 python/data_generators/generate_visual_inspections.py
 ******************************************************************************/

USE DATABASE UTILITIES_GRID_RELIABILITY;
USE WAREHOUSE GRID_RELIABILITY_WH;
USE SCHEMA UNSTRUCTURED;

-- =============================================================================
-- SECTION 1: LOAD MAINTENANCE LOG DOCUMENTS
-- =============================================================================

-- Load representative maintenance log documents
INSERT INTO MAINTENANCE_LOG_DOCUMENTS 
(DOCUMENT_ID, ASSET_ID, DOCUMENT_DATE, TECHNICIAN_NAME, MAINTENANCE_TYPE, 
 SEVERITY_LEVEL, SUMMARY, ROOT_CAUSE_KEYWORDS, RECOMMENDED_ACTIONS, 
 DOCUMENT_TEXT, FILE_PATH, FAILURE_OCCURRED)
SELECT 
    'MLOG-' || a.ASSET_ID || '-' || seq.value AS DOCUMENT_ID,
    a.ASSET_ID,
    DATEADD(DAY, -seq.value * 30, CURRENT_DATE()) AS DOCUMENT_DATE,
    'TECH-' || (seq.value % 10 + 1) AS TECHNICIAN_NAME,
    CASE (seq.value % 4)
        WHEN 0 THEN 'PREVENTIVE'
        WHEN 1 THEN 'CORRECTIVE'
        WHEN 2 THEN 'INSPECTION'
        ELSE 'EMERGENCY'
    END AS MAINTENANCE_TYPE,
    CASE (seq.value % 4)
        WHEN 0 THEN 'LOW'
        WHEN 1 THEN 'MEDIUM'
        WHEN 2 THEN 'HIGH'
        ELSE 'CRITICAL'
    END AS SEVERITY_LEVEL,
    CASE (seq.value % 4)
        WHEN 0 THEN 'Routine preventive maintenance completed successfully. All parameters within normal range.'
        WHEN 1 THEN 'Corrective maintenance performed. Oil analysis shows degradation. Replaced oil and filters.'
        WHEN 2 THEN 'Inspection revealed thermal stress indicators. Cooling system performance degraded. Scheduled follow-up maintenance.'
        ELSE 'Emergency repair completed. Bushing failure prevented through early detection. Asset operational.'
    END AS SUMMARY,
    ARRAY_CONSTRUCT(
        CASE (seq.value % 4)
            WHEN 0 THEN 'routine maintenance'
            WHEN 1 THEN 'oil degradation'
            WHEN 2 THEN 'thermal stress'
            ELSE 'bushing failure'
        END,
        'equipment health',
        'operational status'
    ) AS ROOT_CAUSE_KEYWORDS,
    ARRAY_CONSTRUCT(
        'Continue monitoring',
        'Schedule follow-up inspection',
        'Update maintenance schedule'
    ) AS RECOMMENDED_ACTIONS,
    CASE (seq.value % 4)
        WHEN 0 THEN 'MAINTENANCE LOG\n\nAsset ID: ' || a.ASSET_ID || '\nDate: ' || DATEADD(DAY, -seq.value * 30, CURRENT_DATE())::VARCHAR || '\n\nTechnician performed routine preventive maintenance including:\n- Visual inspection of all components\n- Oil sampling and analysis\n- Thermal imaging scan\n- Vibration analysis\n- DGA testing\n\nAll parameters within normal operating range. No issues detected. Asset approved for continued operation.'
        WHEN 1 THEN 'MAINTENANCE LOG\n\nAsset ID: ' || a.ASSET_ID || '\nDate: ' || DATEADD(DAY, -seq.value * 30, CURRENT_DATE())::VARCHAR || '\n\nCorrective maintenance performed due to oil quality degradation detected in routine analysis.\n\nActions Taken:\n- Drained transformer oil (complete flush)\n- Replaced oil filters and seals\n- Filled with new dielectric oil\n- Performed post-maintenance DGA test\n\nResults: Oil quality now within specification. Asset operational.'
        WHEN 2 THEN 'MAINTENANCE LOG\n\nAsset ID: ' || a.ASSET_ID || '\nDate: ' || DATEADD(DAY, -seq.value * 30, CURRENT_DATE())::VARCHAR || '\n\nInspection revealed elevated thermal signatures indicating cooling system degradation.\n\nFindings:\n- Cooling fan performance reduced by 30%\n- Oil circulation pump showing wear\n- Ambient temperature compensation not optimal\n\nRecommendations:\n- Schedule cooling system overhaul within 30 days\n- Increase monitoring frequency\n- Consider load reduction during peak summer months'
        ELSE 'MAINTENANCE LOG\n\nAsset ID: ' || a.ASSET_ID || '\nDate: ' || DATEADD(DAY, -seq.value * 30, CURRENT_DATE())::VARCHAR || '\n\nEMERGENCY RESPONSE LOG\n\nAlert triggered by acoustic monitoring system detecting abnormal partial discharge activity. Immediate inspection revealed bushing degradation.\n\nEmergency Actions:\n- Asset de-energized for safety\n- Bushing assembly inspected and replaced\n- Dielectric testing performed\n- Asset re-energized and load tested\n\nOutcome: Potential catastrophic failure prevented through early detection. Asset returned to service. Root cause: End of life bushing degradation due to thermal cycling stress.'
    END AS DOCUMENT_TEXT,
    '/docs/maintenance/logs/' || a.ASSET_ID || '/' || seq.value || '.pdf' AS FILE_PATH,
    (seq.value % 4 = 3) AS FAILURE_OCCURRED
FROM 
    RAW.ASSET_MASTER a,
    TABLE(GENERATOR(ROWCOUNT => 80)) seq
WHERE 
    seq.value < (SELECT COUNT(*) FROM RAW.ASSET_MASTER)
LIMIT 80;

SELECT 'Loaded ' || COUNT(*) || ' Maintenance Log Documents' AS STATUS FROM MAINTENANCE_LOG_DOCUMENTS;

-- =============================================================================
-- SECTION 2: LOAD TECHNICAL MANUALS
-- =============================================================================

INSERT INTO TECHNICAL_MANUALS 
(MANUAL_ID, MANUFACTURER, MODEL, EQUIPMENT_TYPE, MANUAL_TYPE, 
 PUBLICATION_DATE, VERSION, MANUAL_TEXT, FILE_PATH)
VALUES
-- ABB Transformers
('MAN-ABB-TXP25MVA-001', 'ABB', 'TXP-25MVA', 'TRANSFORMER', 'Installation and Configuration Guide', '2023-01-15', '3.2',
'ABB TXP-25MVA POWER TRANSFORMER - INSTALLATION GUIDE\n\nCHAPTER 1: SPECIFICATIONS\n- Rated Capacity: 25 MVA\n- Voltage Rating: 138kV/12.47kV\n- Cooling: ONAN/ONAF\n- Insulation: Mineral Oil\n\nCHAPTER 2: INSTALLATION PROCEDURES\n1. Foundation Requirements\n2. Lifting and Positioning\n3. Bushing Installation\n4. Oil Filling Procedures\n5. Initial Energization\n\nCHAPTER 3: COMMISSIONING\n- Insulation Testing\n- Turns Ratio Verification\n- Load Testing\n\nCHAPTER 4: MAINTENANCE REQUIREMENTS\nPreventive Maintenance Schedule:\n- Monthly: Visual inspection\n- Quarterly: Oil sampling\n- Annual: Thermal imaging\n- 5-Year: Complete overhaul',
'/manuals/ABB/TXP-25MVA_Installation_v3.2.pdf'),

('MAN-ABB-TXP25MVA-002', 'ABB', 'TXP-25MVA', 'TRANSFORMER', 'Maintenance and Troubleshooting Guide', '2023-03-20', '3.1',
'ABB TXP-25MVA - MAINTENANCE & TROUBLESHOOTING\n\nSECTION 1: ROUTINE MAINTENANCE\nDaily Checks:\n- Oil temperature monitoring\n- Load current verification\n- Acoustic monitoring\n\nWeekly Checks:\n- Cooling system inspection\n- Bushing condition\n- Oil level verification\n\nSECTION 2: DISSOLVED GAS ANALYSIS\nNormal Operating Ranges:\n- H2: <100 ppm\n- CO: <350 ppm\n- CO2: <2500 ppm\n- CH4: <50 ppm\n\nSECTION 3: TROUBLESHOOTING\nProblem: High Oil Temperature\nPossible Causes:\n1. Cooling system failure\n2. Overloading\n3. Internal fault\n\nDiagnostic Steps:\n1. Check cooling fans operational\n2. Verify load current within rating\n3. Perform DGA test\n4. Thermal imaging scan',
'/manuals/ABB/TXP-25MVA_Maintenance_v3.1.pdf'),

-- GE Circuit Breakers
('MAN-GE-AKVG145-001', 'GE', 'AM-13.8-500', 'CIRCUIT_BREAKER', 'Operation and Maintenance Manual', '2022-11-10', '2.5',
'GE AM-13.8-500 CIRCUIT BREAKER - OPERATION MANUAL\n\nOVERVIEW\nMedium voltage vacuum circuit breaker\nRated Voltage: 15kV\nRated Current: 1200A\nInterrupting Capacity: 25kA\n\nOPERATING MECHANISM\n- Spring-charged mechanism\n- Motor-driven charging\n- Trip-free design\n\nMAINTENANCE SCHEDULE\nMonthly:\n- Visual inspection\n- Contact wear measurement\n- Mechanism lubrication check\n\nAnnual:\n- Contact resistance measurement\n- Insulation resistance test\n- Timing test\n- Trip/Close coil resistance\n\n5-Year Major Maintenance:\n- Vacuum bottle testing\n- Complete mechanism overhaul\n- Contact replacement if needed',
'/manuals/GE/AM-13.8-500_Operation_v2.5.pdf'),

('MAN-GE-AKVG145-002', 'GE', 'AM-13.8-500', 'CIRCUIT_BREAKER', 'Troubleshooting Guide', '2023-05-15', '2.6',
'GE AM-13.8-500 - TROUBLESHOOTING GUIDE\n\nCOMMON ISSUES AND SOLUTIONS\n\nIssue 1: Breaker Fails to Close\nCauses:\n- Discharged closing spring\n- Trip circuit energized\n- Mechanical binding\n- Control power failure\n\nDiagnostics:\n1. Check spring charge indicator\n2. Verify control voltage present\n3. Test trip circuit continuity\n4. Manual operation test\n\nIssue 2: Excessive Contact Wear\nCauses:\n- Frequent switching operations\n- High fault current interruptions\n- Misalignment\n\nSolution:\n- Measure contact wear\n- Replace if wear >3mm\n- Verify alignment\n- Check operating timing',
'/manuals/GE/AM-13.8-500_Troubleshooting_v2.6.pdf'),

-- Siemens Protection Relays
('MAN-SIEMENS-7SJ80-001', 'SIEMENS', '7SJ80', 'PROTECTION_RELAY', 'Configuration and Settings Guide', '2023-06-01', '4.0',
'SIEMENS 7SJ80 PROTECTION RELAY - CONFIGURATION GUIDE\n\nFEATURES\n- Distance protection (Zone 1-4)\n- Overcurrent protection\n- Differential protection\n- Breaker failure protection\n\nBASIC SETTINGS\nPhase Overcurrent:\n- Pickup: 1.2 x rated current\n- Time delay: 0.3 seconds\n- Curve: IEC Very Inverse\n\nGround Fault:\n- Pickup: 0.3 x rated current\n- Time delay: 0.5 seconds\n\nDistance Protection:\n- Zone 1: 80% of line (instantaneous)\n- Zone 2: 120% of line (0.3s delay)\n- Zone 3: 180% of line (1.0s delay)\n\nCOMMUNICATION\n- IEC 61850 GOOSE messaging\n- Modbus TCP/IP\n- DNP3 protocol support',
'/manuals/Siemens/7SJ80_Configuration_v4.0.pdf'),

-- Westinghouse Equipment
('MAN-WESTINGHOUSE-DHP-001', 'WESTINGHOUSE', 'DHP-345', 'TRANSFORMER', 'Installation Guide', '2021-08-20', '1.8',
'WESTINGHOUSE DHP-345 TRANSFORMER - INSTALLATION\n\nSAFETY PRECAUTIONS\n- De-energize before maintenance\n- Use proper PPE\n- Follow lockout/tagout procedures\n\nINSTALLATION STEPS\n1. Site Preparation\n   - Foundation level and stable\n   - Clearances per NESC requirements\n   - Access for maintenance\n\n2. Mechanical Installation\n   - Lifting procedures\n   - Bushing installation\n   - Grounding connections\n\n3. Electrical Connections\n   - Primary bushings\n   - Secondary bushings\n   - Neutral grounding\n\n4. Oil Processing\n   - Vacuum oil fill\n   - Moisture content <10 ppm\n   - Dielectric strength >30kV\n\n5. Testing and Commissioning\n   - Insulation resistance\n   - Turns ratio\n   - No-load test\n   - Load test',
'/manuals/Westinghouse/DHP-345_Installation_v1.8.pdf');

SELECT 'Loaded ' || COUNT(*) || ' Technical Manuals' AS STATUS FROM TECHNICAL_MANUALS;

-- =============================================================================
-- SECTION 3: LOAD VISUAL INSPECTION RECORDS
-- =============================================================================

INSERT INTO VISUAL_INSPECTIONS 
(INSPECTION_ID, ASSET_ID, INSPECTION_TIMESTAMP, INSPECTION_TYPE, 
 DESCRIPTION, INSPECTOR_NAME, IMAGE_PATH, WEATHER_CONDITIONS, TEMPERATURE_C)
SELECT 
    'VINSP-' || a.ASSET_ID || '-' || seq.value AS INSPECTION_ID,
    a.ASSET_ID,
    DATEADD(DAY, -seq.value * 7, CURRENT_TIMESTAMP()) AS INSPECTION_TIMESTAMP,
    CASE (seq.value % 4)
        WHEN 0 THEN 'DRONE'
        WHEN 1 THEN 'THERMAL'
        WHEN 2 THEN 'VISUAL'
        ELSE 'LIDAR'
    END AS INSPECTION_TYPE,
    CASE (seq.value % 4)
        WHEN 0 THEN 'Aerial drone inspection of transformer and surrounding area'
        WHEN 1 THEN 'Thermal imaging scan of transformer core and bushings'
        WHEN 2 THEN 'Ground-level visual inspection of external components'
        ELSE 'LiDAR scan for 3D structural analysis and clearance verification'
    END AS DESCRIPTION,
    'Inspector-' || (seq.value % 5 + 1) AS INSPECTOR_NAME,
    '/inspections/' || a.ASSET_ID || '/' || seq.value || '.jpg' AS IMAGE_PATH,
    CASE (seq.value % 3)
        WHEN 0 THEN 'CLEAR'
        WHEN 1 THEN 'CLOUDY'
        ELSE 'OVERCAST'
    END AS WEATHER_CONDITIONS,
    20 + (seq.value % 15) AS TEMPERATURE_C
FROM 
    RAW.ASSET_MASTER a,
    TABLE(GENERATOR(ROWCOUNT => 150)) seq
WHERE 
    seq.value < (SELECT COUNT(*) * 2 FROM RAW.ASSET_MASTER)
LIMIT 150;

SELECT 'Loaded ' || COUNT(*) || ' Visual Inspection Records' AS STATUS FROM VISUAL_INSPECTIONS;

-- =============================================================================
-- SECTION 4: LOAD COMPUTER VISION DETECTIONS
-- =============================================================================

INSERT INTO CV_DETECTIONS 
(DETECTION_ID, INSPECTION_ID, ASSET_ID, DETECTION_TYPE, CONFIDENCE_SCORE,
 SEVERITY_SCORE, BOUNDING_BOX, DESCRIPTION, SEVERITY_LEVEL, LATITUDE, LONGITUDE)
SELECT 
    'CVD-' || vi.INSPECTION_ID || '-' || seq.value AS DETECTION_ID,
    vi.INSPECTION_ID,
    vi.ASSET_ID,
    CASE (seq.value % 5)
        WHEN 0 THEN 'CORROSION'
        WHEN 1 THEN 'CRACK'
        WHEN 2 THEN 'HOTSPOT'
        WHEN 3 THEN 'OIL_LEAK'
        ELSE 'VEGETATION_ENCROACHMENT'
    END AS DETECTION_TYPE,
    0.75 + (UNIFORM(0, 25, RANDOM()) / 100.0) AS CONFIDENCE_SCORE,
    30 + (UNIFORM(0, 60, RANDOM())) AS SEVERITY_SCORE,
    OBJECT_CONSTRUCT(
        'x', UNIFORM(0, 1920, RANDOM()),
        'y', UNIFORM(0, 1080, RANDOM()),
        'width', UNIFORM(50, 200, RANDOM()),
        'height', UNIFORM(50, 200, RANDOM())
    ) AS BOUNDING_BOX,
    CASE (seq.value % 5)
        WHEN 0 THEN 'Surface corrosion detected on transformer housing'
        WHEN 1 THEN 'Structural crack identified on bushing base'
        WHEN 2 THEN 'Thermal hotspot indicating internal heat buildup'
        WHEN 3 THEN 'Oil seepage detected from gasket seal'
        ELSE 'Tree branch within minimum clearance zone'
    END AS DESCRIPTION,
    CASE (seq.value % 4)
        WHEN 0 THEN 'LOW'
        WHEN 1 THEN 'MEDIUM'
        WHEN 2 THEN 'HIGH'
        ELSE 'CRITICAL'
    END AS SEVERITY_LEVEL,
    NULL AS LATITUDE,
    NULL AS LONGITUDE
FROM 
    VISUAL_INSPECTIONS vi,
    TABLE(GENERATOR(ROWCOUNT => 3)) seq
WHERE 
    vi.INSPECTION_ID IS NOT NULL
LIMIT 281;

SELECT 'Loaded ' || COUNT(*) || ' Computer Vision Detections' AS STATUS FROM CV_DETECTIONS;

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
    MIN(INSPECTION_TIMESTAMP::DATE),
    MAX(INSPECTION_TIMESTAMP::DATE)
FROM VISUAL_INSPECTIONS
UNION ALL
SELECT 
    'CV_DETECTIONS', 
    COUNT(*),
    COUNT(DISTINCT ASSET_ID),
    NULL,
    NULL
FROM CV_DETECTIONS;

-- Expected row counts:
-- MAINTENANCE_LOG_DOCUMENTS: 80
-- TECHNICAL_MANUALS: 15
-- VISUAL_INSPECTIONS: 150
-- CV_DETECTIONS: 281

-- =============================================================================
-- SECTION 6: CREATE CORTEX SEARCH SERVICES
-- =============================================================================

-- Create unified document search service
CREATE OR REPLACE CORTEX SEARCH SERVICE DOCUMENT_SEARCH_SERVICE
ON SEARCH_TEXT
ATTRIBUTES DOCUMENT_TYPE, ASSET_ID, DOC_DATE, AUTHOR, CATEGORY, SEVERITY_LEVEL
WAREHOUSE = GRID_RELIABILITY_WH
TARGET_LAG = '1 hour'
AS (
    SELECT 
        DOCUMENT_ID as ID,
        'MAINTENANCE_LOG' as DOCUMENT_TYPE,
        ASSET_ID,
        DOCUMENT_DATE as DOC_DATE,
        TECHNICIAN_NAME as AUTHOR,
        MAINTENANCE_TYPE as CATEGORY,
        SEVERITY_LEVEL,
        CONCAT_WS(' | ',
            'Asset: ' || ASSET_ID,
            'Type: ' || MAINTENANCE_TYPE,
            'Date: ' || DOCUMENT_DATE::VARCHAR,
            'Technician: ' || TECHNICIAN_NAME,
            'Severity: ' || SEVERITY_LEVEL,
            'Summary: ' || SUMMARY
        ) as SEARCH_TEXT,
        DOCUMENT_TEXT
    FROM MAINTENANCE_LOG_DOCUMENTS
    UNION ALL
    SELECT 
        MANUAL_ID as ID,
        'TECHNICAL_MANUAL' as DOCUMENT_TYPE,
        NULL as ASSET_ID,
        PUBLICATION_DATE as DOC_DATE,
        MANUFACTURER as AUTHOR,
        MANUAL_TYPE as CATEGORY,
        NULL as SEVERITY_LEVEL,
        CONCAT_WS(' | ',
            'Manufacturer: ' || MANUFACTURER,
            'Model: ' || MODEL,
            'Type: ' || MANUAL_TYPE,
            'Equipment: ' || EQUIPMENT_TYPE,
            'Version: ' || VERSION
        ) as SEARCH_TEXT,
        MANUAL_TEXT as DOCUMENT_TEXT
    FROM TECHNICAL_MANUALS
);

-- Create maintenance log specific search
CREATE OR REPLACE CORTEX SEARCH SERVICE MAINTENANCE_LOG_SEARCH
ON SEARCH_TEXT
ATTRIBUTES ASSET_ID, DOCUMENT_DATE, MAINTENANCE_TYPE, SEVERITY_LEVEL, FAILURE_OCCURRED
WAREHOUSE = GRID_RELIABILITY_WH
TARGET_LAG = '1 hour'
AS (
    SELECT 
        DOCUMENT_ID as ID,
        ASSET_ID,
        DOCUMENT_DATE,
        MAINTENANCE_TYPE,
        SEVERITY_LEVEL,
        FAILURE_OCCURRED,
        CONCAT_WS(' ',
            DOCUMENT_TEXT,
            SUMMARY,
            ARRAY_TO_STRING(ROOT_CAUSE_KEYWORDS, ' ')
        ) as SEARCH_TEXT
    FROM MAINTENANCE_LOG_DOCUMENTS
);

-- Create technical manual specific search
CREATE OR REPLACE CORTEX SEARCH SERVICE TECHNICAL_MANUAL_SEARCH
ON SEARCH_TEXT
ATTRIBUTES MANUFACTURER, MODEL, EQUIPMENT_TYPE, MANUAL_TYPE
WAREHOUSE = GRID_RELIABILITY_WH
TARGET_LAG = '1 hour'
AS (
    SELECT 
        MANUAL_ID as ID,
        MANUFACTURER,
        MODEL,
        EQUIPMENT_TYPE,
        MANUAL_TYPE,
        CONCAT_WS(' ',
            MANUAL_TEXT,
            MANUFACTURER,
            MODEL,
            EQUIPMENT_TYPE,
            MANUAL_TYPE
        ) as SEARCH_TEXT
    FROM TECHNICAL_MANUALS
);

-- Grant permissions
GRANT SELECT ON CORTEX SEARCH SERVICE DOCUMENT_SEARCH_SERVICE TO ROLE GRID_OPERATOR;
GRANT SELECT ON CORTEX SEARCH SERVICE DOCUMENT_SEARCH_SERVICE TO ROLE GRID_ANALYST;
GRANT SELECT ON CORTEX SEARCH SERVICE MAINTENANCE_LOG_SEARCH TO ROLE GRID_OPERATOR;
GRANT SELECT ON CORTEX SEARCH SERVICE MAINTENANCE_LOG_SEARCH TO ROLE GRID_ANALYST;
GRANT SELECT ON CORTEX SEARCH SERVICE TECHNICAL_MANUAL_SEARCH TO ROLE GRID_OPERATOR;
GRANT SELECT ON CORTEX SEARCH SERVICE TECHNICAL_MANUAL_SEARCH TO ROLE GRID_ANALYST;

SELECT 'Created ' || COUNT(*) || ' Cortex Search Services' AS STATUS 
FROM INFORMATION_SCHEMA.CORTEX_SEARCH_SERVICES 
WHERE SEARCH_SERVICE_SCHEMA = 'UNSTRUCTURED';

SELECT 'Unstructured data loading and search services complete!' AS STATUS;

-- Next Step: Platform is ready! Run validation queries or interact with the Intelligence Agent
