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

## Step 6: Dashboard (Already Deployed! ✅)

The **Streamlit in Snowflake Dashboard** is automatically deployed by `deploy.sh` (Phase 8).

**Access the Dashboard:**

1. **From Snowflake UI:**
   - Navigate to: **Projects** → **Streamlit**
   - Click on: **`GRID_RELIABILITY_DASHBOARD`**

2. **Or use Direct URL:**
   ```
   https://<your-account>.snowflakecomputing.com/streamlit/UTILITIES_GRID_RELIABILITY.ANALYTICS.GRID_RELIABILITY_DASHBOARD
   ```

**Dashboard Features:**
- 📊 **Overview** - Executive KPIs, risk distribution, financial metrics
- 🗺️ **Asset Map** - Geographic heatmap with color-coded risk scores
- ⚠️ **High-Risk Alerts** - Real-time critical asset notifications
- 📈 **Asset Details** - 30-day sensor trends for individual assets
- 💰 **ROI Calculator** - Financial impact analysis
- 📋 **Work Orders** - Automated maintenance work order generation

✅ **Verify**: Dashboard opens in browser with all 6 pages accessible

---

## 🎯 Quick Demo

### Dashboard Demo (3 minutes)
1. Open dashboard in Snowflake → Overview page
2. See 100 assets, all currently at 100 risk score (expected with demo data)
3. Navigate to Asset Map → See geographic distribution across Florida
4. Click High-Risk Alerts → See 100 critical assets with predictions
5. Click Asset Details → Select asset and view 30-day sensor trends
6. Click ROI Calculator → See financial impact and scenario modeling

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


