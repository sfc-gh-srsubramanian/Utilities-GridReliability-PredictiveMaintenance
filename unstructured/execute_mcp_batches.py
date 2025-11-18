"""
Parse the bulk_load_statements.sql file and print batch info for MCP execution
"""
import re
from pathlib import Path

sql_file = Path(__file__).parent / "bulk_load_statements.sql"

with open(sql_file, 'r') as f:
    content = f.read()

# Find all batch comments
batch_pattern = r'-- Batch (\d+)/(\d+)'
batches = re.findall(batch_pattern, content)

# Split by batch markers
batch_sections = re.split(r'-- Batch \d+/\d+\n', content)[1:]  # Skip header

print(f"\n📊 Bulk Load SQL Analysis")
print(f"="*60)
print(f"Total batches found: {len(batch_sections)}")
print(f"="*60)

# Analyze each batch
for i, section in enumerate(batch_sections, 1):
    # Extract table name
    table_match = re.search(r'INSERT INTO [^\s]+\.([A-Z_]+)', section)
    table = table_match.group(1) if table_match else "UNKNOWN"
    
    # Count rows (by counting UNION ALL or SELECT statements)
    union_count = section.count('UNION ALL') + 1
    
    # Get statement length
    stmt_length = len(section.strip())
    
    print(f"Batch {i:2d}: {table:30s} | {union_count:3d} rows | {stmt_length:6,d} chars")

print(f"\n💡 Recommendation: Execute in Snowsight for faster loading")
print(f"   File: {sql_file}")

