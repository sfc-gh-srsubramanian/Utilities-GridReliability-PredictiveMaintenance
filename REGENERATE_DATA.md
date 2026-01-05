# Data Regeneration Required

**Date:** January 4, 2026  
**Status:** ⚠️ ACTION REQUIRED

---

## Why Regeneration is Needed

The data generator has been fixed to ensure **100% schema compliance**. The current generated data files contain **13 records** with HUMIDITY_PCT values exceeding 100, which will cause deployment failures due to schema constraints.

---

## What Was Fixed

**File:** `python/data_generators/generate_asset_data.py`  
**Line:** 293

**Change:**
```python
# BEFORE (could generate humidity > 100)
"HUMIDITY_PCT": round(70 + 15 * np.sin((month - 1) * np.pi / 6) + np.random.normal(0, 5), 2),

# AFTER (constrained to 0-100 range)
"HUMIDITY_PCT": round(np.clip(70 + 15 * np.sin((month - 1) * np.pi / 6) + np.random.normal(0, 5), 0, 100), 2),
```

---

## How to Regenerate Data

### Option 1: Full Regeneration (Recommended)

**Time Required:** ~10-15 minutes  
**Impact:** All data regenerated with new random seed

```bash
cd python/data_generators

# Generate all data files
python3 generate_asset_data.py \
    --output-dir ../../generated_data \
    --months 1 \
    --assets 100 \
    --failure-rate 0.10

# This will create:
# - asset_master.csv (100 assets)
# - sensor_readings_batch_1-5.json (~432,000 records for 1 month)
# - maintenance_history.csv (~192 records)
# - failure_events.csv (10 failures)
```

### Option 2: Quick Verification (Testing Only)

Generate small sample to verify fix:

```bash
python3 generate_asset_data.py \
    --output-dir ../../test_data \
    --months 1 \
    --assets 10 \
    --failure-rate 0.10
```

Then validate:

```python
import json

violations = 0
total = 0

for i in range(1, 6):
    try:
        with open(f"test_data/sensor_readings_batch_{i}.json") as f:
            for line in f:
                data = json.loads(line)
                total += 1
                if data["HUMIDITY_PCT"] < 0 or data["HUMIDITY_PCT"] > 100:
                    violations += 1
    except FileNotFoundError:
        pass

print(f"Total records: {total:,}")
print(f"Violations: {violations}")
print(f"Status: {'✅ PASS' if violations == 0 else '⚠️ FAIL'}")
```

---

## Alternative: Deploy Without Regeneration (Quick Fix)

If you need to deploy immediately without regeneration, you can temporarily disable the constraint:

### ⚠️ NOT RECOMMENDED FOR PRODUCTION

```sql
-- In sql/02_structured_data_schema.sql, comment out:
-- ALTER TABLE RAW.SENSOR_READINGS ADD CONSTRAINT CHK_HUMIDITY_RANGE 
--     CHECK (HUMIDITY_PCT IS NULL OR (HUMIDITY_PCT BETWEEN 0 AND 100));
```

**Drawbacks:**
- No data quality enforcement
- May cause issues with downstream analytics
- Technical debt that must be addressed later

---

## Verification Steps

After regeneration, verify data quality:

### 1. Check File Sizes
```bash
ls -lh generated_data/

# Expected sizes (1 month):
# - asset_master.csv: ~20KB
# - sensor_readings_batch_1-5.json: ~40-45MB each
# - maintenance_history.csv: ~25KB
# - failure_events.csv: ~2KB
```

### 2. Validate Schema Compliance
```bash
python3 << 'EOF'
import json
import pandas as pd

# Check asset criticality scores
assets = pd.read_csv("generated_data/asset_master.csv")
crit_violations = len(assets[(assets["CRITICALITY_SCORE"] < 0) | (assets["CRITICALITY_SCORE"] > 100)])
print(f"Asset criticality violations: {crit_violations}")

# Check sensor humidity
humidity_violations = 0
for i in range(1, 6):
    try:
        with open(f"generated_data/sensor_readings_batch_{i}.json") as f:
            for line in f:
                data = json.loads(line)
                if data["HUMIDITY_PCT"] < 0 or data["HUMIDITY_PCT"] > 100:
                    humidity_violations += 1
    except FileNotFoundError:
        pass

print(f"Humidity violations: {humidity_violations}")
print(f"\nOverall: {'✅ READY TO DEPLOY' if crit_violations == 0 and humidity_violations == 0 else '⚠️ ISSUES FOUND'}")
EOF
```

### 3. Test Load in Snowflake
```sql
-- Test with a small batch first
COPY INTO RAW.SENSOR_READINGS 
FROM @SENSOR_DATA_STAGE/sensor_readings_batch_1.json
FILE_FORMAT = (FORMAT_NAME = 'JSON_FORMAT')
MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE
VALIDATION_MODE = RETURN_ERRORS;

-- If successful, load all batches
COPY INTO RAW.SENSOR_READINGS 
FROM @SENSOR_DATA_STAGE
FILE_FORMAT = (FORMAT_NAME = 'JSON_FORMAT')
MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE;
```

---

## Timeline

| Task | Time | Priority |
|------|------|----------|
| Apply code fix | ✅ Complete | Critical |
| Regenerate 1 month data | ~15 minutes | High |
| Validate compliance | ~2 minutes | High |
| Test deployment | ~5 minutes | Medium |
| **Total** | **~22 minutes** | - |

---

## Notes

- The fix uses `np.clip()` which is a standard NumPy function
- No changes needed to CSV generators (asset_master, maintenance_history, failure_events)
- Only sensor readings JSON files need regeneration
- The random seed can be kept the same for reproducibility

---

## Status

- [x] Code fix applied
- [ ] Data regenerated
- [ ] Validation passed
- [ ] Ready for deployment

**Next Action:** Run regeneration command above

---

For questions or issues, refer to `SCHEMA_VALIDATION_REPORT.md` for detailed analysis.

