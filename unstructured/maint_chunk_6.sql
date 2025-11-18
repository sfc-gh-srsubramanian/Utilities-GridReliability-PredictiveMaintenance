-- Maintenance Logs Chunk 6/6 (records 71-75)
INSERT INTO UTILITIES_GRID_RELIABILITY.UNSTRUCTURED.MAINTENANCE_LOG_DOCUMENTS
(DOCUMENT_ID, ASSET_ID, DOCUMENT_TYPE, DOCUMENT_DATE, TECHNICIAN_NAME, TECHNICIAN_ID,
 FILE_PATH, FILE_SIZE_BYTES, FILE_FORMAT, MAINTENANCE_TYPE, DURATION_HOURS, COST_USD,
 FAILURE_OCCURRED, DOCUMENT_TEXT, SUMMARY, ROOT_CAUSE_KEYWORDS, SEVERITY_LEVEL, RECOMMENDED_ACTIONS)
SELECT 'MAINT-T-SS038-001-20250821-071', 'T-SS038-001', 'INSPECTION_REPORT',
       '2025-08-21'::DATE, 'Jennifer Garcia', 'TECH8570',
       '@MAINTENANCE_DOCS_STAGE/MAINT-T-SS038-001-20250821-071.pdf', 3847, 'PDF',
       'PREVENTIVE', 2.9, 9261.9,
       FALSE, 'Conducted scheduled preventive maintenance on T-SS038-001. Checked all electrical connections, found all secure. Oil level and color satisfactory. Bushings clean with no signs of tracking. Radiators clean and unobstructed. Load tap changer tested - operating normally. Recommended continued monitoring.', 'Conducted scheduled preventive maintenance on T-SS038-001. Checked all electrical connections, found all secure. Oil level and color satisfactory. Bushings clean with no signs of tracking. Radiators clean and unobstructed. Load tap changer tested - operating normally. Recommended continued monitoring.',
       PARSE_JSON('[]'), 'LOW',
       PARSE_JSON('["Offline testing", "Bushing replacement", "Emergency repair", "Continue standard monitoring", "No immediate action required"]')
UNION ALL SELECT 'MAINT-T-SS007-001-20240630-072', 'T-SS007-001', 'INSPECTION_REPORT',
       '2024-06-30'::DATE, 'David Rodriguez', 'TECH9038',
       '@MAINTENANCE_DOCS_STAGE/MAINT-T-SS007-001-20240630-072.pdf', 4004, 'PDF',
       'CORRECTIVE', 6.54, 22376.88,
       FALSE, 'Maintenance crew dispatched to T-SS007-001 for reported issue. Discovered turn-to-turn short during inspection. Winding Fault confirmed through diagnostic testing. Completed transformer replacement. Load tests performed successfully. Placed asset back online with continuous monitoring recommended.', 'Maintenance crew dispatched to T-SS007-001 for reported issue. Discovered turn-to-turn short during inspection. Winding Fault confirmed through diagnostic testing. Completed transformer replacement. Load tests performed successfully. Placed asset back online with continuous monitoring recommended.',
       PARSE_JSON('["Winding Fault", "turn-to-turn short", "ground fault"]'), 'CRITICAL',
       PARSE_JSON('["Transformer replacement", "Winding repair", "Outage required", "Immediate review by engineering team", "Daily monitoring until stable", "Prepare backup equipment"]')
UNION ALL SELECT 'MAINT-T-SS032-001-20250925-073', 'T-SS032-001', 'INSPECTION_REPORT',
       '2025-09-25'::DATE, 'Sarah Johnson', 'TECH7171',
       '@MAINTENANCE_DOCS_STAGE/MAINT-T-SS032-001-20250925-073.pdf', 4019, 'PDF',
       'EMERGENCY', 7.01, 101661.91,
       TRUE, 'URGENT REPAIR: T-SS032-001 tripped offline unexpectedly. Field investigation found rust on tank surface. Tank Corrosion confirmed as failure mode. Significant damage observed. Sandblast and repaint underway. Parts ordered for expedited delivery. Customer impact: 13,000 accounts. Working around the clock to restore service.', 'URGENT REPAIR: T-SS032-001 tripped offline unexpectedly. Field investigation found rust on tank surface. Tank Corrosion confirmed as failure mode. Significant damage observed. Sandblast and repaint underway. Parts ordered for expedited delivery. Customer impact: 13,000 accounts. Working around the clock to restore service.',
       PARSE_JSON('["Tank Corrosion", "rust on tank surface", "paint deterioration"]'), 'MEDIUM',
       PARSE_JSON('["Sandblast and repaint", "Seal leaks", "Monitor corrosion rate", "Monitor trend over next 30 days", "Include in quarterly review", "Document for analysis"]')
UNION ALL SELECT 'MAINT-T-SS012-001-20250904-074', 'T-SS012-001', 'INSPECTION_REPORT',
       '2025-09-04'::DATE, 'Lisa Thompson', 'TECH8318',
       '@MAINTENANCE_DOCS_STAGE/MAINT-T-SS012-001-20250904-074.pdf', 4028, 'PDF',
       'EMERGENCY', 8.15, 95091.67,
       TRUE, 'URGENT REPAIR: T-SS012-001 tripped offline unexpectedly. Field investigation found high moisture content. Oil Contamination confirmed as failure mode. Significant damage observed. Oil filtering underway. Parts ordered for expedited delivery. Customer impact: 13,000 accounts. Working around the clock to restore service.', 'URGENT REPAIR: T-SS012-001 tripped offline unexpectedly. Field investigation found high moisture content. Oil Contamination confirmed as failure mode. Significant damage observed. Oil filtering underway. Parts ordered for expedited delivery. Customer impact: 13,000 accounts. Working around the clock to restore service.',
       PARSE_JSON('["Oil Contamination", "high moisture content", "acidic oil"]'), 'MEDIUM',
       PARSE_JSON('["Oil filtering", "Oil replacement", "Seal repair", "Monitor trend over next 30 days", "Include in quarterly review", "Document for analysis"]')
UNION ALL SELECT 'MAINT-T-SS096-001-20240918-075', 'T-SS096-001', 'INSPECTION_REPORT',
       '2024-09-18'::DATE, 'John Martinez', 'TECH3231',
       '@MAINTENANCE_DOCS_STAGE/MAINT-T-SS096-001-20240918-075.pdf', 3966, 'PDF',
       'CORRECTIVE', 8.4, 17471.74,
       FALSE, 'Maintenance crew dispatched to T-SS096-001 for reported issue. Discovered lightning strike during inspection. Weather Damage confirmed through diagnostic testing. Completed assess damage. Load tests performed successfully. Placed asset back online with continuous monitoring recommended.', 'Maintenance crew dispatched to T-SS096-001 for reported issue. Discovered lightning strike during inspection. Weather Damage confirmed through diagnostic testing. Completed assess damage. Load tests performed successfully. Placed asset back online with continuous monitoring recommended.',
       PARSE_JSON('["Weather Damage", "lightning strike", "flood damage"]'), 'MEDIUM',
       PARSE_JSON('["Assess damage", "Dry out equipment", "Replace damaged parts", "Monitor trend over next 30 days", "Include in quarterly review", "Document for analysis"]')
;
