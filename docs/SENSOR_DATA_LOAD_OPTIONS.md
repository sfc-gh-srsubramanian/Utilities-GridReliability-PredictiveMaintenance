# Sensor Data Load Options

You have **3 options** to load the 432,000 sensor readings into Snowflake:

---

## ⚡ Option 1: Automated Shell Script (RECOMMENDED)
**Fastest & Easiest - 10-15 seconds total**

Simply run:
```bash
./load_sensor_data.sh
```

This script will:
- ✅ Check for generated data files
- ✅ Upload JSON files to Snowflake stage
- ✅ Load all data using COPY INTO
- ✅ Verify the load with count queries
- ✅ Display summary statistics

**Prerequisites:**
- SnowSQL installed and configured (`demo_tools` connection)
- Passphrase in `~/.snowsql/config`
- Generated data files in `generated_data/` directory

---

## 🎯 Option 2: Manual SnowSQL Script
**Fast - 10-15 seconds + manual setup**

### Step 1: Upload files to stage
```bash
cd "/Users/srsubramanian/cursor/AI-driven Grid Reliability & Predictive Maintenance"

export SNOWSQL_PRIVATE_KEY_PASSPHRASE="<your_passphrase>"

snowsql -c demo_tools -d UTILITIES_GRID_RELIABILITY -s RAW << 'EOF'
PUT file://generated_data/sensor_readings_batch_*.json @SENSOR_DATA_STAGE AUTO_COMPRESS=TRUE;
EOF
```

### Step 2: Run the load script
```bash
snowsql -c demo_tools -d UTILITIES_GRID_RELIABILITY -s RAW \
  -f data/load_all_sensor_data.sql
```

---

## 🐌 Option 3: Continue MCP Load (NOT RECOMMENDED)
**Very Slow - 2-3 hours estimated**

Continue loading via MCP in small batches. This was attempted but is impractical for bulk data:
- Only 24 of 432,000 readings loaded so far
- Each batch requires separate API call
- Subject to MCP size and timeout limits

**This option is only viable for small datasets (<1000 rows)**

---

## 📊 Current Status

| Item | Current | Target | Status |
|------|---------|--------|--------|
| Assets | 100 | 100 | ✅ Complete |
| Maintenance | 192 | ~187 | ✅ Complete |
| Sensor Readings | **24** | **432,000** | ⚠️ 0.006% loaded |
| Training Data | 6 | 6 | ✅ Complete |
| Models | 1 | 1 | ✅ Complete |
| Predictions | 30 | 30 | ✅ Complete |

---

## 🚀 After Loading Data

Once sensor data is fully loaded, run these commands to retrain models with real data:

```sql
-- 1. Retrain ML models
USE DATABASE UTILITIES_GRID_RELIABILITY;
USE SCHEMA ML;
USE WAREHOUSE COMPUTE_WH;

CALL TRAIN_FAILURE_PREDICTION_MODELS();

-- 2. Generate new predictions
CALL SCORE_ASSETS();

-- 3. View high-risk assets
SELECT * FROM ANALYTICS.VW_HIGH_RISK_ASSETS
ORDER BY RISK_SCORE DESC;

-- 4. Check feature engineering
SELECT * FROM ML.VW_ASSET_FEATURES_DAILY
WHERE ASSET_ID = 'T-SS000-001'
ORDER BY FEATURE_TIMESTAMP DESC
LIMIT 10;
```

---

## ❓ Troubleshooting

### "Permission denied" on shell script
```bash
chmod +x load_sensor_data.sh
```

### "Cannot find private_key_passphrase"
Add to `~/.snowsql/config`:
```ini
[connections.demo_tools]
private_key_passphrase = <your_passphrase>
```

### "generated_data directory not found"
Run the data generator first:
```bash
python3 data/data_generator.py
```

### SnowSQL not installed
```bash
# macOS
brew install snowflake-snowsql

# Or download from: https://docs.snowflake.com/en/user-guide/snowsql-install-config
```

---

## 📈 Performance Comparison

| Method | Time | Complexity | Reliability |
|--------|------|------------|-------------|
| **Shell Script** | 10-15 sec | ⭐ Low | ⭐⭐⭐ High |
| **Manual SnowSQL** | 10-15 sec | ⭐⭐ Medium | ⭐⭐⭐ High |
| **MCP Load** | 2-3 hours | ⭐⭐⭐ High | ⭐ Low |

**Recommendation: Use Option 1 (Shell Script)**

---

## 🎯 Quick Commands

```bash
# Option 1 - Run automated script
./load_sensor_data.sh

# Option 2 - Manual load
export SNOWSQL_PRIVATE_KEY_PASSPHRASE="<passphrase>"
snowsql -c demo_tools -d UTILITIES_GRID_RELIABILITY -s RAW \
  -f data/load_all_sensor_data.sql

# Verify load
snowsql -c demo_tools -d UTILITIES_GRID_RELIABILITY -s RAW \
  -q "SELECT COUNT(*) FROM SENSOR_READINGS;"
```

---

*Last Updated: November 17, 2025*

