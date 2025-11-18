# Role-Based Access Control (RBAC) - Grid Reliability Project

**Project:** AI-Driven Grid Reliability & Predictive Maintenance  
**Database:** UTILITIES_GRID_RELIABILITY  
**Created:** November 15, 2025  
**Status:** ✅ Fully Configured

---

## 🎭 ROLES OVERVIEW

Three specialized roles have been created for this project:

| Role | Purpose | Access Level | Primary Users |
|------|---------|--------------|---------------|
| **GRID_ANALYST** | Read-only analytics and reporting | SELECT only | Business analysts, executives, operations managers |
| **GRID_DATA_ENGINEER** | Data pipeline management and ETL | SELECT, INSERT, UPDATE, DELETE | Data engineers, ETL developers |
| **GRID_ML_ENGINEER** | ML model training and deployment | SELECT (all), WRITE (ML schema) | Data scientists, ML engineers |

---

## 📊 ROLE: GRID_ANALYST (Read-Only)

### Purpose
Business analysts and operations staff who need to query data and create reports but should not modify any data.

### Permissions

#### Database & Warehouse
- ✅ **USAGE** on `UTILITIES_GRID_RELIABILITY` database
- ✅ **USAGE** on `GRID_RELIABILITY_WH` warehouse

#### Schemas
- ✅ **USAGE** on `RAW` schema
- ✅ **USAGE** on `ML` schema
- ✅ **USAGE** on `ANALYTICS` schema

#### Tables (SELECT only)
**RAW Schema:**
- `ASSET_MASTER` - Asset inventory
- `SENSOR_READINGS` - Sensor time-series data
- `MAINTENANCE_HISTORY` - Maintenance records
- `FAILURE_EVENTS` - Historical failures
- `WEATHER_DATA` - Weather data
- `SCADA_EVENTS` - SCADA events
- `DATA_QUALITY_LOG` - Data quality metrics
- `FAILURE_TYPE_REFERENCE` - Failure type lookup

**ML Schema:**
- `MODEL_PREDICTIONS` - ML predictions and risk scores
- `MODEL_REGISTRY` - Model metadata
- `TRAINING_DATA` - Training datasets
- `MODEL_PERFORMANCE` - Model metrics
- `FEATURE_IMPORTANCE` - Feature importance scores

**ANALYTICS Schema:**
- `ASSET_SEARCH_INDEX` - Searchable asset index

#### Views (SELECT only)
**ANALYTICS Schema:**
- `VW_ASSET_HEALTH_DASHBOARD` - Asset health and risk scores
- `VW_HIGH_RISK_ASSETS` - High-risk assets (risk >= 71)
- `VW_RELIABILITY_METRICS` - SAIDI/SAIFI metrics
- `VW_COST_AVOIDANCE_REPORT` - Financial impact and ROI
- `VW_ASSET_DETAIL` - Detailed asset information
- `VW_SYSTEM_DASHBOARD` - System-wide KPIs
- `GRID_RELIABILITY_SEMANTIC` - Semantic view for Intelligence

#### Cortex Services
- ✅ **USAGE** on `ASSET_SEARCH_SERVICE` (Cortex Search)
- ✅ **USAGE** on `Grid Risk Analyst` Agent (if created)

#### Stages
- ✅ **READ** on `ANALYTICS.SEMANTIC_MODEL_STAGE`

#### Future Objects
- ✅ Automatic **SELECT** on all future tables in RAW, ML, ANALYTICS schemas
- ✅ Automatic **SELECT** on all future views in RAW, ML, ANALYTICS schemas

### Sample Use Cases
1. Query asset health dashboard
2. Generate risk reports
3. Analyze cost avoidance metrics
4. Search for assets using Cortex Search
5. Create Tableau/PowerBI dashboards
6. Run ad-hoc SQL queries for analysis

### Assign Role to Users
```sql
-- Assign to a user
GRANT ROLE GRID_ANALYST TO USER john_analyst;

-- Assign to another role (role hierarchy)
GRANT ROLE GRID_ANALYST TO ROLE BUSINESS_INTELLIGENCE;
```

---

## 🔧 ROLE: GRID_DATA_ENGINEER (Read + Write)

### Purpose
Data engineers who manage ETL pipelines, load data, and maintain data quality.

### Permissions

#### Database & Warehouse
- ✅ **USAGE** on `UTILITIES_GRID_RELIABILITY` database
- ✅ **USAGE** on `GRID_RELIABILITY_WH` warehouse

#### Schemas
- ✅ **USAGE** on `RAW` schema
- ✅ **USAGE** on `ML` schema
- ✅ **USAGE** on `ANALYTICS` schema
- ✅ **USAGE** on `STAGING` schema

#### Tables (Full DML)
**RAW Schema:**
- ✅ **SELECT, INSERT, UPDATE, DELETE** on all tables
- ✅ Automatic grants on future tables

**ML Schema:**
- ✅ **SELECT, INSERT, UPDATE, DELETE** on all tables
- ✅ Automatic grants on future tables

**ANALYTICS Schema:**
- ✅ **SELECT, INSERT, UPDATE, DELETE** on `ASSET_SEARCH_INDEX`

**STAGING Schema:**
- ✅ **SELECT, INSERT, UPDATE, DELETE** on all tables
- ✅ Automatic grants on future tables

#### Views (SELECT only)
- ✅ **SELECT** on all views in RAW, ML, ANALYTICS schemas

#### Stages & File Formats
- ✅ **READ, WRITE** on all stages in RAW schema
- ✅ **READ, WRITE** on all stages in ANALYTICS schema
- ✅ **USAGE** on all file formats in RAW schema

#### Cortex Services
- ✅ **USAGE** on `ASSET_SEARCH_SERVICE` (Cortex Search)

#### Future Objects
- ✅ Automatic **SELECT, INSERT, UPDATE, DELETE** on future tables in RAW, ML, STAGING

### Sample Use Cases
1. Load new sensor data from external sources
2. Update asset master records
3. Insert maintenance history records
4. Upload files to stages
5. Manage data quality logs
6. Create and populate new tables
7. Run ETL jobs and data pipelines
8. Refresh Cortex Search index

### Assign Role to Users
```sql
-- Assign to a data engineer
GRANT ROLE GRID_DATA_ENGINEER TO USER sarah_dataeng;

-- Allow them to also read as an analyst
GRANT ROLE GRID_ANALYST TO ROLE GRID_DATA_ENGINEER;
```

---

## 🤖 ROLE: GRID_ML_ENGINEER (ML Development)

### Purpose
Data scientists and ML engineers who train models, manage predictions, and optimize ML pipelines.

### Permissions

#### Database & Warehouse
- ✅ **USAGE** on `UTILITIES_GRID_RELIABILITY` database
- ✅ **USAGE** on `GRID_RELIABILITY_WH` warehouse

#### Schemas
- ✅ **USAGE** on `ML` schema (primary workspace)
- ✅ **USAGE** on `ANALYTICS` schema (for reporting)

#### Tables

**ML Schema (Full DML):**
- ✅ **SELECT, INSERT, UPDATE, DELETE** on:
  - `MODEL_PREDICTIONS` - Write new predictions
  - `MODEL_REGISTRY` - Register new models
  - `TRAINING_DATA` - Manage training datasets
  - `MODEL_PERFORMANCE` - Track model metrics
  - `FEATURE_IMPORTANCE` - Store feature analysis

**RAW Schema (SELECT only):**
- ✅ **SELECT** on all tables (read source data for training)

**ANALYTICS Schema (SELECT only):**
- ✅ **SELECT** on all views (evaluate model impact)

#### Views
- ✅ **SELECT** on all views in ML and ANALYTICS schemas

#### Future Objects
- ✅ Automatic **SELECT** on future tables in RAW
- ✅ Automatic **SELECT, INSERT, UPDATE, DELETE** on future tables in ML

### Sample Use Cases
1. Train new XGBoost models for failure prediction
2. Register model versions in MODEL_REGISTRY
3. Score new predictions and write to MODEL_PREDICTIONS
4. Calculate and store feature importance
5. Track model performance metrics
6. Read raw sensor data for feature engineering
7. Evaluate model impact on cost avoidance

### Assign Role to Users
```sql
-- Assign to ML engineer
GRANT ROLE GRID_ML_ENGINEER TO USER alex_mleng;

-- Allow read access to analytics
GRANT ROLE GRID_ANALYST TO ROLE GRID_ML_ENGINEER;
```

---

## 🔐 PERMISSION MATRIX

| Object Type | GRID_ANALYST | GRID_DATA_ENGINEER | GRID_ML_ENGINEER |
|-------------|--------------|-------------------|------------------|
| **Database** | USAGE | USAGE | USAGE |
| **Warehouse** | USAGE | USAGE | USAGE |
| **RAW Tables** | SELECT | SELECT, INSERT, UPDATE, DELETE | SELECT |
| **ML Tables** | SELECT | SELECT, INSERT, UPDATE, DELETE | SELECT, INSERT, UPDATE, DELETE |
| **ANALYTICS Tables** | SELECT | SELECT, INSERT, UPDATE, DELETE | - |
| **STAGING Tables** | - | SELECT, INSERT, UPDATE, DELETE | - |
| **All Views** | SELECT | SELECT | SELECT (ML/ANALYTICS) |
| **Stages (RAW)** | - | READ, WRITE | - |
| **Stages (ANALYTICS)** | READ | READ, WRITE | - |
| **File Formats** | - | USAGE | - |
| **Cortex Search** | USAGE | USAGE | - |
| **Semantic View** | SELECT | SELECT | SELECT |

---

## 📝 GRANT STATEMENTS (For Reference)

### Create Roles
```sql
CREATE ROLE GRID_ANALYST 
  COMMENT = 'Read-only analyst role for Grid Reliability project';

CREATE ROLE GRID_DATA_ENGINEER 
  COMMENT = 'Data engineer role with read/write access';

CREATE ROLE GRID_ML_ENGINEER 
  COMMENT = 'ML engineer role for model training and deployment';
```

### Grant Database & Warehouse Access
```sql
-- All roles need database and warehouse access
GRANT USAGE ON DATABASE UTILITIES_GRID_RELIABILITY TO ROLE GRID_ANALYST;
GRANT USAGE ON DATABASE UTILITIES_GRID_RELIABILITY TO ROLE GRID_DATA_ENGINEER;
GRANT USAGE ON DATABASE UTILITIES_GRID_RELIABILITY TO ROLE GRID_ML_ENGINEER;

GRANT USAGE ON WAREHOUSE GRID_RELIABILITY_WH TO ROLE GRID_ANALYST;
GRANT USAGE ON WAREHOUSE GRID_RELIABILITY_WH TO ROLE GRID_DATA_ENGINEER;
GRANT USAGE ON WAREHOUSE GRID_RELIABILITY_WH TO ROLE GRID_ML_ENGINEER;
```

### Grant Schema Access
```sql
-- GRID_ANALYST: Read-only on RAW, ML, ANALYTICS
GRANT USAGE ON SCHEMA UTILITIES_GRID_RELIABILITY.RAW TO ROLE GRID_ANALYST;
GRANT USAGE ON SCHEMA UTILITIES_GRID_RELIABILITY.ML TO ROLE GRID_ANALYST;
GRANT USAGE ON SCHEMA UTILITIES_GRID_RELIABILITY.ANALYTICS TO ROLE GRID_ANALYST;

-- GRID_DATA_ENGINEER: Full access to RAW, ML, ANALYTICS, STAGING
GRANT USAGE ON SCHEMA UTILITIES_GRID_RELIABILITY.RAW TO ROLE GRID_DATA_ENGINEER;
GRANT USAGE ON SCHEMA UTILITIES_GRID_RELIABILITY.ML TO ROLE GRID_DATA_ENGINEER;
GRANT USAGE ON SCHEMA UTILITIES_GRID_RELIABILITY.ANALYTICS TO ROLE GRID_DATA_ENGINEER;
GRANT USAGE ON SCHEMA UTILITIES_GRID_RELIABILITY.STAGING TO ROLE GRID_DATA_ENGINEER;

-- GRID_ML_ENGINEER: ML and ANALYTICS schemas
GRANT USAGE ON SCHEMA UTILITIES_GRID_RELIABILITY.ML TO ROLE GRID_ML_ENGINEER;
GRANT USAGE ON SCHEMA UTILITIES_GRID_RELIABILITY.ANALYTICS TO ROLE GRID_ML_ENGINEER;
```

### Grant Table Permissions (GRID_ANALYST)
```sql
-- Current tables
GRANT SELECT ON ALL TABLES IN SCHEMA UTILITIES_GRID_RELIABILITY.RAW TO ROLE GRID_ANALYST;
GRANT SELECT ON ALL TABLES IN SCHEMA UTILITIES_GRID_RELIABILITY.ML TO ROLE GRID_ANALYST;
GRANT SELECT ON ALL TABLES IN SCHEMA UTILITIES_GRID_RELIABILITY.ANALYTICS TO ROLE GRID_ANALYST;

-- Future tables
GRANT SELECT ON FUTURE TABLES IN SCHEMA UTILITIES_GRID_RELIABILITY.RAW TO ROLE GRID_ANALYST;
GRANT SELECT ON FUTURE TABLES IN SCHEMA UTILITIES_GRID_RELIABILITY.ML TO ROLE GRID_ANALYST;
GRANT SELECT ON FUTURE TABLES IN SCHEMA UTILITIES_GRID_RELIABILITY.ANALYTICS TO ROLE GRID_ANALYST;

-- Views
GRANT SELECT ON ALL VIEWS IN SCHEMA UTILITIES_GRID_RELIABILITY.RAW TO ROLE GRID_ANALYST;
GRANT SELECT ON ALL VIEWS IN SCHEMA UTILITIES_GRID_RELIABILITY.ML TO ROLE GRID_ANALYST;
GRANT SELECT ON ALL VIEWS IN SCHEMA UTILITIES_GRID_RELIABILITY.ANALYTICS TO ROLE GRID_ANALYST;

GRANT SELECT ON FUTURE VIEWS IN SCHEMA UTILITIES_GRID_RELIABILITY.RAW TO ROLE GRID_ANALYST;
GRANT SELECT ON FUTURE VIEWS IN SCHEMA UTILITIES_GRID_RELIABILITY.ML TO ROLE GRID_ANALYST;
GRANT SELECT ON FUTURE VIEWS IN SCHEMA UTILITIES_GRID_RELIABILITY.ANALYTICS TO ROLE GRID_ANALYST;
```

### Grant Table Permissions (GRID_DATA_ENGINEER)
```sql
-- Full DML on current tables
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA UTILITIES_GRID_RELIABILITY.RAW TO ROLE GRID_DATA_ENGINEER;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA UTILITIES_GRID_RELIABILITY.ML TO ROLE GRID_DATA_ENGINEER;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA UTILITIES_GRID_RELIABILITY.STAGING TO ROLE GRID_DATA_ENGINEER;

-- Full DML on future tables
GRANT SELECT, INSERT, UPDATE, DELETE ON FUTURE TABLES IN SCHEMA UTILITIES_GRID_RELIABILITY.RAW TO ROLE GRID_DATA_ENGINEER;
GRANT SELECT, INSERT, UPDATE, DELETE ON FUTURE TABLES IN SCHEMA UTILITIES_GRID_RELIABILITY.ML TO ROLE GRID_DATA_ENGINEER;
GRANT SELECT, INSERT, UPDATE, DELETE ON FUTURE TABLES IN SCHEMA UTILITIES_GRID_RELIABILITY.STAGING TO ROLE GRID_DATA_ENGINEER;

-- Views (read-only)
GRANT SELECT ON ALL VIEWS IN SCHEMA UTILITIES_GRID_RELIABILITY.RAW TO ROLE GRID_DATA_ENGINEER;
GRANT SELECT ON ALL VIEWS IN SCHEMA UTILITIES_GRID_RELIABILITY.ML TO ROLE GRID_DATA_ENGINEER;
GRANT SELECT ON ALL VIEWS IN SCHEMA UTILITIES_GRID_RELIABILITY.ANALYTICS TO ROLE GRID_DATA_ENGINEER;
```

### Grant Table Permissions (GRID_ML_ENGINEER)
```sql
-- Full DML on ML tables
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA UTILITIES_GRID_RELIABILITY.ML TO ROLE GRID_ML_ENGINEER;

-- Read-only on RAW tables (for training)
GRANT SELECT ON ALL TABLES IN SCHEMA UTILITIES_GRID_RELIABILITY.RAW TO ROLE GRID_ML_ENGINEER;

-- Read-only on ANALYTICS views
GRANT SELECT ON ALL VIEWS IN SCHEMA UTILITIES_GRID_RELIABILITY.ANALYTICS TO ROLE GRID_ML_ENGINEER;
```

### Grant Stage & File Format Access
```sql
-- Data Engineer: Full access to stages
GRANT READ, WRITE ON ALL STAGES IN SCHEMA UTILITIES_GRID_RELIABILITY.RAW TO ROLE GRID_DATA_ENGINEER;
GRANT READ, WRITE ON ALL STAGES IN SCHEMA UTILITIES_GRID_RELIABILITY.ANALYTICS TO ROLE GRID_DATA_ENGINEER;
GRANT USAGE ON ALL FILE FORMATS IN SCHEMA UTILITIES_GRID_RELIABILITY.RAW TO ROLE GRID_DATA_ENGINEER;

-- Analyst: Read-only on semantic model stage
GRANT READ ON ALL STAGES IN SCHEMA UTILITIES_GRID_RELIABILITY.ANALYTICS TO ROLE GRID_ANALYST;
```

### Grant Cortex Services
```sql
GRANT USAGE ON CORTEX SEARCH SERVICE UTILITIES_GRID_RELIABILITY.ANALYTICS.ASSET_SEARCH_SERVICE TO ROLE GRID_ANALYST;
GRANT USAGE ON CORTEX SEARCH SERVICE UTILITIES_GRID_RELIABILITY.ANALYTICS.ASSET_SEARCH_SERVICE TO ROLE GRID_DATA_ENGINEER;

-- When Intelligence Agent is created:
-- GRANT USAGE ON AGENT UTILITIES_GRID_RELIABILITY.ANALYTICS."Grid Reliability Intelligence Agent" TO ROLE GRID_ANALYST;
```

---

## 👥 RECOMMENDED USER ASSIGNMENTS

### Business Analysts & Executives
```sql
-- Read-only access for reporting and dashboards
GRANT ROLE GRID_ANALYST TO USER john.smith@fpl.com;
GRANT ROLE GRID_ANALYST TO USER susan.executive@fpl.com;
```

### Operations Managers
```sql
-- Read-only access with Cortex Search
GRANT ROLE GRID_ANALYST TO USER mike.operations@fpl.com;
```

### Data Engineers
```sql
-- Full data management capabilities
GRANT ROLE GRID_DATA_ENGINEER TO USER sarah.dataeng@fpl.com;

-- Also give analyst role for easy querying
GRANT ROLE GRID_ANALYST TO ROLE GRID_DATA_ENGINEER;
```

### ML Engineers / Data Scientists
```sql
-- ML development access
GRANT ROLE GRID_ML_ENGINEER TO USER alex.datascientist@fpl.com;

-- Also give analyst role for reporting
GRANT ROLE GRID_ANALYST TO ROLE GRID_ML_ENGINEER;
```

---

## 🔍 VERIFY ROLE PERMISSIONS

### Check What a Role Can Access
```sql
-- View all grants for a role
SHOW GRANTS TO ROLE GRID_ANALYST;
SHOW GRANTS TO ROLE GRID_DATA_ENGINEER;
SHOW GRANTS TO ROLE GRID_ML_ENGINEER;
```

### Test Role Access
```sql
-- Switch to a role and test
USE ROLE GRID_ANALYST;
USE DATABASE UTILITIES_GRID_RELIABILITY;
USE SCHEMA ANALYTICS;

-- This should work (SELECT)
SELECT * FROM VW_ASSET_HEALTH_DASHBOARD LIMIT 5;

-- This should FAIL (no INSERT permission for GRID_ANALYST)
INSERT INTO RAW.ASSET_MASTER VALUES (...);
```

---

## 🛡️ SECURITY BEST PRACTICES

### 1. Principle of Least Privilege
- ✅ Analysts have read-only access
- ✅ Data Engineers can write but not drop objects
- ✅ ML Engineers can only write to ML schema
- ❌ No users have ACCOUNTADMIN by default

### 2. Future Grants
- ✅ All roles have automatic grants on future tables/views
- ✅ No need to re-run grants when new objects are created

### 3. Separation of Duties
- ✅ Analysts cannot modify data
- ✅ Data Engineers cannot drop schemas or databases
- ✅ ML Engineers are isolated to ML schema for writes

### 4. Audit & Monitoring
```sql
-- View who has what role
SHOW GRANTS TO USER john.smith@fpl.com;

-- View role hierarchy
SHOW GRANTS OF ROLE GRID_ANALYST;

-- Check recent queries by role
SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY
WHERE ROLE_NAME = 'GRID_ANALYST'
AND START_TIME >= DATEADD(day, -7, CURRENT_TIMESTAMP())
ORDER BY START_TIME DESC;
```

---

## 📊 ROLE USAGE EXAMPLES

### Example 1: Analyst Queries Asset Health
```sql
USE ROLE GRID_ANALYST;
USE DATABASE UTILITIES_GRID_RELIABILITY;
USE WAREHOUSE GRID_RELIABILITY_WH;

-- View top 10 high-risk assets
SELECT * FROM ANALYTICS.VW_HIGH_RISK_ASSETS
ORDER BY RISK_SCORE DESC
LIMIT 10;

-- Search using Cortex Search
SELECT * FROM TABLE(
  ANALYTICS.ASSET_SEARCH_SERVICE!SEARCH('critical transformers in Miami')
);
```

### Example 2: Data Engineer Loads New Sensor Data
```sql
USE ROLE GRID_DATA_ENGINEER;
USE DATABASE UTILITIES_GRID_RELIABILITY;

-- Load from stage to staging table
COPY INTO STAGING.SENSOR_STAGING
FROM @RAW.SENSOR_DATA_STAGE
FILE_FORMAT = (FORMAT_NAME = RAW.CSV_FORMAT);

-- Merge into RAW table
MERGE INTO RAW.SENSOR_READINGS target
USING STAGING.SENSOR_STAGING source
ON target.ASSET_ID = source.ASSET_ID 
   AND target.READING_TIMESTAMP = source.READING_TIMESTAMP
WHEN MATCHED THEN UPDATE SET ...
WHEN NOT MATCHED THEN INSERT ...;
```

### Example 3: ML Engineer Trains and Scores Model
```sql
USE ROLE GRID_ML_ENGINEER;
USE DATABASE UTILITIES_GRID_RELIABILITY;

-- Register new model
INSERT INTO ML.MODEL_REGISTRY (MODEL_ID, MODEL_NAME, MODEL_TYPE, CREATED_TS)
VALUES ('XGB_v2.0', 'XGBoost Failure Predictor', 'CLASSIFICATION', CURRENT_TIMESTAMP());

-- Write new predictions
INSERT INTO ML.MODEL_PREDICTIONS
SELECT 
    ASSET_ID,
    CURRENT_TIMESTAMP() as PREDICTION_TIMESTAMP,
    'XGB_v2.0' as MODEL_ID,
    -- prediction logic here
FROM ML.TRAINING_DATA;

-- Update model performance
INSERT INTO ML.MODEL_PERFORMANCE (MODEL_ID, METRIC_NAME, METRIC_VALUE, CREATED_TS)
VALUES ('XGB_v2.0', 'ACCURACY', 0.94, CURRENT_TIMESTAMP());
```

---

## 🎯 SUMMARY

| Role | Key Capability | Primary Permission |
|------|---------------|-------------------|
| **GRID_ANALYST** | Query & Report | SELECT everywhere |
| **GRID_DATA_ENGINEER** | Load & Transform Data | SELECT, INSERT, UPDATE, DELETE (all schemas) |
| **GRID_ML_ENGINEER** | Train & Score Models | Full DML on ML schema, SELECT on RAW |

**All roles have been successfully created and configured! ✅**

---

**Document Version:** 1.0  
**Last Updated:** November 15, 2025  
**Status:** ✅ Production Ready  
**Maintained By:** Grid Reliability Project Team


