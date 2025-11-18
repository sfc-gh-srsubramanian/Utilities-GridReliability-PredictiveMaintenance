# System Architecture: AI-Driven Grid Reliability & Predictive Maintenance

## 1. Overview

This document describes the technical architecture of FPL's AI-driven grid reliability and predictive maintenance system built on the Snowflake AI Data Cloud platform.

## 2. Architecture Principles

### 2.1 IT/OT Convergence
The architecture bridges the traditional divide between Information Technology (IT) and Operational Technology (OT) systems:
- **OT Data**: Real-time sensor readings from SCADA, DCS, and IIoT devices
- **IT Data**: Asset master data, maintenance history, work orders, and financial systems
- **Unified Platform**: Snowflake serves as the single source of truth

### 2.2 Multi-Layered Data Architecture
Following data lake/lakehouse best practices:
- **Bronze Layer** (RAW): Immutable raw data from all sources
- **Silver Layer** (FEATURES): Cleaned, validated, and enriched data
- **Gold Layer** (ANALYTICS): Business-ready aggregations and metrics
- **ML Layer**: Model artifacts, predictions, and model monitoring

### 2.3 Real-Time + Batch Processing
Hybrid processing model:
- **Streaming**: Snowpipe for continuous sensor data ingestion
- **Micro-batch**: Snowflake Tasks for feature engineering (every 15 minutes)
- **Batch**: Daily model retraining and historical analysis

## 3. Detailed Architecture

### 3.1 Data Ingestion Layer

```
┌─────────────────────────────────────────────────────────────┐
│                    DATA SOURCES                              │
├─────────────────────────────────────────────────────────────┤
│  SCADA Systems  │  DCS  │  IoT Sensors  │  Asset Mgmt  │...│
└──────┬──────────┴───┬───┴───────┬───────┴──────┬───────────┘
       │              │           │              │
       ▼              ▼           ▼              ▼
┌──────────────────────────────────────────────────────────────┐
│              INGESTION MECHANISMS                             │
├──────────────────────────────────────────────────────────────┤
│  • REST APIs → S3 → Snowpipe (real-time)                     │
│  • MQTT → Kafka → S3 → Snowpipe (streaming)                  │
│  • Database Connectors (batch)                               │
│  • File Upload (manual/scheduled)                            │
└──────────────────┬───────────────────────────────────────────┘
                   ▼
         ┌──────────────────┐
         │  SNOWFLAKE STAGE  │
         │  (External S3)    │
         └──────────────────┘
```

### 3.2 Database Schema Architecture

**Database**: `UTILITIES_GRID_RELIABILITY`

#### Schema: RAW (Bronze Layer)
```sql
-- Core Tables
- SENSOR_READINGS          -- Time-series sensor data (1M+ rows/day)
- ASSET_MASTER             -- Asset inventory (5,000+ assets)
- MAINTENANCE_HISTORY      -- Historical work orders
- FAILURE_EVENTS           -- Historical failure incidents
- WEATHER_DATA             -- Environmental conditions
- SCADA_EVENTS             -- Operational events and alarms
```

#### Schema: FEATURES (Silver Layer)
```sql
-- Engineered Features
- VW_ASSET_FEATURES_HOURLY      -- Rolling statistics (hourly)
- VW_ASSET_FEATURES_DAILY       -- Daily aggregates
- VW_DEGRADATION_INDICATORS     -- Trend analysis
- VW_ANOMALY_SCORES             -- Statistical anomalies
```

#### Schema: ML
```sql
-- ML Artifacts
- TRAINING_DATA                 -- Labeled training sets
- MODEL_REGISTRY                -- Model metadata and versions
- MODEL_PREDICTIONS             -- Inference results
- MODEL_PERFORMANCE             -- Evaluation metrics
- FEATURE_IMPORTANCE            -- Model explainability
```

#### Schema: ANALYTICS (Gold Layer)
```sql
-- Business Analytics
- VW_ASSET_HEALTH_DASHBOARD     -- Current health scores
- VW_HIGH_RISK_ASSETS           -- Prioritized alert list
- VW_MAINTENANCE_RECOMMENDATIONS -- Optimized scheduling
- VW_RELIABILITY_METRICS        -- SAIDI/SAIFI calculations
- VW_COST_AVOIDANCE_REPORT      -- Financial impact
```

### 3.3 Data Flow Diagram

```
┌─────────────┐
│ OT Sensors  │
│ (Hourly)    │
└──────┬──────┘
       │
       ▼
┌──────────────┐         ┌─────────────┐
│  Snowpipe    │────────>│ RAW.SENSOR_ │
│  (Streaming) │         │  READINGS   │
└──────────────┘         └──────┬──────┘
                                │
                                ▼
                         ┌──────────────┐
                         │ STREAM:      │
                         │ SENSOR_STREAM│
                         └──────┬───────┘
                                │
                                ▼
                    ┌──────────────────────┐
                    │ TASK (Every 15 min): │
                    │ Feature Engineering  │
                    └──────┬───────────────┘
                           │
                           ▼
              ┌────────────────────────────┐
              │ FEATURES.VW_ASSET_FEATURES │
              └────────────┬───────────────┘
                           │
                           ▼
                  ┌─────────────────┐
                  │ TASK (Hourly):  │
                  │ Model Scoring   │
                  └────────┬────────┘
                           │
                           ▼
               ┌──────────────────────┐
               │ ML.MODEL_PREDICTIONS │
               └──────────┬───────────┘
                          │
                          ▼
              ┌───────────────────────┐
              │ ANALYTICS.VW_HIGH_    │
              │ RISK_ASSETS           │
              └───────────┬───────────┘
                          │
          ┌───────────────┴────────────────┐
          ▼                                ▼
┌──────────────────┐            ┌──────────────────┐
│ Streamlit        │            │ Snowflake        │
│ Dashboard        │            │ Intelligence     │
└──────────────────┘            │ Agent            │
                                └──────────────────┘
```

### 3.4 ML Pipeline Architecture

```
┌─────────────────────────────────────────────────────┐
│             TRAINING PIPELINE (Weekly)               │
├─────────────────────────────────────────────────────┤
│  1. Data Collection                                  │
│     • Last 6 months sensor readings                  │
│     • Labeled failure events                         │
│     • Asset characteristics                          │
│                                                      │
│  2. Feature Engineering                              │
│     • Rolling statistics (7d, 30d)                   │
│     • Rate of change calculations                    │
│     • Deviation from baseline                        │
│     • Seasonal adjustments                           │
│                                                      │
│  3. Model Training (Snowpark ML)                     │
│     ┌─────────────────────────┐                     │
│     │ Anomaly Detection       │                     │
│     │ (Isolation Forest)      │                     │
│     └─────────────────────────┘                     │
│     ┌─────────────────────────┐                     │
│     │ Failure Classification  │                     │
│     │ (XGBoost)               │                     │
│     └─────────────────────────┘                     │
│     ┌─────────────────────────┐                     │
│     │ RUL Prediction          │                     │
│     │ (Linear Regression)     │                     │
│     └─────────────────────────┘                     │
│                                                      │
│  4. Model Evaluation                                 │
│     • Precision/Recall/F1                            │
│     • ROC-AUC                                        │
│     • Mean Absolute Error (RUL)                      │
│     • Business metrics (cost-weighted)               │
│                                                      │
│  5. Model Registration                               │
│     • Version tagging                                │
│     • Performance metadata                           │
│     • Feature schema                                 │
└─────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────┐
│          INFERENCE PIPELINE (Hourly)                 │
├─────────────────────────────────────────────────────┤
│  1. Fetch Latest Features                            │
│  2. Load Production Model                            │
│  3. Generate Predictions                             │
│  4. Calculate Risk Scores                            │
│  5. Trigger Alerts (if score > threshold)            │
│  6. Log to Prediction Table                          │
└─────────────────────────────────────────────────────┘
```

## 4. Machine Learning Models

### 4.1 Anomaly Detection Model

**Algorithm**: Isolation Forest
**Purpose**: Identify unusual sensor patterns that deviate from normal behavior
**Input Features** (15):
- Oil temperature (current, 7d avg, 30d avg)
- Load current (current, peak, avg)
- Dissolved gases (H2, CO, CO2, CH4)
- Vibration levels
- Ambient temperature
- Tap changer operations

**Output**: Anomaly score (0-1, where >0.7 indicates anomaly)

### 4.2 Failure Classification Model

**Algorithm**: XGBoost Classifier
**Purpose**: Predict probability of failure in next 30 days
**Input Features** (25):
- All anomaly detection features
- Asset age and maintenance history
- Historical failure rate
- Load factor trends
- Seasonal factors
- Time since last maintenance

**Output**: 
- Binary classification (Fail/No-Fail)
- Probability score (0-1)

**Training Labels**: Historical failures within 30-day window

### 4.3 Remaining Useful Life (RUL) Model

**Algorithm**: Linear Regression
**Purpose**: Estimate days until failure for high-risk assets
**Input Features** (20):
- Current degradation rate
- Anomaly score trends
- Load utilization patterns
- Maintenance effectiveness

**Output**: Estimated days until failure (1-365)

### 4.4 Composite Risk Score

**Formula**:
```
Risk Score = (Anomaly * 0.3) + (Failure_Prob * 0.5) + (RUL_Factor * 0.2)

Where:
  Anomaly = Normalized anomaly score (0-100)
  Failure_Prob = Classification probability * 100
  RUL_Factor = (365 - RUL) / 365 * 100
```

**Thresholds**:
- 0-40: Low risk (routine monitoring)
- 41-70: Medium risk (increased monitoring)
- 71-85: High risk (schedule maintenance)
- 86-100: Critical (immediate action required)

## 5. Semantic Model & AI Agent

### 5.1 Cortex Analyst Semantic Model

**File**: `grid_reliability_semantic.yaml`

Defines business logic and relationships for natural language queries:
```yaml
dimensions:
  - asset_id
  - asset_type
  - location
  - age_years
  - criticality_score
  
facts:
  - risk_score
  - failure_probability
  - remaining_useful_life
  - customers_affected
  
measures:
  - avg_risk_score
  - count_high_risk_assets
  - total_customers_at_risk
  - predicted_saidi_impact
```

### 5.2 Snowflake Intelligence Agent

**Model**: Claude 4 Sonnet
**Tools**:
1. `cortex_search` - Search asset and sensor metadata
2. `cortex_analyst_text_to_sql` - Convert questions to SQL queries

**Example Queries**:
- "Which 10 transformers have the highest failure risk?"
- "Show me assets in Miami-Dade county with risk score > 80"
- "What's the total SAIDI impact if all high-risk assets fail?"
- "List maintenance recommendations for next month"

## 6. Visualization Layer

### 6.1 Streamlit Dashboard

**Components**:
1. **Asset Health Heatmap** - Geographic visualization of risk scores
2. **High-Risk Alert List** - Sortable table with drill-down capability
3. **Asset Detail View** - Sensor trends and prediction confidence
4. **Work Order Generator** - Automated maintenance scheduling
5. **ROI Calculator** - Cost avoidance and SAIDI impact

**Refresh Rate**: Real-time (queries latest data on page load)

### 6.2 Key Visualizations

- Time-series plots with confidence intervals
- Geographic heatmaps using Plotly
- Risk score gauges with threshold bands
- Feature importance charts for explainability
- Maintenance calendar with optimal scheduling

## 7. Scalability Considerations

### 7.1 Data Volume Projections

**Current Demo**: 
- 100 transformers
- 6 months historical data
- ~4.3M sensor readings

**Production Scale**:
- 5,000+ monitored assets
- 3 years historical data
- ~1.3B sensor readings
- ~500K new readings per day

### 7.2 Compute Optimization

**Warehouse Sizing**:
- **XS**: Demo and development (current)
- **S**: Production with <1,000 assets
- **M**: Production with 1,000-5,000 assets
- **L**: Production with >5,000 assets

**Cost Optimization**:
- Clustering keys on time-series tables
- Materialized views for frequently accessed features
- Search optimization for alert queries
- Auto-suspend set to 60 seconds

## 8. Security & Compliance

### 8.1 Data Security

- **Encryption**: At-rest and in-transit (Snowflake default)
- **Access Control**: Role-based access (RBAC)
- **Audit Logging**: Query history and data access tracking
- **Data Masking**: PII and sensitive location data (if needed)

### 8.2 Roles & Privileges

```sql
-- Read-only analyst
CREATE ROLE GRID_ANALYST;
GRANT SELECT ON SCHEMA ANALYTICS TO ROLE GRID_ANALYST;

-- ML engineer (model development)
CREATE ROLE GRID_ML_ENGINEER;
GRANT ALL ON SCHEMA ML TO ROLE GRID_ML_ENGINEER;

-- System admin (full access)
CREATE ROLE GRID_ADMIN;
GRANT ALL ON DATABASE UTILITIES_GRID_RELIABILITY TO ROLE GRID_ADMIN;
```

## 9. Monitoring & Alerting

### 9.1 System Health Monitoring

- Data ingestion lag (should be <5 minutes)
- Model inference latency (should be <1 second)
- Feature engineering task success rate
- Snowpipe credit consumption

### 9.2 Operational Alerts

- Critical risk score threshold breached (>85)
- Model prediction confidence drops below threshold
- Data quality issues (missing sensors, anomalies)
- Task failures or delays

## 10. Deployment & CI/CD

### 10.1 Deployment Process

1. **Development**: Local testing with sample data
2. **Staging**: Snowflake DEV environment with production schema
3. **Production**: Gradual rollout with shadow mode testing

### 10.2 Version Control

- SQL scripts in Git repository
- Semantic model YAML versioned
- Dashboard code in separate repository
- Database schema migrations tracked

## 11. Future Enhancements

### Phase 2 (Q1 2026)
- Expand to circuit breakers and switchgear
- Add weather forecast integration
- Implement optimization for maintenance crew scheduling

### Phase 3 (Q2 2026)
- Distribution automation devices (reclosers, capacitors)
- Grid topology analysis for cascade failure prediction
- Integration with outage management system (OMS)

### Phase 4 (Q3 2026)
- Computer vision for drone inspection data
- NLP for maintenance notes analysis
- What-if scenario modeling

---

**Document Version**: 1.0  
**Last Updated**: 2025-11-15  
**Owner**: FPL AI/ML Team


