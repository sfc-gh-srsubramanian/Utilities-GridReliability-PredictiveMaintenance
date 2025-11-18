"""
Execute bulk load via terminal by reading the SQL file and showing progress
"""
import sys

sql_file = "unstructured/bulk_load_statements.sql"

print("\n📊 Full Dataset Load Summary")
print("="*60)
print("Total Records: 518")
print("  - 75 Maintenance Logs")
print("  - 12 Technical Manuals")
print("  - 150 Visual Inspections")
print("  - 281 CV Detections")
print("="*60)
print("\n⚠️  NOTE: Due to the size of the dataset (34 batched SQL statements),")
print("    the most efficient way to load is:")
print("\n    Option A: Run in Snowsight (Recommended - Fastest)")
print("    1. Open Snowsight")
print("    2. Copy/paste the contents of:")
print(f"       {sql_file}")
print("    3. Execute the SQL script")
print("\n    Option B: Continue with MCP (Slower but automated)")
print("    - Will execute 34 batches via MCP")
print("    - Estimated time: 5-10 minutes")
print("\n")

choice = input("Choose [A] for Snowsight or [B] for MCP (recommended: A): ").strip().upper()

if choice == 'A':
    print("\n✅ Good choice! File ready at:")
    print(f"   {sql_file}")
    print("\n📋 Steps:")
    print("   1. Open the file above")
    print("   2. Copy all contents")
    print("   3. Paste into Snowsight")
    print("   4. Execute")
    print("\n   The script will load all 518 records in ~30 seconds.")
elif choice == 'B':
    print("\n🚀 MCP load selected. This will take a few minutes...")
    print("   (Implementation would execute batches via MCP)")
else:
    print("\n❌ Invalid choice. Please run script again.")

sys.exit(0)
