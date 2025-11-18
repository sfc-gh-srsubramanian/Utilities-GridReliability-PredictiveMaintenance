"""
Bulk load all unstructured data (518 records) into Snowflake
Uses batched inserts for efficiency
"""

import json
from pathlib import Path

# File paths
BASE_DIR = Path(__file__).parent.parent
MAINT_LOGS_FILE = BASE_DIR / "data/generated_maintenance_logs/maintenance_logs_metadata.json"
TECH_MANUALS_FILE = BASE_DIR / "data/generated_technical_manuals/technical_manuals_metadata.json"
VISUAL_INSP_FILE = BASE_DIR / "data/generated_visual_inspections/visual_inspections_metadata.json"
CV_DETECTIONS_FILE = BASE_DIR / "data/generated_visual_inspections/cv_detections.json"

def generate_maintenance_logs_insert():
    """Generate INSERT statements for maintenance logs"""
    
    print("📋 Processing maintenance logs...")
    
    with open(MAINT_LOGS_FILE, 'r') as f:
        logs = [json.loads(line) for line in f]
    
    print(f"   Found {len(logs)} maintenance logs")
    
    # Generate SQL INSERT statements in batches
    sql_statements = []
    batch_size = 10
    
    for i in range(0, len(logs), batch_size):
        batch = logs[i:i+batch_size]
        
        values = []
        for log in batch:
            root_causes_json = json.dumps(log['ROOT_CAUSE_KEYWORDS'])
            actions_json = json.dumps(log['RECOMMENDED_ACTIONS'])
            
            # Escape single quotes in text
            doc_text = log['DOCUMENT_TEXT'].replace("'", "''")
            summary = doc_text[:500].replace("'", "''")  # First 500 chars as summary
            
            value = f"""(
                '{log['DOCUMENT_ID']}', '{log['ASSET_ID']}', '{log['DOCUMENT_TYPE']}', 
                '{log['DOCUMENT_DATE']}'::DATE, '{log['TECHNICIAN_NAME']}', '{log['TECHNICIAN_ID']}',
                '{log['FILE_PATH']}', {log['FILE_SIZE_BYTES']}, '{log['FILE_FORMAT']}',
                '{log['MAINTENANCE_TYPE']}', {log['DURATION_HOURS']}, {log['COST_USD']},
                {str(log['FAILURE_OCCURRED']).upper()}, '{doc_text}', '{summary}',
                PARSE_JSON('{root_causes_json}'), '{log['SEVERITY_LEVEL']}',
                PARSE_JSON('{actions_json}')
            )"""
            values.append(value)
        
        sql = f"""INSERT INTO UTILITIES_GRID_RELIABILITY.UNSTRUCTURED.MAINTENANCE_LOG_DOCUMENTS 
(DOCUMENT_ID, ASSET_ID, DOCUMENT_TYPE, DOCUMENT_DATE, TECHNICIAN_NAME, TECHNICIAN_ID, 
 FILE_PATH, FILE_SIZE_BYTES, FILE_FORMAT, MAINTENANCE_TYPE, DURATION_HOURS, COST_USD, 
 FAILURE_OCCURRED, DOCUMENT_TEXT, SUMMARY, ROOT_CAUSE_KEYWORDS, SEVERITY_LEVEL, RECOMMENDED_ACTIONS)
SELECT {','.join(values)};"""
        
        sql_statements.append(sql)
    
    return sql_statements, len(logs)

def generate_technical_manuals_insert():
    """Generate INSERT statements for technical manuals"""
    
    print("📚 Processing technical manuals...")
    
    with open(TECH_MANUALS_FILE, 'r') as f:
        manuals = [json.loads(line) for line in f if line.strip()]
    
    print(f"   Found {len(manuals)} technical manuals")
    
    values = []
    for manual in manuals:
        value = f"""SELECT 
 '{manual['MANUAL_ID']}', '{manual['MANUAL_TYPE']}', '{manual['EQUIPMENT_TYPE']}',
 '{manual['MANUFACTURER']}', '{manual['MODEL']}', '{manual['VERSION']}',
 '{manual['PUBLICATION_DATE']}'::DATE, '{manual['FILE_PATH']}',
 {manual['FILE_SIZE_BYTES']}, {manual['PAGE_COUNT']}"""
        values.append(value)
    
    sql = f"""INSERT INTO UTILITIES_GRID_RELIABILITY.UNSTRUCTURED.TECHNICAL_MANUALS 
(MANUAL_ID, MANUAL_TYPE, EQUIPMENT_TYPE, MANUFACTURER, MODEL, VERSION, PUBLICATION_DATE, 
 FILE_PATH, FILE_SIZE_BYTES, PAGE_COUNT)
{' UNION ALL '.join(values)};"""
    
    return [sql], len(manuals)

def generate_visual_inspections_insert():
    """Generate INSERT statements for visual inspections"""
    
    print("📸 Processing visual inspections...")
    
    with open(VISUAL_INSP_FILE, 'r') as f:
        inspections = [json.loads(line) for line in f]
    
    print(f"   Found {len(inspections)} visual inspections")
    
    sql_statements = []
    batch_size = 15
    
    for i in range(0, len(inspections), batch_size):
        batch = inspections[i:i+batch_size]
        
        values = []
        for insp in batch:
            value = f"""SELECT 
 '{insp['INSPECTION_ID']}', '{insp['ASSET_ID']}', '{insp['INSPECTION_DATE']}'::DATE,
 '{insp['INSPECTOR_NAME']}', '{insp['INSPECTOR_ID']}', '{insp['INSPECTION_METHOD']}',
 '{insp['WEATHER_CONDITIONS']}', '{insp['FILE_PATH']}', '{insp['FILE_TYPE']}',
 {insp['FILE_SIZE_BYTES']}, '{insp['RESOLUTION']}', {insp['GPS_LATITUDE']}, {insp['GPS_LONGITUDE']},
 {str(insp['CV_PROCESSED']).upper()}, '{insp['CV_PROCESSING_TIMESTAMP']}'::TIMESTAMP_NTZ"""
            values.append(value)
        
        sql = f"""INSERT INTO UTILITIES_GRID_RELIABILITY.UNSTRUCTURED.VISUAL_INSPECTIONS 
(INSPECTION_ID, ASSET_ID, INSPECTION_DATE, INSPECTOR_NAME, INSPECTOR_ID, INSPECTION_METHOD, 
 WEATHER_CONDITIONS, FILE_PATH, FILE_TYPE, FILE_SIZE_BYTES, RESOLUTION, GPS_LATITUDE, GPS_LONGITUDE, 
 CV_PROCESSED, CV_PROCESSING_TIMESTAMP)
{' UNION ALL '.join(values)};"""
        
        sql_statements.append(sql)
    
    return sql_statements, len(inspections)

def generate_cv_detections_insert():
    """Generate INSERT statements for CV detections"""
    
    print("🔍 Processing CV detections...")
    
    with open(CV_DETECTIONS_FILE, 'r') as f:
        detections = [json.loads(line) for line in f]
    
    print(f"   Found {len(detections)} CV detections")
    
    sql_statements = []
    batch_size = 20
    
    for i in range(0, len(detections), batch_size):
        batch = detections[i:i+batch_size]
        
        values = []
        for det in batch:
            bbox_json = json.dumps(det['BOUNDING_BOX'])
            desc = det['DESCRIPTION'].replace("'", "''")
            
            value = f"""SELECT 
 '{det['DETECTION_ID']}', '{det['INSPECTION_ID']}', '{det['ASSET_ID']}',
 '{det['DETECTION_TYPE']}', {det['CONFIDENCE_SCORE']}, PARSE_JSON('{bbox_json}'),
 '{det['SEVERITY_LEVEL']}', {str(det['REQUIRES_IMMEDIATE_ACTION']).upper()},
 '{det['DETECTED_AT_COMPONENT']}', '{desc}', '{det['MODEL_NAME']}', '{det['MODEL_VERSION']}'"""
            values.append(value)
        
        sql = f"""INSERT INTO UTILITIES_GRID_RELIABILITY.UNSTRUCTURED.CV_DETECTIONS 
(DETECTION_ID, INSPECTION_ID, ASSET_ID, DETECTION_TYPE, CONFIDENCE_SCORE, BOUNDING_BOX, 
 SEVERITY_LEVEL, REQUIRES_IMMEDIATE_ACTION, DETECTED_AT_COMPONENT, DESCRIPTION, MODEL_NAME, MODEL_VERSION)
{' UNION ALL '.join(values)};"""
        
        sql_statements.append(sql)
    
    return sql_statements, len(detections)

def main():
    """Generate all SQL statements"""
    
    print("\n🚀 Generating bulk load SQL statements...\n")
    
    all_statements = []
    
    # Generate INSERT statements for each table
    maint_stmts, maint_count = generate_maintenance_logs_insert()
    all_statements.extend(maint_stmts)
    
    manual_stmts, manual_count = generate_technical_manuals_insert()
    all_statements.extend(manual_stmts)
    
    visual_stmts, visual_count = generate_visual_inspections_insert()
    all_statements.extend(visual_stmts)
    
    cv_stmts, cv_count = generate_cv_detections_insert()
    all_statements.extend(cv_stmts)
    
    total_records = maint_count + manual_count + visual_count + cv_count
    
    print(f"\n✅ Generated {len(all_statements)} SQL statements for {total_records} records")
    print(f"   📋 Maintenance logs: {maint_count} ({len(maint_stmts)} batches)")
    print(f"   📚 Technical manuals: {manual_count} ({len(manual_stmts)} batches)")
    print(f"   📸 Visual inspections: {visual_count} ({len(visual_stmts)} batches)")
    print(f"   🔍 CV detections: {cv_count} ({len(cv_stmts)} batches)")
    
    # Save to file
    output_file = Path(__file__).parent / "bulk_load_statements.sql"
    with open(output_file, 'w') as f:
        f.write("-- BULK LOAD ALL UNSTRUCTURED DATA\n")
        f.write(f"-- Total: {total_records} records in {len(all_statements)} batches\n")
        f.write("-- Generated: " + str(Path(__file__).resolve()) + "\n\n")
        f.write("USE DATABASE UTILITIES_GRID_RELIABILITY;\n")
        f.write("USE SCHEMA UNSTRUCTURED;\n")
        f.write("USE WAREHOUSE COMPUTE_WH;\n\n")
        
        for i, stmt in enumerate(all_statements, 1):
            f.write(f"-- Batch {i}/{len(all_statements)}\n")
            f.write(stmt + "\n\n")
        
        f.write(f"\n-- Verification\nSELECT ")
        f.write(f"(SELECT COUNT(*) FROM MAINTENANCE_LOG_DOCUMENTS) as MAINT_LOGS, ")
        f.write(f"(SELECT COUNT(*) FROM TECHNICAL_MANUALS) as TECH_MANUALS, ")
        f.write(f"(SELECT COUNT(*) FROM VISUAL_INSPECTIONS) as VISUAL_INSPECTIONS, ")
        f.write(f"(SELECT COUNT(*) FROM CV_DETECTIONS) as CV_DETECTIONS;\n")
    
    print(f"\n📄 SQL file saved: {output_file}")
    print(f"\n💡 Ready to execute via MCP or Snowsight!")
    
    return all_statements

if __name__ == "__main__":
    statements = main()

