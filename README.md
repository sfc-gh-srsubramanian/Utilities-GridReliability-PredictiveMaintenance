# ⚡ Grid Reliability & Predictive Maintenance Platform
## *Transforming Utility Operations Through AI (Artificial Intelligence)-Powered Asset Intelligence*

---

## 🎯 **WHY This System Exists**

### **The Utility Grid Challenge**
Modern utilities manage complex grid infrastructure while facing unprecedented reliability pressures. Most utilities struggle with:

- **Aging infrastructure** - 40% of transformers >20 years old, facing thermal stress and load growth
- **Reactive maintenance** - 60-70% of failures occur despite calendar-based maintenance schedules
- **Data silos** - OT (Operational Technology) sensor data trapped in SCADA (Supervisory Control and Data Acquisition), IT (Information Technology) asset data in separate systems
- **Unstructured intelligence gap** - Maintenance logs, technical manuals, and visual inspections not analyzed
- **Regulatory pressure** - State commissions closely monitor SAIDI/SAIFI (System Average Interruption Duration Index / System Average Interruption Frequency Index) metrics with penalties for poor performance

### **The Business Opportunity**
Industry studies and proven implementations indicate that **AI-powered predictive maintenance platforms** can potentially deliver:
- ⚡ **70% reduction in unplanned outages** through early failure detection
- 💰 **$25M+ annual cost avoidance** from prevented failures and optimized maintenance
- 📈 **15-20% improvement in SAIDI/SAIFI scores** with proactive asset management
- 🔧 **40% reduction in maintenance costs** by transitioning from reactive to predictive
- ⏱️ **5-7 year extension of asset lifespan** through condition-based maintenance

> **Note:** These are industry benchmark ranges based on utility technology ROI (Return on Investment) studies and proven results from gas turbine predictive maintenance programs. Actual results vary based on asset base, current maintenance maturity, and implementation quality.

### **Our Solution**
A **comprehensive AI-powered predictive maintenance platform** that:
- 🔗 **Unifies IT and OT data** into a single source of truth on Snowflake
- 🧠 **Predicts equipment failures** 14-30 days in advance with ML (Machine Learning) models
- 📄 **Analyzes unstructured data** (maintenance logs, manuals, visual inspections, CV (Computer Vision) detections)
- 💡 **Provides conversational analytics** through Snowflake Intelligence Agents
- 📊 **Delivers actionable insights** for maintenance optimization and cost avoidance

---

## 🚀 **QUICK START**

### Deploy in 3 Simple Steps

**Prerequisites:**
```bash
# 1. Install Snowflake CLI or SnowSQL
pip install snowflake-cli-labs

# 2. Configure your Snowflake connection
snow connection add default
```

**Note:** Python dependencies are **automatically managed**:
- ✅ Auto-detects Python 3.8+ on your system
- ✅ Creates and activates virtual environment automatically
- ✅ Installs all required packages (numpy, pandas, reportlab)
- ✅ No manual setup needed - just run `./deploy.sh`!

**Step 1: Deploy the Platform** (15-20 minutes)
```bash
./deploy.sh

# Or deploy to a specific environment:
./deploy.sh --prefix DEV
./deploy.sh -c prod  # Use 'prod' connection
./deploy.sh --skip-agents  # Skip Intelligence Agents
```

**What Gets Deployed:**
- ✅ Database with 6 schemas (RAW, FEATURES, ML, ANALYTICS, UNSTRUCTURED, STAGING)
- ✅ 15+ tables across medallion architecture
- ✅ 100 demo assets (transformers, circuit breakers, substations)
- ✅ 432,000+ sensor readings (30 days @ 5-min intervals)
- ✅ 192 maintenance records + 10 failure events
- ✅ 80 maintenance log documents (NLP (Natural Language Processing)-ready)
- ✅ 15 technical manuals across 4 equipment types
- ✅ 150 visual inspection records + 281 CV detections
- ✅ ML models (XGBoost, Isolation Forest, Linear Regression)
- ✅ Cortex Search services for document intelligence
- ✅ Semantic views for natural language queries
- ✅ Grid Intelligence Agent (optional)
- ✅ **Interactive Streamlit Dashboard** with 6 pages

**Step 2: Validate the Deployment**
```bash
# Run validation queries
./run.sh validate

# Check resource and data status
./run.sh status
```

**Step 3: Query and Explore**
```bash
# Execute custom queries
./run.sh query "SELECT * FROM ML.MODEL_PREDICTIONS WHERE ALERT_LEVEL = 'HIGH' LIMIT 10"

# Test Intelligence Agent
./run.sh test-agents

# Run sample integration queries
./run.sh sample-queries
```

### Available Scripts

- **`./deploy.sh`** - Full platform deployment
  - `--prefix DEV` - Deploy with environment prefix
  - `--skip-agents` - Skip Intelligence Agents
  - `-c prod` - Use specific Snowflake connection
  
- **`./run.sh`** - Runtime operations
  - `status` - Check resource and data status
  - `validate` - Run validation queries
  - `query "SQL"` - Execute custom SQL
  - `test-agents` - Test Intelligence Agents
  - `sample-queries` - Run sample integration queries
  
- **`./clean.sh`** - Cleanup and reset
  - `--force` - Skip confirmation prompt
  - `--prefix DEV` - Match deployment prefix

---

## 📊 **WHAT'S INCLUDED**

### **Structured Data (IT/OT Convergence)**
| Data Source | Records | Description |
|------------|---------|-------------|
| **Asset Master** | 100 | Transformers, circuit breakers, substations |
| **Sensor Readings** | 432,000+ | Temperature, load, vibration, DGA (Dissolved Gas Analysis), acoustic |
| **Maintenance History** | 192 | Work orders, inspections, repairs |
| **Failure Events** | 10 | Historical failures with root cause analysis |

### **Unstructured Data (Document Intelligence)**
| Data Source | Records | Description |
|------------|---------|-------------|
| **Maintenance Logs** | 80 | Technician reports with NLP-ready text |
| **Technical Manuals** | 15 | Equipment specs, troubleshooting guides |
| **Visual Inspections** | 150 | Drone, thermal, visual, LiDAR (Light Detection and Ranging) imagery |
| **CV Detections** | 281 | Corrosion, cracks, hotspots, oil leaks |

### **ML Models**
| Model | Purpose | Output |
|-------|---------|--------|
| **XGBoost Classifier** | Failure prediction | Probability (0-100%), Alert level |
| **Isolation Forest** | Anomaly detection | Anomaly score, Flag |
| **Linear Regression** | Remaining useful life (RUL) | Predicted RUL in days |

### **AI Capabilities**
- 🤖 **Snowflake Intelligence Agent** - Natural language queries across structured + unstructured data
  - **Access**: Navigate to `Projects → Intelligence` in Snowflake UI (automatically registered)
  - Combines Cortex Analyst (text-to-SQL) with Cortex Search (document retrieval)
- 🔍 **Cortex Search Services** - Semantic search across maintenance logs and technical manuals
- 📊 **Semantic Views** - Business-friendly data model for analytics

### **Interactive Dashboard**
- 🎨 **Streamlit in Snowflake Dashboard** - 6-page interactive web application
  - 📊 **Overview Page** - Executive KPIs, risk distribution, financial metrics
  - 🗺️ **Asset Map** - Geographic heatmap with color-coded risk scores
  - ⚠️ **High-Risk Alerts** - Real-time critical asset notifications
  - 📈 **Asset Details** - Individual asset analysis with 30-day sensor trends
  - 💰 **ROI Calculator** - Financial impact analysis and scenario modeling
  - 📋 **Work Orders** - Automated maintenance work order generation

---

## 💡 **SAMPLE QUERIES**

### High-Risk Assets
```sql
SELECT 
    a.ASSET_ID,
    a.LOCATION_SUBSTATION,
    mp.FAILURE_PROBABILITY,
    mp.PREDICTED_RUL_DAYS,
    mp.ALERT_LEVEL,
    m.DOCUMENT_TEXT AS LATEST_MAINT_LOG
FROM RAW.ASSET_MASTER a
JOIN ML.MODEL_PREDICTIONS mp ON a.ASSET_ID = mp.ASSET_ID
LEFT JOIN UNSTRUCTURED.MAINTENANCE_LOG_DOCUMENTS m ON a.ASSET_ID = m.ASSET_ID
WHERE mp.ALERT_LEVEL IN ('HIGH', 'CRITICAL')
ORDER BY mp.FAILURE_PROBABILITY DESC
LIMIT 20;
```

### Maintenance Optimization
```sql
SELECT 
    ASSET_ID,
    PREDICTED_RUL_DAYS,
    FAILURE_PROBABILITY,
    LOCATION_SUBSTATION,
    CRITICALITY_SCORE
FROM ANALYTICS.VW_ASSET_HEALTH_SCORECARD
WHERE PREDICTED_RUL_DAYS < 90
  AND ALERT_LEVEL IN ('HIGH', 'CRITICAL')
ORDER BY CRITICALITY_SCORE DESC, PREDICTED_RUL_DAYS ASC;
```

### Natural Language (via Intelligence Agent)
```
"Which transformers have high failure probability and recent maintenance logs indicating oil degradation?"

"Show me thermal inspection images for assets with predicted failures in the next 30 days"

"What are the top 5 root causes of failures across circuit breakers in the last year?"

"Find technical manuals for all GE equipment with high vibration readings"
```

---

## 🏗️ **ARCHITECTURE**

### **Medallion Architecture on Snowflake**

```
┌─────────────────────────────────────────────────────────────┐
│                    SNOWFLAKE AI DATA CLOUD                  │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │
│  │   RAW (Bronze)│  │FEATURES (Silver)│ │ML & ANALYTICS│    │
│  ├──────────────┤  ├──────────────┤  ├──────────────┤     │
│  │ Assets       │→ │ Engineered   │→ │ Predictions  │     │
│  │ Sensors      │  │ Features     │  │ Scorecards   │     │
│  │ Maintenance  │  │ Degradation  │  │ Cost Avoid   │     │
│  │ Failures     │  │ Indicators   │  │ Reliability  │     │
│  └──────────────┘  └──────────────┘  └──────────────┘     │
│                                                             │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │
│  │ UNSTRUCTURED │  │ CORTEX SEARCH│  │  INTELLIGENCE│     │
│  ├──────────────┤  ├──────────────┤  ├──────────────┤     │
│  │ Maint Logs   │→ │ Document     │→ │  AGENT       │     │
│  │ Tech Manuals │  │ Search       │  │              │     │
│  │ Visual Insp. │  │ Services     │  │ Natural Lang │     │
│  │ CV Detections│  │              │  │ Queries      │     │
│  └──────────────┘  └──────────────┘  └──────────────┘     │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

**Key Layers:**
1. **RAW (Bronze)** - Ingestion from SCADA, asset systems, documents
2. **FEATURES (Silver)** - Data quality, feature engineering
3. **ML** - Model training, scoring, predictions
4. **ANALYTICS (Gold)** - Business views, reliability metrics
5. **UNSTRUCTURED** - Document intelligence, Cortex Search
6. **Semantic Views** - Natural language interface

---

## 📚 **DOCUMENTATION**

### **Quick Links**
- 📖 [Solution Overview](solution_presentation/Grid_Reliability_Solution_Overview.md) - Executive summary, business value, use cases
- 🚀 [Quick Start Guide](docs/guides/QUICKSTART.md) - Get started in 15 minutes
- 📘 [Deployment Guide](docs/guides/DEPLOYMENT_GUIDE.md) - Detailed deployment instructions
- 🎨 [Streamlit Dashboard Guide](docs/guides/STREAMLIT_DASHBOARD_GUIDE.md) - Interactive dashboard user guide
- 🏗️ [Architecture Guide](docs/architecture/ARCHITECTURE.md) - Technical architecture deep dive
- 💼 [Business Case](docs/business/BUSINESS_CASE.md) - ROI analysis and business justification
- 🎬 [Demo Script](docs/business/DEMO_SCRIPT.md) - Step-by-step demo walkthrough

### **Reference Documentation**
- 📝 [Agent Sample Questions](docs/references/AGENT_SAMPLE_QUESTIONS.md) - 100+ example questions for Intelligence Agent
- 📊 [Column Reference](docs/references/COLUMN_REFERENCE.md) - Database schema and column definitions
- 🔗 [Integration Queries](sql/99_sample_queries.sql) - Sample SQL queries for common use cases

---

## 🎯 **USE CASES**

### **1. Predictive Maintenance**
Identify assets requiring maintenance 14-30 days before failure, enabling scheduled interventions during planned outages.

### **2. Cost Avoidance**
Prevent emergency replacements ($385K avg) by detecting degradation early. Annual savings: $25M+.

### **3. Reliability Improvement**
Improve SAIDI/SAIFI scores 15-20% through proactive asset management.

### **4. Root Cause Analysis**
Analyze unstructured maintenance logs to identify common failure patterns and optimize maintenance programs.

### **5. Technician Support**
Provide field technicians instant access to technical manuals and historical maintenance logs via natural language search.

---

## 🔧 **CUSTOMIZATION**

### **Add Your Data**
```bash
# Place your CSV/JSON files in generated_data/
# Update python/data_generators/ scripts with your data schema
# Re-run: ./deploy.sh
```

### **Modify ML Models**
```sql
-- Edit: sql/06_ml_models.sql
-- Adjust hyperparameters, features, or add new models
```

### **Customize Intelligence Agent**
```sql
-- Edit: sql/09_intelligence_agent.sql
-- Modify agent instructions, add tools, adjust semantic model
```

---

## 📊 **SUCCESS METRICS**

Track these KPIs to measure impact:

**Reliability Metrics:**
- SAIDI, SAIFI, CAIDI (Customer Average Interruption Duration Index) scores
- Unplanned outage rate
- Asset availability

**Maintenance Metrics:**
- Preventable failures detected
- Emergency vs. planned maintenance ratio
- Maintenance cost per asset
- Mean time between failures (MTBF - Mean Time Between Failures)

**Business Metrics:**
- Cost avoidance (prevented failures)
- Regulatory compliance score
- Customer satisfaction (NPS - Net Promoter Score)

---

## 🆘 **TROUBLESHOOTING**

**Connection Issues:**
```bash
# Test Snowflake connection
python3 python/utilities/test_snowflake_connection.py
```

**Deployment Failures:**
```bash
# Check logs for specific errors
# Verify prerequisites: Database, Warehouse, Roles
# Re-run specific SQL file: snow sql -f sql/01_infrastructure_setup.sql
```

**Data Loading Issues:**
```bash
# Verify generated data exists
ls -lh generated_data/

# Check table counts
./run.sh status
```

---

## 🤝 **SUPPORT & CONTRIBUTIONS**

### **Getting Help**
- 📧 Contact your Snowflake Account Executive
- 🎓 Schedule a technical deep dive with Solution Engineering
- 📚 Review [Snowflake Documentation](https://docs.snowflake.com/)

### **Feedback**
This is a reference implementation. Adapt it to your specific needs:
- Modify asset types and sensor parameters
- Integrate with your SCADA/OMS (Outage Management System) systems
- Customize ML models for your failure patterns
- Extend Intelligence Agent with domain-specific tools

---

## 📜 **LICENSE**

This project is a Snowflake reference implementation for demonstration purposes.

---

## 🌟 **WHAT'S NEXT?**

1. **Deploy**: Run `./deploy.sh` to get started
2. **Explore**: Try sample queries and Intelligence Agent
3. **Customize**: Adapt to your asset types and data sources
4. **Pilot**: Deploy to a subset of critical assets
5. **Scale**: Expand to full asset base (5,000+ assets)
6. **Integrate**: Connect to production SCADA and OMS systems

---

**Built on Snowflake AI Data Cloud** | **Powered by Snowflake Cortex** | **Ready for Enterprise Scale**

*Last Updated: January 2026*
