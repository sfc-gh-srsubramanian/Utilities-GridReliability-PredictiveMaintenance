# Streamlit Dashboard Guide

## Grid Reliability & Predictive Maintenance Dashboard

**Interactive real-time monitoring and analytics dashboard built with Streamlit in Snowflake**

---

## 📊 Overview

The Grid Reliability Dashboard provides a comprehensive, interactive interface for monitoring transformer health, analyzing failure predictions, and managing maintenance operations across the utility's electrical grid.

### **Key Features**
- 🗺️ **Geographic Asset Heatmap** - Visual risk mapping across Florida
- ⚠️ **High-Risk Alerts** - Real-time critical asset notifications
- 📈 **Sensor Trend Analysis** - Historical performance tracking
- 💰 **ROI Calculator** - Financial impact assessment
- 📋 **Work Order Generator** - Automated maintenance scheduling
- 📊 **Executive Dashboard** - Key metrics and KPIs

---

## 🚀 Accessing the Dashboard

### **From Snowflake UI**

1. Log into your Snowflake account
2. Navigate to: **Projects** → **Streamlit**
3. Find: **`GRID_RELIABILITY_DASHBOARD`**
4. Click to launch

### **Direct URL**
```
https://<your-account>.snowflakecomputing.com/streamlit/UTILITIES_GRID_RELIABILITY.ANALYTICS.GRID_RELIABILITY_DASHBOARD
```

### **Permissions Required**
- Role: `GRID_OPERATOR`, `GRID_ANALYST`, or `GRID_ADMIN`
- Warehouse: `GRID_RELIABILITY_WH`

---

## 📑 Dashboard Pages

### **1. 📊 Overview**

**Purpose:** Executive summary of grid reliability status

**Metrics Displayed:**
- Total Assets monitored
- Average Risk Score across fleet
- Critical Assets requiring immediate action
- High-Risk Assets needing attention
- Total Customers at Risk

**Visualizations:**
- Risk Score Distribution (bar chart)
- Top 5 High-Risk Assets (table)
- Financial Impact Summary
- SAIDI Risk Gauge

**Use Cases:**
- Daily morning briefing for operations team
- Executive status reports
- Quick health check of entire fleet

---

### **2. 🗺️ Asset Map**

**Purpose:** Geographic visualization of asset health across service territory

**Features:**
- Interactive map of all assets
- Color-coded by risk score:
  - 🟢 Green: Low risk (0-40)
  - 🟡 Yellow: Medium risk (41-70)
  - 🟠 Orange: High risk (71-85)
  - 🔴 Red: Critical (86-100)
- Bubble size represents customers affected

**Filters:**
- County selection
- Risk level filter
- Minimum customers affected

**Use Cases:**
- Regional outage risk assessment
- Resource allocation planning
- Emergency response preparation

---

### **3. ⚠️ High-Risk Alerts**

**Purpose:** Detailed view of assets requiring immediate attention

**Alert Categories:**

**🚨 CRITICAL Alerts (Risk ≥ 86)**
- Immediate inspection required
- Emergency response team notified
- Potential for imminent failure

**⚠️ HIGH-RISK Alerts (Risk 71-85)**
- Schedule maintenance within 7 days
- Monitor closely
- Prepare contingency plans

**Asset Details Shown:**
- Failure probability
- Predicted Remaining Useful Life (RUL)
- Customers affected
- SAIDI impact if failure occurs
- Days since last maintenance
- Recommended action timeline

**Use Cases:**
- Daily maintenance planning
- Emergency crew dispatch
- Proactive failure prevention

---

### **4. 📈 Asset Details**

**Purpose:** Deep-dive analysis of individual asset health

**Information Displayed:**

**Asset Summary:**
- Risk Score & Trend
- Failure Probability
- Predicted RUL
- Alert Level

**Location & Impact:**
- Substation name
- Geographic coordinates
- Customers affected
- Criticality score

**Sensor Trends (30-day history):**
1. **Oil Temperature (°C)**
   - Warning threshold: 90°C
   - Critical threshold: 105°C

2. **Load Current (Amps)**
   - Tracks loading patterns
   - Identifies overload conditions

3. **Dissolved H2 (ppm)**
   - Key indicator of electrical stress
   - Normal limit: 100 ppm

4. **Vibration (mm/s)**
   - Mechanical health indicator
   - Detects bearing/tap changer issues

5. **Power Factor**
   - Electrical efficiency metric
   - Ideal: 0.95-1.00

**Use Cases:**
- Root cause analysis
- Maintenance decision support
- Trend validation

---

### **5. 💰 ROI Calculator**

**Purpose:** Quantify financial impact of predictive maintenance program

**Current Program Metrics:**
- High-Risk Assets Identified
- Emergency Repair Cost Avoidance
- Preventive Maintenance Investment
- Net Cost Avoidance
- Return on Investment (ROI %)

**Reliability Metrics:**
- Customers Protected
- SAIDI Impact Prevented
- Annualized Projections

**Custom Scenario Calculator:**

Input Parameters:
- Number of failures prevented
- Average emergency repair cost
- Average preventive maintenance cost
- Customers affected per asset
- Average outage duration

Calculated Outputs:
- Net cost savings
- ROI percentage
- SAIDI points saved

**Use Cases:**
- Budget justification
- Executive reporting
- Program effectiveness measurement

---

### **6. 📋 Work Orders**

**Purpose:** Generate maintenance work orders for high-risk assets

**Work Order Details:**

**Priority Levels:**
- 🔴 **Priority 1** - Critical (< 7 days)
- 🟡 **Priority 2** - High (7-30 days)
- 🟢 **Priority 3** - Medium (30-90 days)

**Each Work Order Includes:**

**Risk Assessment:**
- Risk score
- Failure probability
- Predicted failure timeline
- Customer impact
- SAIDI impact

**Recommended Actions:**
1. Oil sampling & DGA (Dissolved Gas Analysis)
2. Thermal imaging (bushings & tap changer)
3. Vibration analysis
4. Load transfer planning
5. Maintenance window scheduling
6. Standby transformer preparation

**Cost Estimate:**
- Preventive Maintenance: ~$45K
- Emergency Repair (if failure): ~$450K
- Cost Avoidance: ~$405K

**Customer Impact:**
- Planned outage: 0-2 hours
- Unplanned outage: 4-6 hours

**Actions Available:**
- Generate Work Order PDF
- Schedule Maintenance

**Use Cases:**
- Maintenance crew scheduling
- Parts ordering
- Customer outage notifications
- Compliance documentation

---

## 🔄 Data Refresh

### **Automatic Refresh**
- Dashboard data is cached for **5 minutes**
- Automatic refresh every 5 minutes when active

### **Manual Refresh**
- Click **🔄 Refresh Data** button in sidebar
- Clears cache and reloads all data

### **Data Sources**
All data is queried real-time from Snowflake:
- `UTILITIES_GRID_RELIABILITY.ANALYTICS.VW_ASSET_HEALTH_DASHBOARD`
- `UTILITIES_GRID_RELIABILITY.ANALYTICS.VW_HIGH_RISK_ASSETS`
- `UTILITIES_GRID_RELIABILITY.ANALYTICS.VW_RELIABILITY_METRICS`
- `UTILITIES_GRID_RELIABILITY.ANALYTICS.VW_COST_AVOIDANCE_REPORT`
- `UTILITIES_GRID_RELIABILITY.RAW.SENSOR_READINGS`

---

## 🎨 Dashboard Features

### **Interactive Elements**
- ✅ Filters and dropdowns
- ✅ Sortable data tables
- ✅ Expandable detail cards
- ✅ Downloadable reports
- ✅ Zoom-able maps
- ✅ Hoverable tooltips

### **Visualizations**
- 📊 Bar charts
- 📈 Line graphs
- 🗺️ Geographic maps
- 🎯 Gauge meters
- 📉 Multi-series trends

### **Export Options**
- 📄 PDF work orders (planned)
- 📊 CSV data export (via Snowflake)
- 📸 Screenshot capability (browser native)

---

## 🛠️ Technical Details

### **Technology Stack**
- **Framework:** Streamlit 1.29+
- **Platform:** Streamlit in Snowflake (SiS)
- **Database:** Snowflake
- **Language:** Python 3.11
- **Visualization:** Plotly Express

### **Python Dependencies**
```python
streamlit
pandas
numpy
plotly
snowflake-snowpark-python
```

### **File Location**
- **Snowflake Stage:** `@UTILITIES_GRID_RELIABILITY.ANALYTICS.STREAMLIT_STAGE`
- **Main File:** `grid_reliability_dashboard.py`
- **Local Path:** `python/dashboard/grid_reliability_dashboard.py`

### **Warehouse Requirements**
- **Warehouse:** `GRID_RELIABILITY_WH`
- **Size:** X-SMALL (sufficient for dashboard queries)
- **Auto-suspend:** 5 minutes recommended

---

## 📱 Best Practices

### **For Operations Teams**
1. **Check Overview page daily** for system health
2. **Monitor High-Risk Alerts** every 4 hours
3. **Review Asset Map** for regional planning
4. **Generate work orders** weekly

### **For Analysts**
1. **Use Asset Details** for root cause analysis
2. **Track sensor trends** for pattern recognition
3. **Run ROI Calculator** for reporting
4. **Export data** for detailed analysis

### **For Executives**
1. **Review Overview metrics** weekly
2. **Focus on ROI Calculator** for business value
3. **Monitor SAIDI impact** for regulatory compliance
4. **Use for board presentations**

---

## 🐛 Troubleshooting

### **Dashboard won't load**
- ✅ Check Snowflake connection
- ✅ Verify role permissions
- ✅ Ensure warehouse is running
- ✅ Clear browser cache

### **No data showing**
- ✅ Run data validation queries
- ✅ Check if predictions are up to date
- ✅ Verify ML models are trained
- ✅ Hit "Refresh Data" button

### **Slow performance**
- ✅ Increase warehouse size
- ✅ Reduce date range for sensor trends
- ✅ Apply filters to reduce data volume
- ✅ Check Snowflake query history

### **Map not displaying**
- ✅ Check asset coordinates are valid
- ✅ Verify location data is populated
- ✅ Try different web browser
- ✅ Check internet connectivity

---

## 📞 Support

### **Technical Issues**
- Contact: Grid Reliability AI/ML Team
- Email: grid-reliability@utility.com
- Slack: #grid-reliability-support

### **Feature Requests**
- Submit via: Internal Portal
- Priority: Based on business impact

### **Training**
- Onboarding sessions: Weekly
- Advanced training: Monthly
- Documentation: This guide + inline help

---

## 🔐 Security & Compliance

### **Data Access**
- All data queries respect Snowflake RBAC
- Row-level security applied where configured
- Audit logging enabled

### **User Authentication**
- Snowflake SSO integration
- MFA recommended
- Session timeout: 30 minutes inactive

### **Data Privacy**
- No PII displayed
- Asset IDs anonymized in exports
- Compliant with utility data policies

---

## 🚀 Future Enhancements

### **Planned Features**
- [ ] Mobile-responsive design
- [ ] Email alerting system
- [ ] Integration with CMMS
- [ ] Advanced anomaly detection visualizations
- [ ] Weather overlay on asset map
- [ ] Predictive maintenance calendar
- [ ] Custom alert threshold configuration

### **Under Development**
- PDF work order export
- Historical trend comparisons
- Multi-utility support
- Real-time SCADA integration

---

## 📚 Related Documentation

- **[Deployment Guide](DEPLOYMENT_GUIDE.md)** - How to deploy the platform
- **[Quick Start](QUICK_START.md)** - Getting started guide
- **[Architecture](../architecture/ARCHITECTURE.md)** - System architecture
- **[API Reference](API_REFERENCE.md)** - ML model APIs
- **[Solution Overview](../../solution_presentation/Grid_Reliability_Solution_Overview.md)** - Executive summary

---

**Last Updated:** January 6, 2026  
**Version:** 1.0  
**Status:** Production Ready ✅

