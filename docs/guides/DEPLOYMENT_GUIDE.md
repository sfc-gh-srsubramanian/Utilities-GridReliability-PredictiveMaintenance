# Deployment Guide: AI-Driven Grid Reliability & Predictive Maintenance

## 🎯 Overview

This guide provides step-by-step instructions to deploy the complete Grid Reliability and Predictive Maintenance system in your Snowflake environment.

**Estimated Deployment Time**: 2-3 hours  
**Prerequisites**: Snowflake account with appropriate privileges, Python 3.11+

---

## 📋 Pre-Deployment Checklist

- [ ] Snowflake account with ACCOUNTADMIN role access
- [ ] Python 3.11 or higher installed
- [ ] Git repository cloned/files available
- [ ] Snowflake CLI (`snowsql`) or SnowSQL installed
- [ ] Text editor for configuration

---

## 🚀 Step-by-Step Deployment

### **Phase 1: Database Setup (30 minutes)**

#### Step 1.1: Connect to Snowflake

```bash
# Option A: Using SnowSQL
snowsql -a <your_account> -u <your_user>

# Option B: Using Snowflake Web UI
# Navigate to Worksheets → Create new SQL worksheet
```

#### Step 1.2: Run Database Setup Scripts

Execute scripts in order:

```sql
-- 1. Create database, schemas, tables
!source database/01_setup_database_schema.sql

-- Verify: Should see database and 5 schemas
SHOW SCHEMAS IN DATABASE UTILITIES_GRID_RELIABILITY;
```

```sql
-- 2. Create stages for data ingestion
!source database/02_create_stages.sql

-- Verify: Should see multiple stages
SHOW STAGES;
```

```sql
-- 3. Create Snowpipes for continuous ingestion
!source database/03_create_pipes.sql

-- Verify: Should see 4 pipes
SHOW PIPES;
```

```sql
-- 4. Create streams and tasks
!source database/04_create_streams_tasks.sql

-- Verify: Tasks are created (suspended initially)
SHOW TASKS;
```

**Checkpoint**: You should now have:
- ✅ Database: `UTILITIES_GRID_RELIABILITY`
- ✅ Schemas: RAW, FEATURES, ML, ANALYTICS, STAGING
- ✅ Warehouse: `GRID_RELIABILITY_WH` (X-SMALL)
- ✅ Tables: ASSET_MASTER, SENSOR_READINGS, etc.
- ✅ Stages, Pipes, Streams, Tasks (all created)

---

### **Phase 2: Data Generation & Loading (45 minutes)**

#### Step 2.1: Generate Synthetic Data

```bash
cd data
pip install pandas numpy

python data_generator.py \
  --output-dir ./generated_data \
  --months 6 \
  --assets 100 \
  --failure-rate 0.10
```

**Output**: 
- `asset_master.csv`
- `sensor_readings_batch_*.json` (multiple files)
- `maintenance_history.csv`
- `failure_events.csv`

#### Step 2.2: Upload Data to Snowflake

```bash
# Upload asset master data
snowsql -q "
PUT file://$(pwd)/generated_data/asset_master.csv @RAW.ASSET_DATA_STAGE AUTO_COMPRESS=TRUE;
"

# Upload sensor readings (all batches)
snowsql -q "
PUT file://$(pwd)/generated_data/sensor_readings_batch_*.json @RAW.SENSOR_DATA_STAGE AUTO_COMPRESS=TRUE;
"

# Upload maintenance history
snowsql -q "
PUT file://$(pwd)/generated_data/maintenance_history.csv @RAW.MAINTENANCE_DATA_STAGE AUTO_COMPRESS=TRUE;
"
```

#### Step 2.3: Load Data into Tables

```sql
-- Load asset master
COPY INTO RAW.ASSET_MASTER 
FROM @RAW.ASSET_DATA_STAGE 
FILE_FORMAT = (FORMAT_NAME = 'CSV_FORMAT') 
MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE;

-- Verify
SELECT COUNT(*) FROM RAW.ASSET_MASTER;  -- Should be 100

-- Trigger Snowpipe for sensor data
ALTER PIPE RAW.SENSOR_READINGS_PIPE REFRESH;

-- Wait 2-3 minutes, then verify
SELECT COUNT(*) FROM RAW.SENSOR_READINGS;  -- Should be ~4.3M

-- Load maintenance history
COPY INTO RAW.MAINTENANCE_HISTORY 
FROM @RAW.MAINTENANCE_DATA_STAGE 
FILE_FORMAT = (FORMAT_NAME = 'CSV_FORMAT') 
MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE;

-- Verify
SELECT COUNT(*) FROM RAW.MAINTENANCE_HISTORY;  -- Should be ~500

-- Load failure events manually (CSV format)
-- Upload failure_events.csv and load similarly
```

**Checkpoint**: You should now have:
- ✅ 100 assets in ASSET_MASTER
- ✅ ~4.3M sensor readings in SENSOR_READINGS
- ✅ ~500 maintenance records
- ✅ ~10 failure events

---

### **Phase 3: ML Pipeline Setup (45 minutes)**

#### Step 3.1: Create Feature Engineering Views

```sql
!source ml_models/01_feature_engineering.sql

-- Verify: Check that views are created
SHOW VIEWS IN SCHEMA FEATURES;

-- Test query
SELECT * FROM FEATURES.VW_ASSET_FEATURES_HOURLY LIMIT 10;
```

#### Step 3.2: Prepare Training Data

```sql
!source ml_models/02_training_data_prep.sql

-- Verify: Should see training records
SELECT COUNT(*) FROM ML.TRAINING_DATA;  -- Should be ~2,600 records
SELECT COUNT(*) FROM ML.TRAINING_DATA WHERE FAILURE_WITHIN_30_DAYS = TRUE;  -- ~260 failures
```

#### Step 3.3: Train ML Models

```sql
!source ml_models/03_model_training_stored_proc.sql

-- This will take 5-10 minutes to train models
-- Monitor progress in Snowflake Query History

-- Verify: Check model registry
SELECT * FROM ML.MODEL_REGISTRY WHERE STATUS = 'PRODUCTION';
-- Should see 3 models: XGBoost, IsolationForest, LinearRegression
```

#### Step 3.4: Generate Predictions

```sql
!source ml_models/04_model_scoring.sql

-- This will score all assets
-- Verify: Check predictions
SELECT COUNT(*) FROM ML.MODEL_PREDICTIONS;  -- Should be 100
SELECT * FROM ANALYTICS.VW_HIGH_RISK_ASSETS;  -- Should see ~10-15 high-risk assets
```

**Checkpoint**: You should now have:
- ✅ Feature engineering views working
- ✅ Training data prepared (~2,600 records)
- ✅ 3 ML models trained and in production
- ✅ Predictions generated for all 100 assets
- ✅ Analytics views populated

---

### **Phase 4: Semantic Model & Intelligence Agent (30 minutes)**

#### Step 4.1: Upload Semantic Model

```bash
# Upload YAML file to Snowflake stage
snowsql -q "
PUT file://$(pwd)/semantic_model/grid_reliability_semantic.yaml 
@ANALYTICS.SEMANTIC_MODEL_STAGE 
AUTO_COMPRESS=FALSE 
OVERWRITE=TRUE;
"

# Verify upload
snowsql -q "LIST @ANALYTICS.SEMANTIC_MODEL_STAGE;"
```

#### Step 4.2: Create Semantic View

```sql
!source semantic_model/create_semantic_view.sql

-- Verify: Semantic view created
SHOW SEMANTIC VIEWS;

-- Test query
SELECT * FROM GRID_RELIABILITY_ANALYTICS.ASSET_HEALTH WHERE RISK_SCORE > 70;
```

#### Step 4.3: Create Intelligence Agent

```sql
!source agents/create_grid_intelligence_agent.sql

-- Verify: Agent created
-- Navigate to Snowflake UI → Projects → Intelligence → Agents
-- You should see "Grid Reliability Intelligence Agent"
```

**Checkpoint**: You should now have:
- ✅ Semantic model YAML uploaded
- ✅ Semantic view `GRID_RELIABILITY_ANALYTICS` created
- ✅ Cortex Search Service for assets
- ✅ Intelligence Agent deployed and ready

---

### **Phase 5: Streamlit Dashboard (20 minutes)**

#### Step 5.1: Install Dependencies

```bash
pip install streamlit pandas numpy plotly snowflake-connector-python snowflake-snowpark-python
```

#### Step 5.2: Configure Connection

Create `.streamlit/secrets.toml`:

```toml
[snowflake]
account = "your_account"
user = "your_user"
password = "your_password"
warehouse = "GRID_RELIABILITY_WH"
database = "UTILITIES_GRID_RELIABILITY"
schema = "ANALYTICS"
role = "GRID_OPERATOR"
```

**Alternative**: For Streamlit in Snowflake (SPCS), no configuration needed.

#### Step 5.3: Launch Dashboard

```bash
cd dashboard
streamlit run grid_reliability_dashboard.py
```

**Or deploy to Streamlit in Snowflake**:

```sql
-- Create Streamlit app in Snowflake
CREATE STREAMLIT GRID_RELIABILITY_DASHBOARD
  ROOT_LOCATION = '@<your_stage>/dashboard'
  MAIN_FILE = 'grid_reliability_dashboard.py'
  QUERY_WAREHOUSE = GRID_RELIABILITY_WH;
```

**Checkpoint**: You should now have:
- ✅ Dashboard running (locally or in Snowflake)
- ✅ All 6 pages functional: Overview, Asset Map, High-Risk Alerts, Asset Details, ROI Calculator, Work Orders
- ✅ Real-time data from Snowflake

---

### **Phase 6: Enable Automation (10 minutes)**

#### Step 6.1: Resume Tasks

```sql
-- Resume all automated tasks
CALL RAW.RESUME_ALL_TASKS();

-- Verify tasks are running
SHOW TASKS;
SELECT * FROM RAW.VW_ACTIVE_TASKS;
```

Tasks that will now run automatically:
- **TASK_UPDATE_ASSET_FEATURES**: Every 15 minutes
- **TASK_SCORE_ASSETS**: Every hour
- **TASK_GENERATE_ALERTS**: 5 minutes past every hour
- **TASK_UPDATE_LAST_MAINTENANCE**: Daily at 2 AM
- **TASK_DATA_QUALITY_CHECK**: Every 30 minutes
- **TASK_MODEL_RETRAINING**: Weekly on Sundays at 3 AM

#### Step 6.2: Monitor Automation

```sql
-- Check task execution history
SELECT * FROM RAW.VW_TASK_HISTORY 
WHERE SCHEDULED_TIME >= DATEADD(hour, -24, CURRENT_TIMESTAMP())
ORDER BY SCHEDULED_TIME DESC;

-- Check data quality
SELECT * FROM RAW.DATA_QUALITY_LOG 
ORDER BY CHECK_TIMESTAMP DESC 
LIMIT 20;
```

**Checkpoint**: You should now have:
- ✅ All tasks running on schedule
- ✅ Automated feature updates every 15 minutes
- ✅ Automated model scoring every hour
- ✅ Data quality monitoring active

---

## ✅ Post-Deployment Verification

### Functional Testing

#### Test 1: Data Pipeline
```sql
-- Insert test sensor reading
INSERT INTO RAW.SENSOR_READINGS (ASSET_ID, READING_TIMESTAMP, OIL_TEMPERATURE_C)
VALUES ('T-SS001-001', CURRENT_TIMESTAMP(), 85.5);

-- Verify stream captured it
SELECT * FROM RAW.SENSOR_READINGS_STREAM WHERE ASSET_ID = 'T-SS001-001';
```

#### Test 2: ML Predictions
```sql
-- Check latest predictions
SELECT * FROM ML.VW_LATEST_PREDICTIONS ORDER BY RISK_SCORE DESC LIMIT 5;

-- Check high-risk assets
SELECT * FROM ANALYTICS.VW_HIGH_RISK_ASSETS;
```

#### Test 3: Dashboard
- Open dashboard in browser
- Navigate to each page
- Verify data loads correctly
- Test filters and interactions

#### Test 4: Intelligence Agent
- Open Snowflake UI → Projects → Intelligence
- Find "Grid Reliability Intelligence Agent"
- Ask: "Which 5 substations have the highest risk?"
- Verify agent responds with accurate data

---

## 📊 Demo Preparation

### Featured Asset: T-SS047-001

This asset is pre-configured as a high-risk example for demonstrations.

**Demo Talking Points**:
1. Show overall system metrics (100 assets monitored)
2. Navigate to Asset Map showing geographic distribution
3. Click on high-risk asset in West Palm Beach (T-SS047-001)
4. Show sensor trends indicating degradation
5. Display work order with cost avoidance calculation
6. Ask Intelligence Agent for regional analysis
7. Show ROI calculator with $25M+ annual savings

### Sample Intelligence Agent Queries

1. "Which substations have the highest risk?"
2. "Show me all critical assets in Miami-Dade county"
3. "What's the total SAIDI impact if all high-risk assets fail?"
4. "Tell me about transformer T-SS047-001"
5. "How many assets need immediate maintenance?"
6. "What is our predicted cost avoidance this month?"

---

## 🔧 Troubleshooting

### Issue: Snowpipe Not Loading Data

```sql
-- Check pipe status
SELECT SYSTEM$PIPE_STATUS('RAW.SENSOR_READINGS_PIPE');

-- Check for errors
SELECT * FROM TABLE(VALIDATE_PIPE_LOAD(
    PIPE_NAME => 'RAW.SENSOR_READINGS_PIPE',
    START_TIME => DATEADD('hour', -1, CURRENT_TIMESTAMP())
));

-- Manually refresh
ALTER PIPE RAW.SENSOR_READINGS_PIPE REFRESH;
```

### Issue: Models Not Training

```sql
-- Check for sufficient data
SELECT COUNT(*) FROM ML.TRAINING_DATA;  -- Need at least 1,000 records

-- Check Python packages
CALL TRAIN_FAILURE_PREDICTION_MODELS();  -- Review error message
```

### Issue: Dashboard Not Connecting

- Verify `.streamlit/secrets.toml` credentials
- Test connection:
  ```python
  from snowflake.snowpark import Session
  session = Session.builder.configs({
      "account": "your_account",
      "user": "your_user",
      # ... other params
  }).create()
  print(session.sql("SELECT CURRENT_USER()").collect())
  ```

### Issue: Tasks Not Running

```sql
-- Check task execution is enabled
SHOW PARAMETERS LIKE 'TASK%' IN ACCOUNT;

-- Check task history for errors
SELECT * FROM TABLE(INFORMATION_SCHEMA.TASK_HISTORY())
WHERE STATE = 'FAILED'
ORDER BY SCHEDULED_TIME DESC;

-- Resume suspended task
ALTER TASK <task_name> RESUME;
```

---

## 📈 Monitoring & Maintenance

### Daily Checks
- [ ] Review high-risk asset alerts
- [ ] Check data quality log for anomalies
- [ ] Verify Snowpipe ingestion is current (<5 min lag)
- [ ] Review critical asset work orders

### Weekly Checks
- [ ] Review model performance metrics
- [ ] Check task execution success rate (should be >99%)
- [ ] Review cost avoidance reports
- [ ] Update stakeholders on SAIDI impact

### Monthly Maintenance
- [ ] Model retraining review (automatic, but verify)
- [ ] Archive old predictions (>90 days)
- [ ] Review and optimize warehouse sizing
- [ ] Update semantic model if needed

---

## 🎓 Training Resources

### For Operators
- Dashboard user guide: See `docs/demo_script.md`
- Intelligence Agent query examples: See `agents/create_grid_intelligence_agent.sql`

### For Engineers
- ML model architecture: See `docs/architecture.md`
- Feature engineering logic: See `ml_models/01_feature_engineering.sql`
- Data model: See `docs/data_model.md`

### For Leadership
- Business case & ROI: See `docs/business_case.md`
- Executive demo script: See `docs/demo_script.md`

---

## 🆘 Support

**Technical Issues**: Check Snowflake Query History for detailed error messages  
**Data Issues**: Review `RAW.DATA_QUALITY_LOG` table  
**ML Issues**: Check `ML.MODEL_PERFORMANCE` for accuracy metrics

---

## ✨ Next Steps

After successful deployment:

1. **Phase 2 Expansion** (Q1 2026)
   - Add circuit breakers and switchgear
   - Increase to 500 monitored assets

2. **Phase 3 Production** (Q2 2026)
   - Scale to all 5,000+ transformers
   - Integrate with work order management system
   - Add mobile notifications for critical alerts

3. **Phase 4 Enhancement** (Q3 2026)
   - Computer vision for drone inspections
   - NLP analysis of maintenance notes
   - Advanced optimization algorithms

---

**Congratulations!** 🎉 Your AI-Driven Grid Reliability system is now operational!


