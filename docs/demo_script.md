# Demo Script: AI-Driven Grid Reliability & Predictive Maintenance

## Demo Duration: 15-20 minutes

## Audience: FPL Leadership & Florida PSC

---

## Pre-Demo Checklist

- [ ] Database deployed with sample data
- [ ] Models trained and predictions current
- [ ] Streamlit dashboard running
- [ ] Snowflake Intelligence Agent configured
- [ ] Target asset (T-SS047-001) flagged with high risk score
- [ ] Backup slides ready (if demo environment issues)

---

## Demo Flow

### **Part 1: The Challenge (2 minutes)**

#### Talking Points:

**"FPL manages over 5,000 critical substation assets across Florida."**

- Show map visualization on dashboard
- Highlight density in major metropolitan areas

**"Each transformer failure impacts thousands of customers and directly affects our SAIDI/SAIFI metrics that the PSC closely monitors."**

**Key Statistics:**
- Average transformer failure: 4-6 hour outage
- Typical impact: 5,000-15,000 customers
- Emergency replacement cost: $300K-$500K
- SAIDI impact: 0.003-0.008 points per incident

**"Traditional maintenance is reactive or calendar-based, which misses 60-70% of preventable failures."**

**The Challenge:**
- Critical OT sensor data trapped in SCADA systems
- IT asset data in separate enterprise systems
- No predictive capability
- Inability to optimize maintenance scheduling

---

### **Part 2: The Solution - IT/OT Convergence (3 minutes)**

#### Demonstration:

**"Snowflake AI Data Cloud breaks down these silos."**

**Show Architecture Diagram** (on screen or slides):

```
┌─────────────┐
│ SCADA/OT    │ ─┐
│ Sensors     │  │
└─────────────┘  │
                 ├──> Snowpipe ──> Snowflake ──> ML Models
┌─────────────┐  │                                    │
│ Asset Mgmt  │  │                                    ▼
│ IT Systems  │ ─┘                              Predictions
└─────────────┘                                      │
                                                     ▼
                                              Actions/Alerts
```

**Navigate to Streamlit Dashboard → Data Sources Tab**

**"We're ingesting real-time sensor data from 100 transformers:"**
- Oil temperature and quality
- Load current and voltage
- Vibration and acoustic signatures
- Dissolved gas analysis (H2, CO, CO2, CH4)

**Show sample raw data table** (last 24 hours of readings)

**"This OT data is automatically merged with IT systems:"**
- Asset age and manufacturer specs
- Maintenance history
- Historical failure patterns
- Customer impact data

**"All in one platform, updated in near real-time."**

---

### **Part 3: Predictive Analytics in Action (5 minutes)**

#### Demonstration:

**Navigate to Dashboard → Asset Health Overview**

**"Our ML models analyze this converged data to predict failures 2-4 weeks in advance."**

**Show Heat Map:**
- Most assets green (healthy)
- Several yellow (medium risk)
- One red marker in Palm Beach County

**"Let me show you a real example from this morning's analysis."**

**Click on Red Marker → Asset Detail Page for T-SS047-001**

---

### **Featured Asset: Transformer T-SS047-001**

**Asset Profile:**
```
Location: West Palm Beach Substation
Type: Power Transformer, 25 MVA
Age: 18 years (of 25-year expected life)
Customers Served: 12,500
Critical Business Asset: 92/100
```

**Current Risk Assessment:**
```
┌─────────────────────────────┐
│  RISK SCORE: 89/100         │
│  ⚠️ CRITICAL - IMMEDIATE    │
│  ACTION REQUIRED            │
└─────────────────────────────┘

Failure Probability: 89%
Predicted Failure Window: 21 days
Model Confidence: 87%
```

**"What triggered this alert?"**

**Show Sensor Trend Charts:**

1. **Oil Temperature:**
   - Normal range: 70-80°C
   - 14 days ago: 85°C
   - Today: 92°C
   - Trend: +0.5°C per day

2. **Dissolved Hydrogen (H2):**
   - Normal range: <100 ppm
   - 30 days ago: 150 ppm
   - Today: 320 ppm
   - Indication: Possible arcing or overheating

3. **Load Factor:**
   - Operating at 87% capacity
   - Frequent peaks above 90%
   - Higher thermal stress

4. **Ambient Conditions:**
   - Recent heat wave
   - 5°C above historical average

**"Our AI models detected this pattern and flagged it before any alarms in the SCADA system."**

---

### **Part 4: Explainability & Root Cause (2 minutes)**

**Navigate to → Model Insights Tab**

**Show Feature Importance Chart:**

```
Top Contributing Factors to Risk Score:
1. Oil Temperature Trend      ████████████████████ 35%
2. Dissolved H2 Level          ███████████████ 28%
3. Load Utilization            ██████████ 18%
4. Days Since Maintenance      ████████ 12%
5. Ambient Temperature         ████ 7%
```

**"This isn't a black box. We can see exactly what's driving the prediction."**

**Show Historical Comparison:**
- Compare current sensor patterns to previous failure cases
- Highlight similarity to transformer that failed 3 months ago
- That failure resulted in 6.5-hour outage affecting 11,200 customers

---

### **Part 5: Prescriptive Action & Impact (3 minutes)**

**Navigate to → Recommended Actions Tab**

**Work Order Generated Automatically:**

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
MAINTENANCE WORK ORDER #WO-2025-11847
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Asset: T-SS047-001 (West Palm Beach)
Priority: CRITICAL (within 14 days)

Recommended Actions:
✓ Immediate oil sampling and dissolved gas analysis
✓ Thermal imaging of bushings and tap changer
✓ Load transfer planning (switch to T-SS047-002)
✓ Schedule maintenance window: Nov 23-24 (weekend)
✓ Standby mobile transformer on-site

Estimated Cost: $45,000 (preventive maintenance)
```

**"Compare this to the alternative..."**

**Show Impact Comparison Table:**

| Scenario | Cost | Outage Duration | Customers | SAIDI Impact |
|----------|------|-----------------|-----------|--------------|
| **Proactive Maintenance** | $45,000 | 0 hours (planned) | 0 | 0.0000 |
| **Reactive Failure** | $475,000 | 4.2 hours (unplanned) | 12,500 | 0.0060 |
| **Net Benefit** | **$430,000 saved** | **4.2 hours prevented** | **12,500 protected** | **0.0060 prevented** |

**"And this is just ONE transformer. We're monitoring 100 in this demo, 5,000+ in production."**

---

### **Part 6: Conversational AI with Snowflake Intelligence (3 minutes)**

**Open Snowflake UI → Navigate to Intelligence Agent**

**"Beyond the dashboard, leadership can ask questions in plain English."**

**Demo Query 1:**
```
User: "Which 5 substations have the highest cumulative risk?"

Agent Response:
1. West Palm Beach - Total Risk: 247 (3 high-risk assets)
2. Miami-Dade Central - Total Risk: 189 (2 high-risk assets)
3. Fort Lauderdale North - Total Risk: 156 (2 high-risk assets)
4. Orlando East - Total Risk: 134 (1 critical asset)
5. Tampa Bay South - Total Risk: 128 (3 medium-risk assets)
```

**Demo Query 2:**
```
User: "What's the total SAIDI impact if all high-risk assets fail this month?"

Agent Response:
Based on current risk scores, if all 12 high-risk assets (score >70) 
fail within 30 days:

- Total customers affected: 87,500
- Estimated total outage hours: 312
- Predicted SAIDI impact: 0.042 points
- This represents 14% of your annual SAIDI budget

Immediate action on top 5 assets can reduce this risk by 68%.
```

**Demo Query 3:**
```
User: "Show me the ROI of this predictive maintenance program"

Agent Response:
Based on 6 months of operation:

Cost Avoidance:
- Prevented failures: 8 transformers
- Emergency repair costs avoided: $3.2M
- Outage costs avoided: $1.8M
- Total benefit: $5.0M

Program Costs:
- Platform costs: $150K
- Implementation: $250K
- Operations: $100K
- Total cost: $500K

Net ROI: 900% or 9:1 return
Payback period: 1.2 months
```

**"This is the power of conversational AI - insights without needing data analysts."**

---

### **Part 7: Wrap-Up & Business Case (2 minutes)**

**Navigate back to Dashboard → ROI Summary**

**"Let me summarize the value proposition:"**

**Strategic Benefits:**
1. **Reliability Leadership**
   - 40% reduction in unplanned outages
   - Direct SAIDI/SAIFI improvement
   - Stronger PSC regulatory position

2. **Financial Impact**
   - $25M+ annual cost avoidance (proven at FPL gas turbines)
   - 30-40% maintenance cost reduction
   - Extended asset life (5-7 additional years)

3. **Operational Excellence**
   - Proactive vs. reactive operations
   - Optimized maintenance scheduling
   - Better crew utilization

4. **Technology Leadership**
   - First utility to fully converge IT/OT at scale
   - AI-driven decision making
   - Platform for future innovation

**"This demo covered transformers, but the platform extends to:"**
- Circuit breakers and switchgear
- Distribution automation devices
- Underground cables
- Even generation assets

**"Snowflake gives us a unified platform to scale predictive maintenance across all T&D assets."**

---

## Backup Slides / Talking Points

### If Asked: "What about false positives?"

**"Great question. Our current model has:"**
- 87% precision (13% false positive rate)
- 92% recall (catches 92% of actual failures)
- We intentionally bias toward false positives - better safe than sorry
- Cost of false positive: $45K inspection
- Cost of missed failure: $475K + SAIDI impact
- 10:1 cost-benefit ratio favors sensitivity

### If Asked: "How long to deploy in production?"

**"Based on our pilot:"**
- Phase 1 (100 assets): 6 weeks (complete)
- Phase 2 (500 assets): 8 weeks (in progress)
- Full production (5,000+ assets): 6 months
- Already generating positive ROI in Phase 1

### If Asked: "What about cybersecurity?"

**"Snowflake provides enterprise-grade security:"**
- Data encrypted at rest and in transit
- Role-based access control (RBAC)
- No direct connection to operational networks
- Read-only ingestion from SCADA
- Full audit logging
- SOC 2 Type II, HIPAA, PCI DSS compliant

### If Asked: "Integration with existing systems?"

**"Designed for minimal disruption:"**
- Read-only access to SCADA (no control signals)
- Standard REST APIs to work order systems
- Can export recommendations to existing tools
- Dashboard embeddable in other portals
- Gradual rollout by substation/region

---

## Demo Environment URLs

**Streamlit Dashboard:**
```
https://[your-snowflake-account].snowflakecomputing.com/streamlit/UTILITIES_GRID_RELIABILITY
```

**Snowflake Intelligence Agent:**
```
Snowflake UI → Projects → Intelligence → Grid Reliability Agent
```

**Sample SQL for Live Queries:**
```sql
-- Show current high-risk assets
SELECT * FROM ANALYTICS.VW_HIGH_RISK_ASSETS 
ORDER BY RISK_SCORE DESC LIMIT 10;

-- Show prevented failures this month
SELECT COUNT(*), SUM(CUSTOMERS_AFFECTED)
FROM ML.MODEL_PREDICTIONS p
JOIN RAW.ASSET_MASTER a ON p.ASSET_ID = a.ASSET_ID
WHERE p.RISK_SCORE > 85
AND p.PREDICTION_TIMESTAMP >= DATEADD(month, -1, CURRENT_DATE());
```

---

## Post-Demo Follow-Up

**Materials to Provide:**
- [ ] This demo script
- [ ] Architecture documentation
- [ ] ROI calculator spreadsheet
- [ ] Pilot program results
- [ ] Production deployment timeline
- [ ] Cost estimate for full rollout

**Next Steps:**
1. Schedule technical deep-dive with engineering teams
2. PSC briefing on SAIDI/SAIFI impact
3. Budget approval for Phase 2 expansion
4. Vendor partnership formalization (Snowflake)

---

**Demo Script Version**: 1.0  
**Last Updated**: 2025-11-15  
**Owner**: FPL AI/ML Team

**Rehearsal Notes:**
- Practice timing (15-20 min target)
- Test all demo environment components 1 hour before
- Have backup video recording if live demo fails
- Prepare for technical questions on ML algorithms
- Know PSC regulatory context cold


