# Data Model Documentation

## Database: UTILITIES_GRID_RELIABILITY

This document provides comprehensive documentation of all schemas, tables, views, and relationships in the Grid Reliability system.

---

## Schema Overview

| Schema | Purpose | Tables | Views | Update Frequency |
|--------|---------|--------|-------|------------------|
| RAW | Raw data ingestion | 6 | 0 | Real-time to Daily |
| FEATURES | Engineered features | 0 | 4 | Every 15 minutes |
| ML | Machine learning | 5 | 1 | Weekly (training), Hourly (inference) |
| ANALYTICS | Business analytics | 0 | 5 | Real-time (computed) |
| STAGING | Temporary ingestion | 2 | 0 | Transient |

---

## Schema: RAW

### Table: ASSET_MASTER

Master inventory of all monitored T&D and substation assets.

| Column | Type | Description | Constraints |
|--------|------|-------------|-------------|
| ASSET_ID | VARCHAR(50) | Unique asset identifier | PRIMARY KEY |
| ASSET_TYPE | VARCHAR(50) | Type: TRANSFORMER, BREAKER, SWITCHGEAR | NOT NULL |
| ASSET_SUBTYPE | VARCHAR(50) | Specific subtype/category | |
| MANUFACTURER | VARCHAR(100) | Equipment manufacturer | |
| MODEL | VARCHAR(100) | Model number | |
| SERIAL_NUMBER | VARCHAR(100) | Serial number | |
| INSTALL_DATE | DATE | Installation date | |
| EXPECTED_LIFE_YEARS | NUMBER(3) | Design life expectancy | |
| LOCATION_SUBSTATION | VARCHAR(100) | Substation name | |
| LOCATION_CITY | VARCHAR(100) | City | |
| LOCATION_COUNTY | VARCHAR(100) | County | |
| LOCATION_LAT | NUMBER(10,6) | Latitude | |
| LOCATION_LON | NUMBER(10,6) | Longitude | |
| VOLTAGE_RATING_KV | NUMBER(10,2) | Voltage rating (kV) | |
| CAPACITY_MVA | NUMBER(10,2) | Power capacity (MVA) | |
| CRITICALITY_SCORE | NUMBER(3) | Business criticality (1-100) | |
| CUSTOMERS_AFFECTED | NUMBER(10) | Customers impacted by failure | |
| REPLACEMENT_COST_USD | NUMBER(12,2) | Replacement cost | |
| LAST_MAINTENANCE_DATE | DATE | Last maintenance date | |
| STATUS | VARCHAR(20) | ACTIVE, RETIRED, UNDER_REPAIR | DEFAULT 'ACTIVE' |
| CREATED_TS | TIMESTAMP_NTZ | Record creation timestamp | |
| UPDATED_TS | TIMESTAMP_NTZ | Record update timestamp | |
| METADATA | VARIANT | Additional flexible attributes | |

**Sample Query**:
```sql
SELECT 
    ASSET_ID,
    ASSET_TYPE,
    LOCATION_SUBSTATION,
    CUSTOMERS_AFFECTED,
    DATEDIFF(year, INSTALL_DATE, CURRENT_DATE()) as AGE_YEARS
FROM RAW.ASSET_MASTER
WHERE STATUS = 'ACTIVE'
ORDER BY CRITICALITY_SCORE DESC;
```

---

### Table: SENSOR_READINGS

Time-series operational data from OT sensors.

| Column | Type | Description | Constraints |
|--------|------|-------------|-------------|
| READING_ID | NUMBER(38,0) | Auto-increment ID | PRIMARY KEY |
| ASSET_ID | VARCHAR(50) | Reference to ASSET_MASTER | NOT NULL, FK |
| READING_TIMESTAMP | TIMESTAMP_NTZ | Sensor reading time | NOT NULL |
| OIL_TEMPERATURE_C | NUMBER(5,2) | Oil temp (Celsius) | |
| WINDING_TEMPERATURE_C | NUMBER(5,2) | Winding temp (Celsius) | |
| LOAD_CURRENT_A | NUMBER(10,2) | Load current (Amps) | |
| LOAD_VOLTAGE_KV | NUMBER(10,2) | Voltage (kV) | |
| AMBIENT_TEMP_C | NUMBER(5,2) | Ambient temperature | |
| HUMIDITY_PCT | NUMBER(5,2) | Relative humidity (%) | |
| VIBRATION_MM_S | NUMBER(8,4) | Vibration (mm/s) | |
| ACOUSTIC_DB | NUMBER(5,2) | Acoustic level (dB) | |
| DISSOLVED_H2_PPM | NUMBER(10,2) | Dissolved hydrogen | |
| DISSOLVED_CO_PPM | NUMBER(10,2) | Dissolved CO | |
| DISSOLVED_CO2_PPM | NUMBER(10,2) | Dissolved CO2 | |
| DISSOLVED_CH4_PPM | NUMBER(10,2) | Dissolved methane | |
| BUSHING_TEMP_C | NUMBER(5,2) | Bushing temperature | |
| TAP_POSITION | NUMBER(3) | Tap changer position | |
| PARTIAL_DISCHARGE_PC | NUMBER(8,2) | Partial discharge (pC) | |
| POWER_FACTOR | NUMBER(5,4) | Power factor | |
| INGESTION_TS | TIMESTAMP_NTZ | Data ingestion time | DEFAULT CURRENT_TIMESTAMP |

**Partitioning**: Clustered by `(READING_TIMESTAMP, ASSET_ID)` for optimal query performance.

**Sample Query**:
```sql
SELECT 
    ASSET_ID,
    DATE_TRUNC('hour', READING_TIMESTAMP) as HOUR,
    AVG(OIL_TEMPERATURE_C) as AVG_OIL_TEMP,
    MAX(LOAD_CURRENT_A) as PEAK_LOAD
FROM RAW.SENSOR_READINGS
WHERE READING_TIMESTAMP >= DATEADD(day, -7, CURRENT_TIMESTAMP())
GROUP BY ASSET_ID, HOUR
ORDER BY ASSET_ID, HOUR;
```

---

### Table: MAINTENANCE_HISTORY

Historical maintenance and inspection records.

| Column | Type | Description |
|--------|------|-------------|
| MAINTENANCE_ID | VARCHAR(50) | Unique work order ID (PK) |
| ASSET_ID | VARCHAR(50) | Reference to ASSET_MASTER |
| MAINTENANCE_DATE | DATE | Date performed |
| MAINTENANCE_TYPE | VARCHAR(50) | INSPECTION, REPAIR, REPLACEMENT, PREVENTIVE |
| DESCRIPTION | VARCHAR(5000) | Work performed description |
| TECHNICIAN | VARCHAR(100) | Technician name/ID |
| COST_USD | NUMBER(12,2) | Total cost |
| DOWNTIME_HOURS | NUMBER(5,2) | Asset downtime |
| OUTCOME | VARCHAR(50) | SUCCESS, PARTIAL, FAILED |
| CREATED_TS | TIMESTAMP_NTZ | Record creation time |

---

### Table: FAILURE_EVENTS

Historical asset failure incidents.

| Column | Type | Description |
|--------|------|-------------|
| EVENT_ID | VARCHAR(50) | Unique event ID (PK) |
| ASSET_ID | VARCHAR(50) | Reference to ASSET_MASTER |
| FAILURE_TIMESTAMP | TIMESTAMP_NTZ | When failure occurred |
| FAILURE_TYPE | VARCHAR(100) | WINDING_FAILURE, BUSHING_FAULT, OIL_LEAK, etc. |
| ROOT_CAUSE | VARCHAR(5000) | Determined root cause |
| CUSTOMERS_AFFECTED | NUMBER(10) | Customers impacted |
| OUTAGE_DURATION_HOURS | NUMBER(5,2) | Total outage duration |
| REPAIR_COST_USD | NUMBER(12,2) | Repair costs |
| REPLACEMENT_FLAG | BOOLEAN | TRUE if asset replaced |
| CREATED_TS | TIMESTAMP_NTZ | Record creation time |

---

### Table: WEATHER_DATA

Environmental conditions from weather stations.

| Column | Type | Description |
|--------|------|-------------|
| WEATHER_ID | NUMBER(38,0) | Auto-increment ID (PK) |
| LOCATION_LAT | NUMBER(10,6) | Latitude |
| LOCATION_LON | NUMBER(10,6) | Longitude |
| OBSERVATION_TIMESTAMP | TIMESTAMP_NTZ | Observation time |
| TEMPERATURE_C | NUMBER(5,2) | Air temperature |
| HUMIDITY_PCT | NUMBER(5,2) | Relative humidity |
| WIND_SPEED_MPS | NUMBER(5,2) | Wind speed (m/s) |
| PRECIPITATION_MM | NUMBER(5,2) | Precipitation |
| SOLAR_RADIATION_WM2 | NUMBER(8,2) | Solar radiation |

---

### Table: SCADA_EVENTS

Operational events and alarms from SCADA systems.

| Column | Type | Description |
|--------|------|-------------|
| EVENT_ID | NUMBER(38,0) | Auto-increment ID (PK) |
| ASSET_ID | VARCHAR(50) | Reference to ASSET_MASTER |
| EVENT_TIMESTAMP | TIMESTAMP_NTZ | Event time |
| EVENT_TYPE | VARCHAR(50) | ALARM, WARNING, INFO, ERROR |
| EVENT_CODE | VARCHAR(20) | Standard event code |
| EVENT_DESCRIPTION | VARCHAR(1000) | Event description |
| SEVERITY | NUMBER(1) | 1=Low, 5=Critical |
| ACKNOWLEDGED | BOOLEAN | Operator acknowledged |
| ACKNOWLEDGED_BY | VARCHAR(100) | Operator ID |

---

## Schema: FEATURES

### View: VW_ASSET_FEATURES_HOURLY

Engineered features computed hourly for ML models.

**Key Metrics**:
- Rolling averages (7-day, 30-day windows)
- Standard deviations
- Rate of change calculations
- Deviation from baseline
- Load utilization percentage

**Sample Columns**:
```sql
- ASSET_ID
- FEATURE_TIMESTAMP
- OIL_TEMP_CURRENT
- OIL_TEMP_7D_AVG
- OIL_TEMP_30D_AVG
- OIL_TEMP_STDDEV
- OIL_TEMP_RATE_OF_CHANGE
- LOAD_CURRENT_AVG
- LOAD_UTILIZATION_PCT
- DISSOLVED_H2_TREND
- VIBRATION_ANOMALY_SCORE
- DAYS_SINCE_MAINTENANCE
- ASSET_AGE_YEARS
```

**Refresh**: Every 15 minutes via Snowflake Task

---

### View: VW_ASSET_FEATURES_DAILY

Daily aggregated features for trend analysis.

Similar to hourly view but with daily granularity and additional metrics:
- Peak values
- Minimum values
- Operating hours
- Alarm counts
- Maintenance activity flags

---

### View: VW_DEGRADATION_INDICATORS

Specific indicators of asset degradation.

| Column | Description |
|--------|-------------|
| ASSET_ID | Asset identifier |
| INDICATOR_DATE | Date of calculation |
| OIL_QUALITY_INDEX | Composite oil quality (0-100) |
| THERMAL_STRESS_INDEX | Thermal degradation indicator |
| ELECTRICAL_STRESS_INDEX | Electrical stress level |
| MECHANICAL_STRESS_INDEX | Mechanical stress from vibration |
| MAINTENANCE_EFFECTIVENESS | How well maintenance is working |
| OVERALL_HEALTH_INDEX | Composite health (0-100) |

---

### View: VW_ANOMALY_SCORES

Statistical anomaly detection results.

Uses z-score and IQR methods to identify unusual patterns.

---

## Schema: ML

### Table: TRAINING_DATA

Labeled dataset for model training.

| Column | Type | Description |
|--------|------|-------------|
| RECORD_ID | NUMBER(38,0) | Unique ID (PK) |
| ASSET_ID | VARCHAR(50) | Asset identifier |
| SNAPSHOT_DATE | DATE | Date of feature snapshot |
| FAILURE_WITHIN_30_DAYS | BOOLEAN | Target label (classification) |
| DAYS_TO_FAILURE | NUMBER(10) | Target label (regression) |
| [ALL FEATURE COLUMNS] | VARIANT | Feature values at snapshot |
| CREATED_TS | TIMESTAMP_NTZ | Record creation time |

---

### Table: MODEL_REGISTRY

Model metadata and versioning.

| Column | Type | Description |
|--------|------|-------------|
| MODEL_ID | VARCHAR(50) | Unique model ID (PK) |
| MODEL_NAME | VARCHAR(100) | Model name |
| MODEL_TYPE | VARCHAR(50) | CLASSIFICATION, REGRESSION, ANOMALY |
| ALGORITHM | VARCHAR(50) | XGBoost, IsolationForest, etc. |
| VERSION | VARCHAR(20) | Semantic version |
| TRAINING_DATE | TIMESTAMP_NTZ | When trained |
| MODEL_OBJECT | VARCHAR(16777216) | Serialized model |
| FEATURE_SCHEMA | VARIANT | Expected feature structure |
| HYPERPARAMETERS | VARIANT | Model hyperparameters |
| STATUS | VARCHAR(20) | TRAINING, PRODUCTION, RETIRED |

---

### Table: MODEL_PREDICTIONS

Real-time model inference results.

| Column | Type | Description |
|--------|------|-------------|
| PREDICTION_ID | NUMBER(38,0) | Auto-increment ID (PK) |
| ASSET_ID | VARCHAR(50) | Asset identifier |
| PREDICTION_TIMESTAMP | TIMESTAMP_NTZ | When prediction made |
| MODEL_ID | VARCHAR(50) | Model used |
| ANOMALY_SCORE | NUMBER(5,4) | Anomaly model output (0-1) |
| FAILURE_PROBABILITY | NUMBER(5,4) | Classification output (0-1) |
| PREDICTED_RUL_DAYS | NUMBER(10,2) | Regression output |
| RISK_SCORE | NUMBER(5,2) | Composite score (0-100) |
| CONFIDENCE | NUMBER(5,4) | Prediction confidence |
| FEATURE_VALUES | VARIANT | Input features used |
| CREATED_TS | TIMESTAMP_NTZ | Record creation time |

---

### Table: MODEL_PERFORMANCE

Model evaluation metrics over time.

| Column | Type | Description |
|--------|------|-------------|
| EVAL_ID | VARCHAR(50) | Unique evaluation ID (PK) |
| MODEL_ID | VARCHAR(50) | Model being evaluated |
| EVAL_DATE | DATE | Evaluation date |
| DATASET_TYPE | VARCHAR(20) | TRAIN, TEST, PRODUCTION |
| ACCURACY | NUMBER(5,4) | Classification accuracy |
| PRECISION | NUMBER(5,4) | Precision score |
| RECALL | NUMBER(5,4) | Recall score |
| F1_SCORE | NUMBER(5,4) | F1 score |
| ROC_AUC | NUMBER(5,4) | ROC-AUC score |
| MAE | NUMBER(10,4) | Mean absolute error (RUL) |
| RMSE | NUMBER(10,4) | Root mean squared error |

---

### Table: FEATURE_IMPORTANCE

Model explainability - feature importance scores.

| Column | Type | Description |
|--------|------|-------------|
| MODEL_ID | VARCHAR(50) | Model reference |
| FEATURE_NAME | VARCHAR(100) | Feature name |
| IMPORTANCE_SCORE | NUMBER(10,6) | Importance value |
| RANK | NUMBER(10) | Importance rank |

---

### View: VW_LATEST_PREDICTIONS

Most recent prediction for each asset (materialized for performance).

---

## Schema: ANALYTICS

### View: VW_ASSET_HEALTH_DASHBOARD

Real-time asset health summary for dashboard.

```sql
SELECT
    a.ASSET_ID,
    a.ASSET_TYPE,
    a.LOCATION_SUBSTATION,
    a.LOCATION_CITY,
    a.LOCATION_COUNTY,
    a.LOCATION_LAT,
    a.LOCATION_LON,
    a.CUSTOMERS_AFFECTED,
    p.RISK_SCORE,
    p.FAILURE_PROBABILITY,
    p.PREDICTED_RUL_DAYS,
    p.PREDICTION_TIMESTAMP,
    CASE 
        WHEN p.RISK_SCORE >= 86 THEN 'CRITICAL'
        WHEN p.RISK_SCORE >= 71 THEN 'HIGH'
        WHEN p.RISK_SCORE >= 41 THEN 'MEDIUM'
        ELSE 'LOW'
    END as RISK_CATEGORY
FROM RAW.ASSET_MASTER a
LEFT JOIN ML.VW_LATEST_PREDICTIONS p ON a.ASSET_ID = p.ASSET_ID
WHERE a.STATUS = 'ACTIVE';
```

---

### View: VW_HIGH_RISK_ASSETS

Prioritized list of assets requiring attention.

Filters for `RISK_SCORE >= 71` and adds:
- Days since last maintenance
- Estimated SAIDI impact
- Recommended action timeline
- Work order priority

---

### View: VW_MAINTENANCE_RECOMMENDATIONS

Optimized maintenance scheduling recommendations.

Groups high-risk assets by:
- Geographic proximity (for crew routing)
- Required maintenance type
- Optimal time window (load patterns)
- Resource requirements

---

### View: VW_RELIABILITY_METRICS

SAIDI/SAIFI calculations and trending.

```sql
-- System Average Interruption Duration Index
SAIDI = SUM(Customer-Minutes of Interruption) / Total Customers

-- System Average Interruption Frequency Index  
SAIFI = SUM(Customer Interruptions) / Total Customers
```

Includes:
- Historical metrics (monthly, quarterly, annually)
- Predicted impact if high-risk assets fail
- Comparison to PSC targets

---

### View: VW_COST_AVOIDANCE_REPORT

Financial impact analysis.

Calculates:
- Prevented outage costs
- Avoided emergency repair costs
- Maintenance optimization savings
- Total ROI from predictive maintenance program

---

## Data Relationships

```
ASSET_MASTER (1) ──< (M) SENSOR_READINGS
ASSET_MASTER (1) ──< (M) MAINTENANCE_HISTORY
ASSET_MASTER (1) ──< (M) FAILURE_EVENTS
ASSET_MASTER (1) ──< (M) MODEL_PREDICTIONS

SENSOR_READINGS (M) ──> (1) VW_ASSET_FEATURES_HOURLY
VW_ASSET_FEATURES_HOURLY ──> TRAINING_DATA
TRAINING_DATA ──> MODEL_REGISTRY
MODEL_REGISTRY (1) ──< (M) MODEL_PREDICTIONS
```

---

## Data Volumes

### Current Demo
- ASSET_MASTER: 100 rows
- SENSOR_READINGS: ~4.3M rows (100 assets × 6 months × hourly)
- MAINTENANCE_HISTORY: ~500 rows
- FAILURE_EVENTS: ~25 rows
- MODEL_PREDICTIONS: ~100 rows (refreshed hourly)

### Production Estimates
- ASSET_MASTER: 5,000+ rows
- SENSOR_READINGS: ~1.3B rows (growing ~500K/day)
- MAINTENANCE_HISTORY: ~50K rows
- FAILURE_EVENTS: ~1,000 rows
- MODEL_PREDICTIONS: ~5K rows (refreshed hourly)

---

**Document Version**: 1.0  
**Last Updated**: 2025-11-15


