# ML Models Deployment Guide

## 🔧 FIXES APPLIED

### Issue 1: Missing Custom Function ✅ FIXED
**Error:** `SQL compilation error: Unknown user-defined function RAW.CALCULATE_ASSET_AGE`

**Solution:** Replaced custom function calls with inline SQL:
```sql
-- Before (BROKEN):
RAW.CALCULATE_ASSET_AGE(am.INSTALL_DATE) as ASSET_AGE_YEARS

-- After (FIXED):
DATEDIFF(day, am.INSTALL_DATE, CURRENT_DATE()) / 365.25 as ASSET_AGE_YEARS
```

**Files Fixed:**
- ✅ `ml_models/01_feature_engineering.sql` - Schema changed to ML, custom function removed
- ✅ `ml_models/02_training_data_prep.sql` - FEATURES schema references changed to ML
- ✅ `ml_models/04_model_scoring.sql` - FEATURES schema references changed to ML, custom function removed

### Issue 2: Empty FEATURES Schema ✅ FIXED
**Problem:** Feature engineering SQL was trying to use empty FEATURES schema

**Solution:** Changed target schema from FEATURES to ML
```sql
-- Before:
USE SCHEMA FEATURES;

-- After:
USE SCHEMA ML;
```

**File Fixed:**
- ✅ `ml_models/01_feature_engineering.sql`

---

## 🚀 DEPLOY FEATURE ENGINEERING VIEWS

Now you can deploy the feature engineering views using **SnowSQL** (MCP can't handle complex CTEs):

### Option 1: Deploy via SnowSQL (Recommended)
```bash
snowsql -c your_connection -f ml_models/01_feature_engineering.sql
```

### Option 2: Deploy via Snowflake UI
1. Open Snowflake UI
2. Go to Worksheets
3. Copy/paste contents of `01_feature_engineering.sql`
4. Run the script

---

## 📊 WHAT GETS CREATED

The feature engineering script creates **3 views in ML schema**:

### 1. VW_ASSET_FEATURES_HOURLY
**Purpose:** Compute hourly features with rolling statistics

**Features:**
- Current sensor readings (hourly average)
- 7-day rolling averages
- 30-day rolling averages
- Trend indicators (change vs. 7-day avg)
- Variability metrics (standard deviation)

**Columns:** ~40 engineered features per asset per hour

### 2. VW_ASSET_FEATURES_DAILY
**Purpose:** Asset-level features combined with sensor features

**Features:**
- Asset characteristics (age, capacity, voltage rating)
- Load utilization (current & peak)
- Thermal stress indicators
- DGA (Dissolved Gas Analysis) ratios
- Composite gas indicators
- Days since maintenance

**Columns:** ~25 asset + sensor features per asset per day

### 3. VW_WEATHER_ENRICHED_FEATURES
**Purpose:** Features enriched with weather data (when available)

**Features:**
- All features from VW_ASSET_FEATURES_DAILY
- Weather conditions (temperature, humidity, precipitation)
- Weather impact on equipment

**Note:** Currently optional - no weather data loaded yet

---

## ⚠️ IMPORTANT NOTES

### Schema Changes
- ✅ Views will be created in **ML schema** (not FEATURES)
- ✅ This is correct - ML schema is for all ML-related objects
- ⚠️ FEATURES schema can be deleted (it's empty and unused)

### Data Requirements
- ✅ Requires sensor data in `RAW.SENSOR_READINGS` (YOU HAVE THIS - 14 rows)
- ✅ Requires asset data in `RAW.ASSET_MASTER` (YOU HAVE THIS - 15 assets)
- ⚠️ Weather features view will be empty until weather data is loaded

### Performance
- Views use **90-day rolling window** for historical features
- Computes **hourly aggregations** for time-series features
- Uses **window functions** for rolling averages and trends

---

## 🧪 TEST AFTER DEPLOYMENT

Once deployed, test the views:

```sql
USE DATABASE UTILITIES_GRID_RELIABILITY;
USE SCHEMA ML;

-- Test 1: Check hourly features
SELECT * FROM VW_ASSET_FEATURES_HOURLY
WHERE ASSET_ID = 'T-SS047-001'
ORDER BY FEATURE_TIMESTAMP DESC
LIMIT 10;

-- Test 2: Check daily asset features
SELECT 
    ASSET_ID,
    FEATURE_TIMESTAMP,
    ASSET_AGE_YEARS,
    DAYS_SINCE_MAINTENANCE,
    LOAD_UTILIZATION_PCT,
    THERMAL_RISE,
    H2_CO_RATIO
FROM VW_ASSET_FEATURES_DAILY
WHERE ASSET_ID = 'T-SS047-001'
ORDER BY FEATURE_TIMESTAMP DESC
LIMIT 5;

-- Test 3: Count features by asset
SELECT 
    ASSET_ID,
    COUNT(*) as FEATURE_RECORDS,
    MIN(FEATURE_TIMESTAMP) as FIRST_RECORD,
    MAX(FEATURE_TIMESTAMP) as LAST_RECORD
FROM VW_ASSET_FEATURES_HOURLY
GROUP BY ASSET_ID
ORDER BY FEATURE_RECORDS DESC;
```

---

## 📁 DEPLOYMENT ORDER

If you want to deploy the full ML pipeline:

1. ✅ **01_feature_engineering.sql** (YOU'RE HERE)
   - Creates feature views
   - No dependencies

2. ⏸️ **02_training_data_prep.sql** (NEXT)
   - Creates training dataset from features
   - Depends on: 01_feature_engineering.sql

3. ⏸️ **03_model_training_stored_proc.sql** (AFTER)
   - Creates Python stored procedures for model training
   - Depends on: 02_training_data_prep.sql

4. ⏸️ **04_model_scoring.sql** (LAST)
   - Creates scoring views and procedures
   - Depends on: 03_model_training_stored_proc.sql

---

## 🎯 WHAT'S ALREADY WORKING

You **DON'T need to deploy ML models** for demo because:

✅ You already have **sample predictions** in `ML.MODEL_PREDICTIONS`  
✅ You already have **analytics views** working  
✅ Your **risk scores and alerts** are functional  
✅ **Cortex Search** is operational  

**Feature engineering is OPTIONAL for demo** - it's only needed if you want to:
- Train new models from scratch
- Retrain models with real data
- Experiment with different features

---

## 🆘 TROUBLESHOOTING

### Error: "Object does not exist"
**Cause:** Missing sensor or asset data  
**Fix:** Ensure RAW.SENSOR_READINGS and RAW.ASSET_MASTER have data

### Error: "Schema FEATURES does not exist"
**Cause:** Old version of file  
**Fix:** Re-download the fixed version (USE SCHEMA ML)

### Error: "Division by zero"
**Cause:** Missing or zero values in calculations  
**Fix:** Views include CASE statements to handle this, but ensure data quality

### Performance Issues
**Cause:** Views scan 90 days of data with window functions  
**Fix:** Consider materializing views as tables for production use

---

## 📞 QUICK REFERENCE

**Fixed Files:**
- ✅ `ml_models/01_feature_engineering.sql` - No more custom functions, uses ML schema
- ✅ `ml_models/04_model_scoring.sql` - No more custom functions

**Target Schema:**
- ML (not FEATURES)

**Deploy Command:**
```bash
snowsql -c your_connection -f ml_models/01_feature_engineering.sql
```

**Expected Result:**
- 3 views created in ML schema
- Features available for model training
- No errors about missing functions

---

**Status:** ✅ READY TO DEPLOY  
**Last Updated:** November 15, 2025  
**Fixed Issues:** Custom function removed, schema corrected

