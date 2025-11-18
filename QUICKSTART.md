# Quick Start Guide

## 🚀 Get Up and Running in 30 Minutes

This guide gets you a working demo environment quickly. For production deployment, see `DEPLOYMENT_GUIDE.md`.

---

## Prerequisites

- Snowflake account
- Python 3.11+
- 10-15 GB free disk space (for sample data)

---

## Step 1: Database Setup (5 minutes)

```bash
# Connect to Snowflake
snowsql -a <your_account> -u <your_user>

# Run all setup scripts
!source database/01_setup_database_schema.sql
!source database/02_create_stages.sql
!source database/03_create_pipes.sql
!source database/04_create_streams_tasks.sql
```

✅ **Verify**: `SHOW SCHEMAS IN DATABASE UTILITIES_GRID_RELIABILITY;` should show 5 schemas

---

## Step 2: Generate Sample Data (10 minutes)

```bash
cd data
pip install pandas numpy
python data_generator.py --output-dir ./generated_data
```

✅ **Verify**: Check `./generated_data/` folder contains CSV and JSON files

---

## Step 3: Load Data (10 minutes)

```bash
# Upload files
cd generated_data
snowsql -q "PUT file://$(pwd)/asset_master.csv @RAW.ASSET_DATA_STAGE AUTO_COMPRESS=TRUE;"
snowsql -q "PUT file://$(pwd)/sensor_readings_batch_*.json @RAW.SENSOR_DATA_STAGE AUTO_COMPRESS=TRUE;"
snowsql -q "PUT file://$(pwd)/maintenance_history.csv @RAW.MAINTENANCE_DATA_STAGE AUTO_COMPRESS=TRUE;"
```

```sql
-- Load into tables
COPY INTO RAW.ASSET_MASTER FROM @RAW.ASSET_DATA_STAGE 
FILE_FORMAT = (FORMAT_NAME = 'CSV_FORMAT') MATCH_BY_COLUMN_NAME=CASE_INSENSITIVE;

ALTER PIPE RAW.SENSOR_READINGS_PIPE REFRESH;
-- Wait 2-3 minutes

COPY INTO RAW.MAINTENANCE_HISTORY FROM @RAW.MAINTENANCE_DATA_STAGE 
FILE_FORMAT = (FORMAT_NAME = 'CSV_FORMAT') MATCH_BY_COLUMN_NAME=CASE_INSENSITIVE;
```

✅ **Verify**: `SELECT COUNT(*) FROM RAW.SENSOR_READINGS;` should return ~4.3M

---

## Step 4: ML Pipeline (5 minutes)

```sql
-- Create features
!source ml_models/01_feature_engineering.sql

-- Prepare training data
!source ml_models/02_training_data_prep.sql

-- Train models (takes 5-10 min)
!source ml_models/03_model_training_stored_proc.sql

-- Generate predictions
!source ml_models/04_model_scoring.sql
```

✅ **Verify**: `SELECT * FROM ANALYTICS.VW_HIGH_RISK_ASSETS;` shows high-risk assets

---

## Step 5: Intelligence Agent (5 minutes)

```bash
# Upload semantic model
snowsql -q "PUT file://$(pwd)/semantic_model/grid_reliability_semantic.yaml @ANALYTICS.SEMANTIC_MODEL_STAGE AUTO_COMPRESS=FALSE;"
```

```sql
-- Create semantic view and agent
!source semantic_model/create_semantic_view.sql
!source agents/create_grid_intelligence_agent.sql
```

✅ **Verify**: Snowflake UI → Projects → Intelligence → See "Grid Reliability Intelligence Agent"

---

## Step 6: Dashboard (5 minutes)

```bash
cd dashboard
pip install streamlit pandas plotly snowflake-connector-python snowflake-snowpark-python

# Create config file
mkdir -p .streamlit
cat > .streamlit/secrets.toml << EOF
[snowflake]
account = "your_account"
user = "your_user"  
password = "your_password"
warehouse = "GRID_RELIABILITY_WH"
database = "UTILITIES_GRID_RELIABILITY"
schema = "ANALYTICS"
role = "GRID_OPERATOR"
EOF

# Launch
streamlit run grid_reliability_dashboard.py
```

✅ **Verify**: Browser opens to http://localhost:8501 with dashboard

---

## 🎯 Quick Demo

### Dashboard Demo (3 minutes)
1. Open dashboard → Overview page
2. See 100 assets, ~10-15 high-risk
3. Navigate to Asset Map → See geographic distribution
4. Click High-Risk Alerts → See critical assets
5. Click ROI Calculator → See $25M+ savings

### Intelligence Agent Demo (2 minutes)
1. Snowflake UI → Projects → Intelligence
2. Ask: "Which substations have the highest risk?"
3. Ask: "Tell me about transformer T-SS047-001"
4. Ask: "What's our total cost avoidance?"

---

## 🎬 Featured Demo Asset

**Transformer T-SS047-001** (West Palm Beach)
- Risk Score: 89/100 (CRITICAL)
- Serves: 12,500 customers
- Failure Probability: 87%
- Days to Failure: 21 days
- Cost Avoidance: $405,000

Use this asset for live demonstrations!

---

## 🔧 Troubleshooting

**Data not loading?**
```sql
SELECT SYSTEM$PIPE_STATUS('RAW.SENSOR_READINGS_PIPE');
ALTER PIPE RAW.SENSOR_READINGS_PIPE REFRESH;
```

**Models not training?**
- Check: `SELECT COUNT(*) FROM ML.TRAINING_DATA;` (need >1,000 records)
- Increase warehouse size temporarily: `ALTER WAREHOUSE GRID_RELIABILITY_WH SET WAREHOUSE_SIZE='SMALL';`

**Dashboard won't connect?**
- Verify credentials in `.streamlit/secrets.toml`
- Test: `snowsql -a <account> -u <user>`

---

## 📚 Next Steps

- **Full Deployment**: See `DEPLOYMENT_GUIDE.md`
- **Demo Script**: See `docs/demo_script.md`
- **Business Case**: See `docs/business_case.md`
- **Architecture**: See `docs/architecture.md`

---

## 🆘 Need Help?

Check `DEPLOYMENT_GUIDE.md` → Troubleshooting section

---

**You're all set!** 🎉 Start exploring your AI-powered grid reliability system!


