-- BULK LOAD ALL UNSTRUCTURED DATA
-- Total: 518 records in 34 batches
-- Generated: /Users/srsubramanian/cursor/AI-driven Grid Reliability & Predictive Maintenance/unstructured/bulk_load_data.py

USE DATABASE UTILITIES_GRID_RELIABILITY;
USE SCHEMA UNSTRUCTURED;
USE WAREHOUSE COMPUTE_WH;

-- Batch 1/34
INSERT INTO UTILITIES_GRID_RELIABILITY.UNSTRUCTURED.MAINTENANCE_LOG_DOCUMENTS 
(DOCUMENT_ID, ASSET_ID, DOCUMENT_TYPE, DOCUMENT_DATE, TECHNICIAN_NAME, TECHNICIAN_ID, 
 FILE_PATH, FILE_SIZE_BYTES, FILE_FORMAT, MAINTENANCE_TYPE, DURATION_HOURS, COST_USD, 
 FAILURE_OCCURRED, DOCUMENT_TEXT, SUMMARY, ROOT_CAUSE_KEYWORDS, SEVERITY_LEVEL, RECOMMENDED_ACTIONS)
SELECT (
                'MAINT-T-SS070-001-20250724-001', 'T-SS070-001', 'INSPECTION_REPORT', 
                '2025-07-24'::DATE, 'John Martinez', 'TECH9177',
                '@MAINTENANCE_DOCS_STAGE/MAINT-T-SS070-001-20250724-001.pdf', 3822, 'PDF',
                'PREVENTIVE', 5.9, 9472.04,
                FALSE, 'Performed routine quarterly inspection of transformer T-SS070-001. Visual inspection showed equipment in satisfactory condition. Oil sample collected for laboratory analysis. All cooling fans operational. Minor paint touch-up applied to tank exterior. No immediate concerns noted.', 'Performed routine quarterly inspection of transformer T-SS070-001. Visual inspection showed equipment in satisfactory condition. Oil sample collected for laboratory analysis. All cooling fans operational. Minor paint touch-up applied to tank exterior. No immediate concerns noted.',
                PARSE_JSON('[]'), 'LOW',
                PARSE_JSON('["Sandblast and repaint", "Seal leaks", "Monitor corrosion rate", "Continue standard monitoring", "No immediate action required"]')
            ),(
                'MAINT-T-SS081-001-20250820-002', 'T-SS081-001', 'INSPECTION_REPORT', 
                '2025-08-20'::DATE, 'Chris Anderson', 'TECH8012',
                '@MAINTENANCE_DOCS_STAGE/MAINT-T-SS081-001-20250820-002.pdf', 3955, 'PDF',
                'CORRECTIVE', 7.13, 31746.82,
                FALSE, 'Responded to abnormal readings from T-SS081-001. Investigation revealed cracked porcelain. Bushing Failure identified as primary issue. Performed bushing replacement. Equipment returned to normal operation. Recommend follow-up inspection in 30 days to verify stability.', 'Responded to abnormal readings from T-SS081-001. Investigation revealed cracked porcelain. Bushing Failure identified as primary issue. Performed bushing replacement. Equipment returned to normal operation. Recommend follow-up inspection in 30 days to verify stability.',
                PARSE_JSON('["Bushing Failure", "cracked porcelain", "oil leak at bushing"]'), 'HIGH',
                PARSE_JSON('["Bushing replacement", "Emergency shutdown", "Load transfer", "Increase monitoring frequency", "Schedule follow-up in 2 weeks", "Review similar assets"]')
            ),(
                'MAINT-T-SS046-001-20241220-003', 'T-SS046-001', 'INSPECTION_REPORT', 
                '2024-12-20'::DATE, 'Lisa Thompson', 'TECH6827',
                '@MAINTENANCE_DOCS_STAGE/MAINT-T-SS046-001-20241220-003.pdf', 4030, 'PDF',
                'EMERGENCY', 9.29, 36113.25,
                TRUE, 'URGENT REPAIR: T-SS046-001 tripped offline unexpectedly. Field investigation found sustained high load. Overload Condition confirmed as failure mode. Significant damage observed. Load redistribution underway. Parts ordered for expedited delivery. Customer impact: 9,500 accounts. Working around the clock to restore service.', 'URGENT REPAIR: T-SS046-001 tripped offline unexpectedly. Field investigation found sustained high load. Overload Condition confirmed as failure mode. Significant damage observed. Load redistribution underway. Parts ordered for expedited delivery. Customer impact: 9,500 accounts. Working around the clock to restore service.',
                PARSE_JSON('["Overload Condition", "sustained high load", "exceeding nameplate rating"]'), 'HIGH',
                PARSE_JSON('["Load redistribution", "Capacity upgrade", "Parallel operation", "Increase monitoring frequency", "Schedule follow-up in 2 weeks", "Review similar assets"]')
            ),(
                'MAINT-T-SS099-001-20240207-004', 'T-SS099-001', 'INSPECTION_REPORT', 
                '2024-02-07'::DATE, 'Mike Chen', 'TECH4233',
                '@MAINTENANCE_DOCS_STAGE/MAINT-T-SS099-001-20240207-004.pdf', 3972, 'PDF',
                'CORRECTIVE', 7.37, 29347.18,
                FALSE, 'Maintenance crew dispatched to T-SS099-001 for reported issue. Discovered rust on tank surface during inspection. Tank Corrosion confirmed through diagnostic testing. Completed sandblast and repaint. Load tests performed successfully. Placed asset back online with continuous monitoring recommended.', 'Maintenance crew dispatched to T-SS099-001 for reported issue. Discovered rust on tank surface during inspection. Tank Corrosion confirmed through diagnostic testing. Completed sandblast and repaint. Load tests performed successfully. Placed asset back online with continuous monitoring recommended.',
                PARSE_JSON('["Tank Corrosion", "rust on tank surface", "paint deterioration"]'), 'MEDIUM',
                PARSE_JSON('["Sandblast and repaint", "Seal leaks", "Monitor corrosion rate", "Monitor trend over next 30 days", "Include in quarterly review", "Document for analysis"]')
            ),(
                'MAINT-T-SS071-001-20240424-005', 'T-SS071-001', 'INSPECTION_REPORT', 
                '2024-04-24'::DATE, 'Jennifer Garcia', 'TECH8433',
                '@MAINTENANCE_DOCS_STAGE/MAINT-T-SS071-001-20240424-005.pdf', 3779, 'PDF',
                'INSPECTION', 1.58, 4208.87,
                FALSE, 'Routine visual inspection of T-SS071-001 completed. All external components appear normal. No oil leaks detected. Paint condition good. Gauge readings within normal limits. No maintenance actions required at this time. Equipment suitable for continued operation. Next inspection scheduled per maintenance calendar.', 'Routine visual inspection of T-SS071-001 completed. All external components appear normal. No oil leaks detected. Paint condition good. Gauge readings within normal limits. No maintenance actions required at this time. Equipment suitable for continued operation. Next inspection scheduled per maintenance calendar.',
                PARSE_JSON('[]'), 'LOW',
                PARSE_JSON('["Continue routine monitoring", "Continue standard monitoring", "No immediate action required"]')
            ),(
                'MAINT-T-SS058-001-20240503-006', 'T-SS058-001', 'INSPECTION_REPORT', 
                '2024-05-03'::DATE, 'Sarah Johnson', 'TECH6457',
                '@MAINTENANCE_DOCS_STAGE/MAINT-T-SS058-001-20240503-006.pdf', 4021, 'PDF',
                'CORRECTIVE', 4.55, 21195.65,
                TRUE, 'Corrective action taken on T-SS058-001 following operations alert. Found evidence of exceeding nameplate rating. Root cause analysis indicates overload condition. Implemented capacity upgrade as remedial measure. Post-repair testing satisfactory. System restored to service.', 'Corrective action taken on T-SS058-001 following operations alert. Found evidence of exceeding nameplate rating. Root cause analysis indicates overload condition. Implemented capacity upgrade as remedial measure. Post-repair testing satisfactory. System restored to service.',
                PARSE_JSON('["Overload Condition", "sustained high load", "exceeding nameplate rating"]'), 'HIGH',
                PARSE_JSON('["Load redistribution", "Capacity upgrade", "Parallel operation", "Increase monitoring frequency", "Schedule follow-up in 2 weeks", "Review similar assets"]')
            ),(
                'MAINT-T-SS045-001-20240122-007', 'T-SS045-001', 'INSPECTION_REPORT', 
                '2024-01-22'::DATE, 'Jennifer Garcia', 'TECH5526',
                '@MAINTENANCE_DOCS_STAGE/MAINT-T-SS045-001-20240122-007.pdf', 4024, 'PDF',
                'EMERGENCY', 23.94, 89626.86,
                TRUE, 'URGENT REPAIR: T-SS045-001 tripped offline unexpectedly. Field investigation found elevated H2 levels. Dissolved Gas Anomaly confirmed as failure mode. Significant damage observed. DGA analysis underway. Parts ordered for expedited delivery. Customer impact: 11,000 accounts. Working around the clock to restore service.', 'URGENT REPAIR: T-SS045-001 tripped offline unexpectedly. Field investigation found elevated H2 levels. Dissolved Gas Anomaly confirmed as failure mode. Significant damage observed. DGA analysis underway. Parts ordered for expedited delivery. Customer impact: 11,000 accounts. Working around the clock to restore service.',
                PARSE_JSON('["Dissolved Gas Anomaly", "elevated H2 levels", "high CO/CO2 ratio"]'), 'HIGH',
                PARSE_JSON('["DGA analysis", "Load reduction", "Immediate inspection", "Increase monitoring frequency", "Schedule follow-up in 2 weeks", "Review similar assets"]')
            ),(
                'MAINT-T-SS015-001-20240523-008', 'T-SS015-001', 'INSPECTION_REPORT', 
                '2024-05-23'::DATE, 'Lisa Thompson', 'TECH1726',
                '@MAINTENANCE_DOCS_STAGE/MAINT-T-SS015-001-20240523-008.pdf', 3830, 'PDF',
                'PREVENTIVE', 2.87, 6242.22,
                FALSE, 'Annual maintenance completed on T-SS015-001. Replaced air filters on cooling system. Cleaned radiator fins. Torque-checked all bolted connections. Oil dielectric test passed. No abnormalities detected. Equipment performing to specification. Next scheduled maintenance in 12 months.', 'Annual maintenance completed on T-SS015-001. Replaced air filters on cooling system. Cleaned radiator fins. Torque-checked all bolted connections. Oil dielectric test passed. No abnormalities detected. Equipment performing to specification. Next scheduled maintenance in 12 months.',
                PARSE_JSON('[]'), 'LOW',
                PARSE_JSON('["Sandblast and repaint", "Seal leaks", "Monitor corrosion rate", "Continue standard monitoring", "No immediate action required"]')
            ),(
                'MAINT-T-SS060-001-20241210-009', 'T-SS060-001', 'INSPECTION_REPORT', 
                '2024-12-10'::DATE, 'Jennifer Garcia', 'TECH9481',
                '@MAINTENANCE_DOCS_STAGE/MAINT-T-SS060-001-20241210-009.pdf', 3972, 'PDF',
                'CORRECTIVE', 5.02, 33086.87,
                FALSE, 'Corrective action taken on T-SS060-001 following operations alert. Found evidence of paint deterioration. Root cause analysis indicates tank corrosion. Implemented seal leaks as remedial measure. Post-repair testing satisfactory. System restored to service.', 'Corrective action taken on T-SS060-001 following operations alert. Found evidence of paint deterioration. Root cause analysis indicates tank corrosion. Implemented seal leaks as remedial measure. Post-repair testing satisfactory. System restored to service.',
                PARSE_JSON('["Tank Corrosion", "rust on tank surface", "paint deterioration"]'), 'MEDIUM',
                PARSE_JSON('["Sandblast and repaint", "Seal leaks", "Monitor corrosion rate", "Monitor trend over next 30 days", "Include in quarterly review", "Document for analysis"]')
            ),(
                'MAINT-T-SS036-001-20241204-010', 'T-SS036-001', 'INSPECTION_REPORT', 
                '2024-12-04'::DATE, 'Sarah Johnson', 'TECH5112',
                '@MAINTENANCE_DOCS_STAGE/MAINT-T-SS036-001-20241204-010.pdf', 3847, 'PDF',
                'PREVENTIVE', 4.23, 14211.6,
                FALSE, 'Conducted scheduled preventive maintenance on T-SS036-001. Checked all electrical connections, found all secure. Oil level and color satisfactory. Bushings clean with no signs of tracking. Radiators clean and unobstructed. Load tap changer tested - operating normally. Recommended continued monitoring.', 'Conducted scheduled preventive maintenance on T-SS036-001. Checked all electrical connections, found all secure. Oil level and color satisfactory. Bushings clean with no signs of tracking. Radiators clean and unobstructed. Load tap changer tested - operating normally. Recommended continued monitoring.',
                PARSE_JSON('[]'), 'LOW',
                PARSE_JSON('["DGA analysis", "Load reduction", "Immediate inspection", "Continue standard monitoring", "No immediate action required"]')
            );

-- Batch 2/34
INSERT INTO UTILITIES_GRID_RELIABILITY.UNSTRUCTURED.MAINTENANCE_LOG_DOCUMENTS 
(DOCUMENT_ID, ASSET_ID, DOCUMENT_TYPE, DOCUMENT_DATE, TECHNICIAN_NAME, TECHNICIAN_ID, 
 FILE_PATH, FILE_SIZE_BYTES, FILE_FORMAT, MAINTENANCE_TYPE, DURATION_HOURS, COST_USD, 
 FAILURE_OCCURRED, DOCUMENT_TEXT, SUMMARY, ROOT_CAUSE_KEYWORDS, SEVERITY_LEVEL, RECOMMENDED_ACTIONS)
SELECT (
                'MAINT-T-SS033-001-20250119-011', 'T-SS033-001', 'INSPECTION_REPORT', 
                '2025-01-19'::DATE, 'Robert Wilson', 'TECH8073',
                '@MAINTENANCE_DOCS_STAGE/MAINT-T-SS033-001-20250119-011.pdf', 3993, 'PDF',
                'CORRECTIVE', 8.33, 42697.22,
                FALSE, 'Corrective action taken on T-SS033-001 following operations alert. Found evidence of high CO/CO2 ratio. Root cause analysis indicates dissolved gas anomaly. Implemented load reduction as remedial measure. Post-repair testing satisfactory. System restored to service.', 'Corrective action taken on T-SS033-001 following operations alert. Found evidence of high CO/CO2 ratio. Root cause analysis indicates dissolved gas anomaly. Implemented load reduction as remedial measure. Post-repair testing satisfactory. System restored to service.',
                PARSE_JSON('["Dissolved Gas Anomaly", "elevated H2 levels", "high CO/CO2 ratio"]'), 'HIGH',
                PARSE_JSON('["DGA analysis", "Load reduction", "Immediate inspection", "Increase monitoring frequency", "Schedule follow-up in 2 weeks", "Review similar assets"]')
            ),(
                'MAINT-T-SS087-001-20240827-012', 'T-SS087-001', 'INSPECTION_REPORT', 
                '2024-08-27'::DATE, 'Maria Lopez', 'TECH6343',
                '@MAINTENANCE_DOCS_STAGE/MAINT-T-SS087-001-20240827-012.pdf', 3817, 'PDF',
                'PREVENTIVE', 2.82, 9032.93,
                FALSE, 'Performed routine quarterly inspection of transformer T-SS087-001. Visual inspection showed equipment in satisfactory condition. Oil sample collected for laboratory analysis. All cooling fans operational. Minor paint touch-up applied to tank exterior. No immediate concerns noted.', 'Performed routine quarterly inspection of transformer T-SS087-001. Visual inspection showed equipment in satisfactory condition. Oil sample collected for laboratory analysis. All cooling fans operational. Minor paint touch-up applied to tank exterior. No immediate concerns noted.',
                PARSE_JSON('[]'), 'LOW',
                PARSE_JSON('["Assess damage", "Dry out equipment", "Replace damaged parts", "Continue standard monitoring", "No immediate action required"]')
            ),(
                'MAINT-T-SS082-001-20250723-013', 'T-SS082-001', 'INSPECTION_REPORT', 
                '2025-07-23'::DATE, 'Lisa Thompson', 'TECH9479',
                '@MAINTENANCE_DOCS_STAGE/MAINT-T-SS082-001-20250723-013.pdf', 3991, 'PDF',
                'CORRECTIVE', 5.78, 25523.83,
                FALSE, 'Maintenance crew dispatched to T-SS082-001 for reported issue. Discovered PD activity detected during inspection. Partial Discharge confirmed through diagnostic testing. Completed offline testing. Load tests performed successfully. Placed asset back online with continuous monitoring recommended.', 'Maintenance crew dispatched to T-SS082-001 for reported issue. Discovered PD activity detected during inspection. Partial Discharge confirmed through diagnostic testing. Completed offline testing. Load tests performed successfully. Placed asset back online with continuous monitoring recommended.',
                PARSE_JSON('["Partial Discharge", "PD activity detected", "corona discharge"]'), 'CRITICAL',
                PARSE_JSON('["Offline testing", "Bushing replacement", "Emergency repair", "Immediate review by engineering team", "Daily monitoring until stable", "Prepare backup equipment"]')
            ),(
                'MAINT-T-SS052-001-20240830-014', 'T-SS052-001', 'INSPECTION_REPORT', 
                '2024-08-30'::DATE, 'Robert Wilson', 'TECH6039',
                '@MAINTENANCE_DOCS_STAGE/MAINT-T-SS052-001-20240830-014.pdf', 3829, 'PDF',
                'PREVENTIVE', 4.05, 6290.84,
                FALSE, 'Annual maintenance completed on T-SS052-001. Replaced air filters on cooling system. Cleaned radiator fins. Torque-checked all bolted connections. Oil dielectric test passed. No abnormalities detected. Equipment performing to specification. Next scheduled maintenance in 12 months.', 'Annual maintenance completed on T-SS052-001. Replaced air filters on cooling system. Cleaned radiator fins. Torque-checked all bolted connections. Oil dielectric test passed. No abnormalities detected. Equipment performing to specification. Next scheduled maintenance in 12 months.',
                PARSE_JSON('[]'), 'LOW',
                PARSE_JSON('["DGA analysis", "Load reduction", "Immediate inspection", "Continue standard monitoring", "No immediate action required"]')
            ),(
                'MAINT-T-SS036-001-20250915-015', 'T-SS036-001', 'INSPECTION_REPORT', 
                '2025-09-15'::DATE, 'Lisa Thompson', 'TECH2705',
                '@MAINTENANCE_DOCS_STAGE/MAINT-T-SS036-001-20250915-015.pdf', 3997, 'PDF',
                'EMERGENCY', 18.03, 76525.03,
                TRUE, 'Critical failure event on T-SS036-001. Operations detected paint deterioration. Emergency shutdown initiated per safety protocol. Assessment revealed tank corrosion caused the outage. Backup power systems activated. Seal leaks in progress. Coordinating with grid operations for load management. ETA to service restoration: 2-3 days.', 'Critical failure event on T-SS036-001. Operations detected paint deterioration. Emergency shutdown initiated per safety protocol. Assessment revealed tank corrosion caused the outage. Backup power systems activated. Seal leaks in progress. Coordinating with grid operations for load management. ETA to service restoration: 2-3 days.',
                PARSE_JSON('["Tank Corrosion", "rust on tank surface", "paint deterioration"]'), 'MEDIUM',
                PARSE_JSON('["Sandblast and repaint", "Seal leaks", "Monitor corrosion rate", "Monitor trend over next 30 days", "Include in quarterly review", "Document for analysis"]')
            ),(
                'MAINT-T-SS024-001-20240207-016', 'T-SS024-001', 'INSPECTION_REPORT', 
                '2024-02-07'::DATE, 'David Rodriguez', 'TECH4530',
                '@MAINTENANCE_DOCS_STAGE/MAINT-T-SS024-001-20240207-016.pdf', 3939, 'PDF',
                'CORRECTIVE', 11.37, 20983.99,
                FALSE, 'Responded to abnormal readings from T-SS024-001. Investigation revealed lightning strike. Weather Damage identified as primary issue. Performed assess damage. Equipment returned to normal operation. Recommend follow-up inspection in 30 days to verify stability.', 'Responded to abnormal readings from T-SS024-001. Investigation revealed lightning strike. Weather Damage identified as primary issue. Performed assess damage. Equipment returned to normal operation. Recommend follow-up inspection in 30 days to verify stability.',
                PARSE_JSON('["Weather Damage", "lightning strike", "flood damage"]'), 'MEDIUM',
                PARSE_JSON('["Assess damage", "Dry out equipment", "Replace damaged parts", "Monitor trend over next 30 days", "Include in quarterly review", "Document for analysis"]')
            ),(
                'MAINT-T-SS056-001-20241125-017', 'T-SS056-001', 'INSPECTION_REPORT', 
                '2024-11-25'::DATE, 'Sarah Johnson', 'TECH7689',
                '@MAINTENANCE_DOCS_STAGE/MAINT-T-SS056-001-20241125-017.pdf', 3851, 'PDF',
                'EMERGENCY', 9.05, 109508.19,
                FALSE, 'Critical failure event on T-SS056-001. Operations detected moisture ingress. Emergency shutdown initiated per safety protocol. Assessment revealed insulation degradation caused the outage. Backup power systems activated. Replace bushings in progress. Coordinating with grid operations for load management. ETA to service restoration: 2-3 days.', 'Critical failure event on T-SS056-001. Operations detected moisture ingress. Emergency shutdown initiated per safety protocol. Assessment revealed insulation degradation caused the outage. Backup power systems activated. Replace bushings in progress. Coordinating with grid operations for load management. ETA to service restoration: 2-3 days.',
                PARSE_JSON('[]'), 'LOW',
                PARSE_JSON('["Oil reclamation", "Replace bushings", "Transformer replacement", "Continue standard monitoring", "No immediate action required"]')
            ),(
                'MAINT-T-SS045-001-20240624-018', 'T-SS045-001', 'INSPECTION_REPORT', 
                '2024-06-24'::DATE, 'Mike Chen', 'TECH3623',
                '@MAINTENANCE_DOCS_STAGE/MAINT-T-SS045-001-20240624-018.pdf', 3810, 'PDF',
                'PREVENTIVE', 4.53, 12920.14,
                FALSE, 'Annual maintenance completed on T-SS045-001. Replaced air filters on cooling system. Cleaned radiator fins. Torque-checked all bolted connections. Oil dielectric test passed. No abnormalities detected. Equipment performing to specification. Next scheduled maintenance in 12 months.', 'Annual maintenance completed on T-SS045-001. Replaced air filters on cooling system. Cleaned radiator fins. Torque-checked all bolted connections. Oil dielectric test passed. No abnormalities detected. Equipment performing to specification. Next scheduled maintenance in 12 months.',
                PARSE_JSON('[]'), 'LOW',
                PARSE_JSON('["Oil filtering", "Oil replacement", "Seal repair", "Continue standard monitoring", "No immediate action required"]')
            ),(
                'MAINT-T-SS073-001-20250405-019', 'T-SS073-001', 'INSPECTION_REPORT', 
                '2025-04-05'::DATE, 'David Rodriguez', 'TECH3574',
                '@MAINTENANCE_DOCS_STAGE/MAINT-T-SS073-001-20250405-019.pdf', 3840, 'PDF',
                'PREVENTIVE', 4.69, 9312.16,
                FALSE, 'Performed routine quarterly inspection of transformer T-SS073-001. Visual inspection showed equipment in satisfactory condition. Oil sample collected for laboratory analysis. All cooling fans operational. Minor paint touch-up applied to tank exterior. No immediate concerns noted.', 'Performed routine quarterly inspection of transformer T-SS073-001. Visual inspection showed equipment in satisfactory condition. Oil sample collected for laboratory analysis. All cooling fans operational. Minor paint touch-up applied to tank exterior. No immediate concerns noted.',
                PARSE_JSON('[]'), 'LOW',
                PARSE_JSON('["Tighten connections", "Replace bearings", "Balance rotating parts", "Continue standard monitoring", "No immediate action required"]')
            ),(
                'MAINT-T-SS070-001-20241019-020', 'T-SS070-001', 'INSPECTION_REPORT', 
                '2024-10-19'::DATE, 'Emily Davis', 'TECH3889',
                '@MAINTENANCE_DOCS_STAGE/MAINT-T-SS070-001-20241019-020.pdf', 3801, 'PDF',
                'INSPECTION', 1.82, 2835.87,
                FALSE, 'Walk-through inspection performed on T-SS070-001. Checked for obvious signs of deterioration or damage. All observed parameters normal. Cooling system functioning properly. No unusual sounds or odors noted. Asset appears to be operating satisfactorily. Documentation updated in asset management system.', 'Walk-through inspection performed on T-SS070-001. Checked for obvious signs of deterioration or damage. All observed parameters normal. Cooling system functioning properly. No unusual sounds or odors noted. Asset appears to be operating satisfactorily. Documentation updated in asset management system.',
                PARSE_JSON('[]'), 'LOW',
                PARSE_JSON('["Continue routine monitoring", "Continue standard monitoring", "No immediate action required"]')
            );

-- Batch 3/34
INSERT INTO UTILITIES_GRID_RELIABILITY.UNSTRUCTURED.MAINTENANCE_LOG_DOCUMENTS 
(DOCUMENT_ID, ASSET_ID, DOCUMENT_TYPE, DOCUMENT_DATE, TECHNICIAN_NAME, TECHNICIAN_ID, 
 FILE_PATH, FILE_SIZE_BYTES, FILE_FORMAT, MAINTENANCE_TYPE, DURATION_HOURS, COST_USD, 
 FAILURE_OCCURRED, DOCUMENT_TEXT, SUMMARY, ROOT_CAUSE_KEYWORDS, SEVERITY_LEVEL, RECOMMENDED_ACTIONS)
SELECT (
                'MAINT-T-SS076-001-20240913-021', 'T-SS076-001', 'INSPECTION_REPORT', 
                '2024-09-13'::DATE, 'Lisa Thompson', 'TECH3117',
                '@MAINTENANCE_DOCS_STAGE/MAINT-T-SS076-001-20240913-021.pdf', 3832, 'PDF',
                'PREVENTIVE', 5.29, 13050.21,
                FALSE, 'Performed routine quarterly inspection of transformer T-SS076-001. Visual inspection showed equipment in satisfactory condition. Oil sample collected for laboratory analysis. All cooling fans operational. Minor paint touch-up applied to tank exterior. No immediate concerns noted.', 'Performed routine quarterly inspection of transformer T-SS076-001. Visual inspection showed equipment in satisfactory condition. Oil sample collected for laboratory analysis. All cooling fans operational. Minor paint touch-up applied to tank exterior. No immediate concerns noted.',
                PARSE_JSON('[]'), 'LOW',
                PARSE_JSON('["Oil reclamation", "Replace bushings", "Transformer replacement", "Continue standard monitoring", "No immediate action required"]')
            ),(
                'MAINT-T-SS087-001-20240127-022', 'T-SS087-001', 'INSPECTION_REPORT', 
                '2024-01-27'::DATE, 'John Martinez', 'TECH7403',
                '@MAINTENANCE_DOCS_STAGE/MAINT-T-SS087-001-20240127-022.pdf', 3990, 'PDF',
                'CORRECTIVE', 10.71, 15365.7,
                FALSE, 'Corrective action taken on T-SS087-001 following operations alert. Found evidence of radiator inefficiency. Root cause analysis indicates high oil temperature. Implemented check oil level as remedial measure. Post-repair testing satisfactory. System restored to service.', 'Corrective action taken on T-SS087-001 following operations alert. Found evidence of radiator inefficiency. Root cause analysis indicates high oil temperature. Implemented check oil level as remedial measure. Post-repair testing satisfactory. System restored to service.',
                PARSE_JSON('["High Oil Temperature", "oil temp above 85\u00b0C", "radiator inefficiency"]'), 'HIGH',
                PARSE_JSON('["Clean radiators", "Check oil level", "Inspect cooling fans", "Increase monitoring frequency", "Schedule follow-up in 2 weeks", "Review similar assets"]')
            ),(
                'MAINT-T-SS069-001-20251008-023', 'T-SS069-001', 'INSPECTION_REPORT', 
                '2025-10-08'::DATE, 'Sarah Johnson', 'TECH3606',
                '@MAINTENANCE_DOCS_STAGE/MAINT-T-SS069-001-20251008-023.pdf', 3969, 'PDF',
                'CORRECTIVE', 7.38, 24120.29,
                FALSE, 'Responded to abnormal readings from T-SS069-001. Investigation revealed oil temp above 85°C. High Oil Temperature identified as primary issue. Performed clean radiators. Equipment returned to normal operation. Recommend follow-up inspection in 30 days to verify stability.', 'Responded to abnormal readings from T-SS069-001. Investigation revealed oil temp above 85°C. High Oil Temperature identified as primary issue. Performed clean radiators. Equipment returned to normal operation. Recommend follow-up inspection in 30 days to verify stability.',
                PARSE_JSON('["High Oil Temperature", "oil temp above 85\u00b0C", "radiator inefficiency"]'), 'HIGH',
                PARSE_JSON('["Clean radiators", "Check oil level", "Inspect cooling fans", "Increase monitoring frequency", "Schedule follow-up in 2 weeks", "Review similar assets"]')
            ),(
                'MAINT-T-SS009-001-20250614-024', 'T-SS009-001', 'INSPECTION_REPORT', 
                '2025-06-14'::DATE, 'Jennifer Garcia', 'TECH9127',
                '@MAINTENANCE_DOCS_STAGE/MAINT-T-SS009-001-20250614-024.pdf', 3827, 'PDF',
                'PREVENTIVE', 2.68, 12234.2,
                FALSE, 'Annual maintenance completed on T-SS009-001. Replaced air filters on cooling system. Cleaned radiator fins. Torque-checked all bolted connections. Oil dielectric test passed. No abnormalities detected. Equipment performing to specification. Next scheduled maintenance in 12 months.', 'Annual maintenance completed on T-SS009-001. Replaced air filters on cooling system. Cleaned radiator fins. Torque-checked all bolted connections. Oil dielectric test passed. No abnormalities detected. Equipment performing to specification. Next scheduled maintenance in 12 months.',
                PARSE_JSON('[]'), 'LOW',
                PARSE_JSON('["Tighten connections", "Replace bearings", "Balance rotating parts", "Continue standard monitoring", "No immediate action required"]')
            ),(
                'MAINT-T-SS088-001-20241126-025', 'T-SS088-001', 'INSPECTION_REPORT', 
                '2024-11-26'::DATE, 'Mike Chen', 'TECH3996',
                '@MAINTENANCE_DOCS_STAGE/MAINT-T-SS088-001-20241126-025.pdf', 3982, 'PDF',
                'CORRECTIVE', 9.26, 38486.59,
                TRUE, 'Responded to abnormal readings from T-SS088-001. Investigation revealed PD activity detected. Partial Discharge identified as primary issue. Performed offline testing. Equipment returned to normal operation. Recommend follow-up inspection in 30 days to verify stability.', 'Responded to abnormal readings from T-SS088-001. Investigation revealed PD activity detected. Partial Discharge identified as primary issue. Performed offline testing. Equipment returned to normal operation. Recommend follow-up inspection in 30 days to verify stability.',
                PARSE_JSON('["Partial Discharge", "PD activity detected", "corona discharge"]'), 'CRITICAL',
                PARSE_JSON('["Offline testing", "Bushing replacement", "Emergency repair", "Immediate review by engineering team", "Daily monitoring until stable", "Prepare backup equipment"]')
            ),(
                'MAINT-T-SS023-001-20240318-026', 'T-SS023-001', 'INSPECTION_REPORT', 
                '2024-03-18'::DATE, 'Lisa Thompson', 'TECH7361',
                '@MAINTENANCE_DOCS_STAGE/MAINT-T-SS023-001-20240318-026.pdf', 3991, 'PDF',
                'EMERGENCY', 15.26, 86585.51,
                TRUE, 'EMERGENCY RESPONSE: T-SS023-001 experienced failure at 21:42. Tank Corrosion identified as cause. rust on tank surface was primary factor. Immediate isolation performed. Load transferred to backup transformer. Sandblast and repaint required. Estimated repair time: 48-72 hours. 18,000 customers temporarily affected.', 'EMERGENCY RESPONSE: T-SS023-001 experienced failure at 21:42. Tank Corrosion identified as cause. rust on tank surface was primary factor. Immediate isolation performed. Load transferred to backup transformer. Sandblast and repaint required. Estimated repair time: 48-72 hours. 18,000 customers temporarily affected.',
                PARSE_JSON('["Tank Corrosion", "rust on tank surface", "paint deterioration"]'), 'MEDIUM',
                PARSE_JSON('["Sandblast and repaint", "Seal leaks", "Monitor corrosion rate", "Monitor trend over next 30 days", "Include in quarterly review", "Document for analysis"]')
            ),(
                'MAINT-T-SS009-001-20231126-027', 'T-SS009-001', 'INSPECTION_REPORT', 
                '2023-11-26'::DATE, 'Jennifer Garcia', 'TECH1992',
                '@MAINTENANCE_DOCS_STAGE/MAINT-T-SS009-001-20231126-027.pdf', 3851, 'PDF',
                'PREVENTIVE', 2.11, 9827.66,
                FALSE, 'Conducted scheduled preventive maintenance on T-SS009-001. Checked all electrical connections, found all secure. Oil level and color satisfactory. Bushings clean with no signs of tracking. Radiators clean and unobstructed. Load tap changer tested - operating normally. Recommended continued monitoring.', 'Conducted scheduled preventive maintenance on T-SS009-001. Checked all electrical connections, found all secure. Oil level and color satisfactory. Bushings clean with no signs of tracking. Radiators clean and unobstructed. Load tap changer tested - operating normally. Recommended continued monitoring.',
                PARSE_JSON('[]'), 'LOW',
                PARSE_JSON('["Sandblast and repaint", "Seal leaks", "Monitor corrosion rate", "Continue standard monitoring", "No immediate action required"]')
            ),(
                'MAINT-T-SS067-001-20231215-028', 'T-SS067-001', 'INSPECTION_REPORT', 
                '2023-12-15'::DATE, 'Jennifer Garcia', 'TECH9714',
                '@MAINTENANCE_DOCS_STAGE/MAINT-T-SS067-001-20231215-028.pdf', 4032, 'PDF',
                'EMERGENCY', 7.44, 59973.91,
                TRUE, 'Critical failure event on T-SS067-001. Operations detected exceeding nameplate rating. Emergency shutdown initiated per safety protocol. Assessment revealed overload condition caused the outage. Backup power systems activated. Capacity upgrade in progress. Coordinating with grid operations for load management. ETA to service restoration: 2-3 days.', 'Critical failure event on T-SS067-001. Operations detected exceeding nameplate rating. Emergency shutdown initiated per safety protocol. Assessment revealed overload condition caused the outage. Backup power systems activated. Capacity upgrade in progress. Coordinating with grid operations for load management. ETA to service restoration: 2-3 days.',
                PARSE_JSON('["Overload Condition", "sustained high load", "exceeding nameplate rating"]'), 'HIGH',
                PARSE_JSON('["Load redistribution", "Capacity upgrade", "Parallel operation", "Increase monitoring frequency", "Schedule follow-up in 2 weeks", "Review similar assets"]')
            ),(
                'MAINT-T-SS003-001-20241210-029', 'T-SS003-001', 'INSPECTION_REPORT', 
                '2024-12-10'::DATE, 'John Martinez', 'TECH8659',
                '@MAINTENANCE_DOCS_STAGE/MAINT-T-SS003-001-20241210-029.pdf', 4008, 'PDF',
                'CORRECTIVE', 4.46, 44039.77,
                FALSE, 'Maintenance crew dispatched to T-SS003-001 for reported issue. Discovered turn-to-turn short during inspection. Winding Fault confirmed through diagnostic testing. Completed transformer replacement. Load tests performed successfully. Placed asset back online with continuous monitoring recommended.', 'Maintenance crew dispatched to T-SS003-001 for reported issue. Discovered turn-to-turn short during inspection. Winding Fault confirmed through diagnostic testing. Completed transformer replacement. Load tests performed successfully. Placed asset back online with continuous monitoring recommended.',
                PARSE_JSON('["Winding Fault", "turn-to-turn short", "ground fault"]'), 'CRITICAL',
                PARSE_JSON('["Transformer replacement", "Winding repair", "Outage required", "Immediate review by engineering team", "Daily monitoring until stable", "Prepare backup equipment"]')
            ),(
                'MAINT-T-SS034-001-20240124-030', 'T-SS034-001', 'INSPECTION_REPORT', 
                '2024-01-24'::DATE, 'Sarah Johnson', 'TECH7412',
                '@MAINTENANCE_DOCS_STAGE/MAINT-T-SS034-001-20240124-030.pdf', 3988, 'PDF',
                'CORRECTIVE', 8.09, 30797.07,
                FALSE, 'Maintenance crew dispatched to T-SS034-001 for reported issue. Discovered PD activity detected during inspection. Partial Discharge confirmed through diagnostic testing. Completed offline testing. Load tests performed successfully. Placed asset back online with continuous monitoring recommended.', 'Maintenance crew dispatched to T-SS034-001 for reported issue. Discovered PD activity detected during inspection. Partial Discharge confirmed through diagnostic testing. Completed offline testing. Load tests performed successfully. Placed asset back online with continuous monitoring recommended.',
                PARSE_JSON('["Partial Discharge", "PD activity detected", "corona discharge"]'), 'CRITICAL',
                PARSE_JSON('["Offline testing", "Bushing replacement", "Emergency repair", "Immediate review by engineering team", "Daily monitoring until stable", "Prepare backup equipment"]')
            );

-- Batch 4/34
INSERT INTO UTILITIES_GRID_RELIABILITY.UNSTRUCTURED.MAINTENANCE_LOG_DOCUMENTS 
(DOCUMENT_ID, ASSET_ID, DOCUMENT_TYPE, DOCUMENT_DATE, TECHNICIAN_NAME, TECHNICIAN_ID, 
 FILE_PATH, FILE_SIZE_BYTES, FILE_FORMAT, MAINTENANCE_TYPE, DURATION_HOURS, COST_USD, 
 FAILURE_OCCURRED, DOCUMENT_TEXT, SUMMARY, ROOT_CAUSE_KEYWORDS, SEVERITY_LEVEL, RECOMMENDED_ACTIONS)
SELECT (
                'MAINT-T-SS079-001-20250926-031', 'T-SS079-001', 'INSPECTION_REPORT', 
                '2025-09-26'::DATE, 'Lisa Thompson', 'TECH9518',
                '@MAINTENANCE_DOCS_STAGE/MAINT-T-SS079-001-20250926-031.pdf', 3992, 'PDF',
                'CORRECTIVE', 5.91, 39419.54,
                FALSE, 'Corrective action taken on T-SS079-001 following operations alert. Found evidence of moisture ingress. Root cause analysis indicates insulation degradation. Implemented replace bushings as remedial measure. Post-repair testing satisfactory. System restored to service.', 'Corrective action taken on T-SS079-001 following operations alert. Found evidence of moisture ingress. Root cause analysis indicates insulation degradation. Implemented replace bushings as remedial measure. Post-repair testing satisfactory. System restored to service.',
                PARSE_JSON('["Insulation Degradation", "low insulation resistance", "moisture ingress"]'), 'CRITICAL',
                PARSE_JSON('["Oil reclamation", "Replace bushings", "Transformer replacement", "Immediate review by engineering team", "Daily monitoring until stable", "Prepare backup equipment"]')
            ),(
                'MAINT-T-SS035-001-20250531-032', 'T-SS035-001', 'INSPECTION_REPORT', 
                '2025-05-31'::DATE, 'Chris Anderson', 'TECH2856',
                '@MAINTENANCE_DOCS_STAGE/MAINT-T-SS035-001-20250531-032.pdf', 4007, 'PDF',
                'CORRECTIVE', 8.07, 25176.1,
                TRUE, 'Maintenance crew dispatched to T-SS035-001 for reported issue. Discovered rust on tank surface during inspection. Tank Corrosion confirmed through diagnostic testing. Completed sandblast and repaint. Load tests performed successfully. Placed asset back online with continuous monitoring recommended.', 'Maintenance crew dispatched to T-SS035-001 for reported issue. Discovered rust on tank surface during inspection. Tank Corrosion confirmed through diagnostic testing. Completed sandblast and repaint. Load tests performed successfully. Placed asset back online with continuous monitoring recommended.',
                PARSE_JSON('["Tank Corrosion", "rust on tank surface", "paint deterioration"]'), 'MEDIUM',
                PARSE_JSON('["Sandblast and repaint", "Seal leaks", "Monitor corrosion rate", "Monitor trend over next 30 days", "Include in quarterly review", "Document for analysis"]')
            ),(
                'MAINT-T-SS079-001-20240131-033', 'T-SS079-001', 'INSPECTION_REPORT', 
                '2024-01-31'::DATE, 'Emily Davis', 'TECH7035',
                '@MAINTENANCE_DOCS_STAGE/MAINT-T-SS079-001-20240131-033.pdf', 3818, 'PDF',
                'PREVENTIVE', 2.23, 7708.98,
                FALSE, 'Performed routine quarterly inspection of transformer T-SS079-001. Visual inspection showed equipment in satisfactory condition. Oil sample collected for laboratory analysis. All cooling fans operational. Minor paint touch-up applied to tank exterior. No immediate concerns noted.', 'Performed routine quarterly inspection of transformer T-SS079-001. Visual inspection showed equipment in satisfactory condition. Oil sample collected for laboratory analysis. All cooling fans operational. Minor paint touch-up applied to tank exterior. No immediate concerns noted.',
                PARSE_JSON('[]'), 'LOW',
                PARSE_JSON('["Assess damage", "Dry out equipment", "Replace damaged parts", "Continue standard monitoring", "No immediate action required"]')
            ),(
                'MAINT-T-SS073-001-20240527-034', 'T-SS073-001', 'INSPECTION_REPORT', 
                '2024-05-27'::DATE, 'Jennifer Garcia', 'TECH2220',
                '@MAINTENANCE_DOCS_STAGE/MAINT-T-SS073-001-20240527-034.pdf', 3994, 'PDF',
                'EMERGENCY', 23.62, 43932.01,
                TRUE, 'EMERGENCY RESPONSE: T-SS073-001 experienced failure at 21:42. Weather Damage identified as cause. lightning strike was primary factor. Immediate isolation performed. Load transferred to backup transformer. Assess damage required. Estimated repair time: 48-72 hours. 18,000 customers temporarily affected.', 'EMERGENCY RESPONSE: T-SS073-001 experienced failure at 21:42. Weather Damage identified as cause. lightning strike was primary factor. Immediate isolation performed. Load transferred to backup transformer. Assess damage required. Estimated repair time: 48-72 hours. 18,000 customers temporarily affected.',
                PARSE_JSON('["Weather Damage", "lightning strike", "flood damage"]'), 'MEDIUM',
                PARSE_JSON('["Assess damage", "Dry out equipment", "Replace damaged parts", "Monitor trend over next 30 days", "Include in quarterly review", "Document for analysis"]')
            ),(
                'MAINT-T-SS096-001-20240414-035', 'T-SS096-001', 'INSPECTION_REPORT', 
                '2024-04-14'::DATE, 'Emily Davis', 'TECH7489',
                '@MAINTENANCE_DOCS_STAGE/MAINT-T-SS096-001-20240414-035.pdf', 3856, 'PDF',
                'PREVENTIVE', 3.18, 9321.28,
                FALSE, 'Conducted scheduled preventive maintenance on T-SS096-001. Checked all electrical connections, found all secure. Oil level and color satisfactory. Bushings clean with no signs of tracking. Radiators clean and unobstructed. Load tap changer tested - operating normally. Recommended continued monitoring.', 'Conducted scheduled preventive maintenance on T-SS096-001. Checked all electrical connections, found all secure. Oil level and color satisfactory. Bushings clean with no signs of tracking. Radiators clean and unobstructed. Load tap changer tested - operating normally. Recommended continued monitoring.',
                PARSE_JSON('[]'), 'LOW',
                PARSE_JSON('["Oil reclamation", "Replace bushings", "Transformer replacement", "Continue standard monitoring", "No immediate action required"]')
            ),(
                'MAINT-T-SS058-001-20250901-036', 'T-SS058-001', 'INSPECTION_REPORT', 
                '2025-09-01'::DATE, 'Chris Anderson', 'TECH1698',
                '@MAINTENANCE_DOCS_STAGE/MAINT-T-SS058-001-20250901-036.pdf', 3841, 'PDF',
                'PREVENTIVE', 2.93, 11817.48,
                FALSE, 'Conducted scheduled preventive maintenance on T-SS058-001. Checked all electrical connections, found all secure. Oil level and color satisfactory. Bushings clean with no signs of tracking. Radiators clean and unobstructed. Load tap changer tested - operating normally. Recommended continued monitoring.', 'Conducted scheduled preventive maintenance on T-SS058-001. Checked all electrical connections, found all secure. Oil level and color satisfactory. Bushings clean with no signs of tracking. Radiators clean and unobstructed. Load tap changer tested - operating normally. Recommended continued monitoring.',
                PARSE_JSON('[]'), 'LOW',
                PARSE_JSON('["Sandblast and repaint", "Seal leaks", "Monitor corrosion rate", "Continue standard monitoring", "No immediate action required"]')
            ),(
                'MAINT-T-SS011-001-20241227-037', 'T-SS011-001', 'INSPECTION_REPORT', 
                '2024-12-27'::DATE, 'David Rodriguez', 'TECH8239',
                '@MAINTENANCE_DOCS_STAGE/MAINT-T-SS011-001-20241227-037.pdf', 3964, 'PDF',
                'CORRECTIVE', 10.98, 44977.25,
                FALSE, 'Responded to abnormal readings from T-SS011-001. Investigation revealed oil temp above 85°C. High Oil Temperature identified as primary issue. Performed clean radiators. Equipment returned to normal operation. Recommend follow-up inspection in 30 days to verify stability.', 'Responded to abnormal readings from T-SS011-001. Investigation revealed oil temp above 85°C. High Oil Temperature identified as primary issue. Performed clean radiators. Equipment returned to normal operation. Recommend follow-up inspection in 30 days to verify stability.',
                PARSE_JSON('["High Oil Temperature", "oil temp above 85\u00b0C", "radiator inefficiency"]'), 'HIGH',
                PARSE_JSON('["Clean radiators", "Check oil level", "Inspect cooling fans", "Increase monitoring frequency", "Schedule follow-up in 2 weeks", "Review similar assets"]')
            ),(
                'MAINT-T-SS089-001-20240910-038', 'T-SS089-001', 'INSPECTION_REPORT', 
                '2024-09-10'::DATE, 'Mike Chen', 'TECH1874',
                '@MAINTENANCE_DOCS_STAGE/MAINT-T-SS089-001-20240910-038.pdf', 3841, 'PDF',
                'EMERGENCY', 17.83, 43295.97,
                FALSE, 'Critical failure event on T-SS089-001. Operations detected high CO/CO2 ratio. Emergency shutdown initiated per safety protocol. Assessment revealed dissolved gas anomaly caused the outage. Backup power systems activated. Load reduction in progress. Coordinating with grid operations for load management. ETA to service restoration: 2-3 days.', 'Critical failure event on T-SS089-001. Operations detected high CO/CO2 ratio. Emergency shutdown initiated per safety protocol. Assessment revealed dissolved gas anomaly caused the outage. Backup power systems activated. Load reduction in progress. Coordinating with grid operations for load management. ETA to service restoration: 2-3 days.',
                PARSE_JSON('[]'), 'LOW',
                PARSE_JSON('["DGA analysis", "Load reduction", "Immediate inspection", "Continue standard monitoring", "No immediate action required"]')
            ),(
                'MAINT-T-SS025-001-20250429-039', 'T-SS025-001', 'INSPECTION_REPORT', 
                '2025-04-29'::DATE, 'Mike Chen', 'TECH3660',
                '@MAINTENANCE_DOCS_STAGE/MAINT-T-SS025-001-20250429-039.pdf', 3827, 'PDF',
                'PREVENTIVE', 2.52, 14400.96,
                FALSE, 'Performed routine quarterly inspection of transformer T-SS025-001. Visual inspection showed equipment in satisfactory condition. Oil sample collected for laboratory analysis. All cooling fans operational. Minor paint touch-up applied to tank exterior. No immediate concerns noted.', 'Performed routine quarterly inspection of transformer T-SS025-001. Visual inspection showed equipment in satisfactory condition. Oil sample collected for laboratory analysis. All cooling fans operational. Minor paint touch-up applied to tank exterior. No immediate concerns noted.',
                PARSE_JSON('[]'), 'LOW',
                PARSE_JSON('["Offline testing", "Bushing replacement", "Emergency repair", "Continue standard monitoring", "No immediate action required"]')
            ),(
                'MAINT-T-SS007-001-20240227-040', 'T-SS007-001', 'INSPECTION_REPORT', 
                '2024-02-27'::DATE, 'Chris Anderson', 'TECH4592',
                '@MAINTENANCE_DOCS_STAGE/MAINT-T-SS007-001-20240227-040.pdf', 3823, 'PDF',
                'PREVENTIVE', 2.5, 14529.4,
                FALSE, 'Performed routine quarterly inspection of transformer T-SS007-001. Visual inspection showed equipment in satisfactory condition. Oil sample collected for laboratory analysis. All cooling fans operational. Minor paint touch-up applied to tank exterior. No immediate concerns noted.', 'Performed routine quarterly inspection of transformer T-SS007-001. Visual inspection showed equipment in satisfactory condition. Oil sample collected for laboratory analysis. All cooling fans operational. Minor paint touch-up applied to tank exterior. No immediate concerns noted.',
                PARSE_JSON('[]'), 'LOW',
                PARSE_JSON('["Assess damage", "Dry out equipment", "Replace damaged parts", "Continue standard monitoring", "No immediate action required"]')
            );

-- Batch 5/34
INSERT INTO UTILITIES_GRID_RELIABILITY.UNSTRUCTURED.MAINTENANCE_LOG_DOCUMENTS 
(DOCUMENT_ID, ASSET_ID, DOCUMENT_TYPE, DOCUMENT_DATE, TECHNICIAN_NAME, TECHNICIAN_ID, 
 FILE_PATH, FILE_SIZE_BYTES, FILE_FORMAT, MAINTENANCE_TYPE, DURATION_HOURS, COST_USD, 
 FAILURE_OCCURRED, DOCUMENT_TEXT, SUMMARY, ROOT_CAUSE_KEYWORDS, SEVERITY_LEVEL, RECOMMENDED_ACTIONS)
SELECT (
                'MAINT-T-SS053-001-20240818-041', 'T-SS053-001', 'INSPECTION_REPORT', 
                '2024-08-18'::DATE, 'Emily Davis', 'TECH9971',
                '@MAINTENANCE_DOCS_STAGE/MAINT-T-SS053-001-20240818-041.pdf', 3981, 'PDF',
                'CORRECTIVE', 8.76, 26100.67,
                TRUE, 'Responded to abnormal readings from T-SS053-001. Investigation revealed turn-to-turn short. Winding Fault identified as primary issue. Performed transformer replacement. Equipment returned to normal operation. Recommend follow-up inspection in 30 days to verify stability.', 'Responded to abnormal readings from T-SS053-001. Investigation revealed turn-to-turn short. Winding Fault identified as primary issue. Performed transformer replacement. Equipment returned to normal operation. Recommend follow-up inspection in 30 days to verify stability.',
                PARSE_JSON('["Winding Fault", "turn-to-turn short", "ground fault"]'), 'CRITICAL',
                PARSE_JSON('["Transformer replacement", "Winding repair", "Outage required", "Immediate review by engineering team", "Daily monitoring until stable", "Prepare backup equipment"]')
            ),(
                'MAINT-T-SS096-001-20240606-042', 'T-SS096-001', 'INSPECTION_REPORT', 
                '2024-06-06'::DATE, 'Jennifer Garcia', 'TECH7994',
                '@MAINTENANCE_DOCS_STAGE/MAINT-T-SS096-001-20240606-042.pdf', 4010, 'PDF',
                'CORRECTIVE', 11.63, 44803.77,
                TRUE, 'Maintenance crew dispatched to T-SS096-001 for reported issue. Discovered elevated H2 levels during inspection. Dissolved Gas Anomaly confirmed through diagnostic testing. Completed dga analysis. Load tests performed successfully. Placed asset back online with continuous monitoring recommended.', 'Maintenance crew dispatched to T-SS096-001 for reported issue. Discovered elevated H2 levels during inspection. Dissolved Gas Anomaly confirmed through diagnostic testing. Completed dga analysis. Load tests performed successfully. Placed asset back online with continuous monitoring recommended.',
                PARSE_JSON('["Dissolved Gas Anomaly", "elevated H2 levels", "high CO/CO2 ratio"]'), 'HIGH',
                PARSE_JSON('["DGA analysis", "Load reduction", "Immediate inspection", "Increase monitoring frequency", "Schedule follow-up in 2 weeks", "Review similar assets"]')
            ),(
                'MAINT-T-SS033-001-20250215-043', 'T-SS033-001', 'INSPECTION_REPORT', 
                '2025-02-15'::DATE, 'Chris Anderson', 'TECH4858',
                '@MAINTENANCE_DOCS_STAGE/MAINT-T-SS033-001-20250215-043.pdf', 4002, 'PDF',
                'CORRECTIVE', 7.31, 43271.03,
                FALSE, 'Corrective action taken on T-SS033-001 following operations alert. Found evidence of radiator inefficiency. Root cause analysis indicates high oil temperature. Implemented check oil level as remedial measure. Post-repair testing satisfactory. System restored to service.', 'Corrective action taken on T-SS033-001 following operations alert. Found evidence of radiator inefficiency. Root cause analysis indicates high oil temperature. Implemented check oil level as remedial measure. Post-repair testing satisfactory. System restored to service.',
                PARSE_JSON('["High Oil Temperature", "oil temp above 85\u00b0C", "radiator inefficiency"]'), 'HIGH',
                PARSE_JSON('["Clean radiators", "Check oil level", "Inspect cooling fans", "Increase monitoring frequency", "Schedule follow-up in 2 weeks", "Review similar assets"]')
            ),(
                'MAINT-T-SS089-001-20241104-044', 'T-SS089-001', 'INSPECTION_REPORT', 
                '2024-11-04'::DATE, 'Jennifer Garcia', 'TECH3324',
                '@MAINTENANCE_DOCS_STAGE/MAINT-T-SS089-001-20241104-044.pdf', 3853, 'PDF',
                'PREVENTIVE', 5.86, 6525.78,
                FALSE, 'Conducted scheduled preventive maintenance on T-SS089-001. Checked all electrical connections, found all secure. Oil level and color satisfactory. Bushings clean with no signs of tracking. Radiators clean and unobstructed. Load tap changer tested - operating normally. Recommended continued monitoring.', 'Conducted scheduled preventive maintenance on T-SS089-001. Checked all electrical connections, found all secure. Oil level and color satisfactory. Bushings clean with no signs of tracking. Radiators clean and unobstructed. Load tap changer tested - operating normally. Recommended continued monitoring.',
                PARSE_JSON('[]'), 'LOW',
                PARSE_JSON('["Bushing replacement", "Emergency shutdown", "Load transfer", "Continue standard monitoring", "No immediate action required"]')
            ),(
                'MAINT-T-SS082-001-20250616-045', 'T-SS082-001', 'INSPECTION_REPORT', 
                '2025-06-16'::DATE, 'David Rodriguez', 'TECH8297',
                '@MAINTENANCE_DOCS_STAGE/MAINT-T-SS082-001-20250616-045.pdf', 3833, 'PDF',
                'PREVENTIVE', 2.41, 7623.83,
                FALSE, 'Annual maintenance completed on T-SS082-001. Replaced air filters on cooling system. Cleaned radiator fins. Torque-checked all bolted connections. Oil dielectric test passed. No abnormalities detected. Equipment performing to specification. Next scheduled maintenance in 12 months.', 'Annual maintenance completed on T-SS082-001. Replaced air filters on cooling system. Cleaned radiator fins. Torque-checked all bolted connections. Oil dielectric test passed. No abnormalities detected. Equipment performing to specification. Next scheduled maintenance in 12 months.',
                PARSE_JSON('[]'), 'LOW',
                PARSE_JSON('["Clean radiators", "Check oil level", "Inspect cooling fans", "Continue standard monitoring", "No immediate action required"]')
            ),(
                'MAINT-T-SS077-001-20240902-046', 'T-SS077-001', 'INSPECTION_REPORT', 
                '2024-09-02'::DATE, 'Sarah Johnson', 'TECH6277',
                '@MAINTENANCE_DOCS_STAGE/MAINT-T-SS077-001-20240902-046.pdf', 3839, 'PDF',
                'PREVENTIVE', 2.13, 11682.5,
                FALSE, 'Conducted scheduled preventive maintenance on T-SS077-001. Checked all electrical connections, found all secure. Oil level and color satisfactory. Bushings clean with no signs of tracking. Radiators clean and unobstructed. Load tap changer tested - operating normally. Recommended continued monitoring.', 'Conducted scheduled preventive maintenance on T-SS077-001. Checked all electrical connections, found all secure. Oil level and color satisfactory. Bushings clean with no signs of tracking. Radiators clean and unobstructed. Load tap changer tested - operating normally. Recommended continued monitoring.',
                PARSE_JSON('[]'), 'LOW',
                PARSE_JSON('["DGA analysis", "Load reduction", "Immediate inspection", "Continue standard monitoring", "No immediate action required"]')
            ),(
                'MAINT-T-SS095-001-20240612-047', 'T-SS095-001', 'INSPECTION_REPORT', 
                '2024-06-12'::DATE, 'Robert Wilson', 'TECH4188',
                '@MAINTENANCE_DOCS_STAGE/MAINT-T-SS095-001-20240612-047.pdf', 3833, 'PDF',
                'PREVENTIVE', 3.71, 10811.6,
                FALSE, 'Annual maintenance completed on T-SS095-001. Replaced air filters on cooling system. Cleaned radiator fins. Torque-checked all bolted connections. Oil dielectric test passed. No abnormalities detected. Equipment performing to specification. Next scheduled maintenance in 12 months.', 'Annual maintenance completed on T-SS095-001. Replaced air filters on cooling system. Cleaned radiator fins. Torque-checked all bolted connections. Oil dielectric test passed. No abnormalities detected. Equipment performing to specification. Next scheduled maintenance in 12 months.',
                PARSE_JSON('[]'), 'LOW',
                PARSE_JSON('["Sandblast and repaint", "Seal leaks", "Monitor corrosion rate", "Continue standard monitoring", "No immediate action required"]')
            ),(
                'MAINT-T-SS025-001-20250422-048', 'T-SS025-001', 'INSPECTION_REPORT', 
                '2025-04-22'::DATE, 'John Martinez', 'TECH8538',
                '@MAINTENANCE_DOCS_STAGE/MAINT-T-SS025-001-20250422-048.pdf', 3831, 'PDF',
                'PREVENTIVE', 2.28, 13475.57,
                FALSE, 'Annual maintenance completed on T-SS025-001. Replaced air filters on cooling system. Cleaned radiator fins. Torque-checked all bolted connections. Oil dielectric test passed. No abnormalities detected. Equipment performing to specification. Next scheduled maintenance in 12 months.', 'Annual maintenance completed on T-SS025-001. Replaced air filters on cooling system. Cleaned radiator fins. Torque-checked all bolted connections. Oil dielectric test passed. No abnormalities detected. Equipment performing to specification. Next scheduled maintenance in 12 months.',
                PARSE_JSON('[]'), 'LOW',
                PARSE_JSON('["Oil reclamation", "Replace bushings", "Transformer replacement", "Continue standard monitoring", "No immediate action required"]')
            ),(
                'MAINT-T-SS064-001-20250824-049', 'T-SS064-001', 'INSPECTION_REPORT', 
                '2025-08-24'::DATE, 'Robert Wilson', 'TECH8025',
                '@MAINTENANCE_DOCS_STAGE/MAINT-T-SS064-001-20250824-049.pdf', 3846, 'PDF',
                'PREVENTIVE', 5.12, 5367.84,
                FALSE, 'Conducted scheduled preventive maintenance on T-SS064-001. Checked all electrical connections, found all secure. Oil level and color satisfactory. Bushings clean with no signs of tracking. Radiators clean and unobstructed. Load tap changer tested - operating normally. Recommended continued monitoring.', 'Conducted scheduled preventive maintenance on T-SS064-001. Checked all electrical connections, found all secure. Oil level and color satisfactory. Bushings clean with no signs of tracking. Radiators clean and unobstructed. Load tap changer tested - operating normally. Recommended continued monitoring.',
                PARSE_JSON('[]'), 'LOW',
                PARSE_JSON('["Replace cooling system", "Reduce load", "Add ventilation", "Continue standard monitoring", "No immediate action required"]')
            ),(
                'MAINT-T-SS032-001-20240513-050', 'T-SS032-001', 'INSPECTION_REPORT', 
                '2024-05-13'::DATE, 'Robert Wilson', 'TECH8685',
                '@MAINTENANCE_DOCS_STAGE/MAINT-T-SS032-001-20240513-050.pdf', 3996, 'PDF',
                'CORRECTIVE', 4.92, 29887.71,
                FALSE, 'Corrective action taken on T-SS032-001 following operations alert. Found evidence of loose components. Root cause analysis indicates excessive vibration. Implemented replace bearings as remedial measure. Post-repair testing satisfactory. System restored to service.', 'Corrective action taken on T-SS032-001 following operations alert. Found evidence of loose components. Root cause analysis indicates excessive vibration. Implemented replace bearings as remedial measure. Post-repair testing satisfactory. System restored to service.',
                PARSE_JSON('["Excessive Vibration", "abnormal vibration levels", "loose components"]'), 'MEDIUM',
                PARSE_JSON('["Tighten connections", "Replace bearings", "Balance rotating parts", "Monitor trend over next 30 days", "Include in quarterly review", "Document for analysis"]')
            );

-- Batch 6/34
INSERT INTO UTILITIES_GRID_RELIABILITY.UNSTRUCTURED.MAINTENANCE_LOG_DOCUMENTS 
(DOCUMENT_ID, ASSET_ID, DOCUMENT_TYPE, DOCUMENT_DATE, TECHNICIAN_NAME, TECHNICIAN_ID, 
 FILE_PATH, FILE_SIZE_BYTES, FILE_FORMAT, MAINTENANCE_TYPE, DURATION_HOURS, COST_USD, 
 FAILURE_OCCURRED, DOCUMENT_TEXT, SUMMARY, ROOT_CAUSE_KEYWORDS, SEVERITY_LEVEL, RECOMMENDED_ACTIONS)
SELECT (
                'MAINT-T-SS079-001-20231217-051', 'T-SS079-001', 'INSPECTION_REPORT', 
                '2023-12-17'::DATE, 'Emily Davis', 'TECH1837',
                '@MAINTENANCE_DOCS_STAGE/MAINT-T-SS079-001-20231217-051.pdf', 3974, 'PDF',
                'CORRECTIVE', 10.68, 43475.57,
                FALSE, 'Responded to abnormal readings from T-SS079-001. Investigation revealed sustained high load. Overload Condition identified as primary issue. Performed load redistribution. Equipment returned to normal operation. Recommend follow-up inspection in 30 days to verify stability.', 'Responded to abnormal readings from T-SS079-001. Investigation revealed sustained high load. Overload Condition identified as primary issue. Performed load redistribution. Equipment returned to normal operation. Recommend follow-up inspection in 30 days to verify stability.',
                PARSE_JSON('["Overload Condition", "sustained high load", "exceeding nameplate rating"]'), 'HIGH',
                PARSE_JSON('["Load redistribution", "Capacity upgrade", "Parallel operation", "Increase monitoring frequency", "Schedule follow-up in 2 weeks", "Review similar assets"]')
            ),(
                'MAINT-T-SS017-001-20240315-052', 'T-SS017-001', 'INSPECTION_REPORT', 
                '2024-03-15'::DATE, 'David Rodriguez', 'TECH7861',
                '@MAINTENANCE_DOCS_STAGE/MAINT-T-SS017-001-20240315-052.pdf', 3826, 'PDF',
                'PREVENTIVE', 5.08, 8644.85,
                FALSE, 'Performed routine quarterly inspection of transformer T-SS017-001. Visual inspection showed equipment in satisfactory condition. Oil sample collected for laboratory analysis. All cooling fans operational. Minor paint touch-up applied to tank exterior. No immediate concerns noted.', 'Performed routine quarterly inspection of transformer T-SS017-001. Visual inspection showed equipment in satisfactory condition. Oil sample collected for laboratory analysis. All cooling fans operational. Minor paint touch-up applied to tank exterior. No immediate concerns noted.',
                PARSE_JSON('[]'), 'LOW',
                PARSE_JSON('["Load redistribution", "Capacity upgrade", "Parallel operation", "Continue standard monitoring", "No immediate action required"]')
            ),(
                'MAINT-T-SS073-001-20241025-053', 'T-SS073-001', 'INSPECTION_REPORT', 
                '2024-10-25'::DATE, 'Lisa Thompson', 'TECH1825',
                '@MAINTENANCE_DOCS_STAGE/MAINT-T-SS073-001-20241025-053.pdf', 3779, 'PDF',
                'INSPECTION', 2.46, 3705.62,
                FALSE, 'Infrared thermal scan completed on T-SS073-001. No hotspots detected. Temperature distribution uniform across all components. This inspection is part of our predictive maintenance program. Results support continued normal operation. Recommend next thermal survey in 6 months.', 'Infrared thermal scan completed on T-SS073-001. No hotspots detected. Temperature distribution uniform across all components. This inspection is part of our predictive maintenance program. Results support continued normal operation. Recommend next thermal survey in 6 months.',
                PARSE_JSON('[]'), 'LOW',
                PARSE_JSON('["Continue routine monitoring", "Continue standard monitoring", "No immediate action required"]')
            ),(
                'MAINT-T-SS034-001-20250206-054', 'T-SS034-001', 'INSPECTION_REPORT', 
                '2025-02-06'::DATE, 'Maria Lopez', 'TECH2912',
                '@MAINTENANCE_DOCS_STAGE/MAINT-T-SS034-001-20250206-054.pdf', 3828, 'PDF',
                'PREVENTIVE', 2.66, 12188.85,
                FALSE, 'Performed routine quarterly inspection of transformer T-SS034-001. Visual inspection showed equipment in satisfactory condition. Oil sample collected for laboratory analysis. All cooling fans operational. Minor paint touch-up applied to tank exterior. No immediate concerns noted.', 'Performed routine quarterly inspection of transformer T-SS034-001. Visual inspection showed equipment in satisfactory condition. Oil sample collected for laboratory analysis. All cooling fans operational. Minor paint touch-up applied to tank exterior. No immediate concerns noted.',
                PARSE_JSON('[]'), 'LOW',
                PARSE_JSON('["Load redistribution", "Capacity upgrade", "Parallel operation", "Continue standard monitoring", "No immediate action required"]')
            ),(
                'MAINT-T-SS045-001-20250519-055', 'T-SS045-001', 'INSPECTION_REPORT', 
                '2025-05-19'::DATE, 'David Rodriguez', 'TECH7207',
                '@MAINTENANCE_DOCS_STAGE/MAINT-T-SS045-001-20250519-055.pdf', 3805, 'PDF',
                'INSPECTION', 1.16, 2983.83,
                FALSE, 'Walk-through inspection performed on T-SS045-001. Checked for obvious signs of deterioration or damage. All observed parameters normal. Cooling system functioning properly. No unusual sounds or odors noted. Asset appears to be operating satisfactorily. Documentation updated in asset management system.', 'Walk-through inspection performed on T-SS045-001. Checked for obvious signs of deterioration or damage. All observed parameters normal. Cooling system functioning properly. No unusual sounds or odors noted. Asset appears to be operating satisfactorily. Documentation updated in asset management system.',
                PARSE_JSON('[]'), 'LOW',
                PARSE_JSON('["Continue routine monitoring", "Continue standard monitoring", "No immediate action required"]')
            ),(
                'MAINT-T-SS090-001-20250806-056', 'T-SS090-001', 'INSPECTION_REPORT', 
                '2025-08-06'::DATE, 'John Martinez', 'TECH7184',
                '@MAINTENANCE_DOCS_STAGE/MAINT-T-SS090-001-20250806-056.pdf', 3993, 'PDF',
                'CORRECTIVE', 5.99, 42740.81,
                FALSE, 'Corrective action taken on T-SS090-001 following operations alert. Found evidence of loose components. Root cause analysis indicates excessive vibration. Implemented replace bearings as remedial measure. Post-repair testing satisfactory. System restored to service.', 'Corrective action taken on T-SS090-001 following operations alert. Found evidence of loose components. Root cause analysis indicates excessive vibration. Implemented replace bearings as remedial measure. Post-repair testing satisfactory. System restored to service.',
                PARSE_JSON('["Excessive Vibration", "abnormal vibration levels", "loose components"]'), 'MEDIUM',
                PARSE_JSON('["Tighten connections", "Replace bearings", "Balance rotating parts", "Monitor trend over next 30 days", "Include in quarterly review", "Document for analysis"]')
            ),(
                'MAINT-T-SS015-001-20250204-057', 'T-SS015-001', 'INSPECTION_REPORT', 
                '2025-02-04'::DATE, 'Robert Wilson', 'TECH5656',
                '@MAINTENANCE_DOCS_STAGE/MAINT-T-SS015-001-20250204-057.pdf', 3829, 'PDF',
                'PREVENTIVE', 5.2, 11417.02,
                FALSE, 'Performed routine quarterly inspection of transformer T-SS015-001. Visual inspection showed equipment in satisfactory condition. Oil sample collected for laboratory analysis. All cooling fans operational. Minor paint touch-up applied to tank exterior. No immediate concerns noted.', 'Performed routine quarterly inspection of transformer T-SS015-001. Visual inspection showed equipment in satisfactory condition. Oil sample collected for laboratory analysis. All cooling fans operational. Minor paint touch-up applied to tank exterior. No immediate concerns noted.',
                PARSE_JSON('[]'), 'LOW',
                PARSE_JSON('["Clean radiators", "Check oil level", "Inspect cooling fans", "Continue standard monitoring", "No immediate action required"]')
            ),(
                'MAINT-T-SS076-001-20240627-058', 'T-SS076-001', 'INSPECTION_REPORT', 
                '2024-06-27'::DATE, 'Jennifer Garcia', 'TECH3013',
                '@MAINTENANCE_DOCS_STAGE/MAINT-T-SS076-001-20240627-058.pdf', 3944, 'PDF',
                'CORRECTIVE', 6.55, 23183.56,
                FALSE, 'Responded to abnormal readings from T-SS076-001. Investigation revealed high moisture content. Oil Contamination identified as primary issue. Performed oil filtering. Equipment returned to normal operation. Recommend follow-up inspection in 30 days to verify stability.', 'Responded to abnormal readings from T-SS076-001. Investigation revealed high moisture content. Oil Contamination identified as primary issue. Performed oil filtering. Equipment returned to normal operation. Recommend follow-up inspection in 30 days to verify stability.',
                PARSE_JSON('["Oil Contamination", "high moisture content", "acidic oil"]'), 'MEDIUM',
                PARSE_JSON('["Oil filtering", "Oil replacement", "Seal repair", "Monitor trend over next 30 days", "Include in quarterly review", "Document for analysis"]')
            ),(
                'MAINT-T-SS000-001-20251030-059', 'T-SS000-001', 'INSPECTION_REPORT', 
                '2025-10-30'::DATE, 'Mike Chen', 'TECH9753',
                '@MAINTENANCE_DOCS_STAGE/MAINT-T-SS000-001-20251030-059.pdf', 4018, 'PDF',
                'EMERGENCY', 6.61, 87433.48,
                TRUE, 'URGENT REPAIR: T-SS000-001 tripped offline unexpectedly. Field investigation found lightning strike. Weather Damage confirmed as failure mode. Significant damage observed. Assess damage underway. Parts ordered for expedited delivery. Customer impact: 12,500 accounts. Working around the clock to restore service.', 'URGENT REPAIR: T-SS000-001 tripped offline unexpectedly. Field investigation found lightning strike. Weather Damage confirmed as failure mode. Significant damage observed. Assess damage underway. Parts ordered for expedited delivery. Customer impact: 12,500 accounts. Working around the clock to restore service.',
                PARSE_JSON('["Weather Damage", "lightning strike", "flood damage"]'), 'MEDIUM',
                PARSE_JSON('["Assess damage", "Dry out equipment", "Replace damaged parts", "Monitor trend over next 30 days", "Include in quarterly review", "Document for analysis"]')
            ),(
                'MAINT-T-SS009-001-20231224-060', 'T-SS009-001', 'INSPECTION_REPORT', 
                '2023-12-24'::DATE, 'John Martinez', 'TECH5328',
                '@MAINTENANCE_DOCS_STAGE/MAINT-T-SS009-001-20231224-060.pdf', 4025, 'PDF',
                'EMERGENCY', 13.94, 35004.83,
                TRUE, 'URGENT REPAIR: T-SS009-001 tripped offline unexpectedly. Field investigation found elevated oil temperature. Overheating confirmed as failure mode. Significant damage observed. Replace cooling system underway. Parts ordered for expedited delivery. Customer impact: 12,000 accounts. Working around the clock to restore service.', 'URGENT REPAIR: T-SS009-001 tripped offline unexpectedly. Field investigation found elevated oil temperature. Overheating confirmed as failure mode. Significant damage observed. Replace cooling system underway. Parts ordered for expedited delivery. Customer impact: 12,000 accounts. Working around the clock to restore service.',
                PARSE_JSON('["Overheating", "elevated oil temperature", "thermal runaway"]'), 'HIGH',
                PARSE_JSON('["Replace cooling system", "Reduce load", "Add ventilation", "Increase monitoring frequency", "Schedule follow-up in 2 weeks", "Review similar assets"]')
            );

-- Batch 7/34
INSERT INTO UTILITIES_GRID_RELIABILITY.UNSTRUCTURED.MAINTENANCE_LOG_DOCUMENTS 
(DOCUMENT_ID, ASSET_ID, DOCUMENT_TYPE, DOCUMENT_DATE, TECHNICIAN_NAME, TECHNICIAN_ID, 
 FILE_PATH, FILE_SIZE_BYTES, FILE_FORMAT, MAINTENANCE_TYPE, DURATION_HOURS, COST_USD, 
 FAILURE_OCCURRED, DOCUMENT_TEXT, SUMMARY, ROOT_CAUSE_KEYWORDS, SEVERITY_LEVEL, RECOMMENDED_ACTIONS)
SELECT (
                'MAINT-T-SS086-001-20241206-061', 'T-SS086-001', 'INSPECTION_REPORT', 
                '2024-12-06'::DATE, 'Jennifer Garcia', 'TECH3603',
                '@MAINTENANCE_DOCS_STAGE/MAINT-T-SS086-001-20241206-061.pdf', 3978, 'PDF',
                'CORRECTIVE', 5.05, 31670.46,
                FALSE, 'Maintenance crew dispatched to T-SS086-001 for reported issue. Discovered cracked porcelain during inspection. Bushing Failure confirmed through diagnostic testing. Completed bushing replacement. Load tests performed successfully. Placed asset back online with continuous monitoring recommended.', 'Maintenance crew dispatched to T-SS086-001 for reported issue. Discovered cracked porcelain during inspection. Bushing Failure confirmed through diagnostic testing. Completed bushing replacement. Load tests performed successfully. Placed asset back online with continuous monitoring recommended.',
                PARSE_JSON('["Bushing Failure", "cracked porcelain", "oil leak at bushing"]'), 'HIGH',
                PARSE_JSON('["Bushing replacement", "Emergency shutdown", "Load transfer", "Increase monitoring frequency", "Schedule follow-up in 2 weeks", "Review similar assets"]')
            ),(
                'MAINT-T-SS014-001-20240116-062', 'T-SS014-001', 'INSPECTION_REPORT', 
                '2024-01-16'::DATE, 'Sarah Johnson', 'TECH8087',
                '@MAINTENANCE_DOCS_STAGE/MAINT-T-SS014-001-20240116-062.pdf', 3998, 'PDF',
                'EMERGENCY', 8.68, 99107.46,
                TRUE, 'EMERGENCY RESPONSE: T-SS014-001 experienced failure at 21:42. Overload Condition identified as cause. sustained high load was primary factor. Immediate isolation performed. Load transferred to backup transformer. Load redistribution required. Estimated repair time: 48-72 hours. 14,000 customers temporarily affected.', 'EMERGENCY RESPONSE: T-SS014-001 experienced failure at 21:42. Overload Condition identified as cause. sustained high load was primary factor. Immediate isolation performed. Load transferred to backup transformer. Load redistribution required. Estimated repair time: 48-72 hours. 14,000 customers temporarily affected.',
                PARSE_JSON('["Overload Condition", "sustained high load", "exceeding nameplate rating"]'), 'HIGH',
                PARSE_JSON('["Load redistribution", "Capacity upgrade", "Parallel operation", "Increase monitoring frequency", "Schedule follow-up in 2 weeks", "Review similar assets"]')
            ),(
                'MAINT-T-SS073-001-20251107-063', 'T-SS073-001', 'INSPECTION_REPORT', 
                '2025-11-07'::DATE, 'Sarah Johnson', 'TECH3138',
                '@MAINTENANCE_DOCS_STAGE/MAINT-T-SS073-001-20251107-063.pdf', 3817, 'PDF',
                'PREVENTIVE', 4.45, 7801.56,
                FALSE, 'Annual maintenance completed on T-SS073-001. Replaced air filters on cooling system. Cleaned radiator fins. Torque-checked all bolted connections. Oil dielectric test passed. No abnormalities detected. Equipment performing to specification. Next scheduled maintenance in 12 months.', 'Annual maintenance completed on T-SS073-001. Replaced air filters on cooling system. Cleaned radiator fins. Torque-checked all bolted connections. Oil dielectric test passed. No abnormalities detected. Equipment performing to specification. Next scheduled maintenance in 12 months.',
                PARSE_JSON('[]'), 'LOW',
                PARSE_JSON('["Replace cooling system", "Reduce load", "Add ventilation", "Continue standard monitoring", "No immediate action required"]')
            ),(
                'MAINT-T-SS025-001-20241015-064', 'T-SS025-001', 'INSPECTION_REPORT', 
                '2024-10-15'::DATE, 'Emily Davis', 'TECH1095',
                '@MAINTENANCE_DOCS_STAGE/MAINT-T-SS025-001-20241015-064.pdf', 3792, 'PDF',
                'INSPECTION', 1.8, 4828.49,
                FALSE, 'Walk-through inspection performed on T-SS025-001. Checked for obvious signs of deterioration or damage. All observed parameters normal. Cooling system functioning properly. No unusual sounds or odors noted. Asset appears to be operating satisfactorily. Documentation updated in asset management system.', 'Walk-through inspection performed on T-SS025-001. Checked for obvious signs of deterioration or damage. All observed parameters normal. Cooling system functioning properly. No unusual sounds or odors noted. Asset appears to be operating satisfactorily. Documentation updated in asset management system.',
                PARSE_JSON('[]'), 'LOW',
                PARSE_JSON('["Continue routine monitoring", "Continue standard monitoring", "No immediate action required"]')
            ),(
                'MAINT-T-SS078-001-20250725-065', 'T-SS078-001', 'INSPECTION_REPORT', 
                '2025-07-25'::DATE, 'Emily Davis', 'TECH2099',
                '@MAINTENANCE_DOCS_STAGE/MAINT-T-SS078-001-20250725-065.pdf', 4011, 'PDF',
                'EMERGENCY', 14.39, 35237.27,
                TRUE, 'URGENT REPAIR: T-SS078-001 tripped offline unexpectedly. Field investigation found elevated H2 levels. Dissolved Gas Anomaly confirmed as failure mode. Significant damage observed. DGA analysis underway. Parts ordered for expedited delivery. Customer impact: 10,500 accounts. Working around the clock to restore service.', 'URGENT REPAIR: T-SS078-001 tripped offline unexpectedly. Field investigation found elevated H2 levels. Dissolved Gas Anomaly confirmed as failure mode. Significant damage observed. DGA analysis underway. Parts ordered for expedited delivery. Customer impact: 10,500 accounts. Working around the clock to restore service.',
                PARSE_JSON('["Dissolved Gas Anomaly", "elevated H2 levels", "high CO/CO2 ratio"]'), 'HIGH',
                PARSE_JSON('["DGA analysis", "Load reduction", "Immediate inspection", "Increase monitoring frequency", "Schedule follow-up in 2 weeks", "Review similar assets"]')
            ),(
                'MAINT-T-SS024-001-20251107-066', 'T-SS024-001', 'INSPECTION_REPORT', 
                '2025-11-07'::DATE, 'Chris Anderson', 'TECH7584',
                '@MAINTENANCE_DOCS_STAGE/MAINT-T-SS024-001-20251107-066.pdf', 3819, 'PDF',
                'PREVENTIVE', 4.33, 8728.34,
                FALSE, 'Annual maintenance completed on T-SS024-001. Replaced air filters on cooling system. Cleaned radiator fins. Torque-checked all bolted connections. Oil dielectric test passed. No abnormalities detected. Equipment performing to specification. Next scheduled maintenance in 12 months.', 'Annual maintenance completed on T-SS024-001. Replaced air filters on cooling system. Cleaned radiator fins. Torque-checked all bolted connections. Oil dielectric test passed. No abnormalities detected. Equipment performing to specification. Next scheduled maintenance in 12 months.',
                PARSE_JSON('[]'), 'LOW',
                PARSE_JSON('["Clean radiators", "Check oil level", "Inspect cooling fans", "Continue standard monitoring", "No immediate action required"]')
            ),(
                'MAINT-T-SS033-001-20240729-067', 'T-SS033-001', 'INSPECTION_REPORT', 
                '2024-07-29'::DATE, 'Lisa Thompson', 'TECH4444',
                '@MAINTENANCE_DOCS_STAGE/MAINT-T-SS033-001-20240729-067.pdf', 3834, 'PDF',
                'PREVENTIVE', 4.59, 8580.89,
                FALSE, 'Annual maintenance completed on T-SS033-001. Replaced air filters on cooling system. Cleaned radiator fins. Torque-checked all bolted connections. Oil dielectric test passed. No abnormalities detected. Equipment performing to specification. Next scheduled maintenance in 12 months.', 'Annual maintenance completed on T-SS033-001. Replaced air filters on cooling system. Cleaned radiator fins. Torque-checked all bolted connections. Oil dielectric test passed. No abnormalities detected. Equipment performing to specification. Next scheduled maintenance in 12 months.',
                PARSE_JSON('[]'), 'LOW',
                PARSE_JSON('["Assess damage", "Dry out equipment", "Replace damaged parts", "Continue standard monitoring", "No immediate action required"]')
            ),(
                'MAINT-T-SS018-001-20240713-068', 'T-SS018-001', 'INSPECTION_REPORT', 
                '2024-07-13'::DATE, 'Maria Lopez', 'TECH2319',
                '@MAINTENANCE_DOCS_STAGE/MAINT-T-SS018-001-20240713-068.pdf', 3850, 'PDF',
                'PREVENTIVE', 5.15, 12617.7,
                FALSE, 'Conducted scheduled preventive maintenance on T-SS018-001. Checked all electrical connections, found all secure. Oil level and color satisfactory. Bushings clean with no signs of tracking. Radiators clean and unobstructed. Load tap changer tested - operating normally. Recommended continued monitoring.', 'Conducted scheduled preventive maintenance on T-SS018-001. Checked all electrical connections, found all secure. Oil level and color satisfactory. Bushings clean with no signs of tracking. Radiators clean and unobstructed. Load tap changer tested - operating normally. Recommended continued monitoring.',
                PARSE_JSON('[]'), 'LOW',
                PARSE_JSON('["Tighten connections", "Replace bearings", "Balance rotating parts", "Continue standard monitoring", "No immediate action required"]')
            ),(
                'MAINT-T-SS038-001-20240528-069', 'T-SS038-001', 'INSPECTION_REPORT', 
                '2024-05-28'::DATE, 'Mike Chen', 'TECH2701',
                '@MAINTENANCE_DOCS_STAGE/MAINT-T-SS038-001-20240528-069.pdf', 3990, 'PDF',
                'EMERGENCY', 18.39, 92991.02,
                TRUE, 'Critical failure event on T-SS038-001. Operations detected ground fault. Emergency shutdown initiated per safety protocol. Assessment revealed winding fault caused the outage. Backup power systems activated. Winding repair in progress. Coordinating with grid operations for load management. ETA to service restoration: 2-3 days.', 'Critical failure event on T-SS038-001. Operations detected ground fault. Emergency shutdown initiated per safety protocol. Assessment revealed winding fault caused the outage. Backup power systems activated. Winding repair in progress. Coordinating with grid operations for load management. ETA to service restoration: 2-3 days.',
                PARSE_JSON('["Winding Fault", "turn-to-turn short", "ground fault"]'), 'CRITICAL',
                PARSE_JSON('["Transformer replacement", "Winding repair", "Outage required", "Immediate review by engineering team", "Daily monitoring until stable", "Prepare backup equipment"]')
            ),(
                'MAINT-T-SS088-001-20250527-070', 'T-SS088-001', 'INSPECTION_REPORT', 
                '2025-05-27'::DATE, 'David Rodriguez', 'TECH7970',
                '@MAINTENANCE_DOCS_STAGE/MAINT-T-SS088-001-20250527-070.pdf', 4001, 'PDF',
                'EMERGENCY', 15.39, 60646.52,
                TRUE, 'EMERGENCY RESPONSE: T-SS088-001 experienced failure at 21:42. Overload Condition identified as cause. sustained high load was primary factor. Immediate isolation performed. Load transferred to backup transformer. Load redistribution required. Estimated repair time: 48-72 hours. 10,500 customers temporarily affected.', 'EMERGENCY RESPONSE: T-SS088-001 experienced failure at 21:42. Overload Condition identified as cause. sustained high load was primary factor. Immediate isolation performed. Load transferred to backup transformer. Load redistribution required. Estimated repair time: 48-72 hours. 10,500 customers temporarily affected.',
                PARSE_JSON('["Overload Condition", "sustained high load", "exceeding nameplate rating"]'), 'HIGH',
                PARSE_JSON('["Load redistribution", "Capacity upgrade", "Parallel operation", "Increase monitoring frequency", "Schedule follow-up in 2 weeks", "Review similar assets"]')
            );

-- Batch 8/34
INSERT INTO UTILITIES_GRID_RELIABILITY.UNSTRUCTURED.MAINTENANCE_LOG_DOCUMENTS 
(DOCUMENT_ID, ASSET_ID, DOCUMENT_TYPE, DOCUMENT_DATE, TECHNICIAN_NAME, TECHNICIAN_ID, 
 FILE_PATH, FILE_SIZE_BYTES, FILE_FORMAT, MAINTENANCE_TYPE, DURATION_HOURS, COST_USD, 
 FAILURE_OCCURRED, DOCUMENT_TEXT, SUMMARY, ROOT_CAUSE_KEYWORDS, SEVERITY_LEVEL, RECOMMENDED_ACTIONS)
SELECT (
                'MAINT-T-SS038-001-20250821-071', 'T-SS038-001', 'INSPECTION_REPORT', 
                '2025-08-21'::DATE, 'Jennifer Garcia', 'TECH8570',
                '@MAINTENANCE_DOCS_STAGE/MAINT-T-SS038-001-20250821-071.pdf', 3847, 'PDF',
                'PREVENTIVE', 2.9, 9261.9,
                FALSE, 'Conducted scheduled preventive maintenance on T-SS038-001. Checked all electrical connections, found all secure. Oil level and color satisfactory. Bushings clean with no signs of tracking. Radiators clean and unobstructed. Load tap changer tested - operating normally. Recommended continued monitoring.', 'Conducted scheduled preventive maintenance on T-SS038-001. Checked all electrical connections, found all secure. Oil level and color satisfactory. Bushings clean with no signs of tracking. Radiators clean and unobstructed. Load tap changer tested - operating normally. Recommended continued monitoring.',
                PARSE_JSON('[]'), 'LOW',
                PARSE_JSON('["Offline testing", "Bushing replacement", "Emergency repair", "Continue standard monitoring", "No immediate action required"]')
            ),(
                'MAINT-T-SS007-001-20240630-072', 'T-SS007-001', 'INSPECTION_REPORT', 
                '2024-06-30'::DATE, 'David Rodriguez', 'TECH9038',
                '@MAINTENANCE_DOCS_STAGE/MAINT-T-SS007-001-20240630-072.pdf', 4004, 'PDF',
                'CORRECTIVE', 6.54, 22376.88,
                FALSE, 'Maintenance crew dispatched to T-SS007-001 for reported issue. Discovered turn-to-turn short during inspection. Winding Fault confirmed through diagnostic testing. Completed transformer replacement. Load tests performed successfully. Placed asset back online with continuous monitoring recommended.', 'Maintenance crew dispatched to T-SS007-001 for reported issue. Discovered turn-to-turn short during inspection. Winding Fault confirmed through diagnostic testing. Completed transformer replacement. Load tests performed successfully. Placed asset back online with continuous monitoring recommended.',
                PARSE_JSON('["Winding Fault", "turn-to-turn short", "ground fault"]'), 'CRITICAL',
                PARSE_JSON('["Transformer replacement", "Winding repair", "Outage required", "Immediate review by engineering team", "Daily monitoring until stable", "Prepare backup equipment"]')
            ),(
                'MAINT-T-SS032-001-20250925-073', 'T-SS032-001', 'INSPECTION_REPORT', 
                '2025-09-25'::DATE, 'Sarah Johnson', 'TECH7171',
                '@MAINTENANCE_DOCS_STAGE/MAINT-T-SS032-001-20250925-073.pdf', 4019, 'PDF',
                'EMERGENCY', 7.01, 101661.91,
                TRUE, 'URGENT REPAIR: T-SS032-001 tripped offline unexpectedly. Field investigation found rust on tank surface. Tank Corrosion confirmed as failure mode. Significant damage observed. Sandblast and repaint underway. Parts ordered for expedited delivery. Customer impact: 13,000 accounts. Working around the clock to restore service.', 'URGENT REPAIR: T-SS032-001 tripped offline unexpectedly. Field investigation found rust on tank surface. Tank Corrosion confirmed as failure mode. Significant damage observed. Sandblast and repaint underway. Parts ordered for expedited delivery. Customer impact: 13,000 accounts. Working around the clock to restore service.',
                PARSE_JSON('["Tank Corrosion", "rust on tank surface", "paint deterioration"]'), 'MEDIUM',
                PARSE_JSON('["Sandblast and repaint", "Seal leaks", "Monitor corrosion rate", "Monitor trend over next 30 days", "Include in quarterly review", "Document for analysis"]')
            ),(
                'MAINT-T-SS012-001-20250904-074', 'T-SS012-001', 'INSPECTION_REPORT', 
                '2025-09-04'::DATE, 'Lisa Thompson', 'TECH8318',
                '@MAINTENANCE_DOCS_STAGE/MAINT-T-SS012-001-20250904-074.pdf', 4028, 'PDF',
                'EMERGENCY', 8.15, 95091.67,
                TRUE, 'URGENT REPAIR: T-SS012-001 tripped offline unexpectedly. Field investigation found high moisture content. Oil Contamination confirmed as failure mode. Significant damage observed. Oil filtering underway. Parts ordered for expedited delivery. Customer impact: 13,000 accounts. Working around the clock to restore service.', 'URGENT REPAIR: T-SS012-001 tripped offline unexpectedly. Field investigation found high moisture content. Oil Contamination confirmed as failure mode. Significant damage observed. Oil filtering underway. Parts ordered for expedited delivery. Customer impact: 13,000 accounts. Working around the clock to restore service.',
                PARSE_JSON('["Oil Contamination", "high moisture content", "acidic oil"]'), 'MEDIUM',
                PARSE_JSON('["Oil filtering", "Oil replacement", "Seal repair", "Monitor trend over next 30 days", "Include in quarterly review", "Document for analysis"]')
            ),(
                'MAINT-T-SS096-001-20240918-075', 'T-SS096-001', 'INSPECTION_REPORT', 
                '2024-09-18'::DATE, 'John Martinez', 'TECH3231',
                '@MAINTENANCE_DOCS_STAGE/MAINT-T-SS096-001-20240918-075.pdf', 3966, 'PDF',
                'CORRECTIVE', 8.4, 17471.74,
                FALSE, 'Maintenance crew dispatched to T-SS096-001 for reported issue. Discovered lightning strike during inspection. Weather Damage confirmed through diagnostic testing. Completed assess damage. Load tests performed successfully. Placed asset back online with continuous monitoring recommended.', 'Maintenance crew dispatched to T-SS096-001 for reported issue. Discovered lightning strike during inspection. Weather Damage confirmed through diagnostic testing. Completed assess damage. Load tests performed successfully. Placed asset back online with continuous monitoring recommended.',
                PARSE_JSON('["Weather Damage", "lightning strike", "flood damage"]'), 'MEDIUM',
                PARSE_JSON('["Assess damage", "Dry out equipment", "Replace damaged parts", "Monitor trend over next 30 days", "Include in quarterly review", "Document for analysis"]')
            );

-- Batch 9/34
INSERT INTO UTILITIES_GRID_RELIABILITY.UNSTRUCTURED.TECHNICAL_MANUALS 
(MANUAL_ID, MANUAL_TYPE, EQUIPMENT_TYPE, MANUFACTURER, MODEL, VERSION, PUBLICATION_DATE, 
 FILE_PATH, FILE_SIZE_BYTES, PAGE_COUNT)
SELECT 
 'MAN-ABB-TXP25MVA-001', 'OPERATION_MANUAL', 'Power Transformer',
 'ABB', 'TXP-25MVA', '1.0',
 '2024-01-15'::DATE, '@TECHNICAL_MANUALS_STAGE/MAN-ABB-TXP25MVA-001.pdf',
 10465, 15 UNION ALL SELECT 
 'MAN-ABB-TXP35MVA-001', 'MAINTENANCE_GUIDE', 'Power Transformer',
 'ABB', 'TXP-35MVA', '1.0',
 '2024-01-15'::DATE, '@TECHNICAL_MANUALS_STAGE/MAN-ABB-TXP35MVA-001.pdf',
 12832, 15 UNION ALL SELECT 
 'MAN-ABB-DIAG-001', 'TROUBLESHOOTING', 'Power Transformer',
 'ABB', 'All Models', '1.0',
 '2024-01-15'::DATE, '@TECHNICAL_MANUALS_STAGE/MAN-ABB-DIAG-001.pdf',
 11005, 8 UNION ALL SELECT 
 'MAN-GE-PTG30MVA-001', 'OPERATION_MANUAL', 'Power Transformer',
 'GE', 'PTG-30MVA', '1.0',
 '2024-01-15'::DATE, '@TECHNICAL_MANUALS_STAGE/MAN-GE-PTG30MVA-001.pdf',
 10459, 15 UNION ALL SELECT 
 'MAN-GE-PTG30MVA-002', 'MAINTENANCE_GUIDE', 'Power Transformer',
 'GE', 'PTG-30MVA', '1.0',
 '2024-01-15'::DATE, '@TECHNICAL_MANUALS_STAGE/MAN-GE-PTG30MVA-002.pdf',
 12822, 15 UNION ALL SELECT 
 'MAN-GE-TROUBLESHOOT-001', 'TROUBLESHOOTING', 'Power Transformer',
 'GE', 'All Models', '1.0',
 '2024-01-15'::DATE, '@TECHNICAL_MANUALS_STAGE/MAN-GE-TROUBLESHOOT-001.pdf',
 11014, 8 UNION ALL SELECT 
 'MAN-SIEMENS-H25-001', 'OPERATION_MANUAL', 'Power Transformer',
 'Siemens', 'H-Class-25MVA', '1.0',
 '2024-01-15'::DATE, '@TECHNICAL_MANUALS_STAGE/MAN-SIEMENS-H25-001.pdf',
 10470, 15 UNION ALL SELECT 
 'MAN-SIEMENS-H35-001', 'SPECIFICATIONS', 'Power Transformer',
 'Siemens', 'H-Class-35MVA', '1.0',
 '2024-01-15'::DATE, '@TECHNICAL_MANUALS_STAGE/MAN-SIEMENS-H35-001.pdf',
 11500, 8 UNION ALL SELECT 
 'MAN-SIEMENS-MAINT-001', 'MAINTENANCE_GUIDE', 'Power Transformer',
 'Siemens', 'H-Class Series', '1.0',
 '2024-01-15'::DATE, '@TECHNICAL_MANUALS_STAGE/MAN-SIEMENS-MAINT-001.pdf',
 12853, 15 UNION ALL SELECT 
 'MAN-WESTING-WPT25-001', 'OPERATION_MANUAL', 'Power Transformer',
 'Westinghouse', 'WPT-25MVA', '1.0',
 '2024-01-15'::DATE, '@TECHNICAL_MANUALS_STAGE/MAN-WESTING-WPT25-001.pdf',
 10497, 15 UNION ALL SELECT 
 'MAN-WESTING-WPT35-001', 'MAINTENANCE_GUIDE', 'Power Transformer',
 'Westinghouse', 'WPT-35MVA', '1.0',
 '2024-01-15'::DATE, '@TECHNICAL_MANUALS_STAGE/MAN-WESTING-WPT35-001.pdf',
 12873, 15 UNION ALL SELECT 
 'MAN-WESTING-SPEC-001', 'SPECIFICATIONS', 'Power Transformer',
 'Westinghouse', 'WPT Series', '1.0',
 '2024-01-15'::DATE, '@TECHNICAL_MANUALS_STAGE/MAN-WESTING-SPEC-001.pdf',
 11518, 8;

-- Batch 10/34
INSERT INTO UTILITIES_GRID_RELIABILITY.UNSTRUCTURED.VISUAL_INSPECTIONS 
(INSPECTION_ID, ASSET_ID, INSPECTION_DATE, INSPECTOR_NAME, INSPECTOR_ID, INSPECTION_METHOD, 
 WEATHER_CONDITIONS, FILE_PATH, FILE_TYPE, FILE_SIZE_BYTES, RESOLUTION, GPS_LATITUDE, GPS_LONGITUDE, 
 CV_PROCESSED, CV_PROCESSING_TIMESTAMP)
SELECT 
 'VIS-T-SS099-001-20251005-001', 'T-SS099-001', '2025-10-05'::DATE,
 'Sarah Kim', 'INSP1002', 'VIDEO',
 'Light rain', '@VISUAL_INSPECTION_STAGE/T-SS099-001/202510/VIS-T-SS099-001-20251005-001.mp4', 'MP4',
 382730240, '1920x1080', 27.335405970494943, -82.53037247011063,
 TRUE, '2025-10-06 10:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS085-001-20250130-002', 'T-SS085-001', '2025-01-30'::DATE,
 'Carlos Martinez', 'INSP1001', 'THERMAL',
 'Overcast', '@VISUAL_INSPECTION_STAGE/T-SS085-001/202501/VIS-T-SS085-001-20250130-002.tiff', 'TIFF',
 336592896, '640x480', 30.331954068677437, -81.65622277227162,
 FALSE, '2025-02-01 03:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS072-001-20251002-003', 'T-SS072-001', '2025-10-02'::DATE,
 'Carlos Martinez', 'INSP1001', 'THERMAL',
 'Clear, sunny', '@VISUAL_INSPECTION_STAGE/T-SS072-001/202510/VIS-T-SS072-001-20251002-003.tiff', 'TIFF',
 413138944, '640x480', 27.950675610366385, -82.45670921609957,
 TRUE, '2025-10-04 21:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS022-001-20250114-004', 'T-SS022-001', '2025-01-14'::DATE,
 'Sarah Kim', 'INSP1002', 'VIDEO',
 'Post-storm', '@VISUAL_INSPECTION_STAGE/T-SS022-001/202501/VIS-T-SS022-001-20250114-004.mp4', 'MP4',
 212860928, '1920x1080', 27.949708711276138, -82.45788731617321,
 FALSE, '2025-01-15 18:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS048-001-20250411-005', 'T-SS048-001', '2025-04-11'::DATE,
 'Robert Johnson', 'INSP1003', 'VIDEO',
 'Partly cloudy', '@VISUAL_INSPECTION_STAGE/T-SS048-001/202504/VIS-T-SS048-001-20250411-005.mp4', 'MP4',
 359661568, '1920x1080', 26.63961229184374, -81.87172068821552,
 FALSE, '2025-04-12 11:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS009-001-20251022-006', 'T-SS009-001', '2025-10-22'::DATE,
 'Jennifer Lee', 'INSP1004', 'VIDEO',
 'Light rain', '@VISUAL_INSPECTION_STAGE/T-SS009-001/202510/VIS-T-SS009-001-20251022-006.mp4', 'MP4',
 165675008, '1920x1080', 27.33670016446032, -82.52981246488307,
 TRUE, '2025-10-24 21:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS011-001-20250829-007', 'T-SS011-001', '2025-08-29'::DATE,
 'Michael Chen', 'INSP1005', 'DRONE',
 'Clear, sunny', '@VISUAL_INSPECTION_STAGE/T-SS011-001/202508/VIS-T-SS011-001-20250829-007.mp4', 'MP4',
 274726912, '4K', 25.76246041924303, -80.19085317974641,
 TRUE, '2025-08-31 21:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS095-001-20250630-008', 'T-SS095-001', '2025-06-30'::DATE,
 'Sarah Kim', 'INSP1002', 'DRONE',
 'Post-storm', '@VISUAL_INSPECTION_STAGE/T-SS095-001/202506/VIS-T-SS095-001-20250630-008.mp4', 'MP4',
 403701760, '4K', 30.331571522564058, -81.65593631182121,
 TRUE, '2025-07-01 06:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS055-001-20241229-009', 'T-SS055-001', '2024-12-29'::DATE,
 'Robert Johnson', 'INSP1003', 'HANDHELD_CAMERA',
 'Post-storm', '@VISUAL_INSPECTION_STAGE/T-SS055-001/202412/VIS-T-SS055-001-20241229-009.jpg', 'JPG',
 122683392, '1920x1080', 30.332769029444787, -81.6552349866131,
 TRUE, '2024-12-30 04:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS040-001-20250906-010', 'T-SS040-001', '2025-09-06'::DATE,
 'Robert Johnson', 'INSP1003', 'HANDHELD_CAMERA',
 'Light rain', '@VISUAL_INSPECTION_STAGE/T-SS040-001/202509/VIS-T-SS040-001-20250906-010.jpg', 'JPG',
 249561088, '1920x1080', 26.715554076223302, -80.05386678689621,
 TRUE, '2025-09-08 02:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS088-001-20250526-011', 'T-SS088-001', '2025-05-26'::DATE,
 'Michael Chen', 'INSP1005', 'LIDAR',
 'Post-storm', '@VISUAL_INSPECTION_STAGE/T-SS088-001/202505/VIS-T-SS088-001-20250526-011.las', 'LAS',
 465567744, 'N/A', 26.641170497960925, -81.87237306046337,
 TRUE, '2025-05-27 23:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS054-001-20251114-012', 'T-SS054-001', '2025-11-14'::DATE,
 'Robert Johnson', 'INSP1003', 'HANDHELD_CAMERA',
 'Foggy', '@VISUAL_INSPECTION_STAGE/T-SS054-001/202511/VIS-T-SS054-001-20251114-012.jpg', 'JPG',
 483393536, '1920x1080', 28.537726614215874, -81.37985754123139,
 TRUE, '2025-11-16 01:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS070-001-20241223-013', 'T-SS070-001', '2024-12-23'::DATE,
 'Sarah Kim', 'INSP1002', 'THERMAL',
 'Light rain', '@VISUAL_INSPECTION_STAGE/T-SS070-001/202412/VIS-T-SS070-001-20241223-013.tiff', 'TIFF',
 505413632, '640x480', 26.71628740225475, -80.0537771786005,
 TRUE, '2024-12-24 09:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS008-001-20251003-014', 'T-SS008-001', '2025-10-03'::DATE,
 'Robert Johnson', 'INSP1003', 'VIDEO',
 'Overcast', '@VISUAL_INSPECTION_STAGE/T-SS008-001/202510/VIS-T-SS008-001-20251003-014.mp4', 'MP4',
 503316480, '1920x1080', 26.6399058549034, -81.87250360686676,
 TRUE, '2025-10-05 04:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS035-001-20241211-015', 'T-SS035-001', '2024-12-11'::DATE,
 'Sarah Kim', 'INSP1002', 'THERMAL',
 'Foggy', '@VISUAL_INSPECTION_STAGE/T-SS035-001/202412/VIS-T-SS035-001-20241211-015.tiff', 'TIFF',
 197132288, '640x480', 30.331280778270944, -81.65585461168956,
 TRUE, '2024-12-13 04:47:34'::TIMESTAMP_NTZ;

-- Batch 11/34
INSERT INTO UTILITIES_GRID_RELIABILITY.UNSTRUCTURED.VISUAL_INSPECTIONS 
(INSPECTION_ID, ASSET_ID, INSPECTION_DATE, INSPECTOR_NAME, INSPECTOR_ID, INSPECTION_METHOD, 
 WEATHER_CONDITIONS, FILE_PATH, FILE_TYPE, FILE_SIZE_BYTES, RESOLUTION, GPS_LATITUDE, GPS_LONGITUDE, 
 CV_PROCESSED, CV_PROCESSING_TIMESTAMP)
SELECT 
 'VIS-T-SS009-001-20250410-016', 'T-SS009-001', '2025-04-10'::DATE,
 'Michael Chen', 'INSP1005', 'THERMAL',
 'Partly cloudy', '@VISUAL_INSPECTION_STAGE/T-SS009-001/202504/VIS-T-SS009-001-20250410-016.tiff', 'TIFF',
 239075328, '640x480', 27.33674805841171, -82.53130402698818,
 TRUE, '2025-04-11 10:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS007-001-20241123-017', 'T-SS007-001', '2024-11-23'::DATE,
 'Michael Chen', 'INSP1005', 'VIDEO',
 'Light rain', '@VISUAL_INSPECTION_STAGE/T-SS007-001/202411/VIS-T-SS007-001-20241123-017.mp4', 'MP4',
 324009984, '1920x1080', 26.142161429702053, -81.7947963041275,
 TRUE, '2024-11-24 21:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS057-001-20250802-018', 'T-SS057-001', '2025-08-02'::DATE,
 'Robert Johnson', 'INSP1003', 'DRONE',
 'Clear, sunny', '@VISUAL_INSPECTION_STAGE/T-SS057-001/202508/VIS-T-SS057-001-20250802-018.mp4', 'MP4',
 334495744, '4K', 26.142184443395628, -81.79493728958829,
 TRUE, '2025-08-04 11:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS026-001-20251109-019', 'T-SS026-001', '2025-11-09'::DATE,
 'Sarah Kim', 'INSP1002', 'THERMAL',
 'Partly cloudy', '@VISUAL_INSPECTION_STAGE/T-SS026-001/202511/VIS-T-SS026-001-20251109-019.tiff', 'TIFF',
 84934656, '640x480', 30.4374636442826, -84.28147290966699,
 FALSE, '2025-11-10 07:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS002-001-20250409-020', 'T-SS002-001', '2025-04-09'::DATE,
 'Carlos Martinez', 'INSP1001', 'VIDEO',
 'Post-storm', '@VISUAL_INSPECTION_STAGE/T-SS002-001/202504/VIS-T-SS002-001-20250409-020.mp4', 'MP4',
 139460608, '1920x1080', 27.94982469930098, -82.45728113031021,
 TRUE, '2025-04-10 12:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS077-001-20251106-021', 'T-SS077-001', '2025-11-06'::DATE,
 'Michael Chen', 'INSP1005', 'HANDHELD_CAMERA',
 'Partly cloudy', '@VISUAL_INSPECTION_STAGE/T-SS077-001/202511/VIS-T-SS077-001-20251106-021.jpg', 'JPG',
 276824064, '1920x1080', 26.141198642143404, -81.79422731236964,
 TRUE, '2025-11-08 14:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS091-001-20250120-022', 'T-SS091-001', '2025-01-20'::DATE,
 'Jennifer Lee', 'INSP1004', 'THERMAL',
 'Clear, sunny', '@VISUAL_INSPECTION_STAGE/T-SS091-001/202501/VIS-T-SS091-001-20250120-022.tiff', 'TIFF',
 224395264, '640x480', 25.76091374129135, -80.19087239021967,
 TRUE, '2025-01-22 03:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS019-001-20250815-023', 'T-SS019-001', '2025-08-15'::DATE,
 'Robert Johnson', 'INSP1003', 'VIDEO',
 'Post-storm', '@VISUAL_INSPECTION_STAGE/T-SS019-001/202508/VIS-T-SS019-001-20250815-023.mp4', 'MP4',
 355467264, '1920x1080', 27.336470202460767, -82.53100353078965,
 TRUE, '2025-08-16 14:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS089-001-20250518-024', 'T-SS089-001', '2025-05-18'::DATE,
 'Robert Johnson', 'INSP1003', 'DRONE',
 'Partly cloudy', '@VISUAL_INSPECTION_STAGE/T-SS089-001/202505/VIS-T-SS089-001-20250518-024.mp4', 'MP4',
 522190848, '4K', 27.335731064555386, -82.52988094573098,
 TRUE, '2025-05-19 16:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS016-001-20250409-025', 'T-SS016-001', '2025-04-09'::DATE,
 'Sarah Kim', 'INSP1002', 'DRONE',
 'Post-storm', '@VISUAL_INSPECTION_STAGE/T-SS016-001/202504/VIS-T-SS016-001-20250409-025.mp4', 'MP4',
 471859200, '4K', 30.438904375794053, -84.28114030866844,
 TRUE, '2025-04-10 12:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS075-001-20250427-026', 'T-SS075-001', '2025-04-27'::DATE,
 'Jennifer Lee', 'INSP1004', 'LIDAR',
 'Post-storm', '@VISUAL_INSPECTION_STAGE/T-SS075-001/202504/VIS-T-SS075-001-20250427-026.las', 'LAS',
 425721856, 'N/A', 30.331284659079422, -81.65553380687075,
 TRUE, '2025-04-29 01:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS014-001-20250516-027', 'T-SS014-001', '2025-05-16'::DATE,
 'Robert Johnson', 'INSP1003', 'DRONE',
 'Overcast', '@VISUAL_INSPECTION_STAGE/T-SS014-001/202505/VIS-T-SS014-001-20250516-027.mp4', 'MP4',
 46137344, '4K', 28.538302166064195, -81.3799766872144,
 TRUE, '2025-05-17 14:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS024-001-20250908-028', 'T-SS024-001', '2025-09-08'::DATE,
 'Michael Chen', 'INSP1005', 'DRONE',
 'Partly cloudy', '@VISUAL_INSPECTION_STAGE/T-SS024-001/202509/VIS-T-SS024-001-20250908-028.mp4', 'MP4',
 515899392, '4K', 28.53919584705618, -81.37932248580614,
 TRUE, '2025-09-10 09:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS004-001-20250114-029', 'T-SS004-001', '2025-01-14'::DATE,
 'Michael Chen', 'INSP1005', 'THERMAL',
 'Post-storm', '@VISUAL_INSPECTION_STAGE/T-SS004-001/202501/VIS-T-SS004-001-20250114-029.tiff', 'TIFF',
 413138944, '640x480', 28.53797855106661, -81.37885874441973,
 TRUE, '2025-01-16 09:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS035-001-20251102-030', 'T-SS035-001', '2025-11-02'::DATE,
 'Sarah Kim', 'INSP1002', 'HANDHELD_CAMERA',
 'Clear, sunny', '@VISUAL_INSPECTION_STAGE/T-SS035-001/202511/VIS-T-SS035-001-20251102-030.jpg', 'JPG',
 475004928, '1920x1080', 30.33302759116724, -81.65664363085457,
 FALSE, '2025-11-03 22:47:34'::TIMESTAMP_NTZ;

-- Batch 12/34
INSERT INTO UTILITIES_GRID_RELIABILITY.UNSTRUCTURED.VISUAL_INSPECTIONS 
(INSPECTION_ID, ASSET_ID, INSPECTION_DATE, INSPECTOR_NAME, INSPECTOR_ID, INSPECTION_METHOD, 
 WEATHER_CONDITIONS, FILE_PATH, FILE_TYPE, FILE_SIZE_BYTES, RESOLUTION, GPS_LATITUDE, GPS_LONGITUDE, 
 CV_PROCESSED, CV_PROCESSING_TIMESTAMP)
SELECT 
 'VIS-T-SS003-001-20250719-031', 'T-SS003-001', '2025-07-19'::DATE,
 'Carlos Martinez', 'INSP1001', 'DRONE',
 'Post-storm', '@VISUAL_INSPECTION_STAGE/T-SS003-001/202507/VIS-T-SS003-001-20250719-031.mp4', 'MP4',
 298844160, '4K', 26.121815459700027, -80.13717579875885,
 TRUE, '2025-07-20 04:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS058-001-20250331-032', 'T-SS058-001', '2025-03-31'::DATE,
 'Michael Chen', 'INSP1005', 'HANDHELD_CAMERA',
 'Foggy', '@VISUAL_INSPECTION_STAGE/T-SS058-001/202503/VIS-T-SS058-001-20250331-032.jpg', 'JPG',
 463470592, '1920x1080', 26.63987500961525, -81.87203646510682,
 TRUE, '2025-04-02 02:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS009-001-20241230-033', 'T-SS009-001', '2024-12-30'::DATE,
 'Jennifer Lee', 'INSP1004', 'DRONE',
 'Partly cloudy', '@VISUAL_INSPECTION_STAGE/T-SS009-001/202412/VIS-T-SS009-001-20241230-033.mp4', 'MP4',
 158334976, '4K', 27.33711738345477, -82.52998755592222,
 TRUE, '2025-01-01 01:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS082-001-20250406-034', 'T-SS082-001', '2025-04-06'::DATE,
 'Sarah Kim', 'INSP1002', 'HANDHELD_CAMERA',
 'Light rain', '@VISUAL_INSPECTION_STAGE/T-SS082-001/202504/VIS-T-SS082-001-20250406-034.jpg', 'JPG',
 217055232, '1920x1080', 27.951213480311978, -82.45816894880197,
 TRUE, '2025-04-08 15:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS088-001-20250722-035', 'T-SS088-001', '2025-07-22'::DATE,
 'Sarah Kim', 'INSP1002', 'HANDHELD_CAMERA',
 'Light rain', '@VISUAL_INSPECTION_STAGE/T-SS088-001/202507/VIS-T-SS088-001-20250722-035.jpg', 'JPG',
 389021696, '1920x1080', 26.641558936762674, -81.87192760474001,
 FALSE, '2025-07-24 14:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS060-001-20250427-036', 'T-SS060-001', '2025-04-27'::DATE,
 'Robert Johnson', 'INSP1003', 'HANDHELD_CAMERA',
 'Overcast', '@VISUAL_INSPECTION_STAGE/T-SS060-001/202504/VIS-T-SS060-001-20250427-036.jpg', 'JPG',
 143654912, '1920x1080', 26.71458587537401, -80.05425393650242,
 TRUE, '2025-04-29 11:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS013-001-20250825-037', 'T-SS013-001', '2025-08-25'::DATE,
 'Michael Chen', 'INSP1005', 'THERMAL',
 'Overcast', '@VISUAL_INSPECTION_STAGE/T-SS013-001/202508/VIS-T-SS013-001-20250825-037.tiff', 'TIFF',
 68157440, '640x480', 26.121415479865068, -80.13697295787716,
 TRUE, '2025-08-25 22:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS068-001-20250216-038', 'T-SS068-001', '2025-02-16'::DATE,
 'Sarah Kim', 'INSP1002', 'VIDEO',
 'Post-storm', '@VISUAL_INSPECTION_STAGE/T-SS068-001/202502/VIS-T-SS068-001-20250216-038.mp4', 'MP4',
 449839104, '1920x1080', 26.640843416789178, -81.87187896770484,
 TRUE, '2025-02-18 17:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS064-001-20250902-039', 'T-SS064-001', '2025-09-02'::DATE,
 'Michael Chen', 'INSP1005', 'THERMAL',
 'Foggy', '@VISUAL_INSPECTION_STAGE/T-SS064-001/202509/VIS-T-SS064-001-20250902-039.tiff', 'TIFF',
 135266304, '640x480', 28.53888055423699, -81.37990108447603,
 TRUE, '2025-09-04 07:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS078-001-20250501-040', 'T-SS078-001', '2025-05-01'::DATE,
 'Michael Chen', 'INSP1005', 'LIDAR',
 'Clear, sunny', '@VISUAL_INSPECTION_STAGE/T-SS078-001/202505/VIS-T-SS078-001-20250501-040.las', 'LAS',
 390070272, 'N/A', 26.64051717267643, -81.87139975339278,
 TRUE, '2025-05-02 07:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS004-001-20250623-041', 'T-SS004-001', '2025-06-23'::DATE,
 'Sarah Kim', 'INSP1002', 'THERMAL',
 'Post-storm', '@VISUAL_INSPECTION_STAGE/T-SS004-001/202506/VIS-T-SS004-001-20250623-041.tiff', 'TIFF',
 403701760, '640x480', 28.538360085792764, -81.37982512848063,
 FALSE, '2025-06-24 13:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS001-001-20251105-042', 'T-SS001-001', '2025-11-05'::DATE,
 'Robert Johnson', 'INSP1003', 'DRONE',
 'Overcast', '@VISUAL_INSPECTION_STAGE/T-SS001-001/202511/VIS-T-SS001-001-20251105-042.mp4', 'MP4',
 418381824, '4K', 25.762428429730512, -80.19270468565865,
 TRUE, '2025-11-07 10:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS006-001-20241125-043', 'T-SS006-001', '2024-11-25'::DATE,
 'Carlos Martinez', 'INSP1001', 'HANDHELD_CAMERA',
 'Overcast', '@VISUAL_INSPECTION_STAGE/T-SS006-001/202411/VIS-T-SS006-001-20241125-043.jpg', 'JPG',
 432013312, '1920x1080', 30.437362015746363, -84.28146724463146,
 TRUE, '2024-11-26 05:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS040-001-20251023-044', 'T-SS040-001', '2025-10-23'::DATE,
 'Michael Chen', 'INSP1005', 'VIDEO',
 'Foggy', '@VISUAL_INSPECTION_STAGE/T-SS040-001/202510/VIS-T-SS040-001-20251023-044.mp4', 'MP4',
 209715200, '1920x1080', 26.715153017062285, -80.05370456415947,
 TRUE, '2025-10-25 20:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS057-001-20250629-045', 'T-SS057-001', '2025-06-29'::DATE,
 'Carlos Martinez', 'INSP1001', 'HANDHELD_CAMERA',
 'Overcast', '@VISUAL_INSPECTION_STAGE/T-SS057-001/202506/VIS-T-SS057-001-20250629-045.jpg', 'JPG',
 124780544, '1920x1080', 26.142501391991864, -81.79443211466084,
 TRUE, '2025-07-01 01:47:34'::TIMESTAMP_NTZ;

-- Batch 13/34
INSERT INTO UTILITIES_GRID_RELIABILITY.UNSTRUCTURED.VISUAL_INSPECTIONS 
(INSPECTION_ID, ASSET_ID, INSPECTION_DATE, INSPECTOR_NAME, INSPECTOR_ID, INSPECTION_METHOD, 
 WEATHER_CONDITIONS, FILE_PATH, FILE_TYPE, FILE_SIZE_BYTES, RESOLUTION, GPS_LATITUDE, GPS_LONGITUDE, 
 CV_PROCESSED, CV_PROCESSING_TIMESTAMP)
SELECT 
 'VIS-T-SS031-001-20250411-046', 'T-SS031-001', '2025-04-11'::DATE,
 'Jennifer Lee', 'INSP1004', 'LIDAR',
 'Foggy', '@VISUAL_INSPECTION_STAGE/T-SS031-001/202504/VIS-T-SS031-001-20250411-046.las', 'LAS',
 311427072, 'N/A', 25.76104634566418, -80.1921614452256,
 TRUE, '2025-04-12 09:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS032-001-20250403-047', 'T-SS032-001', '2025-04-03'::DATE,
 'Robert Johnson', 'INSP1003', 'VIDEO',
 'Overcast', '@VISUAL_INSPECTION_STAGE/T-SS032-001/202504/VIS-T-SS032-001-20250403-047.mp4', 'MP4',
 421527552, '1920x1080', 27.95046544768977, -82.4570590421982,
 TRUE, '2025-04-05 16:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS091-001-20250920-048', 'T-SS091-001', '2025-09-20'::DATE,
 'Carlos Martinez', 'INSP1001', 'VIDEO',
 'Overcast', '@VISUAL_INSPECTION_STAGE/T-SS091-001/202509/VIS-T-SS091-001-20250920-048.mp4', 'MP4',
 396361728, '1920x1080', 25.76168611044898, -80.19083015135703,
 TRUE, '2025-09-20 23:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS054-001-20251107-049', 'T-SS054-001', '2025-11-07'::DATE,
 'Robert Johnson', 'INSP1003', 'THERMAL',
 'Overcast', '@VISUAL_INSPECTION_STAGE/T-SS054-001/202511/VIS-T-SS054-001-20251107-049.tiff', 'TIFF',
 430964736, '640x480', 28.53885162120065, -81.37958068776707,
 FALSE, '2025-11-08 00:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS088-001-20251011-050', 'T-SS088-001', '2025-10-11'::DATE,
 'Robert Johnson', 'INSP1003', 'LIDAR',
 'Overcast', '@VISUAL_INSPECTION_STAGE/T-SS088-001/202510/VIS-T-SS088-001-20251011-050.las', 'LAS',
 50331648, 'N/A', 26.64019246279771, -81.87138535738256,
 FALSE, '2025-10-12 14:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS002-001-20250120-051', 'T-SS002-001', '2025-01-20'::DATE,
 'Robert Johnson', 'INSP1003', 'DRONE',
 'Post-storm', '@VISUAL_INSPECTION_STAGE/T-SS002-001/202501/VIS-T-SS002-001-20250120-051.mp4', 'MP4',
 308281344, '4K', 27.951516070627967, -82.456449647084,
 TRUE, '2025-01-21 20:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS075-001-20250806-052', 'T-SS075-001', '2025-08-06'::DATE,
 'Robert Johnson', 'INSP1003', 'HANDHELD_CAMERA',
 'Light rain', '@VISUAL_INSPECTION_STAGE/T-SS075-001/202508/VIS-T-SS075-001-20250806-052.jpg', 'JPG',
 317718528, '1920x1080', 30.33272966474142, -81.6552432465306,
 FALSE, '2025-08-07 04:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS059-001-20250719-053', 'T-SS059-001', '2025-07-19'::DATE,
 'Jennifer Lee', 'INSP1004', 'LIDAR',
 'Light rain', '@VISUAL_INSPECTION_STAGE/T-SS059-001/202507/VIS-T-SS059-001-20250719-053.las', 'LAS',
 12582912, 'N/A', 27.3367989864932, -82.53105169186661,
 FALSE, '2025-07-20 01:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS046-001-20250227-054', 'T-SS046-001', '2025-02-27'::DATE,
 'Michael Chen', 'INSP1005', 'DRONE',
 'Overcast', '@VISUAL_INSPECTION_STAGE/T-SS046-001/202502/VIS-T-SS046-001-20250227-054.mp4', 'MP4',
 424673280, '4K', 30.43838424457731, -84.28133348471536,
 FALSE, '2025-02-28 03:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS023-001-20250922-055', 'T-SS023-001', '2025-09-22'::DATE,
 'Jennifer Lee', 'INSP1004', 'DRONE',
 'Post-storm', '@VISUAL_INSPECTION_STAGE/T-SS023-001/202509/VIS-T-SS023-001-20250922-055.mp4', 'MP4',
 333447168, '4K', 26.12205076634986, -80.13773863078835,
 FALSE, '2025-09-23 13:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS067-001-20241227-056', 'T-SS067-001', '2024-12-27'::DATE,
 'Carlos Martinez', 'INSP1001', 'THERMAL',
 'Post-storm', '@VISUAL_INSPECTION_STAGE/T-SS067-001/202412/VIS-T-SS067-001-20241227-056.tiff', 'TIFF',
 330301440, '640x480', 26.142297788737665, -81.79408383393763,
 TRUE, '2024-12-29 13:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS003-001-20250822-057', 'T-SS003-001', '2025-08-22'::DATE,
 'Jennifer Lee', 'INSP1004', 'THERMAL',
 'Foggy', '@VISUAL_INSPECTION_STAGE/T-SS003-001/202508/VIS-T-SS003-001-20250822-057.tiff', 'TIFF',
 177209344, '640x480', 26.121820050578748, -80.13684761496349,
 TRUE, '2025-08-24 20:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS074-001-20251026-058', 'T-SS074-001', '2025-10-26'::DATE,
 'Sarah Kim', 'INSP1002', 'LIDAR',
 'Foggy', '@VISUAL_INSPECTION_STAGE/T-SS074-001/202510/VIS-T-SS074-001-20251026-058.las', 'LAS',
 272629760, 'N/A', 28.538454915850394, -81.38009222057381,
 TRUE, '2025-10-27 17:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS031-001-20250121-059', 'T-SS031-001', '2025-01-21'::DATE,
 'Carlos Martinez', 'INSP1001', 'LIDAR',
 'Overcast', '@VISUAL_INSPECTION_STAGE/T-SS031-001/202501/VIS-T-SS031-001-20250121-059.las', 'LAS',
 250609664, 'N/A', 25.762542628080368, -80.19253814152273,
 TRUE, '2025-01-22 12:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS039-001-20251001-060', 'T-SS039-001', '2025-10-01'::DATE,
 'Michael Chen', 'INSP1005', 'VIDEO',
 'Light rain', '@VISUAL_INSPECTION_STAGE/T-SS039-001/202510/VIS-T-SS039-001-20251001-060.mp4', 'MP4',
 356515840, '1920x1080', 27.336295550374565, -82.53153752335852,
 TRUE, '2025-10-03 00:47:34'::TIMESTAMP_NTZ;

-- Batch 14/34
INSERT INTO UTILITIES_GRID_RELIABILITY.UNSTRUCTURED.VISUAL_INSPECTIONS 
(INSPECTION_ID, ASSET_ID, INSPECTION_DATE, INSPECTOR_NAME, INSPECTOR_ID, INSPECTION_METHOD, 
 WEATHER_CONDITIONS, FILE_PATH, FILE_TYPE, FILE_SIZE_BYTES, RESOLUTION, GPS_LATITUDE, GPS_LONGITUDE, 
 CV_PROCESSED, CV_PROCESSING_TIMESTAMP)
SELECT 
 'VIS-T-SS078-001-20250711-061', 'T-SS078-001', '2025-07-11'::DATE,
 'Carlos Martinez', 'INSP1001', 'VIDEO',
 'Partly cloudy', '@VISUAL_INSPECTION_STAGE/T-SS078-001/202507/VIS-T-SS078-001-20250711-061.mp4', 'MP4',
 205520896, '1920x1080', 26.641377566686547, -81.87328563455576,
 TRUE, '2025-07-13 13:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS072-001-20251101-062', 'T-SS072-001', '2025-11-01'::DATE,
 'Sarah Kim', 'INSP1002', 'HANDHELD_CAMERA',
 'Partly cloudy', '@VISUAL_INSPECTION_STAGE/T-SS072-001/202511/VIS-T-SS072-001-20251101-062.jpg', 'JPG',
 114294784, '1920x1080', 27.950049786655057, -82.4576413694894,
 TRUE, '2025-11-02 05:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS064-001-20250216-063', 'T-SS064-001', '2025-02-16'::DATE,
 'Jennifer Lee', 'INSP1004', 'THERMAL',
 'Partly cloudy', '@VISUAL_INSPECTION_STAGE/T-SS064-001/202502/VIS-T-SS064-001-20250216-063.tiff', 'TIFF',
 348127232, '640x480', 28.53859531925727, -81.37869482825718,
 TRUE, '2025-02-16 22:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS006-001-20250102-064', 'T-SS006-001', '2025-01-02'::DATE,
 'Sarah Kim', 'INSP1002', 'DRONE',
 'Foggy', '@VISUAL_INSPECTION_STAGE/T-SS006-001/202501/VIS-T-SS006-001-20250102-064.mp4', 'MP4',
 192937984, '4K', 30.437649095929086, -84.28052770919926,
 TRUE, '2025-01-04 13:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS022-001-20250903-065', 'T-SS022-001', '2025-09-03'::DATE,
 'Jennifer Lee', 'INSP1004', 'HANDHELD_CAMERA',
 'Clear, sunny', '@VISUAL_INSPECTION_STAGE/T-SS022-001/202509/VIS-T-SS022-001-20250903-065.jpg', 'JPG',
 189792256, '1920x1080', 27.950043345341875, -82.45646035284649,
 FALSE, '2025-09-03 22:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS037-001-20250902-066', 'T-SS037-001', '2025-09-02'::DATE,
 'Robert Johnson', 'INSP1003', 'HANDHELD_CAMERA',
 'Clear, sunny', '@VISUAL_INSPECTION_STAGE/T-SS037-001/202509/VIS-T-SS037-001-20250902-066.jpg', 'JPG',
 485490688, '1920x1080', 26.14156181625874, -81.79430841042642,
 TRUE, '2025-09-04 07:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS043-001-20241207-067', 'T-SS043-001', '2024-12-07'::DATE,
 'Robert Johnson', 'INSP1003', 'DRONE',
 'Partly cloudy', '@VISUAL_INSPECTION_STAGE/T-SS043-001/202412/VIS-T-SS043-001-20241207-067.mp4', 'MP4',
 422576128, '4K', 26.121616309447393, -80.13744924488103,
 TRUE, '2024-12-08 19:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS055-001-20251024-068', 'T-SS055-001', '2025-10-24'::DATE,
 'Jennifer Lee', 'INSP1004', 'HANDHELD_CAMERA',
 'Clear, sunny', '@VISUAL_INSPECTION_STAGE/T-SS055-001/202510/VIS-T-SS055-001-20251024-068.jpg', 'JPG',
 63963136, '1920x1080', 30.332374569670055, -81.65631600457255,
 TRUE, '2025-10-26 07:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS019-001-20250414-069', 'T-SS019-001', '2025-04-14'::DATE,
 'Robert Johnson', 'INSP1003', 'VIDEO',
 'Foggy', '@VISUAL_INSPECTION_STAGE/T-SS019-001/202504/VIS-T-SS019-001-20250414-069.mp4', 'MP4',
 312475648, '1920x1080', 27.33723742898977, -82.53001682252929,
 TRUE, '2025-04-15 22:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS033-001-20251106-070', 'T-SS033-001', '2025-11-06'::DATE,
 'Michael Chen', 'INSP1005', 'HANDHELD_CAMERA',
 'Light rain', '@VISUAL_INSPECTION_STAGE/T-SS033-001/202511/VIS-T-SS033-001-20251106-070.jpg', 'JPG',
 80740352, '1920x1080', 26.122473749408364, -80.13661235689156,
 TRUE, '2025-11-07 23:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS094-001-20241211-071', 'T-SS094-001', '2024-12-11'::DATE,
 'Michael Chen', 'INSP1005', 'HANDHELD_CAMERA',
 'Light rain', '@VISUAL_INSPECTION_STAGE/T-SS094-001/202412/VIS-T-SS094-001-20241211-071.jpg', 'JPG',
 443547648, '1920x1080', 28.537715266946343, -81.37861399441498,
 TRUE, '2024-12-12 08:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS015-001-20250209-072', 'T-SS015-001', '2025-02-09'::DATE,
 'Carlos Martinez', 'INSP1001', 'DRONE',
 'Light rain', '@VISUAL_INSPECTION_STAGE/T-SS015-001/202502/VIS-T-SS015-001-20250209-072.mp4', 'MP4',
 57671680, '4K', 30.332383322594527, -81.65660750269589,
 TRUE, '2025-02-10 20:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS039-001-20250224-073', 'T-SS039-001', '2025-02-24'::DATE,
 'Robert Johnson', 'INSP1003', 'THERMAL',
 'Foggy', '@VISUAL_INSPECTION_STAGE/T-SS039-001/202502/VIS-T-SS039-001-20250224-073.tiff', 'TIFF',
 389021696, '640x480', 27.335873751724662, -82.53132660662173,
 TRUE, '2025-02-26 01:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS022-001-20241214-074', 'T-SS022-001', '2024-12-14'::DATE,
 'Carlos Martinez', 'INSP1001', 'LIDAR',
 'Foggy', '@VISUAL_INSPECTION_STAGE/T-SS022-001/202412/VIS-T-SS022-001-20241214-074.las', 'LAS',
 66060288, 'N/A', 27.95135345737384, -82.45772354372713,
 TRUE, '2024-12-16 19:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS044-001-20250301-075', 'T-SS044-001', '2025-03-01'::DATE,
 'Robert Johnson', 'INSP1003', 'HANDHELD_CAMERA',
 'Post-storm', '@VISUAL_INSPECTION_STAGE/T-SS044-001/202503/VIS-T-SS044-001-20250301-075.jpg', 'JPG',
 284164096, '1920x1080', 28.539122445670785, -81.37869214059455,
 TRUE, '2025-03-03 21:47:34'::TIMESTAMP_NTZ;

-- Batch 15/34
INSERT INTO UTILITIES_GRID_RELIABILITY.UNSTRUCTURED.VISUAL_INSPECTIONS 
(INSPECTION_ID, ASSET_ID, INSPECTION_DATE, INSPECTOR_NAME, INSPECTOR_ID, INSPECTION_METHOD, 
 WEATHER_CONDITIONS, FILE_PATH, FILE_TYPE, FILE_SIZE_BYTES, RESOLUTION, GPS_LATITUDE, GPS_LONGITUDE, 
 CV_PROCESSED, CV_PROCESSING_TIMESTAMP)
SELECT 
 'VIS-T-SS079-001-20250524-076', 'T-SS079-001', '2025-05-24'::DATE,
 'Jennifer Lee', 'INSP1004', 'DRONE',
 'Post-storm', '@VISUAL_INSPECTION_STAGE/T-SS079-001/202505/VIS-T-SS079-001-20250524-076.mp4', 'MP4',
 173015040, '4K', 27.33670031267416, -82.53057849371682,
 TRUE, '2025-05-26 16:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS073-001-20251106-077', 'T-SS073-001', '2025-11-06'::DATE,
 'Sarah Kim', 'INSP1002', 'VIDEO',
 'Partly cloudy', '@VISUAL_INSPECTION_STAGE/T-SS073-001/202511/VIS-T-SS073-001-20251106-077.mp4', 'MP4',
 256901120, '1920x1080', 26.122640001844047, -80.13697575765526,
 TRUE, '2025-11-08 18:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS028-001-20250915-078', 'T-SS028-001', '2025-09-15'::DATE,
 'Carlos Martinez', 'INSP1001', 'HANDHELD_CAMERA',
 'Light rain', '@VISUAL_INSPECTION_STAGE/T-SS028-001/202509/VIS-T-SS028-001-20250915-078.jpg', 'JPG',
 413138944, '1920x1080', 26.639715333333996, -81.87160118340987,
 FALSE, '2025-09-17 11:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS072-001-20241202-079', 'T-SS072-001', '2024-12-02'::DATE,
 'Robert Johnson', 'INSP1003', 'DRONE',
 'Light rain', '@VISUAL_INSPECTION_STAGE/T-SS072-001/202412/VIS-T-SS072-001-20241202-079.mp4', 'MP4',
 14680064, '4K', 27.950890832581287, -82.45787038271052,
 TRUE, '2024-12-04 14:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS056-001-20241122-080', 'T-SS056-001', '2024-11-22'::DATE,
 'Carlos Martinez', 'INSP1001', 'VIDEO',
 'Clear, sunny', '@VISUAL_INSPECTION_STAGE/T-SS056-001/202411/VIS-T-SS056-001-20241122-080.mp4', 'MP4',
 523239424, '1920x1080', 30.43853435006214, -84.28113164256588,
 FALSE, '2024-11-24 18:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS009-001-20250620-081', 'T-SS009-001', '2025-06-20'::DATE,
 'Sarah Kim', 'INSP1002', 'DRONE',
 'Post-storm', '@VISUAL_INSPECTION_STAGE/T-SS009-001/202506/VIS-T-SS009-001-20250620-081.mp4', 'MP4',
 262144000, '4K', 27.335935514279246, -82.53123303950869,
 FALSE, '2025-06-22 02:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS027-001-20250930-082', 'T-SS027-001', '2025-09-30'::DATE,
 'Sarah Kim', 'INSP1002', 'LIDAR',
 'Light rain', '@VISUAL_INSPECTION_STAGE/T-SS027-001/202509/VIS-T-SS027-001-20250930-082.las', 'LAS',
 53477376, 'N/A', 26.14281340424523, -81.794148871628,
 TRUE, '2025-10-01 23:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS076-001-20250712-083', 'T-SS076-001', '2025-07-12'::DATE,
 'Robert Johnson', 'INSP1003', 'VIDEO',
 'Light rain', '@VISUAL_INSPECTION_STAGE/T-SS076-001/202507/VIS-T-SS076-001-20250712-083.mp4', 'MP4',
 158334976, '1920x1080', 30.43780340843481, -84.28003746686328,
 TRUE, '2025-07-13 15:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS034-001-20250822-084', 'T-SS034-001', '2025-08-22'::DATE,
 'Carlos Martinez', 'INSP1001', 'VIDEO',
 'Foggy', '@VISUAL_INSPECTION_STAGE/T-SS034-001/202508/VIS-T-SS034-001-20250822-084.mp4', 'MP4',
 484442112, '1920x1080', 28.53811368569401, -81.37865227127676,
 FALSE, '2025-08-24 20:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS096-001-20250512-085', 'T-SS096-001', '2025-05-12'::DATE,
 'Carlos Martinez', 'INSP1001', 'THERMAL',
 'Overcast', '@VISUAL_INSPECTION_STAGE/T-SS096-001/202505/VIS-T-SS096-001-20250512-085.tiff', 'TIFF',
 137363456, '640x480', 30.437413975763892, -84.28141594455533,
 TRUE, '2025-05-13 09:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS022-001-20250406-086', 'T-SS022-001', '2025-04-06'::DATE,
 'Robert Johnson', 'INSP1003', 'HANDHELD_CAMERA',
 'Overcast', '@VISUAL_INSPECTION_STAGE/T-SS022-001/202504/VIS-T-SS022-001-20250406-086.jpg', 'JPG',
 30408704, '1920x1080', 27.950513388669815, -82.456265449009,
 TRUE, '2025-04-07 07:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS017-001-20250815-087', 'T-SS017-001', '2025-08-15'::DATE,
 'Robert Johnson', 'INSP1003', 'HANDHELD_CAMERA',
 'Foggy', '@VISUAL_INSPECTION_STAGE/T-SS017-001/202508/VIS-T-SS017-001-20250815-087.jpg', 'JPG',
 213909504, '1920x1080', 26.142275959288728, -81.79565266206386,
 TRUE, '2025-08-16 10:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS081-001-20250512-088', 'T-SS081-001', '2025-05-12'::DATE,
 'Sarah Kim', 'INSP1002', 'HANDHELD_CAMERA',
 'Post-storm', '@VISUAL_INSPECTION_STAGE/T-SS081-001/202505/VIS-T-SS081-001-20250512-088.jpg', 'JPG',
 248512512, '1920x1080', 25.76092321217183, -80.19218809554295,
 TRUE, '2025-05-13 09:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS009-001-20251110-089', 'T-SS009-001', '2025-11-10'::DATE,
 'Carlos Martinez', 'INSP1001', 'LIDAR',
 'Overcast', '@VISUAL_INSPECTION_STAGE/T-SS009-001/202511/VIS-T-SS009-001-20251110-089.las', 'LAS',
 436207616, 'N/A', 27.33666940648953, -82.52996125169348,
 TRUE, '2025-11-11 19:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS079-001-20250922-090', 'T-SS079-001', '2025-09-22'::DATE,
 'Carlos Martinez', 'INSP1001', 'HANDHELD_CAMERA',
 'Light rain', '@VISUAL_INSPECTION_STAGE/T-SS079-001/202509/VIS-T-SS079-001-20250922-090.jpg', 'JPG',
 289406976, '1920x1080', 27.336436536524594, -82.52986445137215,
 TRUE, '2025-09-24 09:47:34'::TIMESTAMP_NTZ;

-- Batch 16/34
INSERT INTO UTILITIES_GRID_RELIABILITY.UNSTRUCTURED.VISUAL_INSPECTIONS 
(INSPECTION_ID, ASSET_ID, INSPECTION_DATE, INSPECTOR_NAME, INSPECTOR_ID, INSPECTION_METHOD, 
 WEATHER_CONDITIONS, FILE_PATH, FILE_TYPE, FILE_SIZE_BYTES, RESOLUTION, GPS_LATITUDE, GPS_LONGITUDE, 
 CV_PROCESSED, CV_PROCESSING_TIMESTAMP)
SELECT 
 'VIS-T-SS054-001-20250925-091', 'T-SS054-001', '2025-09-25'::DATE,
 'Carlos Martinez', 'INSP1001', 'DRONE',
 'Clear, sunny', '@VISUAL_INSPECTION_STAGE/T-SS054-001/202509/VIS-T-SS054-001-20250925-091.mp4', 'MP4',
 458227712, '4K', 28.5388499045107, -81.37995069535746,
 FALSE, '2025-09-26 19:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS038-001-20250715-092', 'T-SS038-001', '2025-07-15'::DATE,
 'Sarah Kim', 'INSP1002', 'VIDEO',
 'Partly cloudy', '@VISUAL_INSPECTION_STAGE/T-SS038-001/202507/VIS-T-SS038-001-20250715-092.mp4', 'MP4',
 303038464, '1920x1080', 26.640462529984973, -81.87309254351686,
 TRUE, '2025-07-16 11:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS094-001-20250923-093', 'T-SS094-001', '2025-09-23'::DATE,
 'Sarah Kim', 'INSP1002', 'VIDEO',
 'Clear, sunny', '@VISUAL_INSPECTION_STAGE/T-SS094-001/202509/VIS-T-SS094-001-20250923-093.mp4', 'MP4',
 461373440, '1920x1080', 28.537956928761677, -81.37989357122038,
 TRUE, '2025-09-24 01:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS031-001-20250428-094', 'T-SS031-001', '2025-04-28'::DATE,
 'Jennifer Lee', 'INSP1004', 'HANDHELD_CAMERA',
 'Clear, sunny', '@VISUAL_INSPECTION_STAGE/T-SS031-001/202504/VIS-T-SS031-001-20250428-094.jpg', 'JPG',
 495976448, '1920x1080', 25.762049609456383, -80.19210750823896,
 FALSE, '2025-04-29 08:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS056-001-20250429-095', 'T-SS056-001', '2025-04-29'::DATE,
 'Robert Johnson', 'INSP1003', 'THERMAL',
 'Overcast', '@VISUAL_INSPECTION_STAGE/T-SS056-001/202504/VIS-T-SS056-001-20250429-095.tiff', 'TIFF',
 493879296, '640x480', 30.439192277074202, -84.28060391960211,
 FALSE, '2025-05-01 07:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS083-001-20250509-096', 'T-SS083-001', '2025-05-09'::DATE,
 'Jennifer Lee', 'INSP1004', 'VIDEO',
 'Partly cloudy', '@VISUAL_INSPECTION_STAGE/T-SS083-001/202505/VIS-T-SS083-001-20250509-096.mp4', 'MP4',
 512753664, '1920x1080', 26.122618957428966, -80.13769921713205,
 TRUE, '2025-05-11 04:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS043-001-20250225-097', 'T-SS043-001', '2025-02-25'::DATE,
 'Jennifer Lee', 'INSP1004', 'DRONE',
 'Overcast', '@VISUAL_INSPECTION_STAGE/T-SS043-001/202502/VIS-T-SS043-001-20250225-097.mp4', 'MP4',
 456130560, '4K', 26.121663871048572, -80.13696643369299,
 TRUE, '2025-02-27 00:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS095-001-20241211-098', 'T-SS095-001', '2024-12-11'::DATE,
 'Jennifer Lee', 'INSP1004', 'THERMAL',
 'Overcast', '@VISUAL_INSPECTION_STAGE/T-SS095-001/202412/VIS-T-SS095-001-20241211-098.tiff', 'TIFF',
 511705088, '640x480', 30.33245789739257, -81.656176766005,
 FALSE, '2024-12-12 21:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS054-001-20250207-099', 'T-SS054-001', '2025-02-07'::DATE,
 'Carlos Martinez', 'INSP1001', 'VIDEO',
 'Light rain', '@VISUAL_INSPECTION_STAGE/T-SS054-001/202502/VIS-T-SS054-001-20250207-099.mp4', 'MP4',
 495976448, '1920x1080', 28.538890140799765, -81.37846959952982,
 TRUE, '2025-02-08 23:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS066-001-20250614-100', 'T-SS066-001', '2025-06-14'::DATE,
 'Carlos Martinez', 'INSP1001', 'HANDHELD_CAMERA',
 'Light rain', '@VISUAL_INSPECTION_STAGE/T-SS066-001/202506/VIS-T-SS066-001-20250614-100.jpg', 'JPG',
 327155712, '1920x1080', 30.438535136683157, -84.28089975423113,
 TRUE, '2025-06-16 19:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS063-001-20241214-101', 'T-SS063-001', '2024-12-14'::DATE,
 'Robert Johnson', 'INSP1003', 'THERMAL',
 'Overcast', '@VISUAL_INSPECTION_STAGE/T-SS063-001/202412/VIS-T-SS063-001-20241214-101.tiff', 'TIFF',
 167772160, '640x480', 26.121952644886125, -80.13737242749684,
 TRUE, '2024-12-16 18:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS061-001-20251014-102', 'T-SS061-001', '2025-10-14'::DATE,
 'Sarah Kim', 'INSP1002', 'THERMAL',
 'Foggy', '@VISUAL_INSPECTION_STAGE/T-SS061-001/202510/VIS-T-SS061-001-20251014-102.tiff', 'TIFF',
 394264576, '640x480', 25.761149340696512, -80.19267734167302,
 TRUE, '2025-10-15 15:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS071-001-20250726-103', 'T-SS071-001', '2025-07-26'::DATE,
 'Robert Johnson', 'INSP1003', 'THERMAL',
 'Foggy', '@VISUAL_INSPECTION_STAGE/T-SS071-001/202507/VIS-T-SS071-001-20250726-103.tiff', 'TIFF',
 205520896, '640x480', 25.76253115495606, -80.19216852399032,
 TRUE, '2025-07-27 08:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS072-001-20250927-104', 'T-SS072-001', '2025-09-27'::DATE,
 'Jennifer Lee', 'INSP1004', 'VIDEO',
 'Partly cloudy', '@VISUAL_INSPECTION_STAGE/T-SS072-001/202509/VIS-T-SS072-001-20250927-104.mp4', 'MP4',
 182452224, '1920x1080', 27.950961262662563, -82.4568887143671,
 TRUE, '2025-09-29 14:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS003-001-20250203-105', 'T-SS003-001', '2025-02-03'::DATE,
 'Sarah Kim', 'INSP1002', 'DRONE',
 'Partly cloudy', '@VISUAL_INSPECTION_STAGE/T-SS003-001/202502/VIS-T-SS003-001-20250203-105.mp4', 'MP4',
 448790528, '4K', 26.122216693781677, -80.13659539864913,
 TRUE, '2025-02-04 19:47:34'::TIMESTAMP_NTZ;

-- Batch 17/34
INSERT INTO UTILITIES_GRID_RELIABILITY.UNSTRUCTURED.VISUAL_INSPECTIONS 
(INSPECTION_ID, ASSET_ID, INSPECTION_DATE, INSPECTOR_NAME, INSPECTOR_ID, INSPECTION_METHOD, 
 WEATHER_CONDITIONS, FILE_PATH, FILE_TYPE, FILE_SIZE_BYTES, RESOLUTION, GPS_LATITUDE, GPS_LONGITUDE, 
 CV_PROCESSED, CV_PROCESSING_TIMESTAMP)
SELECT 
 'VIS-T-SS032-001-20250128-106', 'T-SS032-001', '2025-01-28'::DATE,
 'Michael Chen', 'INSP1005', 'DRONE',
 'Overcast', '@VISUAL_INSPECTION_STAGE/T-SS032-001/202501/VIS-T-SS032-001-20250128-106.mp4', 'MP4',
 253755392, '4K', 27.950570243164282, -82.45808836384839,
 TRUE, '2025-01-29 16:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS006-001-20250527-107', 'T-SS006-001', '2025-05-27'::DATE,
 'Robert Johnson', 'INSP1003', 'DRONE',
 'Partly cloudy', '@VISUAL_INSPECTION_STAGE/T-SS006-001/202505/VIS-T-SS006-001-20250527-107.mp4', 'MP4',
 199229440, '4K', 30.438422994243318, -84.2816372625906,
 TRUE, '2025-05-28 18:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS041-001-20241118-108', 'T-SS041-001', '2024-11-18'::DATE,
 'Sarah Kim', 'INSP1002', 'HANDHELD_CAMERA',
 'Overcast', '@VISUAL_INSPECTION_STAGE/T-SS041-001/202411/VIS-T-SS041-001-20241118-108.jpg', 'JPG',
 324009984, '1920x1080', 25.76101234640164, -80.19132772189803,
 TRUE, '2024-11-20 00:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS027-001-20250813-109', 'T-SS027-001', '2025-08-13'::DATE,
 'Michael Chen', 'INSP1005', 'LIDAR',
 'Light rain', '@VISUAL_INSPECTION_STAGE/T-SS027-001/202508/VIS-T-SS027-001-20250813-109.las', 'LAS',
 198180864, 'N/A', 26.142838356726948, -81.79419916194573,
 TRUE, '2025-08-15 17:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS083-001-20250812-110', 'T-SS083-001', '2025-08-12'::DATE,
 'Sarah Kim', 'INSP1002', 'HANDHELD_CAMERA',
 'Post-storm', '@VISUAL_INSPECTION_STAGE/T-SS083-001/202508/VIS-T-SS083-001-20250812-110.jpg', 'JPG',
 55574528, '1920x1080', 26.12160146756063, -80.13742299631811,
 TRUE, '2025-08-14 11:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS090-001-20241120-111', 'T-SS090-001', '2024-11-20'::DATE,
 'Robert Johnson', 'INSP1003', 'VIDEO',
 'Light rain', '@VISUAL_INSPECTION_STAGE/T-SS090-001/202411/VIS-T-SS090-001-20241120-111.mp4', 'MP4',
 516947968, '1920x1080', 26.715484448658415, -80.05326092582563,
 FALSE, '2024-11-22 08:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS066-001-20251002-112', 'T-SS066-001', '2025-10-02'::DATE,
 'Michael Chen', 'INSP1005', 'THERMAL',
 'Partly cloudy', '@VISUAL_INSPECTION_STAGE/T-SS066-001/202510/VIS-T-SS066-001-20251002-112.tiff', 'TIFF',
 160432128, '640x480', 30.43732477066478, -84.28129843517996,
 TRUE, '2025-10-03 01:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS090-001-20250811-113', 'T-SS090-001', '2025-08-11'::DATE,
 'Jennifer Lee', 'INSP1004', 'VIDEO',
 'Foggy', '@VISUAL_INSPECTION_STAGE/T-SS090-001/202508/VIS-T-SS090-001-20250811-113.mp4', 'MP4',
 34603008, '1920x1080', 26.71600182730935, -80.05267364067514,
 TRUE, '2025-08-13 08:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS056-001-20251102-114', 'T-SS056-001', '2025-11-02'::DATE,
 'Robert Johnson', 'INSP1003', 'THERMAL',
 'Overcast', '@VISUAL_INSPECTION_STAGE/T-SS056-001/202511/VIS-T-SS056-001-20251102-114.tiff', 'TIFF',
 168820736, '640x480', 30.437415237410598, -84.28080358076288,
 TRUE, '2025-11-03 02:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS075-001-20251113-115', 'T-SS075-001', '2025-11-13'::DATE,
 'Carlos Martinez', 'INSP1001', 'LIDAR',
 'Partly cloudy', '@VISUAL_INSPECTION_STAGE/T-SS075-001/202511/VIS-T-SS075-001-20251113-115.las', 'LAS',
 99614720, 'N/A', 30.33129730734099, -81.65501773078988,
 TRUE, '2025-11-14 12:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS023-001-20250712-116', 'T-SS023-001', '2025-07-12'::DATE,
 'Carlos Martinez', 'INSP1001', 'VIDEO',
 'Clear, sunny', '@VISUAL_INSPECTION_STAGE/T-SS023-001/202507/VIS-T-SS023-001-20250712-116.mp4', 'MP4',
 247463936, '1920x1080', 26.123056175609666, -80.13715656752365,
 TRUE, '2025-07-13 23:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS067-001-20241212-117', 'T-SS067-001', '2024-12-12'::DATE,
 'Carlos Martinez', 'INSP1001', 'HANDHELD_CAMERA',
 'Overcast', '@VISUAL_INSPECTION_STAGE/T-SS067-001/202412/VIS-T-SS067-001-20241212-117.jpg', 'JPG',
 469762048, '1920x1080', 26.142363063271286, -81.7946112134526,
 TRUE, '2024-12-13 13:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS072-001-20250415-118', 'T-SS072-001', '2025-04-15'::DATE,
 'Jennifer Lee', 'INSP1004', 'DRONE',
 'Overcast', '@VISUAL_INSPECTION_STAGE/T-SS072-001/202504/VIS-T-SS072-001-20250415-118.mp4', 'MP4',
 488636416, '4K', 27.95099320198742, -82.45779074766799,
 TRUE, '2025-04-17 00:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS053-001-20250131-119', 'T-SS053-001', '2025-01-31'::DATE,
 'Sarah Kim', 'INSP1002', 'HANDHELD_CAMERA',
 'Clear, sunny', '@VISUAL_INSPECTION_STAGE/T-SS053-001/202501/VIS-T-SS053-001-20250131-119.jpg', 'JPG',
 427819008, '1920x1080', 26.121800520170567, -80.13714890000985,
 FALSE, '2025-02-01 10:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS075-001-20250318-120', 'T-SS075-001', '2025-03-18'::DATE,
 'Michael Chen', 'INSP1005', 'THERMAL',
 'Partly cloudy', '@VISUAL_INSPECTION_STAGE/T-SS075-001/202503/VIS-T-SS075-001-20250318-120.tiff', 'TIFF',
 12582912, '640x480', 30.33210003241835, -81.65503412275484,
 TRUE, '2025-03-20 16:47:34'::TIMESTAMP_NTZ;

-- Batch 18/34
INSERT INTO UTILITIES_GRID_RELIABILITY.UNSTRUCTURED.VISUAL_INSPECTIONS 
(INSPECTION_ID, ASSET_ID, INSPECTION_DATE, INSPECTOR_NAME, INSPECTOR_ID, INSPECTION_METHOD, 
 WEATHER_CONDITIONS, FILE_PATH, FILE_TYPE, FILE_SIZE_BYTES, RESOLUTION, GPS_LATITUDE, GPS_LONGITUDE, 
 CV_PROCESSED, CV_PROCESSING_TIMESTAMP)
SELECT 
 'VIS-T-SS083-001-20250925-121', 'T-SS083-001', '2025-09-25'::DATE,
 'Carlos Martinez', 'INSP1001', 'LIDAR',
 'Clear, sunny', '@VISUAL_INSPECTION_STAGE/T-SS083-001/202509/VIS-T-SS083-001-20250925-121.las', 'LAS',
 228589568, 'N/A', 26.123391435640777, -80.13657023670574,
 TRUE, '2025-09-27 08:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS085-001-20250311-122', 'T-SS085-001', '2025-03-11'::DATE,
 'Michael Chen', 'INSP1005', 'HANDHELD_CAMERA',
 'Overcast', '@VISUAL_INSPECTION_STAGE/T-SS085-001/202503/VIS-T-SS085-001-20250311-122.jpg', 'JPG',
 83886080, '1920x1080', 30.331833783537675, -81.65597946283198,
 FALSE, '2025-03-13 00:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS032-001-20241204-123', 'T-SS032-001', '2024-12-04'::DATE,
 'Carlos Martinez', 'INSP1001', 'THERMAL',
 'Clear, sunny', '@VISUAL_INSPECTION_STAGE/T-SS032-001/202412/VIS-T-SS032-001-20241204-123.tiff', 'TIFF',
 416284672, '640x480', 27.94995263686151, -82.45713166648265,
 FALSE, '2024-12-05 18:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS059-001-20250530-124', 'T-SS059-001', '2025-05-30'::DATE,
 'Sarah Kim', 'INSP1002', 'DRONE',
 'Clear, sunny', '@VISUAL_INSPECTION_STAGE/T-SS059-001/202505/VIS-T-SS059-001-20250530-124.mp4', 'MP4',
 368050176, '4K', 27.336997612374564, -82.53108711025975,
 TRUE, '2025-05-31 21:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS074-001-20251006-125', 'T-SS074-001', '2025-10-06'::DATE,
 'Michael Chen', 'INSP1005', 'HANDHELD_CAMERA',
 'Foggy', '@VISUAL_INSPECTION_STAGE/T-SS074-001/202510/VIS-T-SS074-001-20251006-125.jpg', 'JPG',
 313524224, '1920x1080', 28.537914935368217, -81.37906709520328,
 FALSE, '2025-10-08 13:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS017-001-20250914-126', 'T-SS017-001', '2025-09-14'::DATE,
 'Jennifer Lee', 'INSP1004', 'HANDHELD_CAMERA',
 'Foggy', '@VISUAL_INSPECTION_STAGE/T-SS017-001/202509/VIS-T-SS017-001-20250914-126.jpg', 'JPG',
 241172480, '1920x1080', 26.142215727890548, -81.79556556294152,
 TRUE, '2025-09-15 09:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS067-001-20251014-127', 'T-SS067-001', '2025-10-14'::DATE,
 'Jennifer Lee', 'INSP1004', 'VIDEO',
 'Foggy', '@VISUAL_INSPECTION_STAGE/T-SS067-001/202510/VIS-T-SS067-001-20251014-127.mp4', 'MP4',
 442499072, '1920x1080', 26.141351264342884, -81.79579314021146,
 TRUE, '2025-10-16 13:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS027-001-20241209-128', 'T-SS027-001', '2024-12-09'::DATE,
 'Robert Johnson', 'INSP1003', 'THERMAL',
 'Post-storm', '@VISUAL_INSPECTION_STAGE/T-SS027-001/202412/VIS-T-SS027-001-20241209-128.tiff', 'TIFF',
 374341632, '640x480', 26.14287908598572, -81.79395592174615,
 TRUE, '2024-12-10 00:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS090-001-20250226-129', 'T-SS090-001', '2025-02-26'::DATE,
 'Sarah Kim', 'INSP1002', 'THERMAL',
 'Light rain', '@VISUAL_INSPECTION_STAGE/T-SS090-001/202502/VIS-T-SS090-001-20250226-129.tiff', 'TIFF',
 204472320, '640x480', 26.71497200218837, -80.05435480485762,
 TRUE, '2025-02-28 11:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS059-001-20250417-130', 'T-SS059-001', '2025-04-17'::DATE,
 'Michael Chen', 'INSP1005', 'LIDAR',
 'Clear, sunny', '@VISUAL_INSPECTION_STAGE/T-SS059-001/202504/VIS-T-SS059-001-20250417-130.las', 'LAS',
 265289728, 'N/A', 27.337334699192052, -82.53053808087544,
 TRUE, '2025-04-19 04:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS050-001-20250806-131', 'T-SS050-001', '2025-08-06'::DATE,
 'Robert Johnson', 'INSP1003', 'VIDEO',
 'Light rain', '@VISUAL_INSPECTION_STAGE/T-SS050-001/202508/VIS-T-SS050-001-20250806-131.mp4', 'MP4',
 520093696, '1920x1080', 26.715496584414797, -80.05379339192666,
 TRUE, '2025-08-07 20:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS000-001-20241227-132', 'T-SS000-001', '2024-12-27'::DATE,
 'Michael Chen', 'INSP1005', 'HANDHELD_CAMERA',
 'Post-storm', '@VISUAL_INSPECTION_STAGE/T-SS000-001/202412/VIS-T-SS000-001-20241227-132.jpg', 'JPG',
 36700160, '1920x1080', 26.71540974696745, -80.05425309625294,
 TRUE, '2024-12-28 06:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS036-001-20250507-133', 'T-SS036-001', '2025-05-07'::DATE,
 'Robert Johnson', 'INSP1003', 'HANDHELD_CAMERA',
 'Clear, sunny', '@VISUAL_INSPECTION_STAGE/T-SS036-001/202505/VIS-T-SS036-001-20250507-133.jpg', 'JPG',
 249561088, '1920x1080', 30.438309942716447, -84.28068027796706,
 TRUE, '2025-05-09 10:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS016-001-20241221-134', 'T-SS016-001', '2024-12-21'::DATE,
 'Michael Chen', 'INSP1005', 'LIDAR',
 'Clear, sunny', '@VISUAL_INSPECTION_STAGE/T-SS016-001/202412/VIS-T-SS016-001-20241221-134.las', 'LAS',
 355467264, 'N/A', 30.4385908165871, -84.28145544835782,
 TRUE, '2024-12-23 00:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS010-001-20250707-135', 'T-SS010-001', '2025-07-07'::DATE,
 'Michael Chen', 'INSP1005', 'HANDHELD_CAMERA',
 'Post-storm', '@VISUAL_INSPECTION_STAGE/T-SS010-001/202507/VIS-T-SS010-001-20250707-135.jpg', 'JPG',
 106954752, '1920x1080', 26.71597100319097, -80.05341065948515,
 TRUE, '2025-07-09 10:47:34'::TIMESTAMP_NTZ;

-- Batch 19/34
INSERT INTO UTILITIES_GRID_RELIABILITY.UNSTRUCTURED.VISUAL_INSPECTIONS 
(INSPECTION_ID, ASSET_ID, INSPECTION_DATE, INSPECTOR_NAME, INSPECTOR_ID, INSPECTION_METHOD, 
 WEATHER_CONDITIONS, FILE_PATH, FILE_TYPE, FILE_SIZE_BYTES, RESOLUTION, GPS_LATITUDE, GPS_LONGITUDE, 
 CV_PROCESSED, CV_PROCESSING_TIMESTAMP)
SELECT 
 'VIS-T-SS057-001-20251001-136', 'T-SS057-001', '2025-10-01'::DATE,
 'Sarah Kim', 'INSP1002', 'LIDAR',
 'Partly cloudy', '@VISUAL_INSPECTION_STAGE/T-SS057-001/202510/VIS-T-SS057-001-20251001-136.las', 'LAS',
 75497472, 'N/A', 26.142515671537275, -81.79444079526594,
 TRUE, '2025-10-02 16:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS037-001-20250616-137', 'T-SS037-001', '2025-06-16'::DATE,
 'Jennifer Lee', 'INSP1004', 'LIDAR',
 'Clear, sunny', '@VISUAL_INSPECTION_STAGE/T-SS037-001/202506/VIS-T-SS037-001-20250616-137.las', 'LAS',
 362807296, 'N/A', 26.14201424338766, -81.79452074669842,
 TRUE, '2025-06-18 01:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS076-001-20250515-138', 'T-SS076-001', '2025-05-15'::DATE,
 'Robert Johnson', 'INSP1003', 'VIDEO',
 'Overcast', '@VISUAL_INSPECTION_STAGE/T-SS076-001/202505/VIS-T-SS076-001-20250515-138.mp4', 'MP4',
 475004928, '1920x1080', 30.437838177629438, -84.28028954695237,
 TRUE, '2025-05-17 17:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS070-001-20250828-139', 'T-SS070-001', '2025-08-28'::DATE,
 'Sarah Kim', 'INSP1002', 'THERMAL',
 'Clear, sunny', '@VISUAL_INSPECTION_STAGE/T-SS070-001/202508/VIS-T-SS070-001-20250828-139.tiff', 'TIFF',
 500170752, '640x480', 26.715624157212044, -80.05240334258995,
 TRUE, '2025-08-29 01:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS057-001-20250910-140', 'T-SS057-001', '2025-09-10'::DATE,
 'Carlos Martinez', 'INSP1001', 'THERMAL',
 'Light rain', '@VISUAL_INSPECTION_STAGE/T-SS057-001/202509/VIS-T-SS057-001-20250910-140.tiff', 'TIFF',
 296747008, '640x480', 26.142599149817393, -81.7945227213731,
 TRUE, '2025-09-12 20:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS030-001-20241218-141', 'T-SS030-001', '2024-12-18'::DATE,
 'Sarah Kim', 'INSP1002', 'THERMAL',
 'Overcast', '@VISUAL_INSPECTION_STAGE/T-SS030-001/202412/VIS-T-SS030-001-20241218-141.tiff', 'TIFF',
 27262976, '640x480', 26.7161591297279, -80.05259561006953,
 TRUE, '2024-12-19 22:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS038-001-20250129-142', 'T-SS038-001', '2025-01-29'::DATE,
 'Carlos Martinez', 'INSP1001', 'THERMAL',
 'Post-storm', '@VISUAL_INSPECTION_STAGE/T-SS038-001/202501/VIS-T-SS038-001-20250129-142.tiff', 'TIFF',
 54525952, '640x480', 26.64032424829265, -81.87230539612595,
 TRUE, '2025-01-30 18:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS047-001-20251016-143', 'T-SS047-001', '2025-10-16'::DATE,
 'Robert Johnson', 'INSP1003', 'HANDHELD_CAMERA',
 'Clear, sunny', '@VISUAL_INSPECTION_STAGE/T-SS047-001/202510/VIS-T-SS047-001-20251016-143.jpg', 'JPG',
 287309824, '1920x1080', 26.14103093679, -81.79560564072801,
 FALSE, '2025-10-18 14:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS073-001-20250205-144', 'T-SS073-001', '2025-02-05'::DATE,
 'Jennifer Lee', 'INSP1004', 'THERMAL',
 'Post-storm', '@VISUAL_INSPECTION_STAGE/T-SS073-001/202502/VIS-T-SS073-001-20250205-144.tiff', 'TIFF',
 318767104, '640x480', 26.122323167199255, -80.13782938805514,
 TRUE, '2025-02-06 17:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS068-001-20241230-145', 'T-SS068-001', '2024-12-30'::DATE,
 'Jennifer Lee', 'INSP1004', 'THERMAL',
 'Clear, sunny', '@VISUAL_INSPECTION_STAGE/T-SS068-001/202412/VIS-T-SS068-001-20241230-145.tiff', 'TIFF',
 208666624, '640x480', 26.64110285641813, -81.87257099444263,
 TRUE, '2024-12-31 06:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS019-001-20250209-146', 'T-SS019-001', '2025-02-09'::DATE,
 'Sarah Kim', 'INSP1002', 'LIDAR',
 'Clear, sunny', '@VISUAL_INSPECTION_STAGE/T-SS019-001/202502/VIS-T-SS019-001-20250209-146.las', 'LAS',
 93323264, 'N/A', 27.337132580611193, -82.52988630585374,
 TRUE, '2025-02-11 13:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS009-001-20250422-147', 'T-SS009-001', '2025-04-22'::DATE,
 'Jennifer Lee', 'INSP1004', 'DRONE',
 'Foggy', '@VISUAL_INSPECTION_STAGE/T-SS009-001/202504/VIS-T-SS009-001-20250422-147.mp4', 'MP4',
 122683392, '4K', 27.33570530802013, -82.531688952903,
 TRUE, '2025-04-23 09:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS058-001-20250613-148', 'T-SS058-001', '2025-06-13'::DATE,
 'Sarah Kim', 'INSP1002', 'HANDHELD_CAMERA',
 'Light rain', '@VISUAL_INSPECTION_STAGE/T-SS058-001/202506/VIS-T-SS058-001-20250613-148.jpg', 'JPG',
 313524224, '1920x1080', 26.641119535106647, -81.8728999735727,
 TRUE, '2025-06-15 16:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS048-001-20250925-149', 'T-SS048-001', '2025-09-25'::DATE,
 'Sarah Kim', 'INSP1002', 'VIDEO',
 'Foggy', '@VISUAL_INSPECTION_STAGE/T-SS048-001/202509/VIS-T-SS048-001-20250925-149.mp4', 'MP4',
 25165824, '1920x1080', 26.641156035787983, -81.87244088820665,
 TRUE, '2025-09-27 02:47:34'::TIMESTAMP_NTZ UNION ALL SELECT 
 'VIS-T-SS099-001-20250924-150', 'T-SS099-001', '2025-09-24'::DATE,
 'Michael Chen', 'INSP1005', 'DRONE',
 'Overcast', '@VISUAL_INSPECTION_STAGE/T-SS099-001/202509/VIS-T-SS099-001-20250924-150.mp4', 'MP4',
 395313152, '4K', 27.336085702185986, -82.53083943185301,
 TRUE, '2025-09-25 14:47:34'::TIMESTAMP_NTZ;

-- Batch 20/34
INSERT INTO UTILITIES_GRID_RELIABILITY.UNSTRUCTURED.CV_DETECTIONS 
(DETECTION_ID, INSPECTION_ID, ASSET_ID, DETECTION_TYPE, CONFIDENCE_SCORE, BOUNDING_BOX, 
 SEVERITY_LEVEL, REQUIRES_IMMEDIATE_ACTION, DETECTED_AT_COMPONENT, DESCRIPTION, MODEL_NAME, MODEL_VERSION)
SELECT 
 'DET-VIS-T-SS099-001-20251005-001-001', 'VIS-T-SS099-001-20251005-001', 'T-SS099-001',
 'STRUCTURAL_DAMAGE', 0.7821, PARSE_JSON('{"x": 0.5141, "y": 0.3403, "width": 0.0778, "height": 0.06}'),
 'HIGH', TRUE,
 'MOUNTING', 'Physical damage observed on mounting. Deformation or breakage present.', 'temporal_defect_detector_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS099-001-20251005-001-002', 'VIS-T-SS099-001-20251005-001', 'T-SS099-001',
 'STRUCTURAL_DAMAGE', 0.9104, PARSE_JSON('{"x": 0.4033, "y": 0.5609, "width": 0.2639, "height": 0.2708}'),
 'CRITICAL', FALSE,
 'FOUNDATION', 'Deterioration of foundation support structure. Potential stability concern.', 'temporal_defect_detector_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS099-001-20251005-001-003', 'VIS-T-SS099-001-20251005-001', 'T-SS099-001',
 'HOTSPOT', 0.9724, PARSE_JSON('{"x": 0.2984, "y": 0.5715, "width": 0.1674, "height": 0.1843}'),
 'HIGH', FALSE,
 'LOAD_CONNECTION', 'Elevated temperature on load connection. Possible loose connection or high resistance.', 'temporal_defect_detector_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS099-001-20251005-001-004', 'VIS-T-SS099-001-20251005-001', 'T-SS099-001',
 'STRUCTURAL_DAMAGE', 0.9072, PARSE_JSON('{"x": 0.3831, "y": 0.1774, "width": 0.0732, "height": 0.2153}'),
 'MEDIUM', FALSE,
 'MOUNTING', 'Structural integrity compromised at mounting. Requires engineering assessment.', 'temporal_defect_detector_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS072-001-20251002-003-001', 'VIS-T-SS072-001-20251002-003', 'T-SS072-001',
 'HOTSPOT', 0.9146, PARSE_JSON('{"x": 0.6337, "y": 0.2318, "width": 0.1033, "height": 0.1908}'),
 'MEDIUM', FALSE,
 'TAP_CHANGER', 'Elevated temperature on tap changer. Possible loose connection or high resistance.', 'thermal_anomaly_detector_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS009-001-20251022-006-001', 'VIS-T-SS009-001-20251022-006', 'T-SS009-001',
 'CORROSION', 0.7631, PARSE_JSON('{"x": 0.6968, "y": 0.4036, "width": 0.1861, "height": 0.2586}'),
 'LOW', FALSE,
 'RADIATOR', 'Moderate to severe corrosion present. Metal oxidation advancing on radiator.', 'temporal_defect_detector_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS009-001-20251022-006-002', 'VIS-T-SS009-001-20251022-006', 'T-SS009-001',
 'HOTSPOT', 0.9757, PARSE_JSON('{"x": 0.6427, "y": 0.1137, "width": 0.101, "height": 0.076}'),
 'HIGH', FALSE,
 'RADIATOR', 'Elevated temperature on radiator. Possible loose connection or high resistance.', 'temporal_defect_detector_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS009-001-20251022-006-003', 'VIS-T-SS009-001-20251022-006', 'T-SS009-001',
 'STRUCTURAL_DAMAGE', 0.9133, PARSE_JSON('{"x": 0.1573, "y": 0.5708, "width": 0.2802, "height": 0.2026}'),
 'HIGH', FALSE,
 'MOUNTING', 'Physical damage observed on mounting. Deformation or breakage present.', 'temporal_defect_detector_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS011-001-20250829-007-001', 'VIS-T-SS011-001-20250829-007', 'T-SS011-001',
 'CORROSION', 0.8411, PARSE_JSON('{"x": 0.695, "y": 0.2838, "width": 0.06, "height": 0.1912}'),
 'LOW', FALSE,
 'MOUNTING_BRACKETS', 'Surface corrosion detected on mounting brackets. Rust visible with paint degradation.', 'yolov8_transformer_aerial_v3', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS011-001-20250829-007-002', 'VIS-T-SS011-001-20250829-007', 'T-SS011-001',
 'VEGETATION', 0.9582, PARSE_JSON('{"x": 0.4149, "y": 0.113, "width": 0.2894, "height": 0.1459}'),
 'MEDIUM', FALSE,
 'BASE', 'Tree branches encroaching within clearance zone near base.', 'yolov8_transformer_aerial_v3', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS011-001-20250829-007-003', 'VIS-T-SS011-001-20250829-007', 'T-SS011-001',
 'VEGETATION', 0.9815, PARSE_JSON('{"x": 0.6691, "y": 0.6768, "width": 0.1066, "height": 0.1134}'),
 'LOW', FALSE,
 'FENCE_LINE', 'Grass and brush overgrowth affecting access to fence line.', 'yolov8_transformer_aerial_v3', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS011-001-20250829-007-004', 'VIS-T-SS011-001-20250829-007', 'T-SS011-001',
 'CORROSION', 0.8732, PARSE_JSON('{"x": 0.6832, "y": 0.2226, "width": 0.1757, "height": 0.153}'),
 'MEDIUM', FALSE,
 'BUSHING_BASE', 'Corrosion patterns suggest moisture ingress. Located on bushing base.', 'yolov8_transformer_aerial_v3', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS095-001-20250630-008-001', 'VIS-T-SS095-001-20250630-008', 'T-SS095-001',
 'VEGETATION', 0.9322, PARSE_JSON('{"x": 0.6513, "y": 0.1846, "width": 0.2551, "height": 0.0524}'),
 'HIGH', FALSE,
 'ACCESS_ROAD', 'Tree branches encroaching within clearance zone near access road.', 'yolov8_transformer_aerial_v3', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS055-001-20241229-009-001', 'VIS-T-SS055-001-20241229-009', 'T-SS055-001',
 'STRUCTURAL_DAMAGE', 0.9061, PARSE_JSON('{"x": 0.3909, "y": 0.3634, "width": 0.0557, "height": 0.174}'),
 'HIGH', TRUE,
 'SUPPORT_STRUCTURE', 'Physical damage observed on support structure. Deformation or breakage present.', 'yolov8_transformer_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS055-001-20241229-009-002', 'VIS-T-SS055-001-20241229-009', 'T-SS055-001',
 'LEAK', 0.8921, PARSE_JSON('{"x": 0.3834, "y": 0.1941, "width": 0.1799, "height": 0.0834}'),
 'HIGH', FALSE,
 'RADIATOR_JOINT', 'Active oil leak detected at radiator joint. Visible staining and dripping.', 'yolov8_transformer_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS055-001-20241229-009-003', 'VIS-T-SS055-001-20241229-009', 'T-SS055-001',
 'HOTSPOT', 0.8957, PARSE_JSON('{"x": 0.2021, "y": 0.3345, "width": 0.113, "height": 0.1597}'),
 'MEDIUM', FALSE,
 'RADIATOR', 'Elevated temperature on radiator. Possible loose connection or high resistance.', 'yolov8_transformer_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS040-001-20250906-010-001', 'VIS-T-SS040-001-20250906-010', 'T-SS040-001',
 'STRUCTURAL_DAMAGE', 0.7921, PARSE_JSON('{"x": 0.6164, "y": 0.1503, "width": 0.2114, "height": 0.1719}'),
 'CRITICAL', FALSE,
 'FOUNDATION', 'Structural integrity compromised at foundation. Requires engineering assessment.', 'yolov8_transformer_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS040-001-20250906-010-002', 'VIS-T-SS040-001-20250906-010', 'T-SS040-001',
 'STRUCTURAL_DAMAGE', 0.8877, PARSE_JSON('{"x": 0.516, "y": 0.5639, "width": 0.121, "height": 0.1106}'),
 'LOW', FALSE,
 'ENCLOSURE', 'Deterioration of enclosure support structure. Potential stability concern.', 'yolov8_transformer_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS040-001-20250906-010-003', 'VIS-T-SS040-001-20250906-010', 'T-SS040-001',
 'HOTSPOT', 0.9795, PARSE_JSON('{"x": 0.4875, "y": 0.2344, "width": 0.0719, "height": 0.1022}'),
 'HIGH', TRUE,
 'LOAD_CONNECTION', 'Elevated temperature on load connection. Possible loose connection or high resistance.', 'yolov8_transformer_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS040-001-20250906-010-004', 'VIS-T-SS040-001-20250906-010', 'T-SS040-001',
 'CRACK', 0.9378, PARSE_JSON('{"x": 0.5766, "y": 0.2475, "width": 0.2456, "height": 0.1963}'),
 'HIGH', TRUE,
 'TANK', 'Linear crack detected in tank. Length approximately 15-25cm.', 'yolov8_transformer_v2', 'v2.1';

-- Batch 21/34
INSERT INTO UTILITIES_GRID_RELIABILITY.UNSTRUCTURED.CV_DETECTIONS 
(DETECTION_ID, INSPECTION_ID, ASSET_ID, DETECTION_TYPE, CONFIDENCE_SCORE, BOUNDING_BOX, 
 SEVERITY_LEVEL, REQUIRES_IMMEDIATE_ACTION, DETECTED_AT_COMPONENT, DESCRIPTION, MODEL_NAME, MODEL_VERSION)
SELECT 
 'DET-VIS-T-SS088-001-20250526-011-001', 'VIS-T-SS088-001-20250526-011', 'T-SS088-001',
 'STRUCTURAL_DAMAGE', 0.8245, PARSE_JSON('{"x": 0.2426, "y": 0.1672, "width": 0.1404, "height": 0.2012}'),
 'CRITICAL', TRUE,
 'FOUNDATION', 'Deterioration of foundation support structure. Potential stability concern.', 'pointcloud_structural_analyzer_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS088-001-20250526-011-002', 'VIS-T-SS088-001-20250526-011', 'T-SS088-001',
 'VEGETATION', 0.9599, PARSE_JSON('{"x": 0.5963, "y": 0.5515, "width": 0.265, "height": 0.1455}'),
 'MEDIUM', FALSE,
 'BASE', 'Grass and brush overgrowth affecting access to base.', 'pointcloud_structural_analyzer_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS054-001-20251114-012-001', 'VIS-T-SS054-001-20251114-012', 'T-SS054-001',
 'STRUCTURAL_DAMAGE', 0.9303, PARSE_JSON('{"x": 0.4205, "y": 0.2076, "width": 0.2405, "height": 0.1166}'),
 'HIGH', FALSE,
 'ENCLOSURE', 'Deterioration of enclosure support structure. Potential stability concern.', 'yolov8_transformer_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS054-001-20251114-012-002', 'VIS-T-SS054-001-20251114-012', 'T-SS054-001',
 'STRUCTURAL_DAMAGE', 0.9202, PARSE_JSON('{"x": 0.6228, "y": 0.4349, "width": 0.1777, "height": 0.0807}'),
 'MEDIUM', FALSE,
 'ENCLOSURE', 'Deterioration of enclosure support structure. Potential stability concern.', 'yolov8_transformer_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS054-001-20251114-012-003', 'VIS-T-SS054-001-20251114-012', 'T-SS054-001',
 'HOTSPOT', 0.8977, PARSE_JSON('{"x": 0.1463, "y": 0.461, "width": 0.1362, "height": 0.1227}'),
 'CRITICAL', TRUE,
 'BUSHING_CONNECTION', 'Elevated temperature on bushing connection. Possible loose connection or high resistance.', 'yolov8_transformer_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS070-001-20241223-013-001', 'VIS-T-SS070-001-20241223-013', 'T-SS070-001',
 'CORROSION', 0.9145, PARSE_JSON('{"x": 0.4482, "y": 0.665, "width": 0.0949, "height": 0.2383}'),
 'LOW', FALSE,
 'MOUNTING_BRACKETS', 'Corrosion patterns suggest moisture ingress. Located on mounting brackets.', 'thermal_anomaly_detector_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS070-001-20241223-013-002', 'VIS-T-SS070-001-20241223-013', 'T-SS070-001',
 'HOTSPOT', 0.9408, PARSE_JSON('{"x": 0.3051, "y": 0.4414, "width": 0.1709, "height": 0.2808}'),
 'HIGH', TRUE,
 'TAP_CHANGER', 'Elevated temperature on tap changer. Possible loose connection or high resistance.', 'thermal_anomaly_detector_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS070-001-20241223-013-003', 'VIS-T-SS070-001-20241223-013', 'T-SS070-001',
 'HOTSPOT', 0.9225, PARSE_JSON('{"x": 0.402, "y": 0.1362, "width": 0.1718, "height": 0.097}'),
 'LOW', FALSE,
 'LOAD_CONNECTION', 'Elevated temperature on load connection. Possible loose connection or high resistance.', 'thermal_anomaly_detector_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS008-001-20251003-014-001', 'VIS-T-SS008-001-20251003-014', 'T-SS008-001',
 'CORROSION', 0.8213, PARSE_JSON('{"x": 0.607, "y": 0.6391, "width": 0.0919, "height": 0.1807}'),
 'MEDIUM', FALSE,
 'TANK', 'Moderate to severe corrosion present. Metal oxidation advancing on tank.', 'temporal_defect_detector_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS008-001-20251003-014-002', 'VIS-T-SS008-001-20251003-014', 'T-SS008-001',
 'CRACK', 0.9423, PARSE_JSON('{"x": 0.47, "y": 0.5848, "width": 0.2264, "height": 0.0903}'),
 'CRITICAL', TRUE,
 'GASKET', 'Linear crack detected in gasket. Length approximately 15-25cm.', 'temporal_defect_detector_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS008-001-20251003-014-003', 'VIS-T-SS008-001-20251003-014', 'T-SS008-001',
 'CRACK', 0.9166, PARSE_JSON('{"x": 0.4696, "y": 0.5232, "width": 0.1995, "height": 0.0633}'),
 'CRITICAL', TRUE,
 'TANK', 'Structural crack identified. Propagation risk on tank.', 'temporal_defect_detector_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS008-001-20251003-014-004', 'VIS-T-SS008-001-20251003-014', 'T-SS008-001',
 'CORROSION', 0.7504, PARSE_JSON('{"x": 0.6498, "y": 0.4538, "width": 0.2814, "height": 0.0613}'),
 'LOW', FALSE,
 'RADIATOR', 'Moderate to severe corrosion present. Metal oxidation advancing on radiator.', 'temporal_defect_detector_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS008-001-20251003-014-005', 'VIS-T-SS008-001-20251003-014', 'T-SS008-001',
 'VEGETATION', 0.9424, PARSE_JSON('{"x": 0.1785, "y": 0.3565, "width": 0.2413, "height": 0.2476}'),
 'LOW', FALSE,
 'BASE', 'Excessive vegetation growth detected. Clearance violation at base.', 'temporal_defect_detector_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS035-001-20241211-015-001', 'VIS-T-SS035-001-20241211-015', 'T-SS035-001',
 'HOTSPOT', 0.9596, PARSE_JSON('{"x": 0.1423, "y": 0.5949, "width": 0.1215, "height": 0.2735}'),
 'HIGH', FALSE,
 'RADIATOR', 'Thermal anomaly detected at radiator. Temperature differential: 24°C above ambient.', 'thermal_anomaly_detector_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS009-001-20250410-016-001', 'VIS-T-SS009-001-20250410-016', 'T-SS009-001',
 'LEAK', 0.9076, PARSE_JSON('{"x": 0.1726, "y": 0.2191, "width": 0.2806, "height": 0.23}'),
 'HIGH', FALSE,
 'GASKET', 'Active oil leak detected at gasket. Visible staining and dripping.', 'thermal_anomaly_detector_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS009-001-20250410-016-002', 'VIS-T-SS009-001-20250410-016', 'T-SS009-001',
 'CORROSION', 0.8568, PARSE_JSON('{"x": 0.1618, "y": 0.5747, "width": 0.2641, "height": 0.2896}'),
 'LOW', FALSE,
 'RADIATOR', 'Surface corrosion detected on radiator. Rust visible with paint degradation.', 'thermal_anomaly_detector_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS009-001-20250410-016-003', 'VIS-T-SS009-001-20250410-016', 'T-SS009-001',
 'STRUCTURAL_DAMAGE', 0.8072, PARSE_JSON('{"x": 0.1658, "y": 0.1516, "width": 0.0714, "height": 0.1003}'),
 'LOW', FALSE,
 'SUPPORT_STRUCTURE', 'Structural integrity compromised at support structure. Requires engineering assessment.', 'thermal_anomaly_detector_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS007-001-20241123-017-001', 'VIS-T-SS007-001-20241123-017', 'T-SS007-001',
 'LEAK', 0.9562, PARSE_JSON('{"x": 0.435, "y": 0.3504, "width": 0.1612, "height": 0.0516}'),
 'HIGH', TRUE,
 'GASKET', 'Active oil leak detected at gasket. Visible staining and dripping.', 'temporal_defect_detector_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS057-001-20250802-018-001', 'VIS-T-SS057-001-20250802-018', 'T-SS057-001',
 'STRUCTURAL_DAMAGE', 0.9587, PARSE_JSON('{"x": 0.2942, "y": 0.2635, "width": 0.1091, "height": 0.1802}'),
 'HIGH', TRUE,
 'FOUNDATION', 'Structural integrity compromised at foundation. Requires engineering assessment.', 'yolov8_transformer_aerial_v3', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS057-001-20250802-018-002', 'VIS-T-SS057-001-20250802-018', 'T-SS057-001',
 'CORROSION', 0.9419, PARSE_JSON('{"x": 0.5337, "y": 0.2617, "width": 0.1309, "height": 0.2655}'),
 'LOW', FALSE,
 'BUSHING_BASE', 'Surface corrosion detected on bushing base. Rust visible with paint degradation.', 'yolov8_transformer_aerial_v3', 'v2.1';

-- Batch 22/34
INSERT INTO UTILITIES_GRID_RELIABILITY.UNSTRUCTURED.CV_DETECTIONS 
(DETECTION_ID, INSPECTION_ID, ASSET_ID, DETECTION_TYPE, CONFIDENCE_SCORE, BOUNDING_BOX, 
 SEVERITY_LEVEL, REQUIRES_IMMEDIATE_ACTION, DETECTED_AT_COMPONENT, DESCRIPTION, MODEL_NAME, MODEL_VERSION)
SELECT 
 'DET-VIS-T-SS002-001-20250409-020-001', 'VIS-T-SS002-001-20250409-020', 'T-SS002-001',
 'CORROSION', 0.9285, PARSE_JSON('{"x": 0.5868, "y": 0.4734, "width": 0.2934, "height": 0.0563}'),
 'MEDIUM', FALSE,
 'MOUNTING_BRACKETS', 'Surface corrosion detected on mounting brackets. Rust visible with paint degradation.', 'temporal_defect_detector_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS002-001-20250409-020-002', 'VIS-T-SS002-001-20250409-020', 'T-SS002-001',
 'STRUCTURAL_DAMAGE', 0.8762, PARSE_JSON('{"x": 0.5887, "y": 0.6906, "width": 0.1219, "height": 0.2122}'),
 'MEDIUM', FALSE,
 'ENCLOSURE', 'Structural integrity compromised at enclosure. Requires engineering assessment.', 'temporal_defect_detector_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS077-001-20251106-021-001', 'VIS-T-SS077-001-20251106-021', 'T-SS077-001',
 'STRUCTURAL_DAMAGE', 0.7949, PARSE_JSON('{"x": 0.6866, "y": 0.1763, "width": 0.1581, "height": 0.2866}'),
 'MEDIUM', FALSE,
 'SUPPORT_STRUCTURE', 'Structural integrity compromised at support structure. Requires engineering assessment.', 'yolov8_transformer_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS077-001-20251106-021-002', 'VIS-T-SS077-001-20251106-021', 'T-SS077-001',
 'HOTSPOT', 0.9387, PARSE_JSON('{"x": 0.1621, "y": 0.2225, "width": 0.0707, "height": 0.2941}'),
 'CRITICAL', FALSE,
 'LOAD_CONNECTION', 'Hot spot identified via infrared scan. load connection operating 47°C above normal.', 'yolov8_transformer_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS091-001-20250120-022-001', 'VIS-T-SS091-001-20250120-022', 'T-SS091-001',
 'HOTSPOT', 0.9771, PARSE_JSON('{"x": 0.4023, "y": 0.4943, "width": 0.221, "height": 0.1098}'),
 'HIGH', TRUE,
 'TAP_CHANGER', 'Elevated temperature on tap changer. Possible loose connection or high resistance.', 'thermal_anomaly_detector_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS019-001-20250815-023-001', 'VIS-T-SS019-001-20250815-023', 'T-SS019-001',
 'HOTSPOT', 0.9461, PARSE_JSON('{"x": 0.3857, "y": 0.3614, "width": 0.0744, "height": 0.2225}'),
 'HIGH', FALSE,
 'RADIATOR', 'Hot spot identified via infrared scan. radiator operating 26°C above normal.', 'temporal_defect_detector_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS019-001-20250815-023-002', 'VIS-T-SS019-001-20250815-023', 'T-SS019-001',
 'LEAK', 0.8606, PARSE_JSON('{"x": 0.1129, "y": 0.4075, "width": 0.1456, "height": 0.0816}'),
 'HIGH', FALSE,
 'RADIATOR_JOINT', 'Seal failure on radiator joint allowing fluid escape.', 'temporal_defect_detector_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS089-001-20250518-024-001', 'VIS-T-SS089-001-20250518-024', 'T-SS089-001',
 'VEGETATION', 0.921, PARSE_JSON('{"x": 0.1499, "y": 0.4629, "width": 0.1356, "height": 0.2208}'),
 'MEDIUM', FALSE,
 'ACCESS_ROAD', 'Excessive vegetation growth detected. Clearance violation at access road.', 'yolov8_transformer_aerial_v3', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS089-001-20250518-024-002', 'VIS-T-SS089-001-20250518-024', 'T-SS089-001',
 'CORROSION', 0.9058, PARSE_JSON('{"x": 0.1505, "y": 0.6406, "width": 0.0634, "height": 0.2733}'),
 'MEDIUM', FALSE,
 'TANK', 'Moderate to severe corrosion present. Metal oxidation advancing on tank.', 'yolov8_transformer_aerial_v3', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS089-001-20250518-024-003', 'VIS-T-SS089-001-20250518-024', 'T-SS089-001',
 'LEAK', 0.9218, PARSE_JSON('{"x": 0.2106, "y": 0.4203, "width": 0.0587, "height": 0.0595}'),
 'LOW', FALSE,
 'GASKET', 'Evidence of historical leakage on gasket. Surface contamination present.', 'yolov8_transformer_aerial_v3', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS016-001-20250409-025-001', 'VIS-T-SS016-001-20250409-025', 'T-SS016-001',
 'STRUCTURAL_DAMAGE', 0.8172, PARSE_JSON('{"x": 0.3652, "y": 0.4395, "width": 0.2362, "height": 0.1097}'),
 'CRITICAL', TRUE,
 'MOUNTING', 'Structural integrity compromised at mounting. Requires engineering assessment.', 'yolov8_transformer_aerial_v3', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS016-001-20250409-025-002', 'VIS-T-SS016-001-20250409-025', 'T-SS016-001',
 'CORROSION', 0.8074, PARSE_JSON('{"x": 0.5355, "y": 0.6251, "width": 0.1595, "height": 0.0522}'),
 'MEDIUM', FALSE,
 'MOUNTING_BRACKETS', 'Moderate to severe corrosion present. Metal oxidation advancing on mounting brackets.', 'yolov8_transformer_aerial_v3', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS016-001-20250409-025-003', 'VIS-T-SS016-001-20250409-025', 'T-SS016-001',
 'CORROSION', 0.8406, PARSE_JSON('{"x": 0.5716, "y": 0.4651, "width": 0.213, "height": 0.2901}'),
 'MEDIUM', FALSE,
 'TANK', 'Surface corrosion detected on tank. Rust visible with paint degradation.', 'yolov8_transformer_aerial_v3', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS016-001-20250409-025-004', 'VIS-T-SS016-001-20250409-025', 'T-SS016-001',
 'LEAK', 0.9476, PARSE_JSON('{"x": 0.6527, "y": 0.472, "width": 0.158, "height": 0.2657}'),
 'HIGH', TRUE,
 'GASKET', 'Evidence of historical leakage on gasket. Surface contamination present.', 'yolov8_transformer_aerial_v3', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS016-001-20250409-025-005', 'VIS-T-SS016-001-20250409-025', 'T-SS016-001',
 'STRUCTURAL_DAMAGE', 0.9335, PARSE_JSON('{"x": 0.1308, "y": 0.3462, "width": 0.0857, "height": 0.2607}'),
 'MEDIUM', FALSE,
 'SUPPORT_STRUCTURE', 'Physical damage observed on support structure. Deformation or breakage present.', 'yolov8_transformer_aerial_v3', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS075-001-20250427-026-001', 'VIS-T-SS075-001-20250427-026', 'T-SS075-001',
 'VEGETATION', 0.9414, PARSE_JSON('{"x": 0.4534, "y": 0.6238, "width": 0.2612, "height": 0.0719}'),
 'LOW', FALSE,
 'ACCESS_ROAD', 'Tree branches encroaching within clearance zone near access road.', 'pointcloud_structural_analyzer_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS075-001-20250427-026-002', 'VIS-T-SS075-001-20250427-026', 'T-SS075-001',
 'LEAK', 0.9422, PARSE_JSON('{"x": 0.1563, "y": 0.5818, "width": 0.0717, "height": 0.0566}'),
 'MEDIUM', FALSE,
 'GASKET', 'Active oil leak detected at gasket. Visible staining and dripping.', 'pointcloud_structural_analyzer_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS014-001-20250516-027-001', 'VIS-T-SS014-001-20250516-027', 'T-SS014-001',
 'CORROSION', 0.8728, PARSE_JSON('{"x": 0.5342, "y": 0.5085, "width": 0.1522, "height": 0.2202}'),
 'LOW', FALSE,
 'TANK', 'Surface corrosion detected on tank. Rust visible with paint degradation.', 'yolov8_transformer_aerial_v3', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS014-001-20250516-027-002', 'VIS-T-SS014-001-20250516-027', 'T-SS014-001',
 'CORROSION', 0.8863, PARSE_JSON('{"x": 0.1786, "y": 0.4263, "width": 0.1022, "height": 0.1137}'),
 'MEDIUM', FALSE,
 'TANK', 'Surface corrosion detected on tank. Rust visible with paint degradation.', 'yolov8_transformer_aerial_v3', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS014-001-20250516-027-003', 'VIS-T-SS014-001-20250516-027', 'T-SS014-001',
 'CORROSION', 0.9157, PARSE_JSON('{"x": 0.3536, "y": 0.4766, "width": 0.0983, "height": 0.079}'),
 'HIGH', FALSE,
 'BUSHING_BASE', 'Corrosion patterns suggest moisture ingress. Located on bushing base.', 'yolov8_transformer_aerial_v3', 'v2.1';

-- Batch 23/34
INSERT INTO UTILITIES_GRID_RELIABILITY.UNSTRUCTURED.CV_DETECTIONS 
(DETECTION_ID, INSPECTION_ID, ASSET_ID, DETECTION_TYPE, CONFIDENCE_SCORE, BOUNDING_BOX, 
 SEVERITY_LEVEL, REQUIRES_IMMEDIATE_ACTION, DETECTED_AT_COMPONENT, DESCRIPTION, MODEL_NAME, MODEL_VERSION)
SELECT 
 'DET-VIS-T-SS014-001-20250516-027-004', 'VIS-T-SS014-001-20250516-027', 'T-SS014-001',
 'STRUCTURAL_DAMAGE', 0.8626, PARSE_JSON('{"x": 0.3626, "y": 0.2145, "width": 0.052, "height": 0.2797}'),
 'CRITICAL', FALSE,
 'FOUNDATION', 'Deterioration of foundation support structure. Potential stability concern.', 'yolov8_transformer_aerial_v3', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS024-001-20250908-028-001', 'VIS-T-SS024-001-20250908-028', 'T-SS024-001',
 'LEAK', 0.8832, PARSE_JSON('{"x": 0.2618, "y": 0.4436, "width": 0.2667, "height": 0.1534}'),
 'LOW', FALSE,
 'GASKET', 'Evidence of historical leakage on gasket. Surface contamination present.', 'yolov8_transformer_aerial_v3', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS004-001-20250114-029-001', 'VIS-T-SS004-001-20250114-029', 'T-SS004-001',
 'HOTSPOT', 0.9631, PARSE_JSON('{"x": 0.2847, "y": 0.1713, "width": 0.1632, "height": 0.2457}'),
 'CRITICAL', TRUE,
 'TAP_CHANGER', 'Thermal anomaly detected at tap changer. Temperature differential: 25°C above ambient.', 'thermal_anomaly_detector_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS004-001-20250114-029-002', 'VIS-T-SS004-001-20250114-029', 'T-SS004-001',
 'HOTSPOT', 0.9555, PARSE_JSON('{"x": 0.1718, "y": 0.4256, "width": 0.097, "height": 0.2558}'),
 'HIGH', TRUE,
 'BUSHING_CONNECTION', 'Hot spot identified via infrared scan. bushing connection operating 43°C above normal.', 'thermal_anomaly_detector_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS004-001-20250114-029-003', 'VIS-T-SS004-001-20250114-029', 'T-SS004-001',
 'CORROSION', 0.8246, PARSE_JSON('{"x": 0.474, "y": 0.6044, "width": 0.1822, "height": 0.2769}'),
 'MEDIUM', FALSE,
 'TANK', 'Corrosion patterns suggest moisture ingress. Located on tank.', 'thermal_anomaly_detector_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS004-001-20250114-029-004', 'VIS-T-SS004-001-20250114-029', 'T-SS004-001',
 'HOTSPOT', 0.9085, PARSE_JSON('{"x": 0.2617, "y": 0.5221, "width": 0.1789, "height": 0.1167}'),
 'CRITICAL', FALSE,
 'LOAD_CONNECTION', 'Hot spot identified via infrared scan. load connection operating 21°C above normal.', 'thermal_anomaly_detector_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS004-001-20250114-029-005', 'VIS-T-SS004-001-20250114-029', 'T-SS004-001',
 'LEAK', 0.9298, PARSE_JSON('{"x": 0.676, "y": 0.5682, "width": 0.1969, "height": 0.2269}'),
 'MEDIUM', FALSE,
 'RADIATOR_JOINT', 'Active oil leak detected at radiator joint. Visible staining and dripping.', 'thermal_anomaly_detector_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS003-001-20250719-031-001', 'VIS-T-SS003-001-20250719-031', 'T-SS003-001',
 'STRUCTURAL_DAMAGE', 0.8458, PARSE_JSON('{"x": 0.3991, "y": 0.5498, "width": 0.059, "height": 0.257}'),
 'HIGH', FALSE,
 'FOUNDATION', 'Deterioration of foundation support structure. Potential stability concern.', 'yolov8_transformer_aerial_v3', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS003-001-20250719-031-002', 'VIS-T-SS003-001-20250719-031', 'T-SS003-001',
 'VEGETATION', 0.9553, PARSE_JSON('{"x": 0.3626, "y": 0.2933, "width": 0.2287, "height": 0.2035}'),
 'HIGH', FALSE,
 'FENCE_LINE', 'Tree branches encroaching within clearance zone near fence line.', 'yolov8_transformer_aerial_v3', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS058-001-20250331-032-001', 'VIS-T-SS058-001-20250331-032', 'T-SS058-001',
 'LEAK', 0.9834, PARSE_JSON('{"x": 0.2916, "y": 0.3515, "width": 0.1466, "height": 0.2377}'),
 'LOW', FALSE,
 'RADIATOR_JOINT', 'Active oil leak detected at radiator joint. Visible staining and dripping.', 'yolov8_transformer_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS058-001-20250331-032-002', 'VIS-T-SS058-001-20250331-032', 'T-SS058-001',
 'VEGETATION', 0.9742, PARSE_JSON('{"x": 0.3385, "y": 0.5505, "width": 0.0574, "height": 0.0631}'),
 'LOW', FALSE,
 'ACCESS_ROAD', 'Grass and brush overgrowth affecting access to access road.', 'yolov8_transformer_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS058-001-20250331-032-003', 'VIS-T-SS058-001-20250331-032', 'T-SS058-001',
 'HOTSPOT', 0.942, PARSE_JSON('{"x": 0.466, "y": 0.3663, "width": 0.2006, "height": 0.0735}'),
 'MEDIUM', FALSE,
 'LOAD_CONNECTION', 'Elevated temperature on load connection. Possible loose connection or high resistance.', 'yolov8_transformer_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS009-001-20241230-033-001', 'VIS-T-SS009-001-20241230-033', 'T-SS009-001',
 'LEAK', 0.892, PARSE_JSON('{"x": 0.5985, "y": 0.1975, "width": 0.1878, "height": 0.1394}'),
 'LOW', FALSE,
 'RADIATOR_JOINT', 'Seal failure on radiator joint allowing fluid escape.', 'yolov8_transformer_aerial_v3', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS009-001-20241230-033-002', 'VIS-T-SS009-001-20241230-033', 'T-SS009-001',
 'CORROSION', 0.891, PARSE_JSON('{"x": 0.5394, "y": 0.562, "width": 0.2057, "height": 0.1707}'),
 'HIGH', FALSE,
 'RADIATOR', 'Moderate to severe corrosion present. Metal oxidation advancing on radiator.', 'yolov8_transformer_aerial_v3', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS009-001-20241230-033-003', 'VIS-T-SS009-001-20241230-033', 'T-SS009-001',
 'STRUCTURAL_DAMAGE', 0.8625, PARSE_JSON('{"x": 0.1448, "y": 0.6702, "width": 0.243, "height": 0.1949}'),
 'HIGH', FALSE,
 'MOUNTING', 'Deterioration of mounting support structure. Potential stability concern.', 'yolov8_transformer_aerial_v3', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS082-001-20250406-034-001', 'VIS-T-SS082-001-20250406-034', 'T-SS082-001',
 'STRUCTURAL_DAMAGE', 0.7919, PARSE_JSON('{"x": 0.2604, "y": 0.1163, "width": 0.1855, "height": 0.1838}'),
 'LOW', FALSE,
 'FOUNDATION', 'Structural integrity compromised at foundation. Requires engineering assessment.', 'yolov8_transformer_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS082-001-20250406-034-002', 'VIS-T-SS082-001-20250406-034', 'T-SS082-001',
 'STRUCTURAL_DAMAGE', 0.9261, PARSE_JSON('{"x": 0.4925, "y": 0.6026, "width": 0.1826, "height": 0.2005}'),
 'MEDIUM', FALSE,
 'SUPPORT_STRUCTURE', 'Physical damage observed on support structure. Deformation or breakage present.', 'yolov8_transformer_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS082-001-20250406-034-003', 'VIS-T-SS082-001-20250406-034', 'T-SS082-001',
 'LEAK', 0.8815, PARSE_JSON('{"x": 0.1472, "y": 0.1527, "width": 0.2957, "height": 0.0598}'),
 'MEDIUM', FALSE,
 'BUSHING_SEAL', 'Seal failure on bushing seal allowing fluid escape.', 'yolov8_transformer_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS060-001-20250427-036-001', 'VIS-T-SS060-001-20250427-036', 'T-SS060-001',
 'HOTSPOT', 0.9554, PARSE_JSON('{"x": 0.1213, "y": 0.3986, "width": 0.0822, "height": 0.2418}'),
 'MEDIUM', FALSE,
 'LOAD_CONNECTION', 'Thermal anomaly detected at load connection. Temperature differential: 37°C above ambient.', 'yolov8_transformer_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS060-001-20250427-036-002', 'VIS-T-SS060-001-20250427-036', 'T-SS060-001',
 'HOTSPOT', 0.9706, PARSE_JSON('{"x": 0.2465, "y": 0.2571, "width": 0.2563, "height": 0.1136}'),
 'MEDIUM', FALSE,
 'LOAD_CONNECTION', 'Thermal anomaly detected at load connection. Temperature differential: 34°C above ambient.', 'yolov8_transformer_v2', 'v2.1';

-- Batch 24/34
INSERT INTO UTILITIES_GRID_RELIABILITY.UNSTRUCTURED.CV_DETECTIONS 
(DETECTION_ID, INSPECTION_ID, ASSET_ID, DETECTION_TYPE, CONFIDENCE_SCORE, BOUNDING_BOX, 
 SEVERITY_LEVEL, REQUIRES_IMMEDIATE_ACTION, DETECTED_AT_COMPONENT, DESCRIPTION, MODEL_NAME, MODEL_VERSION)
SELECT 
 'DET-VIS-T-SS060-001-20250427-036-003', 'VIS-T-SS060-001-20250427-036', 'T-SS060-001',
 'LEAK', 0.9558, PARSE_JSON('{"x": 0.6427, "y": 0.324, "width": 0.2587, "height": 0.2277}'),
 'MEDIUM', FALSE,
 'RADIATOR_JOINT', 'Active oil leak detected at radiator joint. Visible staining and dripping.', 'yolov8_transformer_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS060-001-20250427-036-004', 'VIS-T-SS060-001-20250427-036', 'T-SS060-001',
 'STRUCTURAL_DAMAGE', 0.8865, PARSE_JSON('{"x": 0.3547, "y": 0.2695, "width": 0.0706, "height": 0.0906}'),
 'LOW', FALSE,
 'SUPPORT_STRUCTURE', 'Physical damage observed on support structure. Deformation or breakage present.', 'yolov8_transformer_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS060-001-20250427-036-005', 'VIS-T-SS060-001-20250427-036', 'T-SS060-001',
 'HOTSPOT', 0.889, PARSE_JSON('{"x": 0.1656, "y": 0.4709, "width": 0.1301, "height": 0.2197}'),
 'CRITICAL', FALSE,
 'BUSHING_CONNECTION', 'Thermal anomaly detected at bushing connection. Temperature differential: 16°C above ambient.', 'yolov8_transformer_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS013-001-20250825-037-001', 'VIS-T-SS013-001-20250825-037', 'T-SS013-001',
 'STRUCTURAL_DAMAGE', 0.9064, PARSE_JSON('{"x": 0.1857, "y": 0.3465, "width": 0.2893, "height": 0.1445}'),
 'LOW', FALSE,
 'MOUNTING', 'Deterioration of mounting support structure. Potential stability concern.', 'thermal_anomaly_detector_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS013-001-20250825-037-002', 'VIS-T-SS013-001-20250825-037', 'T-SS013-001',
 'CORROSION', 0.8273, PARSE_JSON('{"x": 0.3231, "y": 0.2389, "width": 0.1867, "height": 0.1948}'),
 'HIGH', FALSE,
 'BUSHING_BASE', 'Corrosion patterns suggest moisture ingress. Located on bushing base.', 'thermal_anomaly_detector_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS013-001-20250825-037-003', 'VIS-T-SS013-001-20250825-037', 'T-SS013-001',
 'LEAK', 0.9833, PARSE_JSON('{"x": 0.557, "y": 0.2239, "width": 0.2328, "height": 0.2228}'),
 'HIGH', TRUE,
 'RADIATOR_JOINT', 'Seal failure on radiator joint allowing fluid escape.', 'thermal_anomaly_detector_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS013-001-20250825-037-004', 'VIS-T-SS013-001-20250825-037', 'T-SS013-001',
 'HOTSPOT', 0.9358, PARSE_JSON('{"x": 0.6752, "y": 0.3646, "width": 0.159, "height": 0.1188}'),
 'HIGH', TRUE,
 'TAP_CHANGER', 'Elevated temperature on tap changer. Possible loose connection or high resistance.', 'thermal_anomaly_detector_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS068-001-20250216-038-001', 'VIS-T-SS068-001-20250216-038', 'T-SS068-001',
 'CRACK', 0.8261, PARSE_JSON('{"x": 0.366, "y": 0.1102, "width": 0.1303, "height": 0.1066}'),
 'HIGH', TRUE,
 'INSULATOR', 'Structural crack identified. Propagation risk on insulator.', 'temporal_defect_detector_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS064-001-20250902-039-001', 'VIS-T-SS064-001-20250902-039', 'T-SS064-001',
 'HOTSPOT', 0.9243, PARSE_JSON('{"x": 0.4329, "y": 0.1899, "width": 0.0643, "height": 0.2582}'),
 'LOW', FALSE,
 'TAP_CHANGER', 'Thermal anomaly detected at tap changer. Temperature differential: 15°C above ambient.', 'thermal_anomaly_detector_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS064-001-20250902-039-002', 'VIS-T-SS064-001-20250902-039', 'T-SS064-001',
 'LEAK', 0.8694, PARSE_JSON('{"x": 0.3773, "y": 0.4237, "width": 0.146, "height": 0.103}'),
 'MEDIUM', FALSE,
 'GASKET', 'Evidence of historical leakage on gasket. Surface contamination present.', 'thermal_anomaly_detector_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS078-001-20250501-040-001', 'VIS-T-SS078-001-20250501-040', 'T-SS078-001',
 'CORROSION', 0.9384, PARSE_JSON('{"x": 0.3172, "y": 0.6674, "width": 0.1921, "height": 0.1457}'),
 'HIGH', FALSE,
 'MOUNTING_BRACKETS', 'Corrosion patterns suggest moisture ingress. Located on mounting brackets.', 'pointcloud_structural_analyzer_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS001-001-20251105-042-001', 'VIS-T-SS001-001-20251105-042', 'T-SS001-001',
 'VEGETATION', 0.9456, PARSE_JSON('{"x": 0.2325, "y": 0.6887, "width": 0.1286, "height": 0.2391}'),
 'HIGH', FALSE,
 'BASE', 'Tree branches encroaching within clearance zone near base.', 'yolov8_transformer_aerial_v3', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS001-001-20251105-042-002', 'VIS-T-SS001-001-20251105-042', 'T-SS001-001',
 'STRUCTURAL_DAMAGE', 0.9103, PARSE_JSON('{"x": 0.2812, "y": 0.1985, "width": 0.1532, "height": 0.2521}'),
 'CRITICAL', FALSE,
 'FOUNDATION', 'Physical damage observed on foundation. Deformation or breakage present.', 'yolov8_transformer_aerial_v3', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS006-001-20241125-043-001', 'VIS-T-SS006-001-20241125-043', 'T-SS006-001',
 'CORROSION', 0.8126, PARSE_JSON('{"x": 0.2732, "y": 0.4649, "width": 0.117, "height": 0.0748}'),
 'LOW', FALSE,
 'TANK', 'Surface corrosion detected on tank. Rust visible with paint degradation.', 'yolov8_transformer_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS006-001-20241125-043-002', 'VIS-T-SS006-001-20241125-043', 'T-SS006-001',
 'HOTSPOT', 0.8998, PARSE_JSON('{"x": 0.6209, "y": 0.2718, "width": 0.1089, "height": 0.1651}'),
 'CRITICAL', TRUE,
 'BUSHING_CONNECTION', 'Thermal anomaly detected at bushing connection. Temperature differential: 31°C above ambient.', 'yolov8_transformer_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS006-001-20241125-043-003', 'VIS-T-SS006-001-20241125-043', 'T-SS006-001',
 'HOTSPOT', 0.8847, PARSE_JSON('{"x": 0.2358, "y": 0.1293, "width": 0.2608, "height": 0.0611}'),
 'HIGH', TRUE,
 'LOAD_CONNECTION', 'Hot spot identified via infrared scan. load connection operating 41°C above normal.', 'yolov8_transformer_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS040-001-20251023-044-001', 'VIS-T-SS040-001-20251023-044', 'T-SS040-001',
 'CORROSION', 0.7841, PARSE_JSON('{"x": 0.517, "y": 0.4954, "width": 0.2969, "height": 0.0534}'),
 'HIGH', FALSE,
 'BUSHING_BASE', 'Corrosion patterns suggest moisture ingress. Located on bushing base.', 'temporal_defect_detector_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS040-001-20251023-044-002', 'VIS-T-SS040-001-20251023-044', 'T-SS040-001',
 'STRUCTURAL_DAMAGE', 0.7959, PARSE_JSON('{"x": 0.4108, "y": 0.6622, "width": 0.06, "height": 0.0852}'),
 'LOW', FALSE,
 'SUPPORT_STRUCTURE', 'Deterioration of support structure support structure. Potential stability concern.', 'temporal_defect_detector_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS057-001-20250629-045-001', 'VIS-T-SS057-001-20250629-045', 'T-SS057-001',
 'LEAK', 0.9214, PARSE_JSON('{"x": 0.6889, "y": 0.3744, "width": 0.1187, "height": 0.2121}'),
 'LOW', FALSE,
 'BUSHING_SEAL', 'Active oil leak detected at bushing seal. Visible staining and dripping.', 'yolov8_transformer_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS057-001-20250629-045-002', 'VIS-T-SS057-001-20250629-045', 'T-SS057-001',
 'STRUCTURAL_DAMAGE', 0.8322, PARSE_JSON('{"x": 0.1532, "y": 0.1099, "width": 0.2359, "height": 0.1372}'),
 'MEDIUM', FALSE,
 'SUPPORT_STRUCTURE', 'Deterioration of support structure support structure. Potential stability concern.', 'yolov8_transformer_v2', 'v2.1';

-- Batch 25/34
INSERT INTO UTILITIES_GRID_RELIABILITY.UNSTRUCTURED.CV_DETECTIONS 
(DETECTION_ID, INSPECTION_ID, ASSET_ID, DETECTION_TYPE, CONFIDENCE_SCORE, BOUNDING_BOX, 
 SEVERITY_LEVEL, REQUIRES_IMMEDIATE_ACTION, DETECTED_AT_COMPONENT, DESCRIPTION, MODEL_NAME, MODEL_VERSION)
SELECT 
 'DET-VIS-T-SS057-001-20250629-045-003', 'VIS-T-SS057-001-20250629-045', 'T-SS057-001',
 'LEAK', 0.9122, PARSE_JSON('{"x": 0.6459, "y": 0.2029, "width": 0.2516, "height": 0.2606}'),
 'CRITICAL', FALSE,
 'RADIATOR_JOINT', 'Evidence of historical leakage on radiator joint. Surface contamination present.', 'yolov8_transformer_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS031-001-20250411-046-001', 'VIS-T-SS031-001-20250411-046', 'T-SS031-001',
 'HOTSPOT', 0.9534, PARSE_JSON('{"x": 0.4791, "y": 0.1379, "width": 0.2197, "height": 0.1513}'),
 'CRITICAL', TRUE,
 'BUSHING_CONNECTION', 'Hot spot identified via infrared scan. bushing connection operating 37°C above normal.', 'pointcloud_structural_analyzer_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS032-001-20250403-047-001', 'VIS-T-SS032-001-20250403-047', 'T-SS032-001',
 'LEAK', 0.8775, PARSE_JSON('{"x": 0.603, "y": 0.6207, "width": 0.1201, "height": 0.1621}'),
 'CRITICAL', FALSE,
 'RADIATOR_JOINT', 'Evidence of historical leakage on radiator joint. Surface contamination present.', 'temporal_defect_detector_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS032-001-20250403-047-002', 'VIS-T-SS032-001-20250403-047', 'T-SS032-001',
 'STRUCTURAL_DAMAGE', 0.9526, PARSE_JSON('{"x": 0.1294, "y": 0.3129, "width": 0.2357, "height": 0.2763}'),
 'LOW', FALSE,
 'SUPPORT_STRUCTURE', 'Physical damage observed on support structure. Deformation or breakage present.', 'temporal_defect_detector_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS032-001-20250403-047-003', 'VIS-T-SS032-001-20250403-047', 'T-SS032-001',
 'CRACK', 0.9658, PARSE_JSON('{"x": 0.141, "y": 0.1033, "width": 0.0905, "height": 0.2092}'),
 'MEDIUM', FALSE,
 'BUSHING', 'Multiple hairline cracks visible on bushing surface.', 'temporal_defect_detector_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS091-001-20250920-048-001', 'VIS-T-SS091-001-20250920-048', 'T-SS091-001',
 'LEAK', 0.861, PARSE_JSON('{"x": 0.5074, "y": 0.6711, "width": 0.0704, "height": 0.2472}'),
 'MEDIUM', FALSE,
 'BUSHING_SEAL', 'Evidence of historical leakage on bushing seal. Surface contamination present.', 'temporal_defect_detector_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS091-001-20250920-048-002', 'VIS-T-SS091-001-20250920-048', 'T-SS091-001',
 'VEGETATION', 0.9307, PARSE_JSON('{"x": 0.4096, "y": 0.5168, "width": 0.1024, "height": 0.2198}'),
 'MEDIUM', FALSE,
 'ACCESS_ROAD', 'Grass and brush overgrowth affecting access to access road.', 'temporal_defect_detector_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS091-001-20250920-048-003', 'VIS-T-SS091-001-20250920-048', 'T-SS091-001',
 'STRUCTURAL_DAMAGE', 0.95, PARSE_JSON('{"x": 0.1535, "y": 0.641, "width": 0.2804, "height": 0.198}'),
 'MEDIUM', FALSE,
 'ENCLOSURE', 'Physical damage observed on enclosure. Deformation or breakage present.', 'temporal_defect_detector_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS002-001-20250120-051-001', 'VIS-T-SS002-001-20250120-051', 'T-SS002-001',
 'VEGETATION', 0.9391, PARSE_JSON('{"x": 0.5801, "y": 0.5296, "width": 0.2496, "height": 0.1345}'),
 'HIGH', FALSE,
 'CLEARANCE_ZONE', 'Grass and brush overgrowth affecting access to clearance zone.', 'yolov8_transformer_aerial_v3', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS067-001-20241227-056-001', 'VIS-T-SS067-001-20241227-056', 'T-SS067-001',
 'HOTSPOT', 0.9332, PARSE_JSON('{"x": 0.2318, "y": 0.4289, "width": 0.2415, "height": 0.2074}'),
 'HIGH', TRUE,
 'BUSHING_CONNECTION', 'Elevated temperature on bushing connection. Possible loose connection or high resistance.', 'thermal_anomaly_detector_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS067-001-20241227-056-002', 'VIS-T-SS067-001-20241227-056', 'T-SS067-001',
 'CRACK', 0.9266, PARSE_JSON('{"x": 0.2361, "y": 0.6072, "width": 0.2312, "height": 0.0504}'),
 'LOW', FALSE,
 'BUSHING', 'Multiple hairline cracks visible on bushing surface.', 'thermal_anomaly_detector_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS067-001-20241227-056-003', 'VIS-T-SS067-001-20241227-056', 'T-SS067-001',
 'VEGETATION', 0.9405, PARSE_JSON('{"x": 0.3038, "y": 0.3822, "width": 0.0655, "height": 0.2973}'),
 'LOW', FALSE,
 'FENCE_LINE', 'Tree branches encroaching within clearance zone near fence line.', 'thermal_anomaly_detector_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS003-001-20250822-057-001', 'VIS-T-SS003-001-20250822-057', 'T-SS003-001',
 'LEAK', 0.8688, PARSE_JSON('{"x": 0.4824, "y": 0.3916, "width": 0.0659, "height": 0.072}'),
 'MEDIUM', FALSE,
 'BUSHING_SEAL', 'Active oil leak detected at bushing seal. Visible staining and dripping.', 'thermal_anomaly_detector_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS074-001-20251026-058-001', 'VIS-T-SS074-001-20251026-058', 'T-SS074-001',
 'CORROSION', 0.7707, PARSE_JSON('{"x": 0.5434, "y": 0.214, "width": 0.0841, "height": 0.2409}'),
 'LOW', FALSE,
 'MOUNTING_BRACKETS', 'Surface corrosion detected on mounting brackets. Rust visible with paint degradation.', 'pointcloud_structural_analyzer_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS031-001-20250121-059-001', 'VIS-T-SS031-001-20250121-059', 'T-SS031-001',
 'HOTSPOT', 0.9055, PARSE_JSON('{"x": 0.1655, "y": 0.6309, "width": 0.2393, "height": 0.2703}'),
 'HIGH', TRUE,
 'BUSHING_CONNECTION', 'Hot spot identified via infrared scan. bushing connection operating 48°C above normal.', 'pointcloud_structural_analyzer_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS031-001-20250121-059-002', 'VIS-T-SS031-001-20250121-059', 'T-SS031-001',
 'CRACK', 0.9033, PARSE_JSON('{"x": 0.3991, "y": 0.232, "width": 0.0716, "height": 0.2543}'),
 'MEDIUM', FALSE,
 'BUSHING', 'Structural crack identified. Propagation risk on bushing.', 'pointcloud_structural_analyzer_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS031-001-20250121-059-003', 'VIS-T-SS031-001-20250121-059', 'T-SS031-001',
 'STRUCTURAL_DAMAGE', 0.8322, PARSE_JSON('{"x": 0.1917, "y": 0.2519, "width": 0.1991, "height": 0.2136}'),
 'LOW', FALSE,
 'ENCLOSURE', 'Physical damage observed on enclosure. Deformation or breakage present.', 'pointcloud_structural_analyzer_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS031-001-20250121-059-004', 'VIS-T-SS031-001-20250121-059', 'T-SS031-001',
 'HOTSPOT', 0.9543, PARSE_JSON('{"x": 0.4831, "y": 0.1904, "width": 0.2013, "height": 0.0634}'),
 'CRITICAL', FALSE,
 'TAP_CHANGER', 'Thermal anomaly detected at tap changer. Temperature differential: 35°C above ambient.', 'pointcloud_structural_analyzer_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS039-001-20251001-060-001', 'VIS-T-SS039-001-20251001-060', 'T-SS039-001',
 'VEGETATION', 0.9824, PARSE_JSON('{"x": 0.1872, "y": 0.1826, "width": 0.2568, "height": 0.2407}'),
 'HIGH', FALSE,
 'BASE', 'Excessive vegetation growth detected. Clearance violation at base.', 'temporal_defect_detector_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS039-001-20251001-060-002', 'VIS-T-SS039-001-20251001-060', 'T-SS039-001',
 'VEGETATION', 0.9358, PARSE_JSON('{"x": 0.1067, "y": 0.1774, "width": 0.2414, "height": 0.0653}'),
 'MEDIUM', FALSE,
 'CLEARANCE_ZONE', 'Grass and brush overgrowth affecting access to clearance zone.', 'temporal_defect_detector_v1', 'v2.1';

-- Batch 26/34
INSERT INTO UTILITIES_GRID_RELIABILITY.UNSTRUCTURED.CV_DETECTIONS 
(DETECTION_ID, INSPECTION_ID, ASSET_ID, DETECTION_TYPE, CONFIDENCE_SCORE, BOUNDING_BOX, 
 SEVERITY_LEVEL, REQUIRES_IMMEDIATE_ACTION, DETECTED_AT_COMPONENT, DESCRIPTION, MODEL_NAME, MODEL_VERSION)
SELECT 
 'DET-VIS-T-SS078-001-20250711-061-001', 'VIS-T-SS078-001-20250711-061', 'T-SS078-001',
 'HOTSPOT', 0.9712, PARSE_JSON('{"x": 0.5751, "y": 0.586, "width": 0.1964, "height": 0.1319}'),
 'CRITICAL', TRUE,
 'LOAD_CONNECTION', 'Hot spot identified via infrared scan. load connection operating 49°C above normal.', 'temporal_defect_detector_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS078-001-20250711-061-002', 'VIS-T-SS078-001-20250711-061', 'T-SS078-001',
 'VEGETATION', 0.9662, PARSE_JSON('{"x": 0.4322, "y": 0.6868, "width": 0.2854, "height": 0.1791}'),
 'LOW', FALSE,
 'BASE', 'Excessive vegetation growth detected. Clearance violation at base.', 'temporal_defect_detector_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS078-001-20250711-061-003', 'VIS-T-SS078-001-20250711-061', 'T-SS078-001',
 'CORROSION', 0.7942, PARSE_JSON('{"x": 0.1741, "y": 0.4188, "width": 0.2447, "height": 0.2482}'),
 'CRITICAL', FALSE,
 'TANK', 'Surface corrosion detected on tank. Rust visible with paint degradation.', 'temporal_defect_detector_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS072-001-20251101-062-001', 'VIS-T-SS072-001-20251101-062', 'T-SS072-001',
 'CORROSION', 0.8344, PARSE_JSON('{"x": 0.5111, "y": 0.3158, "width": 0.2618, "height": 0.1482}'),
 'LOW', FALSE,
 'BUSHING_BASE', 'Surface corrosion detected on bushing base. Rust visible with paint degradation.', 'yolov8_transformer_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS072-001-20251101-062-002', 'VIS-T-SS072-001-20251101-062', 'T-SS072-001',
 'STRUCTURAL_DAMAGE', 0.8192, PARSE_JSON('{"x": 0.2234, "y": 0.1735, "width": 0.2666, "height": 0.0871}'),
 'MEDIUM', FALSE,
 'MOUNTING', 'Structural integrity compromised at mounting. Requires engineering assessment.', 'yolov8_transformer_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS064-001-20250216-063-001', 'VIS-T-SS064-001-20250216-063', 'T-SS064-001',
 'HOTSPOT', 0.9013, PARSE_JSON('{"x": 0.3551, "y": 0.6249, "width": 0.2634, "height": 0.1545}'),
 'HIGH', FALSE,
 'TAP_CHANGER', 'Thermal anomaly detected at tap changer. Temperature differential: 25°C above ambient.', 'thermal_anomaly_detector_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS064-001-20250216-063-002', 'VIS-T-SS064-001-20250216-063', 'T-SS064-001',
 'LEAK', 0.878, PARSE_JSON('{"x": 0.4345, "y": 0.2118, "width": 0.0912, "height": 0.2686}'),
 'LOW', FALSE,
 'RADIATOR_JOINT', 'Seal failure on radiator joint allowing fluid escape.', 'thermal_anomaly_detector_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS064-001-20250216-063-003', 'VIS-T-SS064-001-20250216-063', 'T-SS064-001',
 'STRUCTURAL_DAMAGE', 0.833, PARSE_JSON('{"x": 0.2597, "y": 0.5857, "width": 0.0715, "height": 0.2178}'),
 'MEDIUM', FALSE,
 'SUPPORT_STRUCTURE', 'Structural integrity compromised at support structure. Requires engineering assessment.', 'thermal_anomaly_detector_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS006-001-20250102-064-001', 'VIS-T-SS006-001-20250102-064', 'T-SS006-001',
 'VEGETATION', 0.9764, PARSE_JSON('{"x": 0.3724, "y": 0.1316, "width": 0.0641, "height": 0.0513}'),
 'MEDIUM', FALSE,
 'ACCESS_ROAD', 'Excessive vegetation growth detected. Clearance violation at access road.', 'yolov8_transformer_aerial_v3', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS037-001-20250902-066-001', 'VIS-T-SS037-001-20250902-066', 'T-SS037-001',
 'HOTSPOT', 0.9414, PARSE_JSON('{"x": 0.539, "y": 0.2713, "width": 0.0534, "height": 0.1282}'),
 'HIGH', FALSE,
 'RADIATOR', 'Elevated temperature on radiator. Possible loose connection or high resistance.', 'yolov8_transformer_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS043-001-20241207-067-001', 'VIS-T-SS043-001-20241207-067', 'T-SS043-001',
 'HOTSPOT', 0.8818, PARSE_JSON('{"x": 0.6317, "y": 0.6971, "width": 0.2353, "height": 0.2974}'),
 'CRITICAL', FALSE,
 'LOAD_CONNECTION', 'Elevated temperature on load connection. Possible loose connection or high resistance.', 'yolov8_transformer_aerial_v3', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS043-001-20241207-067-002', 'VIS-T-SS043-001-20241207-067', 'T-SS043-001',
 'CORROSION', 0.8723, PARSE_JSON('{"x": 0.4163, "y": 0.5784, "width": 0.2455, "height": 0.0692}'),
 'MEDIUM', FALSE,
 'TANK', 'Surface corrosion detected on tank. Rust visible with paint degradation.', 'yolov8_transformer_aerial_v3', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS055-001-20251024-068-001', 'VIS-T-SS055-001-20251024-068', 'T-SS055-001',
 'LEAK', 0.9635, PARSE_JSON('{"x": 0.2075, "y": 0.3995, "width": 0.1397, "height": 0.2434}'),
 'CRITICAL', FALSE,
 'VALVE', 'Seal failure on valve allowing fluid escape.', 'yolov8_transformer_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS055-001-20251024-068-002', 'VIS-T-SS055-001-20251024-068', 'T-SS055-001',
 'CRACK', 0.8958, PARSE_JSON('{"x": 0.5389, "y": 0.3753, "width": 0.0849, "height": 0.0939}'),
 'HIGH', FALSE,
 'INSULATOR', 'Structural crack identified. Propagation risk on insulator.', 'yolov8_transformer_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS055-001-20251024-068-003', 'VIS-T-SS055-001-20251024-068', 'T-SS055-001',
 'HOTSPOT', 0.8894, PARSE_JSON('{"x": 0.4066, "y": 0.5787, "width": 0.2628, "height": 0.2263}'),
 'HIGH', FALSE,
 'LOAD_CONNECTION', 'Hot spot identified via infrared scan. load connection operating 48°C above normal.', 'yolov8_transformer_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS055-001-20251024-068-004', 'VIS-T-SS055-001-20251024-068', 'T-SS055-001',
 'VEGETATION', 0.907, PARSE_JSON('{"x": 0.503, "y": 0.3628, "width": 0.2088, "height": 0.2259}'),
 'MEDIUM', FALSE,
 'BASE', 'Grass and brush overgrowth affecting access to base.', 'yolov8_transformer_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS019-001-20250414-069-001', 'VIS-T-SS019-001-20250414-069', 'T-SS019-001',
 'VEGETATION', 0.95, PARSE_JSON('{"x": 0.1541, "y": 0.2732, "width": 0.0696, "height": 0.0976}'),
 'HIGH', FALSE,
 'ACCESS_ROAD', 'Tree branches encroaching within clearance zone near access road.', 'temporal_defect_detector_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS019-001-20250414-069-002', 'VIS-T-SS019-001-20250414-069', 'T-SS019-001',
 'CRACK', 0.8604, PARSE_JSON('{"x": 0.1941, "y": 0.3269, "width": 0.0577, "height": 0.1081}'),
 'CRITICAL', TRUE,
 'BUSHING', 'Linear crack detected in bushing. Length approximately 15-25cm.', 'temporal_defect_detector_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS019-001-20250414-069-003', 'VIS-T-SS019-001-20250414-069', 'T-SS019-001',
 'LEAK', 0.8706, PARSE_JSON('{"x": 0.5704, "y": 0.2882, "width": 0.1036, "height": 0.1637}'),
 'LOW', FALSE,
 'BUSHING_SEAL', 'Seal failure on bushing seal allowing fluid escape.', 'temporal_defect_detector_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS019-001-20250414-069-004', 'VIS-T-SS019-001-20250414-069', 'T-SS019-001',
 'CORROSION', 0.7592, PARSE_JSON('{"x": 0.619, "y": 0.6454, "width": 0.2864, "height": 0.1177}'),
 'MEDIUM', FALSE,
 'MOUNTING_BRACKETS', 'Moderate to severe corrosion present. Metal oxidation advancing on mounting brackets.', 'temporal_defect_detector_v1', 'v2.1';

-- Batch 27/34
INSERT INTO UTILITIES_GRID_RELIABILITY.UNSTRUCTURED.CV_DETECTIONS 
(DETECTION_ID, INSPECTION_ID, ASSET_ID, DETECTION_TYPE, CONFIDENCE_SCORE, BOUNDING_BOX, 
 SEVERITY_LEVEL, REQUIRES_IMMEDIATE_ACTION, DETECTED_AT_COMPONENT, DESCRIPTION, MODEL_NAME, MODEL_VERSION)
SELECT 
 'DET-VIS-T-SS019-001-20250414-069-005', 'VIS-T-SS019-001-20250414-069', 'T-SS019-001',
 'CRACK', 0.964, PARSE_JSON('{"x": 0.3633, "y": 0.2993, "width": 0.2038, "height": 0.132}'),
 'CRITICAL', TRUE,
 'INSULATOR', 'Multiple hairline cracks visible on insulator surface.', 'temporal_defect_detector_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS033-001-20251106-070-001', 'VIS-T-SS033-001-20251106-070', 'T-SS033-001',
 'STRUCTURAL_DAMAGE', 0.9421, PARSE_JSON('{"x": 0.3956, "y": 0.4707, "width": 0.1831, "height": 0.1259}'),
 'CRITICAL', FALSE,
 'SUPPORT_STRUCTURE', 'Physical damage observed on support structure. Deformation or breakage present.', 'yolov8_transformer_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS033-001-20251106-070-002', 'VIS-T-SS033-001-20251106-070', 'T-SS033-001',
 'HOTSPOT', 0.971, PARSE_JSON('{"x": 0.3843, "y": 0.4382, "width": 0.2611, "height": 0.1482}'),
 'HIGH', TRUE,
 'TAP_CHANGER', 'Hot spot identified via infrared scan. tap changer operating 27°C above normal.', 'yolov8_transformer_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS033-001-20251106-070-003', 'VIS-T-SS033-001-20251106-070', 'T-SS033-001',
 'VEGETATION', 0.9516, PARSE_JSON('{"x": 0.6071, "y": 0.4329, "width": 0.2119, "height": 0.0826}'),
 'LOW', FALSE,
 'CLEARANCE_ZONE', 'Excessive vegetation growth detected. Clearance violation at clearance zone.', 'yolov8_transformer_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS033-001-20251106-070-004', 'VIS-T-SS033-001-20251106-070', 'T-SS033-001',
 'STRUCTURAL_DAMAGE', 0.9228, PARSE_JSON('{"x": 0.3763, "y": 0.6563, "width": 0.2586, "height": 0.0523}'),
 'MEDIUM', FALSE,
 'ENCLOSURE', 'Deterioration of enclosure support structure. Potential stability concern.', 'yolov8_transformer_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS033-001-20251106-070-005', 'VIS-T-SS033-001-20251106-070', 'T-SS033-001',
 'LEAK', 0.9842, PARSE_JSON('{"x": 0.1829, "y": 0.1233, "width": 0.1539, "height": 0.1544}'),
 'CRITICAL', TRUE,
 'VALVE', 'Seal failure on valve allowing fluid escape.', 'yolov8_transformer_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS094-001-20241211-071-001', 'VIS-T-SS094-001-20241211-071', 'T-SS094-001',
 'LEAK', 0.9602, PARSE_JSON('{"x": 0.5766, "y": 0.4472, "width": 0.1147, "height": 0.2948}'),
 'MEDIUM', FALSE,
 'RADIATOR_JOINT', 'Active oil leak detected at radiator joint. Visible staining and dripping.', 'yolov8_transformer_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS094-001-20241211-071-002', 'VIS-T-SS094-001-20241211-071', 'T-SS094-001',
 'VEGETATION', 0.941, PARSE_JSON('{"x": 0.3532, "y": 0.693, "width": 0.2836, "height": 0.0643}'),
 'LOW', FALSE,
 'FENCE_LINE', 'Tree branches encroaching within clearance zone near fence line.', 'yolov8_transformer_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS015-001-20250209-072-001', 'VIS-T-SS015-001-20250209-072', 'T-SS015-001',
 'HOTSPOT', 0.9052, PARSE_JSON('{"x": 0.5204, "y": 0.451, "width": 0.2976, "height": 0.1437}'),
 'CRITICAL', FALSE,
 'TAP_CHANGER', 'Hot spot identified via infrared scan. tap changer operating 45°C above normal.', 'yolov8_transformer_aerial_v3', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS015-001-20250209-072-002', 'VIS-T-SS015-001-20250209-072', 'T-SS015-001',
 'STRUCTURAL_DAMAGE', 0.8548, PARSE_JSON('{"x": 0.6516, "y": 0.3364, "width": 0.2838, "height": 0.086}'),
 'MEDIUM', FALSE,
 'SUPPORT_STRUCTURE', 'Physical damage observed on support structure. Deformation or breakage present.', 'yolov8_transformer_aerial_v3', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS039-001-20250224-073-001', 'VIS-T-SS039-001-20250224-073', 'T-SS039-001',
 'CRACK', 0.8416, PARSE_JSON('{"x": 0.442, "y": 0.1185, "width": 0.1619, "height": 0.2808}'),
 'CRITICAL', TRUE,
 'GASKET', 'Linear crack detected in gasket. Length approximately 15-25cm.', 'thermal_anomaly_detector_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS039-001-20250224-073-002', 'VIS-T-SS039-001-20250224-073', 'T-SS039-001',
 'LEAK', 0.8815, PARSE_JSON('{"x": 0.335, "y": 0.1577, "width": 0.2022, "height": 0.1792}'),
 'HIGH', TRUE,
 'GASKET', 'Evidence of historical leakage on gasket. Surface contamination present.', 'thermal_anomaly_detector_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS039-001-20250224-073-003', 'VIS-T-SS039-001-20250224-073', 'T-SS039-001',
 'STRUCTURAL_DAMAGE', 0.8288, PARSE_JSON('{"x": 0.2667, "y": 0.5679, "width": 0.1525, "height": 0.0594}'),
 'MEDIUM', FALSE,
 'FOUNDATION', 'Deterioration of foundation support structure. Potential stability concern.', 'thermal_anomaly_detector_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS022-001-20241214-074-001', 'VIS-T-SS022-001-20241214-074', 'T-SS022-001',
 'LEAK', 0.8606, PARSE_JSON('{"x": 0.2108, "y": 0.3665, "width": 0.2292, "height": 0.2775}'),
 'CRITICAL', FALSE,
 'BUSHING_SEAL', 'Evidence of historical leakage on bushing seal. Surface contamination present.', 'pointcloud_structural_analyzer_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS022-001-20241214-074-002', 'VIS-T-SS022-001-20241214-074', 'T-SS022-001',
 'CRACK', 0.932, PARSE_JSON('{"x": 0.3053, "y": 0.4134, "width": 0.2269, "height": 0.1892}'),
 'MEDIUM', FALSE,
 'INSULATOR', 'Multiple hairline cracks visible on insulator surface.', 'pointcloud_structural_analyzer_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS044-001-20250301-075-001', 'VIS-T-SS044-001-20250301-075', 'T-SS044-001',
 'LEAK', 0.8732, PARSE_JSON('{"x": 0.3167, "y": 0.136, "width": 0.1283, "height": 0.2112}'),
 'HIGH', FALSE,
 'VALVE', 'Active oil leak detected at valve. Visible staining and dripping.', 'yolov8_transformer_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS079-001-20250524-076-001', 'VIS-T-SS079-001-20250524-076', 'T-SS079-001',
 'CRACK', 0.8411, PARSE_JSON('{"x": 0.2166, "y": 0.2479, "width": 0.2148, "height": 0.0892}'),
 'HIGH', FALSE,
 'GASKET', 'Linear crack detected in gasket. Length approximately 15-25cm.', 'yolov8_transformer_aerial_v3', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS079-001-20250524-076-002', 'VIS-T-SS079-001-20250524-076', 'T-SS079-001',
 'STRUCTURAL_DAMAGE', 0.8502, PARSE_JSON('{"x": 0.5112, "y": 0.6597, "width": 0.1105, "height": 0.2117}'),
 'HIGH', TRUE,
 'ENCLOSURE', 'Structural integrity compromised at enclosure. Requires engineering assessment.', 'yolov8_transformer_aerial_v3', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS079-001-20250524-076-003', 'VIS-T-SS079-001-20250524-076', 'T-SS079-001',
 'STRUCTURAL_DAMAGE', 0.8608, PARSE_JSON('{"x": 0.6346, "y": 0.679, "width": 0.1187, "height": 0.2471}'),
 'LOW', FALSE,
 'FOUNDATION', 'Physical damage observed on foundation. Deformation or breakage present.', 'yolov8_transformer_aerial_v3', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS079-001-20250524-076-004', 'VIS-T-SS079-001-20250524-076', 'T-SS079-001',
 'CORROSION', 0.9102, PARSE_JSON('{"x": 0.5491, "y": 0.1411, "width": 0.2873, "height": 0.2796}'),
 'HIGH', FALSE,
 'TANK', 'Surface corrosion detected on tank. Rust visible with paint degradation.', 'yolov8_transformer_aerial_v3', 'v2.1';

-- Batch 28/34
INSERT INTO UTILITIES_GRID_RELIABILITY.UNSTRUCTURED.CV_DETECTIONS 
(DETECTION_ID, INSPECTION_ID, ASSET_ID, DETECTION_TYPE, CONFIDENCE_SCORE, BOUNDING_BOX, 
 SEVERITY_LEVEL, REQUIRES_IMMEDIATE_ACTION, DETECTED_AT_COMPONENT, DESCRIPTION, MODEL_NAME, MODEL_VERSION)
SELECT 
 'DET-VIS-T-SS073-001-20251106-077-001', 'VIS-T-SS073-001-20251106-077', 'T-SS073-001',
 'VEGETATION', 0.9499, PARSE_JSON('{"x": 0.3095, "y": 0.3578, "width": 0.2248, "height": 0.0931}'),
 'MEDIUM', FALSE,
 'FENCE_LINE', 'Grass and brush overgrowth affecting access to fence line.', 'temporal_defect_detector_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS072-001-20241202-079-001', 'VIS-T-SS072-001-20241202-079', 'T-SS072-001',
 'CORROSION', 0.9477, PARSE_JSON('{"x": 0.4971, "y": 0.2897, "width": 0.2725, "height": 0.0544}'),
 'HIGH', FALSE,
 'MOUNTING_BRACKETS', 'Moderate to severe corrosion present. Metal oxidation advancing on mounting brackets.', 'yolov8_transformer_aerial_v3', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS027-001-20250930-082-001', 'VIS-T-SS027-001-20250930-082', 'T-SS027-001',
 'CRACK', 0.9589, PARSE_JSON('{"x": 0.4486, "y": 0.5155, "width": 0.2849, "height": 0.2693}'),
 'MEDIUM', FALSE,
 'INSULATOR', 'Structural crack identified. Propagation risk on insulator.', 'pointcloud_structural_analyzer_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS027-001-20250930-082-002', 'VIS-T-SS027-001-20250930-082', 'T-SS027-001',
 'STRUCTURAL_DAMAGE', 0.8741, PARSE_JSON('{"x": 0.3838, "y": 0.4301, "width": 0.0968, "height": 0.1945}'),
 'CRITICAL', TRUE,
 'SUPPORT_STRUCTURE', 'Deterioration of support structure support structure. Potential stability concern.', 'pointcloud_structural_analyzer_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS076-001-20250712-083-001', 'VIS-T-SS076-001-20250712-083', 'T-SS076-001',
 'HOTSPOT', 0.8875, PARSE_JSON('{"x": 0.5614, "y": 0.5237, "width": 0.1699, "height": 0.2052}'),
 'HIGH', FALSE,
 'BUSHING_CONNECTION', 'Hot spot identified via infrared scan. bushing connection operating 42°C above normal.', 'temporal_defect_detector_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS076-001-20250712-083-002', 'VIS-T-SS076-001-20250712-083', 'T-SS076-001',
 'VEGETATION', 0.9129, PARSE_JSON('{"x": 0.3586, "y": 0.2441, "width": 0.2713, "height": 0.2378}'),
 'LOW', FALSE,
 'BASE', 'Excessive vegetation growth detected. Clearance violation at base.', 'temporal_defect_detector_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS096-001-20250512-085-001', 'VIS-T-SS096-001-20250512-085', 'T-SS096-001',
 'HOTSPOT', 0.9472, PARSE_JSON('{"x": 0.143, "y": 0.6737, "width": 0.2379, "height": 0.1122}'),
 'HIGH', TRUE,
 'RADIATOR', 'Thermal anomaly detected at radiator. Temperature differential: 35°C above ambient.', 'thermal_anomaly_detector_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS096-001-20250512-085-002', 'VIS-T-SS096-001-20250512-085', 'T-SS096-001',
 'STRUCTURAL_DAMAGE', 0.8985, PARSE_JSON('{"x": 0.2207, "y": 0.6033, "width": 0.1485, "height": 0.2824}'),
 'HIGH', FALSE,
 'FOUNDATION', 'Physical damage observed on foundation. Deformation or breakage present.', 'thermal_anomaly_detector_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS096-001-20250512-085-003', 'VIS-T-SS096-001-20250512-085', 'T-SS096-001',
 'HOTSPOT', 0.9753, PARSE_JSON('{"x": 0.3359, "y": 0.6016, "width": 0.2937, "height": 0.2032}'),
 'MEDIUM', FALSE,
 'BUSHING_CONNECTION', 'Elevated temperature on bushing connection. Possible loose connection or high resistance.', 'thermal_anomaly_detector_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS022-001-20250406-086-001', 'VIS-T-SS022-001-20250406-086', 'T-SS022-001',
 'LEAK', 0.8956, PARSE_JSON('{"x": 0.4452, "y": 0.3096, "width": 0.1201, "height": 0.2288}'),
 'MEDIUM', FALSE,
 'BUSHING_SEAL', 'Evidence of historical leakage on bushing seal. Surface contamination present.', 'yolov8_transformer_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS022-001-20250406-086-002', 'VIS-T-SS022-001-20250406-086', 'T-SS022-001',
 'STRUCTURAL_DAMAGE', 0.7991, PARSE_JSON('{"x": 0.1013, "y": 0.2032, "width": 0.2742, "height": 0.1876}'),
 'CRITICAL', FALSE,
 'FOUNDATION', 'Deterioration of foundation support structure. Potential stability concern.', 'yolov8_transformer_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS017-001-20250815-087-001', 'VIS-T-SS017-001-20250815-087', 'T-SS017-001',
 'CORROSION', 0.905, PARSE_JSON('{"x": 0.693, "y": 0.4988, "width": 0.1338, "height": 0.0976}'),
 'MEDIUM', FALSE,
 'MOUNTING_BRACKETS', 'Moderate to severe corrosion present. Metal oxidation advancing on mounting brackets.', 'yolov8_transformer_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS017-001-20250815-087-002', 'VIS-T-SS017-001-20250815-087', 'T-SS017-001',
 'STRUCTURAL_DAMAGE', 0.9529, PARSE_JSON('{"x": 0.46, "y": 0.1632, "width": 0.2435, "height": 0.1772}'),
 'LOW', FALSE,
 'SUPPORT_STRUCTURE', 'Physical damage observed on support structure. Deformation or breakage present.', 'yolov8_transformer_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS081-001-20250512-088-001', 'VIS-T-SS081-001-20250512-088', 'T-SS081-001',
 'CORROSION', 0.8158, PARSE_JSON('{"x": 0.4549, "y": 0.3521, "width": 0.2205, "height": 0.2922}'),
 'MEDIUM', FALSE,
 'BUSHING_BASE', 'Moderate to severe corrosion present. Metal oxidation advancing on bushing base.', 'yolov8_transformer_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS081-001-20250512-088-002', 'VIS-T-SS081-001-20250512-088', 'T-SS081-001',
 'LEAK', 0.9835, PARSE_JSON('{"x": 0.499, "y": 0.1772, "width": 0.1116, "height": 0.1061}'),
 'HIGH', TRUE,
 'BUSHING_SEAL', 'Seal failure on bushing seal allowing fluid escape.', 'yolov8_transformer_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS081-001-20250512-088-003', 'VIS-T-SS081-001-20250512-088', 'T-SS081-001',
 'CORROSION', 0.8906, PARSE_JSON('{"x": 0.6445, "y": 0.5044, "width": 0.2759, "height": 0.2381}'),
 'HIGH', FALSE,
 'TANK', 'Corrosion patterns suggest moisture ingress. Located on tank.', 'yolov8_transformer_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS009-001-20251110-089-001', 'VIS-T-SS009-001-20251110-089', 'T-SS009-001',
 'CRACK', 0.9453, PARSE_JSON('{"x": 0.5241, "y": 0.3244, "width": 0.1682, "height": 0.1626}'),
 'HIGH', FALSE,
 'INSULATOR', 'Linear crack detected in insulator. Length approximately 15-25cm.', 'pointcloud_structural_analyzer_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS079-001-20250922-090-001', 'VIS-T-SS079-001-20250922-090', 'T-SS079-001',
 'STRUCTURAL_DAMAGE', 0.9004, PARSE_JSON('{"x": 0.192, "y": 0.5863, "width": 0.2035, "height": 0.1632}'),
 'CRITICAL', FALSE,
 'MOUNTING', 'Physical damage observed on mounting. Deformation or breakage present.', 'yolov8_transformer_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS079-001-20250922-090-002', 'VIS-T-SS079-001-20250922-090', 'T-SS079-001',
 'CRACK', 0.8496, PARSE_JSON('{"x": 0.3504, "y": 0.1065, "width": 0.2512, "height": 0.2864}'),
 'CRITICAL', FALSE,
 'TANK', 'Linear crack detected in tank. Length approximately 15-25cm.', 'yolov8_transformer_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS038-001-20250715-092-001', 'VIS-T-SS038-001-20250715-092', 'T-SS038-001',
 'HOTSPOT', 0.9429, PARSE_JSON('{"x": 0.3392, "y": 0.3936, "width": 0.2805, "height": 0.2443}'),
 'HIGH', FALSE,
 'TAP_CHANGER', 'Elevated temperature on tap changer. Possible loose connection or high resistance.', 'temporal_defect_detector_v1', 'v2.1';

-- Batch 29/34
INSERT INTO UTILITIES_GRID_RELIABILITY.UNSTRUCTURED.CV_DETECTIONS 
(DETECTION_ID, INSPECTION_ID, ASSET_ID, DETECTION_TYPE, CONFIDENCE_SCORE, BOUNDING_BOX, 
 SEVERITY_LEVEL, REQUIRES_IMMEDIATE_ACTION, DETECTED_AT_COMPONENT, DESCRIPTION, MODEL_NAME, MODEL_VERSION)
SELECT 
 'DET-VIS-T-SS094-001-20250923-093-001', 'VIS-T-SS094-001-20250923-093', 'T-SS094-001',
 'LEAK', 0.9173, PARSE_JSON('{"x": 0.2516, "y": 0.3379, "width": 0.0605, "height": 0.069}'),
 'LOW', FALSE,
 'GASKET', 'Seal failure on gasket allowing fluid escape.', 'temporal_defect_detector_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS094-001-20250923-093-002', 'VIS-T-SS094-001-20250923-093', 'T-SS094-001',
 'HOTSPOT', 0.9023, PARSE_JSON('{"x": 0.5045, "y": 0.5532, "width": 0.0602, "height": 0.1401}'),
 'CRITICAL', TRUE,
 'TAP_CHANGER', 'Thermal anomaly detected at tap changer. Temperature differential: 27°C above ambient.', 'temporal_defect_detector_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS094-001-20250923-093-003', 'VIS-T-SS094-001-20250923-093', 'T-SS094-001',
 'CRACK', 0.848, PARSE_JSON('{"x": 0.4713, "y": 0.3306, "width": 0.2396, "height": 0.19}'),
 'MEDIUM', FALSE,
 'INSULATOR', 'Structural crack identified. Propagation risk on insulator.', 'temporal_defect_detector_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS083-001-20250509-096-001', 'VIS-T-SS083-001-20250509-096', 'T-SS083-001',
 'HOTSPOT', 0.9723, PARSE_JSON('{"x": 0.446, "y": 0.2722, "width": 0.0949, "height": 0.1598}'),
 'HIGH', TRUE,
 'BUSHING_CONNECTION', 'Thermal anomaly detected at bushing connection. Temperature differential: 28°C above ambient.', 'temporal_defect_detector_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS043-001-20250225-097-001', 'VIS-T-SS043-001-20250225-097', 'T-SS043-001',
 'CRACK', 0.9734, PARSE_JSON('{"x": 0.4866, "y": 0.258, "width": 0.2308, "height": 0.0639}'),
 'MEDIUM', FALSE,
 'INSULATOR', 'Structural crack identified. Propagation risk on insulator.', 'yolov8_transformer_aerial_v3', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS054-001-20250207-099-001', 'VIS-T-SS054-001-20250207-099', 'T-SS054-001',
 'HOTSPOT', 0.939, PARSE_JSON('{"x": 0.4873, "y": 0.5947, "width": 0.1248, "height": 0.1626}'),
 'HIGH', FALSE,
 'BUSHING_CONNECTION', 'Thermal anomaly detected at bushing connection. Temperature differential: 19°C above ambient.', 'temporal_defect_detector_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS054-001-20250207-099-002', 'VIS-T-SS054-001-20250207-099', 'T-SS054-001',
 'HOTSPOT', 0.9303, PARSE_JSON('{"x": 0.4806, "y": 0.4217, "width": 0.2207, "height": 0.1931}'),
 'HIGH', TRUE,
 'TAP_CHANGER', 'Thermal anomaly detected at tap changer. Temperature differential: 22°C above ambient.', 'temporal_defect_detector_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS054-001-20250207-099-003', 'VIS-T-SS054-001-20250207-099', 'T-SS054-001',
 'VEGETATION', 0.9158, PARSE_JSON('{"x": 0.5878, "y": 0.4451, "width": 0.2457, "height": 0.2329}'),
 'MEDIUM', FALSE,
 'CLEARANCE_ZONE', 'Tree branches encroaching within clearance zone near clearance zone.', 'temporal_defect_detector_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS054-001-20250207-099-004', 'VIS-T-SS054-001-20250207-099', 'T-SS054-001',
 'CRACK', 0.9067, PARSE_JSON('{"x": 0.1641, "y": 0.4389, "width": 0.2443, "height": 0.1817}'),
 'HIGH', TRUE,
 'GASKET', 'Structural crack identified. Propagation risk on gasket.', 'temporal_defect_detector_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS054-001-20250207-099-005', 'VIS-T-SS054-001-20250207-099', 'T-SS054-001',
 'CRACK', 0.8472, PARSE_JSON('{"x": 0.116, "y": 0.5833, "width": 0.2695, "height": 0.1369}'),
 'MEDIUM', FALSE,
 'BUSHING', 'Structural crack identified. Propagation risk on bushing.', 'temporal_defect_detector_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS066-001-20250614-100-001', 'VIS-T-SS066-001-20250614-100', 'T-SS066-001',
 'VEGETATION', 0.9622, PARSE_JSON('{"x": 0.4434, "y": 0.2625, "width": 0.0572, "height": 0.2066}'),
 'LOW', FALSE,
 'BASE', 'Grass and brush overgrowth affecting access to base.', 'yolov8_transformer_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS063-001-20241214-101-001', 'VIS-T-SS063-001-20241214-101', 'T-SS063-001',
 'CORROSION', 0.8819, PARSE_JSON('{"x": 0.4109, "y": 0.2087, "width": 0.1213, "height": 0.1784}'),
 'LOW', FALSE,
 'TANK', 'Corrosion patterns suggest moisture ingress. Located on tank.', 'thermal_anomaly_detector_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS063-001-20241214-101-002', 'VIS-T-SS063-001-20241214-101', 'T-SS063-001',
 'HOTSPOT', 0.9234, PARSE_JSON('{"x": 0.3037, "y": 0.5496, "width": 0.1343, "height": 0.2304}'),
 'MEDIUM', FALSE,
 'TAP_CHANGER', 'Hot spot identified via infrared scan. tap changer operating 48°C above normal.', 'thermal_anomaly_detector_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS061-001-20251014-102-001', 'VIS-T-SS061-001-20251014-102', 'T-SS061-001',
 'CORROSION', 0.9223, PARSE_JSON('{"x": 0.513, "y": 0.6181, "width": 0.1221, "height": 0.2524}'),
 'CRITICAL', FALSE,
 'BUSHING_BASE', 'Moderate to severe corrosion present. Metal oxidation advancing on bushing base.', 'thermal_anomaly_detector_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS061-001-20251014-102-002', 'VIS-T-SS061-001-20251014-102', 'T-SS061-001',
 'VEGETATION', 0.951, PARSE_JSON('{"x": 0.3565, "y": 0.1524, "width": 0.249, "height": 0.1614}'),
 'LOW', FALSE,
 'CLEARANCE_ZONE', 'Tree branches encroaching within clearance zone near clearance zone.', 'thermal_anomaly_detector_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS071-001-20250726-103-001', 'VIS-T-SS071-001-20250726-103', 'T-SS071-001',
 'STRUCTURAL_DAMAGE', 0.9315, PARSE_JSON('{"x": 0.6981, "y": 0.1846, "width": 0.2865, "height": 0.1284}'),
 'HIGH', TRUE,
 'ENCLOSURE', 'Physical damage observed on enclosure. Deformation or breakage present.', 'thermal_anomaly_detector_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS071-001-20250726-103-002', 'VIS-T-SS071-001-20250726-103', 'T-SS071-001',
 'CORROSION', 0.7846, PARSE_JSON('{"x": 0.6353, "y": 0.462, "width": 0.2757, "height": 0.2309}'),
 'HIGH', FALSE,
 'BUSHING_BASE', 'Surface corrosion detected on bushing base. Rust visible with paint degradation.', 'thermal_anomaly_detector_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS071-001-20250726-103-003', 'VIS-T-SS071-001-20250726-103', 'T-SS071-001',
 'HOTSPOT', 0.9086, PARSE_JSON('{"x": 0.2182, "y": 0.3956, "width": 0.187, "height": 0.2448}'),
 'HIGH', FALSE,
 'TAP_CHANGER', 'Thermal anomaly detected at tap changer. Temperature differential: 24°C above ambient.', 'thermal_anomaly_detector_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS072-001-20250927-104-001', 'VIS-T-SS072-001-20250927-104', 'T-SS072-001',
 'VEGETATION', 0.9283, PARSE_JSON('{"x": 0.6583, "y": 0.2397, "width": 0.1133, "height": 0.2511}'),
 'LOW', FALSE,
 'ACCESS_ROAD', 'Tree branches encroaching within clearance zone near access road.', 'temporal_defect_detector_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS072-001-20250927-104-002', 'VIS-T-SS072-001-20250927-104', 'T-SS072-001',
 'LEAK', 0.92, PARSE_JSON('{"x": 0.6989, "y": 0.1501, "width": 0.2587, "height": 0.2598}'),
 'MEDIUM', FALSE,
 'BUSHING_SEAL', 'Evidence of historical leakage on bushing seal. Surface contamination present.', 'temporal_defect_detector_v1', 'v2.1';

-- Batch 30/34
INSERT INTO UTILITIES_GRID_RELIABILITY.UNSTRUCTURED.CV_DETECTIONS 
(DETECTION_ID, INSPECTION_ID, ASSET_ID, DETECTION_TYPE, CONFIDENCE_SCORE, BOUNDING_BOX, 
 SEVERITY_LEVEL, REQUIRES_IMMEDIATE_ACTION, DETECTED_AT_COMPONENT, DESCRIPTION, MODEL_NAME, MODEL_VERSION)
SELECT 
 'DET-VIS-T-SS003-001-20250203-105-001', 'VIS-T-SS003-001-20250203-105', 'T-SS003-001',
 'STRUCTURAL_DAMAGE', 0.9484, PARSE_JSON('{"x": 0.5254, "y": 0.3353, "width": 0.2373, "height": 0.1683}'),
 'MEDIUM', FALSE,
 'SUPPORT_STRUCTURE', 'Deterioration of support structure support structure. Potential stability concern.', 'yolov8_transformer_aerial_v3', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS032-001-20250128-106-001', 'VIS-T-SS032-001-20250128-106', 'T-SS032-001',
 'CRACK', 0.8386, PARSE_JSON('{"x": 0.3228, "y": 0.1781, "width": 0.2856, "height": 0.075}'),
 'MEDIUM', FALSE,
 'BUSHING', 'Structural crack identified. Propagation risk on bushing.', 'yolov8_transformer_aerial_v3', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS032-001-20250128-106-002', 'VIS-T-SS032-001-20250128-106', 'T-SS032-001',
 'VEGETATION', 0.9448, PARSE_JSON('{"x": 0.6851, "y": 0.4365, "width": 0.0905, "height": 0.2849}'),
 'LOW', FALSE,
 'CLEARANCE_ZONE', 'Grass and brush overgrowth affecting access to clearance zone.', 'yolov8_transformer_aerial_v3', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS032-001-20250128-106-003', 'VIS-T-SS032-001-20250128-106', 'T-SS032-001',
 'CORROSION', 0.9336, PARSE_JSON('{"x": 0.511, "y": 0.3728, "width": 0.186, "height": 0.0615}'),
 'MEDIUM', FALSE,
 'BUSHING_BASE', 'Moderate to severe corrosion present. Metal oxidation advancing on bushing base.', 'yolov8_transformer_aerial_v3', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS032-001-20250128-106-004', 'VIS-T-SS032-001-20250128-106', 'T-SS032-001',
 'CORROSION', 0.8837, PARSE_JSON('{"x": 0.5458, "y": 0.6561, "width": 0.1037, "height": 0.1465}'),
 'MEDIUM', FALSE,
 'TANK', 'Corrosion patterns suggest moisture ingress. Located on tank.', 'yolov8_transformer_aerial_v3', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS032-001-20250128-106-005', 'VIS-T-SS032-001-20250128-106', 'T-SS032-001',
 'HOTSPOT', 0.9297, PARSE_JSON('{"x": 0.4886, "y": 0.1565, "width": 0.0633, "height": 0.2314}'),
 'CRITICAL', FALSE,
 'TAP_CHANGER', 'Elevated temperature on tap changer. Possible loose connection or high resistance.', 'yolov8_transformer_aerial_v3', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS006-001-20250527-107-001', 'VIS-T-SS006-001-20250527-107', 'T-SS006-001',
 'STRUCTURAL_DAMAGE', 0.8219, PARSE_JSON('{"x": 0.2156, "y": 0.6328, "width": 0.1788, "height": 0.0512}'),
 'MEDIUM', FALSE,
 'FOUNDATION', 'Deterioration of foundation support structure. Potential stability concern.', 'yolov8_transformer_aerial_v3', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS041-001-20241118-108-001', 'VIS-T-SS041-001-20241118-108', 'T-SS041-001',
 'STRUCTURAL_DAMAGE', 0.9297, PARSE_JSON('{"x": 0.1984, "y": 0.4328, "width": 0.1761, "height": 0.1116}'),
 'MEDIUM', FALSE,
 'MOUNTING', 'Structural integrity compromised at mounting. Requires engineering assessment.', 'yolov8_transformer_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS041-001-20241118-108-002', 'VIS-T-SS041-001-20241118-108', 'T-SS041-001',
 'CRACK', 0.8542, PARSE_JSON('{"x": 0.1645, "y": 0.5629, "width": 0.1877, "height": 0.2647}'),
 'MEDIUM', FALSE,
 'TANK', 'Structural crack identified. Propagation risk on tank.', 'yolov8_transformer_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS041-001-20241118-108-003', 'VIS-T-SS041-001-20241118-108', 'T-SS041-001',
 'CRACK', 0.897, PARSE_JSON('{"x": 0.3648, "y": 0.5403, "width": 0.1177, "height": 0.201}'),
 'HIGH', FALSE,
 'GASKET', 'Multiple hairline cracks visible on gasket surface.', 'yolov8_transformer_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS027-001-20250813-109-001', 'VIS-T-SS027-001-20250813-109', 'T-SS027-001',
 'CORROSION', 0.9133, PARSE_JSON('{"x": 0.4061, "y": 0.2333, "width": 0.205, "height": 0.1063}'),
 'MEDIUM', FALSE,
 'RADIATOR', 'Corrosion patterns suggest moisture ingress. Located on radiator.', 'pointcloud_structural_analyzer_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS027-001-20250813-109-002', 'VIS-T-SS027-001-20250813-109', 'T-SS027-001',
 'STRUCTURAL_DAMAGE', 0.9554, PARSE_JSON('{"x": 0.2245, "y": 0.1837, "width": 0.1067, "height": 0.2076}'),
 'LOW', FALSE,
 'ENCLOSURE', 'Deterioration of enclosure support structure. Potential stability concern.', 'pointcloud_structural_analyzer_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS027-001-20250813-109-003', 'VIS-T-SS027-001-20250813-109', 'T-SS027-001',
 'CRACK', 0.9744, PARSE_JSON('{"x": 0.5445, "y": 0.1324, "width": 0.2498, "height": 0.1562}'),
 'CRITICAL', TRUE,
 'TANK', 'Structural crack identified. Propagation risk on tank.', 'pointcloud_structural_analyzer_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS027-001-20250813-109-004', 'VIS-T-SS027-001-20250813-109', 'T-SS027-001',
 'LEAK', 0.9041, PARSE_JSON('{"x": 0.5853, "y": 0.2818, "width": 0.1884, "height": 0.286}'),
 'LOW', FALSE,
 'VALVE', 'Seal failure on valve allowing fluid escape.', 'pointcloud_structural_analyzer_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS083-001-20250812-110-001', 'VIS-T-SS083-001-20250812-110', 'T-SS083-001',
 'CRACK', 0.8924, PARSE_JSON('{"x": 0.6948, "y": 0.2796, "width": 0.218, "height": 0.0717}'),
 'HIGH', FALSE,
 'BUSHING', 'Linear crack detected in bushing. Length approximately 15-25cm.', 'yolov8_transformer_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS083-001-20250812-110-002', 'VIS-T-SS083-001-20250812-110', 'T-SS083-001',
 'CRACK', 0.8467, PARSE_JSON('{"x": 0.4247, "y": 0.6554, "width": 0.07, "height": 0.0633}'),
 'HIGH', FALSE,
 'INSULATOR', 'Structural crack identified. Propagation risk on insulator.', 'yolov8_transformer_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS066-001-20251002-112-001', 'VIS-T-SS066-001-20251002-112', 'T-SS066-001',
 'HOTSPOT', 0.9231, PARSE_JSON('{"x": 0.1624, "y": 0.3755, "width": 0.1979, "height": 0.1607}'),
 'CRITICAL', FALSE,
 'TAP_CHANGER', 'Elevated temperature on tap changer. Possible loose connection or high resistance.', 'thermal_anomaly_detector_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS090-001-20250811-113-001', 'VIS-T-SS090-001-20250811-113', 'T-SS090-001',
 'LEAK', 0.8871, PARSE_JSON('{"x": 0.2656, "y": 0.6786, "width": 0.1677, "height": 0.0985}'),
 'CRITICAL', FALSE,
 'GASKET', 'Active oil leak detected at gasket. Visible staining and dripping.', 'temporal_defect_detector_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS056-001-20251102-114-001', 'VIS-T-SS056-001-20251102-114', 'T-SS056-001',
 'STRUCTURAL_DAMAGE', 0.7854, PARSE_JSON('{"x": 0.6121, "y": 0.5736, "width": 0.2938, "height": 0.2965}'),
 'LOW', FALSE,
 'MOUNTING', 'Deterioration of mounting support structure. Potential stability concern.', 'thermal_anomaly_detector_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS075-001-20251113-115-001', 'VIS-T-SS075-001-20251113-115', 'T-SS075-001',
 'STRUCTURAL_DAMAGE', 0.9389, PARSE_JSON('{"x": 0.2925, "y": 0.5899, "width": 0.2882, "height": 0.2738}'),
 'LOW', FALSE,
 'SUPPORT_STRUCTURE', 'Physical damage observed on support structure. Deformation or breakage present.', 'pointcloud_structural_analyzer_v1', 'v2.1';

-- Batch 31/34
INSERT INTO UTILITIES_GRID_RELIABILITY.UNSTRUCTURED.CV_DETECTIONS 
(DETECTION_ID, INSPECTION_ID, ASSET_ID, DETECTION_TYPE, CONFIDENCE_SCORE, BOUNDING_BOX, 
 SEVERITY_LEVEL, REQUIRES_IMMEDIATE_ACTION, DETECTED_AT_COMPONENT, DESCRIPTION, MODEL_NAME, MODEL_VERSION)
SELECT 
 'DET-VIS-T-SS023-001-20250712-116-001', 'VIS-T-SS023-001-20250712-116', 'T-SS023-001',
 'CRACK', 0.8006, PARSE_JSON('{"x": 0.1698, "y": 0.2883, "width": 0.1986, "height": 0.1437}'),
 'HIGH', TRUE,
 'GASKET', 'Multiple hairline cracks visible on gasket surface.', 'temporal_defect_detector_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS067-001-20241212-117-001', 'VIS-T-SS067-001-20241212-117', 'T-SS067-001',
 'CORROSION', 0.7996, PARSE_JSON('{"x": 0.2791, "y": 0.4053, "width": 0.1021, "height": 0.1401}'),
 'MEDIUM', FALSE,
 'RADIATOR', 'Surface corrosion detected on radiator. Rust visible with paint degradation.', 'yolov8_transformer_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS072-001-20250415-118-001', 'VIS-T-SS072-001-20250415-118', 'T-SS072-001',
 'CORROSION', 0.921, PARSE_JSON('{"x": 0.4531, "y": 0.4417, "width": 0.2212, "height": 0.159}'),
 'MEDIUM', FALSE,
 'TANK', 'Corrosion patterns suggest moisture ingress. Located on tank.', 'yolov8_transformer_aerial_v3', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS072-001-20250415-118-002', 'VIS-T-SS072-001-20250415-118', 'T-SS072-001',
 'CRACK', 0.899, PARSE_JSON('{"x": 0.644, "y": 0.3972, "width": 0.0538, "height": 0.1072}'),
 'HIGH', FALSE,
 'TANK', 'Linear crack detected in tank. Length approximately 15-25cm.', 'yolov8_transformer_aerial_v3', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS072-001-20250415-118-003', 'VIS-T-SS072-001-20250415-118', 'T-SS072-001',
 'VEGETATION', 0.9131, PARSE_JSON('{"x": 0.3734, "y": 0.2564, "width": 0.1537, "height": 0.2867}'),
 'HIGH', FALSE,
 'ACCESS_ROAD', 'Grass and brush overgrowth affecting access to access road.', 'yolov8_transformer_aerial_v3', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS072-001-20250415-118-004', 'VIS-T-SS072-001-20250415-118', 'T-SS072-001',
 'STRUCTURAL_DAMAGE', 0.9183, PARSE_JSON('{"x": 0.5291, "y": 0.2176, "width": 0.1227, "height": 0.2698}'),
 'HIGH', TRUE,
 'SUPPORT_STRUCTURE', 'Deterioration of support structure support structure. Potential stability concern.', 'yolov8_transformer_aerial_v3', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS072-001-20250415-118-005', 'VIS-T-SS072-001-20250415-118', 'T-SS072-001',
 'CORROSION', 0.9077, PARSE_JSON('{"x": 0.5419, "y": 0.5153, "width": 0.2118, "height": 0.1945}'),
 'MEDIUM', FALSE,
 'RADIATOR', 'Surface corrosion detected on radiator. Rust visible with paint degradation.', 'yolov8_transformer_aerial_v3', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS075-001-20250318-120-001', 'VIS-T-SS075-001-20250318-120', 'T-SS075-001',
 'LEAK', 0.9135, PARSE_JSON('{"x": 0.4096, "y": 0.6492, "width": 0.2328, "height": 0.0913}'),
 'LOW', FALSE,
 'GASKET', 'Seal failure on gasket allowing fluid escape.', 'thermal_anomaly_detector_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS083-001-20250925-121-001', 'VIS-T-SS083-001-20250925-121', 'T-SS083-001',
 'CRACK', 0.9419, PARSE_JSON('{"x": 0.5065, "y": 0.2697, "width": 0.0531, "height": 0.2878}'),
 'MEDIUM', FALSE,
 'BUSHING', 'Multiple hairline cracks visible on bushing surface.', 'pointcloud_structural_analyzer_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS083-001-20250925-121-002', 'VIS-T-SS083-001-20250925-121', 'T-SS083-001',
 'STRUCTURAL_DAMAGE', 0.8348, PARSE_JSON('{"x": 0.6501, "y": 0.2443, "width": 0.1096, "height": 0.2138}'),
 'HIGH', TRUE,
 'SUPPORT_STRUCTURE', 'Physical damage observed on support structure. Deformation or breakage present.', 'pointcloud_structural_analyzer_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS059-001-20250530-124-001', 'VIS-T-SS059-001-20250530-124', 'T-SS059-001',
 'STRUCTURAL_DAMAGE', 0.8677, PARSE_JSON('{"x": 0.323, "y": 0.1394, "width": 0.2923, "height": 0.1951}'),
 'LOW', FALSE,
 'FOUNDATION', 'Structural integrity compromised at foundation. Requires engineering assessment.', 'yolov8_transformer_aerial_v3', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS059-001-20250530-124-002', 'VIS-T-SS059-001-20250530-124', 'T-SS059-001',
 'VEGETATION', 0.9395, PARSE_JSON('{"x": 0.3394, "y": 0.6018, "width": 0.2296, "height": 0.1856}'),
 'MEDIUM', FALSE,
 'ACCESS_ROAD', 'Tree branches encroaching within clearance zone near access road.', 'yolov8_transformer_aerial_v3', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS059-001-20250530-124-003', 'VIS-T-SS059-001-20250530-124', 'T-SS059-001',
 'CORROSION', 0.8168, PARSE_JSON('{"x": 0.3191, "y": 0.2789, "width": 0.0884, "height": 0.1786}'),
 'MEDIUM', FALSE,
 'RADIATOR', 'Moderate to severe corrosion present. Metal oxidation advancing on radiator.', 'yolov8_transformer_aerial_v3', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS017-001-20250914-126-001', 'VIS-T-SS017-001-20250914-126', 'T-SS017-001',
 'HOTSPOT', 0.9388, PARSE_JSON('{"x": 0.4757, "y": 0.5075, "width": 0.2276, "height": 0.2182}'),
 'MEDIUM', FALSE,
 'LOAD_CONNECTION', 'Hot spot identified via infrared scan. load connection operating 32°C above normal.', 'yolov8_transformer_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS017-001-20250914-126-002', 'VIS-T-SS017-001-20250914-126', 'T-SS017-001',
 'HOTSPOT', 0.9709, PARSE_JSON('{"x": 0.2137, "y": 0.5196, "width": 0.0536, "height": 0.0519}'),
 'HIGH', TRUE,
 'RADIATOR', 'Hot spot identified via infrared scan. radiator operating 41°C above normal.', 'yolov8_transformer_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS017-001-20250914-126-003', 'VIS-T-SS017-001-20250914-126', 'T-SS017-001',
 'STRUCTURAL_DAMAGE', 0.8297, PARSE_JSON('{"x": 0.6824, "y": 0.3453, "width": 0.1985, "height": 0.2491}'),
 'HIGH', FALSE,
 'ENCLOSURE', 'Physical damage observed on enclosure. Deformation or breakage present.', 'yolov8_transformer_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS017-001-20250914-126-004', 'VIS-T-SS017-001-20250914-126', 'T-SS017-001',
 'LEAK', 0.9477, PARSE_JSON('{"x": 0.606, "y": 0.6756, "width": 0.2973, "height": 0.2662}'),
 'MEDIUM', FALSE,
 'VALVE', 'Active oil leak detected at valve. Visible staining and dripping.', 'yolov8_transformer_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS017-001-20250914-126-005', 'VIS-T-SS017-001-20250914-126', 'T-SS017-001',
 'CORROSION', 0.8523, PARSE_JSON('{"x": 0.1792, "y": 0.5661, "width": 0.13, "height": 0.2558}'),
 'MEDIUM', FALSE,
 'MOUNTING_BRACKETS', 'Moderate to severe corrosion present. Metal oxidation advancing on mounting brackets.', 'yolov8_transformer_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS067-001-20251014-127-001', 'VIS-T-SS067-001-20251014-127', 'T-SS067-001',
 'HOTSPOT', 0.9006, PARSE_JSON('{"x": 0.1118, "y": 0.1299, "width": 0.0657, "height": 0.2318}'),
 'HIGH', FALSE,
 'RADIATOR', 'Thermal anomaly detected at radiator. Temperature differential: 18°C above ambient.', 'temporal_defect_detector_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS067-001-20251014-127-002', 'VIS-T-SS067-001-20251014-127', 'T-SS067-001',
 'STRUCTURAL_DAMAGE', 0.8303, PARSE_JSON('{"x": 0.2834, "y": 0.4176, "width": 0.2396, "height": 0.2273}'),
 'HIGH', FALSE,
 'SUPPORT_STRUCTURE', 'Deterioration of support structure support structure. Potential stability concern.', 'temporal_defect_detector_v1', 'v2.1';

-- Batch 32/34
INSERT INTO UTILITIES_GRID_RELIABILITY.UNSTRUCTURED.CV_DETECTIONS 
(DETECTION_ID, INSPECTION_ID, ASSET_ID, DETECTION_TYPE, CONFIDENCE_SCORE, BOUNDING_BOX, 
 SEVERITY_LEVEL, REQUIRES_IMMEDIATE_ACTION, DETECTED_AT_COMPONENT, DESCRIPTION, MODEL_NAME, MODEL_VERSION)
SELECT 
 'DET-VIS-T-SS027-001-20241209-128-001', 'VIS-T-SS027-001-20241209-128', 'T-SS027-001',
 'HOTSPOT', 0.9595, PARSE_JSON('{"x": 0.2281, "y": 0.2828, "width": 0.2689, "height": 0.2611}'),
 'HIGH', TRUE,
 'TAP_CHANGER', 'Hot spot identified via infrared scan. tap changer operating 39°C above normal.', 'thermal_anomaly_detector_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS090-001-20250226-129-001', 'VIS-T-SS090-001-20250226-129', 'T-SS090-001',
 'HOTSPOT', 0.9384, PARSE_JSON('{"x": 0.5046, "y": 0.6909, "width": 0.0623, "height": 0.1656}'),
 'HIGH', TRUE,
 'LOAD_CONNECTION', 'Thermal anomaly detected at load connection. Temperature differential: 24°C above ambient.', 'thermal_anomaly_detector_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS059-001-20250417-130-001', 'VIS-T-SS059-001-20250417-130', 'T-SS059-001',
 'STRUCTURAL_DAMAGE', 0.8983, PARSE_JSON('{"x": 0.2308, "y": 0.4019, "width": 0.234, "height": 0.1056}'),
 'HIGH', TRUE,
 'FOUNDATION', 'Structural integrity compromised at foundation. Requires engineering assessment.', 'pointcloud_structural_analyzer_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS059-001-20250417-130-002', 'VIS-T-SS059-001-20250417-130', 'T-SS059-001',
 'STRUCTURAL_DAMAGE', 0.9414, PARSE_JSON('{"x": 0.5207, "y": 0.4138, "width": 0.2994, "height": 0.2009}'),
 'LOW', FALSE,
 'FOUNDATION', 'Deterioration of foundation support structure. Potential stability concern.', 'pointcloud_structural_analyzer_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS050-001-20250806-131-001', 'VIS-T-SS050-001-20250806-131', 'T-SS050-001',
 'CORROSION', 0.9492, PARSE_JSON('{"x": 0.6289, "y": 0.5571, "width": 0.1357, "height": 0.0989}'),
 'LOW', FALSE,
 'BUSHING_BASE', 'Surface corrosion detected on bushing base. Rust visible with paint degradation.', 'temporal_defect_detector_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS050-001-20250806-131-002', 'VIS-T-SS050-001-20250806-131', 'T-SS050-001',
 'VEGETATION', 0.9628, PARSE_JSON('{"x": 0.4903, "y": 0.5199, "width": 0.0687, "height": 0.1416}'),
 'MEDIUM', FALSE,
 'FENCE_LINE', 'Grass and brush overgrowth affecting access to fence line.', 'temporal_defect_detector_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS000-001-20241227-132-001', 'VIS-T-SS000-001-20241227-132', 'T-SS000-001',
 'HOTSPOT', 0.8831, PARSE_JSON('{"x": 0.2475, "y": 0.3624, "width": 0.1218, "height": 0.1553}'),
 'CRITICAL', TRUE,
 'RADIATOR', 'Hot spot identified via infrared scan. radiator operating 25°C above normal.', 'yolov8_transformer_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS000-001-20241227-132-002', 'VIS-T-SS000-001-20241227-132', 'T-SS000-001',
 'STRUCTURAL_DAMAGE', 0.8576, PARSE_JSON('{"x": 0.4664, "y": 0.1604, "width": 0.2429, "height": 0.0619}'),
 'MEDIUM', FALSE,
 'SUPPORT_STRUCTURE', 'Deterioration of support structure support structure. Potential stability concern.', 'yolov8_transformer_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS036-001-20250507-133-001', 'VIS-T-SS036-001-20250507-133', 'T-SS036-001',
 'STRUCTURAL_DAMAGE', 0.9595, PARSE_JSON('{"x": 0.1013, "y": 0.4733, "width": 0.2471, "height": 0.2372}'),
 'MEDIUM', FALSE,
 'MOUNTING', 'Structural integrity compromised at mounting. Requires engineering assessment.', 'yolov8_transformer_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS036-001-20250507-133-002', 'VIS-T-SS036-001-20250507-133', 'T-SS036-001',
 'CRACK', 0.8465, PARSE_JSON('{"x": 0.3159, "y": 0.4039, "width": 0.124, "height": 0.2125}'),
 'HIGH', FALSE,
 'GASKET', 'Linear crack detected in gasket. Length approximately 15-25cm.', 'yolov8_transformer_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS016-001-20241221-134-001', 'VIS-T-SS016-001-20241221-134', 'T-SS016-001',
 'STRUCTURAL_DAMAGE', 0.8657, PARSE_JSON('{"x": 0.3609, "y": 0.6607, "width": 0.2582, "height": 0.1706}'),
 'MEDIUM', FALSE,
 'ENCLOSURE', 'Deterioration of enclosure support structure. Potential stability concern.', 'pointcloud_structural_analyzer_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS010-001-20250707-135-001', 'VIS-T-SS010-001-20250707-135', 'T-SS010-001',
 'VEGETATION', 0.9539, PARSE_JSON('{"x": 0.2483, "y": 0.6564, "width": 0.1065, "height": 0.097}'),
 'MEDIUM', FALSE,
 'FENCE_LINE', 'Excessive vegetation growth detected. Clearance violation at fence line.', 'yolov8_transformer_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS057-001-20251001-136-001', 'VIS-T-SS057-001-20251001-136', 'T-SS057-001',
 'STRUCTURAL_DAMAGE', 0.9162, PARSE_JSON('{"x": 0.1055, "y": 0.1431, "width": 0.0761, "height": 0.0539}'),
 'LOW', FALSE,
 'SUPPORT_STRUCTURE', 'Structural integrity compromised at support structure. Requires engineering assessment.', 'pointcloud_structural_analyzer_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS037-001-20250616-137-001', 'VIS-T-SS037-001-20250616-137', 'T-SS037-001',
 'CORROSION', 0.9168, PARSE_JSON('{"x": 0.4239, "y": 0.6501, "width": 0.2003, "height": 0.1045}'),
 'LOW', FALSE,
 'TANK', 'Moderate to severe corrosion present. Metal oxidation advancing on tank.', 'pointcloud_structural_analyzer_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS076-001-20250515-138-001', 'VIS-T-SS076-001-20250515-138', 'T-SS076-001',
 'STRUCTURAL_DAMAGE', 0.8792, PARSE_JSON('{"x": 0.3358, "y": 0.6288, "width": 0.0609, "height": 0.063}'),
 'CRITICAL', FALSE,
 'SUPPORT_STRUCTURE', 'Deterioration of support structure support structure. Potential stability concern.', 'temporal_defect_detector_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS076-001-20250515-138-002', 'VIS-T-SS076-001-20250515-138', 'T-SS076-001',
 'STRUCTURAL_DAMAGE', 0.8033, PARSE_JSON('{"x": 0.1901, "y": 0.1535, "width": 0.0781, "height": 0.0852}'),
 'HIGH', FALSE,
 'SUPPORT_STRUCTURE', 'Physical damage observed on support structure. Deformation or breakage present.', 'temporal_defect_detector_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS076-001-20250515-138-003', 'VIS-T-SS076-001-20250515-138', 'T-SS076-001',
 'CORROSION', 0.907, PARSE_JSON('{"x": 0.3835, "y": 0.5527, "width": 0.1377, "height": 0.2653}'),
 'MEDIUM', FALSE,
 'MOUNTING_BRACKETS', 'Corrosion patterns suggest moisture ingress. Located on mounting brackets.', 'temporal_defect_detector_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS076-001-20250515-138-004', 'VIS-T-SS076-001-20250515-138', 'T-SS076-001',
 'LEAK', 0.969, PARSE_JSON('{"x": 0.4389, "y": 0.649, "width": 0.1783, "height": 0.2317}'),
 'CRITICAL', FALSE,
 'BUSHING_SEAL', 'Seal failure on bushing seal allowing fluid escape.', 'temporal_defect_detector_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS076-001-20250515-138-005', 'VIS-T-SS076-001-20250515-138', 'T-SS076-001',
 'HOTSPOT', 0.9104, PARSE_JSON('{"x": 0.1515, "y": 0.1774, "width": 0.257, "height": 0.0674}'),
 'LOW', FALSE,
 'RADIATOR', 'Thermal anomaly detected at radiator. Temperature differential: 40°C above ambient.', 'temporal_defect_detector_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS070-001-20250828-139-001', 'VIS-T-SS070-001-20250828-139', 'T-SS070-001',
 'HOTSPOT', 0.942, PARSE_JSON('{"x": 0.2333, "y": 0.3456, "width": 0.1727, "height": 0.1995}'),
 'HIGH', FALSE,
 'LOAD_CONNECTION', 'Hot spot identified via infrared scan. load connection operating 43°C above normal.', 'thermal_anomaly_detector_v2', 'v2.1';

-- Batch 33/34
INSERT INTO UTILITIES_GRID_RELIABILITY.UNSTRUCTURED.CV_DETECTIONS 
(DETECTION_ID, INSPECTION_ID, ASSET_ID, DETECTION_TYPE, CONFIDENCE_SCORE, BOUNDING_BOX, 
 SEVERITY_LEVEL, REQUIRES_IMMEDIATE_ACTION, DETECTED_AT_COMPONENT, DESCRIPTION, MODEL_NAME, MODEL_VERSION)
SELECT 
 'DET-VIS-T-SS070-001-20250828-139-002', 'VIS-T-SS070-001-20250828-139', 'T-SS070-001',
 'HOTSPOT', 0.9511, PARSE_JSON('{"x": 0.3333, "y": 0.5598, "width": 0.2108, "height": 0.2552}'),
 'MEDIUM', FALSE,
 'TAP_CHANGER', 'Hot spot identified via infrared scan. tap changer operating 47°C above normal.', 'thermal_anomaly_detector_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS057-001-20250910-140-001', 'VIS-T-SS057-001-20250910-140', 'T-SS057-001',
 'CORROSION', 0.9425, PARSE_JSON('{"x": 0.4214, "y": 0.4804, "width": 0.1107, "height": 0.1468}'),
 'LOW', FALSE,
 'TANK', 'Surface corrosion detected on tank. Rust visible with paint degradation.', 'thermal_anomaly_detector_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS030-001-20241218-141-001', 'VIS-T-SS030-001-20241218-141', 'T-SS030-001',
 'CORROSION', 0.7602, PARSE_JSON('{"x": 0.6733, "y": 0.4987, "width": 0.1282, "height": 0.2517}'),
 'MEDIUM', FALSE,
 'MOUNTING_BRACKETS', 'Moderate to severe corrosion present. Metal oxidation advancing on mounting brackets.', 'thermal_anomaly_detector_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS030-001-20241218-141-002', 'VIS-T-SS030-001-20241218-141', 'T-SS030-001',
 'HOTSPOT', 0.9439, PARSE_JSON('{"x": 0.5878, "y": 0.6774, "width": 0.0638, "height": 0.1567}'),
 'HIGH', TRUE,
 'BUSHING_CONNECTION', 'Elevated temperature on bushing connection. Possible loose connection or high resistance.', 'thermal_anomaly_detector_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS030-001-20241218-141-003', 'VIS-T-SS030-001-20241218-141', 'T-SS030-001',
 'HOTSPOT', 0.9218, PARSE_JSON('{"x": 0.6358, "y": 0.2716, "width": 0.1933, "height": 0.2634}'),
 'MEDIUM', FALSE,
 'LOAD_CONNECTION', 'Elevated temperature on load connection. Possible loose connection or high resistance.', 'thermal_anomaly_detector_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS038-001-20250129-142-001', 'VIS-T-SS038-001-20250129-142', 'T-SS038-001',
 'HOTSPOT', 0.9087, PARSE_JSON('{"x": 0.4482, "y": 0.6142, "width": 0.1151, "height": 0.1932}'),
 'CRITICAL', FALSE,
 'LOAD_CONNECTION', 'Elevated temperature on load connection. Possible loose connection or high resistance.', 'thermal_anomaly_detector_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS038-001-20250129-142-002', 'VIS-T-SS038-001-20250129-142', 'T-SS038-001',
 'STRUCTURAL_DAMAGE', 0.8431, PARSE_JSON('{"x": 0.5461, "y": 0.5163, "width": 0.1267, "height": 0.2512}'),
 'MEDIUM', FALSE,
 'FOUNDATION', 'Physical damage observed on foundation. Deformation or breakage present.', 'thermal_anomaly_detector_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS073-001-20250205-144-001', 'VIS-T-SS073-001-20250205-144', 'T-SS073-001',
 'CORROSION', 0.7593, PARSE_JSON('{"x": 0.6467, "y": 0.6809, "width": 0.2099, "height": 0.1924}'),
 'CRITICAL', FALSE,
 'MOUNTING_BRACKETS', 'Surface corrosion detected on mounting brackets. Rust visible with paint degradation.', 'thermal_anomaly_detector_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS073-001-20250205-144-002', 'VIS-T-SS073-001-20250205-144', 'T-SS073-001',
 'CORROSION', 0.7805, PARSE_JSON('{"x": 0.3877, "y": 0.6049, "width": 0.2397, "height": 0.0915}'),
 'MEDIUM', FALSE,
 'RADIATOR', 'Surface corrosion detected on radiator. Rust visible with paint degradation.', 'thermal_anomaly_detector_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS068-001-20241230-145-001', 'VIS-T-SS068-001-20241230-145', 'T-SS068-001',
 'CORROSION', 0.8016, PARSE_JSON('{"x": 0.6932, "y": 0.1858, "width": 0.0662, "height": 0.2679}'),
 'CRITICAL', FALSE,
 'RADIATOR', 'Surface corrosion detected on radiator. Rust visible with paint degradation.', 'thermal_anomaly_detector_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS019-001-20250209-146-001', 'VIS-T-SS019-001-20250209-146', 'T-SS019-001',
 'VEGETATION', 0.9795, PARSE_JSON('{"x": 0.1505, "y": 0.2769, "width": 0.2303, "height": 0.207}'),
 'MEDIUM', FALSE,
 'BASE', 'Excessive vegetation growth detected. Clearance violation at base.', 'pointcloud_structural_analyzer_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS019-001-20250209-146-002', 'VIS-T-SS019-001-20250209-146', 'T-SS019-001',
 'CORROSION', 0.93, PARSE_JSON('{"x": 0.5581, "y": 0.5833, "width": 0.2953, "height": 0.1374}'),
 'MEDIUM', FALSE,
 'RADIATOR', 'Corrosion patterns suggest moisture ingress. Located on radiator.', 'pointcloud_structural_analyzer_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS009-001-20250422-147-001', 'VIS-T-SS009-001-20250422-147', 'T-SS009-001',
 'STRUCTURAL_DAMAGE', 0.8065, PARSE_JSON('{"x": 0.565, "y": 0.1616, "width": 0.2603, "height": 0.2579}'),
 'CRITICAL', FALSE,
 'ENCLOSURE', 'Physical damage observed on enclosure. Deformation or breakage present.', 'yolov8_transformer_aerial_v3', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS058-001-20250613-148-001', 'VIS-T-SS058-001-20250613-148', 'T-SS058-001',
 'VEGETATION', 0.9375, PARSE_JSON('{"x": 0.4602, "y": 0.3842, "width": 0.2391, "height": 0.1371}'),
 'LOW', FALSE,
 'BASE', 'Excessive vegetation growth detected. Clearance violation at base.', 'yolov8_transformer_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS058-001-20250613-148-002', 'VIS-T-SS058-001-20250613-148', 'T-SS058-001',
 'VEGETATION', 0.9207, PARSE_JSON('{"x": 0.4416, "y": 0.1807, "width": 0.0733, "height": 0.2288}'),
 'LOW', FALSE,
 'FENCE_LINE', 'Excessive vegetation growth detected. Clearance violation at fence line.', 'yolov8_transformer_v2', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS048-001-20250925-149-001', 'VIS-T-SS048-001-20250925-149', 'T-SS048-001',
 'HOTSPOT', 0.8948, PARSE_JSON('{"x": 0.1936, "y": 0.1754, "width": 0.2626, "height": 0.0677}'),
 'CRITICAL', TRUE,
 'BUSHING_CONNECTION', 'Elevated temperature on bushing connection. Possible loose connection or high resistance.', 'temporal_defect_detector_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS048-001-20250925-149-002', 'VIS-T-SS048-001-20250925-149', 'T-SS048-001',
 'CORROSION', 0.9302, PARSE_JSON('{"x": 0.1004, "y": 0.5321, "width": 0.1027, "height": 0.2114}'),
 'HIGH', TRUE,
 'TANK', 'Corrosion patterns suggest moisture ingress. Located on tank.', 'temporal_defect_detector_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS048-001-20250925-149-003', 'VIS-T-SS048-001-20250925-149', 'T-SS048-001',
 'CRACK', 0.8797, PARSE_JSON('{"x": 0.1455, "y": 0.44, "width": 0.2765, "height": 0.1494}'),
 'LOW', FALSE,
 'GASKET', 'Linear crack detected in gasket. Length approximately 15-25cm.', 'temporal_defect_detector_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS048-001-20250925-149-004', 'VIS-T-SS048-001-20250925-149', 'T-SS048-001',
 'CORROSION', 0.859, PARSE_JSON('{"x": 0.1633, "y": 0.1201, "width": 0.0686, "height": 0.2841}'),
 'MEDIUM', FALSE,
 'RADIATOR', 'Corrosion patterns suggest moisture ingress. Located on radiator.', 'temporal_defect_detector_v1', 'v2.1' UNION ALL SELECT 
 'DET-VIS-T-SS099-001-20250924-150-001', 'VIS-T-SS099-001-20250924-150', 'T-SS099-001',
 'STRUCTURAL_DAMAGE', 0.9226, PARSE_JSON('{"x": 0.2014, "y": 0.348, "width": 0.1214, "height": 0.2912}'),
 'MEDIUM', FALSE,
 'SUPPORT_STRUCTURE', 'Deterioration of support structure support structure. Potential stability concern.', 'yolov8_transformer_aerial_v3', 'v2.1';

-- Batch 34/34
INSERT INTO UTILITIES_GRID_RELIABILITY.UNSTRUCTURED.CV_DETECTIONS 
(DETECTION_ID, INSPECTION_ID, ASSET_ID, DETECTION_TYPE, CONFIDENCE_SCORE, BOUNDING_BOX, 
 SEVERITY_LEVEL, REQUIRES_IMMEDIATE_ACTION, DETECTED_AT_COMPONENT, DESCRIPTION, MODEL_NAME, MODEL_VERSION)
SELECT 
 'DET-VIS-T-SS099-001-20250924-150-002', 'VIS-T-SS099-001-20250924-150', 'T-SS099-001',
 'CORROSION', 0.9268, PARSE_JSON('{"x": 0.176, "y": 0.2597, "width": 0.0667, "height": 0.2175}'),
 'MEDIUM', FALSE,
 'RADIATOR', 'Corrosion patterns suggest moisture ingress. Located on radiator.', 'yolov8_transformer_aerial_v3', 'v2.1';


-- Verification
SELECT (SELECT COUNT(*) FROM MAINTENANCE_LOG_DOCUMENTS) as MAINT_LOGS, (SELECT COUNT(*) FROM TECHNICAL_MANUALS) as TECH_MANUALS, (SELECT COUNT(*) FROM VISUAL_INSPECTIONS) as VISUAL_INSPECTIONS, (SELECT COUNT(*) FROM CV_DETECTIONS) as CV_DETECTIONS;
