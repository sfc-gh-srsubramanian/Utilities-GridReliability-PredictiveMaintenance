# 🔗 Unstructured Data Integration Guide

## 📊 Current Status Summary

### ✅ **COMPLETED** (100% via MCP)
1. **Schema & Infrastructure**
   - `UNSTRUCTURED` schema created
   - All stages configured (`MAINTENANCE_DOCS_STAGE`, `TECHNICAL_MANUALS_STAGE`, `VISUAL_INSPECTION_STAGE`)
   - All tables created (4 tables with proper relationships)
   - Enriched features view for ML integration

2. **Data Generation & Loading**
   - 80 Maintenance Log records loaded
   - 15 Technical Manual records loaded
   - 150 Visual Inspection records loaded
   - 281 CV Detection records loaded
   - **Total: 526 records**

3. **Documentation**
   - Architecture diagrams
   - Data dictionaries
   - Load completion summaries

---

## 🔧 **REMAINING** (2 Steps - Manual Execution Required)

### **Step 1: Setup Cortex Search** 🔍
**File**: `unstructured/setup_cortex_search.sql`  
**Estimated Time**: 5 minutes  
**Method**: Run in Snowsight

**What it does**:
- Creates search indexes on maintenance logs and technical manuals
- Enables semantic (meaning-based) search capabilities
- Powers the Intelligence Agent's document search

**Why Manual?**: Cortex Search service creation requires runtime indexing and uses special syntax not supported by MCP batch execution.

**How to Execute**:
```sql
-- In Snowsight, run the entire setup_cortex_search.sql file
-- It will create 2 Cortex Search services:
-- 1. MAINTENANCE_LOGS_SEARCH
-- 2. TECHNICAL_MANUALS_SEARCH
```

---

### **Step 2: Update Intelligence Agent** 🤖
**File**: `unstructured/update_intelligence_agent.sql`  
**Estimated Time**: 2 minutes  
**Method**: Run in Snowsight

**What it does**:
- Adds search tools to the existing `GRID_RELIABILITY_INTELLIGENCE` agent
- Enables the agent to query unstructured documents
- Combines structured sensor data with unstructured maintenance logs

**Why Manual?**: The `ALTER CORTEX SEARCH SERVICE` command requires the search services from Step 1 to exist first.

**How to Execute**:
```sql
-- In Snowsight, after Step 1 is complete, run:
-- unstructured/update_intelligence_agent.sql
```

---

## 🔗 **How Unstructured Data Integrates with Existing System**

### **Integration Points**

The unstructured data connects to your existing system through **ASSET_ID** as the primary join key:

```
EXISTING STRUCTURED DATA          NEW UNSTRUCTURED DATA
├── ASSET_MASTER                  ├── MAINTENANCE_LOG_DOCUMENTS
│   └── ASSET_ID (PK) ──────────────└── ASSET_ID (FK)
├── SENSOR_READINGS               ├── VISUAL_INSPECTIONS
│   └── ASSET_ID (FK) ──────────────└── ASSET_ID (FK)
├── MAINTENANCE_HISTORY           └── CV_DETECTIONS
│   └── ASSET_ID (FK)                 └── ASSET_ID (FK via INSPECTION_ID)
└── PREDICTIONS
    └── ASSET_ID (FK)
```

---

## 💡 **Practical Integration Examples**

### **Example 1: Combine Sensor Alerts with Maintenance History**
```sql
-- Find assets with high temperature AND documented oil leak history
SELECT 
    a.ASSET_ID,
    a.ASSET_NAME,
    s.OIL_TEMP_C AS CURRENT_TEMP,
    m.FINDING AS HISTORICAL_FINDING,
    m.DOCUMENT_DATE,
    m.SEVERITY_LEVEL
FROM RAW.ASSET_MASTER a
JOIN RAW.SENSOR_READINGS s 
    ON a.ASSET_ID = s.ASSET_ID
JOIN UNSTRUCTURED.MAINTENANCE_LOG_DOCUMENTS m 
    ON a.ASSET_ID = m.ASSET_ID
WHERE s.OIL_TEMP_C > 80
  AND LOWER(m.FINDING) LIKE '%oil%leak%'
  AND s.READING_TIMESTAMP >= DATEADD(day, -7, CURRENT_TIMESTAMP())
ORDER BY s.OIL_TEMP_C DESC;
```

---

### **Example 2: Enrich Predictions with CV Detections**
```sql
-- Join ML predictions with visual inspection detections
SELECT 
    p.ASSET_ID,
    p.FAILURE_PROBABILITY,
    p.PREDICTED_RUL_DAYS,
    p.RISK_CATEGORY,
    vi.INSPECTION_TYPE,
    vi.INSPECTION_DATE,
    cv.DETECTION_TYPE,
    cv.SEVERITY_LEVEL,
    cv.CONFIDENCE_SCORE,
    cv.DETECTED_AT_COMPONENT,
    cv.DESCRIPTION
FROM ML.PREDICTIONS p
JOIN UNSTRUCTURED.VISUAL_INSPECTIONS vi 
    ON p.ASSET_ID = vi.ASSET_ID
JOIN UNSTRUCTURED.CV_DETECTIONS cv 
    ON vi.INSPECTION_ID = cv.INSPECTION_ID
WHERE p.RISK_CATEGORY IN ('HIGH', 'CRITICAL')
  AND cv.REQUIRES_IMMEDIATE_ACTION = TRUE
ORDER BY p.FAILURE_PROBABILITY DESC, cv.CONFIDENCE_SCORE DESC;
```

---

### **Example 3: Asset Health Dashboard with All Data Sources**
```sql
-- Comprehensive asset health view combining structured + unstructured
CREATE OR REPLACE VIEW ANALYTICS.VW_COMPREHENSIVE_ASSET_HEALTH AS
SELECT 
    a.ASSET_ID,
    a.ASSET_NAME,
    a.EQUIPMENT_TYPE,
    a.SUBSTATION_NAME,
    
    -- Structured: Latest sensor data
    sr.OIL_TEMP_C AS LATEST_OIL_TEMP,
    sr.LOAD_CURRENT_A AS LATEST_LOAD,
    sr.VIBRATION_MM_S AS LATEST_VIBRATION,
    sr.READING_TIMESTAMP AS LAST_SENSOR_READING,
    
    -- Structured: ML predictions
    p.FAILURE_PROBABILITY,
    p.PREDICTED_RUL_DAYS,
    p.RISK_CATEGORY,
    
    -- Unstructured: Maintenance log summary
    (SELECT COUNT(*) 
     FROM UNSTRUCTURED.MAINTENANCE_LOG_DOCUMENTS m 
     WHERE m.ASSET_ID = a.ASSET_ID 
       AND m.SEVERITY_LEVEL IN ('HIGH', 'CRITICAL')
       AND m.DOCUMENT_DATE >= DATEADD(month, -6, CURRENT_TIMESTAMP())
    ) AS CRITICAL_MAINTENANCE_EVENTS_6M,
    
    -- Unstructured: Latest visual inspection
    (SELECT MAX(INSPECTION_DATE) 
     FROM UNSTRUCTURED.VISUAL_INSPECTIONS vi 
     WHERE vi.ASSET_ID = a.ASSET_ID
    ) AS LAST_VISUAL_INSPECTION,
    
    -- Unstructured: CV detection summary
    (SELECT COUNT(*) 
     FROM UNSTRUCTURED.VISUAL_INSPECTIONS vi
     JOIN UNSTRUCTURED.CV_DETECTIONS cv ON vi.INSPECTION_ID = cv.INSPECTION_ID
     WHERE vi.ASSET_ID = a.ASSET_ID 
       AND cv.SEVERITY_LEVEL = 'CRITICAL'
       AND cv.REQUIRES_IMMEDIATE_ACTION = TRUE
    ) AS CRITICAL_CV_DETECTIONS

FROM RAW.ASSET_MASTER a
LEFT JOIN RAW.SENSOR_READINGS sr 
    ON a.ASSET_ID = sr.ASSET_ID
    AND sr.READING_TIMESTAMP = (
        SELECT MAX(READING_TIMESTAMP) 
        FROM RAW.SENSOR_READINGS 
        WHERE ASSET_ID = a.ASSET_ID
    )
LEFT JOIN ML.PREDICTIONS p 
    ON a.ASSET_ID = p.ASSET_ID
    AND p.PREDICTION_TIMESTAMP = (
        SELECT MAX(PREDICTION_TIMESTAMP) 
        FROM ML.PREDICTIONS 
        WHERE ASSET_ID = a.ASSET_ID
    );
```

---

### **Example 4: NLP Feature Extraction for ML**
```sql
-- Extract text features from maintenance logs to enrich ML training data
SELECT 
    m.ASSET_ID,
    m.DOCUMENT_DATE,
    
    -- NLP Feature: Extract keywords using Cortex
    SNOWFLAKE.CORTEX.COMPLETE(
        'mistral-large',
        CONCAT('Extract key failure indicators from this maintenance report: ', m.FINDING)
    ) AS EXTRACTED_FAILURE_INDICATORS,
    
    -- Text-based features
    CASE 
        WHEN LOWER(m.FINDING) LIKE '%oil%leak%' THEN 1 ELSE 0 
    END AS HAS_OIL_LEAK_MENTION,
    
    CASE 
        WHEN LOWER(m.FINDING) LIKE '%corrosion%' THEN 1 ELSE 0 
    END AS HAS_CORROSION_MENTION,
    
    CASE 
        WHEN LOWER(m.FINDING) LIKE '%overheating%' OR LOWER(m.FINDING) LIKE '%hot%' THEN 1 ELSE 0 
    END AS HAS_THERMAL_ISSUE_MENTION,
    
    m.SEVERITY_LEVEL,
    m.CORRECTIVE_ACTION_REQUIRED
    
FROM UNSTRUCTURED.MAINTENANCE_LOG_DOCUMENTS m
WHERE m.DOCUMENT_DATE >= DATEADD(year, -2, CURRENT_TIMESTAMP());
```

---

### **Example 5: Intelligence Agent Query Examples**

Once you complete **Step 1** (Cortex Search) and **Step 2** (Agent Update), you can ask:

**Structured + Unstructured Queries**:
```
Q: "Show me all transformers with high failure probability that also 
    have maintenance reports mentioning oil leaks in the past 6 months"

Q: "Which assets have both thermal sensor anomalies AND thermal hotspot 
    detections from visual inspections?"

Q: "Find all critical visual inspection findings for assets in Miami 
    substations with predicted RUL < 30 days"
```

**Pure Unstructured Queries**:
```
Q: "What does the technical manual say about transformer cooling systems?"

Q: "Find all maintenance reports where the technician recommended 
    immediate replacement"

Q: "Show me visual inspections with corrosion detections on radiators"
```

---

## 🎯 **How to Use the Intelligence Agent**

### **Before Steps 1 & 2** (Current State):
Your agent can query:
- ✅ Structured sensor data
- ✅ Asset master data
- ✅ ML predictions
- ✅ Maintenance history (structured fields only)

### **After Steps 1 & 2** (Enhanced State):
Your agent can query:
- ✅ Everything above, PLUS:
- ✅ Semantic search over maintenance log text
- ✅ Semantic search over technical manuals
- ✅ Visual inspection metadata
- ✅ Computer vision detection results
- ✅ **Cross-domain queries** combining all data sources

---

## 📊 **Streamlit Dashboard Integration (Optional)**

Add a new tab to `dashboard/grid_reliability_dashboard.py`:

```python
# New tab: Unstructured Data Explorer
with tabs[3]:  # Assuming tabs[0-2] are existing
    st.header("📄 Unstructured Data Explorer")
    
    # Search Maintenance Logs
    st.subheader("🔍 Search Maintenance Logs")
    search_query = st.text_input("Enter search query:", 
                                  placeholder="e.g., oil leak, overheating, corrosion")
    
    if search_query:
        # Use Cortex Search (after Step 1 is complete)
        results = session.sql(f"""
            SELECT m.ASSET_ID, m.DOCUMENT_DATE, m.TECHNICIAN_NAME,
                   m.FINDING, m.SEVERITY_LEVEL, m.DOCUMENT_PATH
            FROM TABLE(
                SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
                    'MAINTENANCE_LOGS_SEARCH',
                    '{search_query}'
                )
            ) s
            JOIN UNSTRUCTURED.MAINTENANCE_LOG_DOCUMENTS m 
                ON s.document_id = m.DOCUMENT_ID
            LIMIT 10
        """).collect()
        
        st.dataframe(results)
    
    # Visual Inspection Gallery
    st.subheader("📸 Recent Visual Inspections")
    inspections = session.sql("""
        SELECT vi.ASSET_ID, vi.INSPECTION_DATE, vi.INSPECTION_TYPE,
               vi.OVERALL_CONDITION_RATING,
               COUNT(cv.DETECTION_ID) AS DETECTIONS
        FROM UNSTRUCTURED.VISUAL_INSPECTIONS vi
        LEFT JOIN UNSTRUCTURED.CV_DETECTIONS cv 
            ON vi.INSPECTION_ID = cv.INSPECTION_ID
        GROUP BY 1,2,3,4
        ORDER BY vi.INSPECTION_DATE DESC
        LIMIT 20
    """).to_pandas()
    
    st.dataframe(inspections)
```

---

## ✅ **Quick Action Checklist**

### **To Complete Integration (15 minutes total):**

- [ ] **Step 1** (5 min): Run `unstructured/setup_cortex_search.sql` in Snowsight
- [ ] **Step 2** (2 min): Run `unstructured/update_intelligence_agent.sql` in Snowsight  
- [ ] **Step 3** (5 min): Test agent with sample queries (see examples above)
- [ ] **Optional**: Add unstructured data tab to Streamlit dashboard

---

## 🎉 **Summary**

### **What's Working Now**:
- ✅ All 526 unstructured records loaded
- ✅ Schema and tables ready
- ✅ Data accessible via SQL joins with structured data
- ✅ Manual SQL queries work (see examples above)

### **What Needs Completion**:
- 🔧 Cortex Search setup (enables semantic search)
- 🔧 Intelligence Agent update (enables natural language queries)

### **Integration is Ready**:
- ✅ All data joins are functional via `ASSET_ID`
- ✅ You can create integrated views NOW
- ✅ Streamlit dashboard can query NOW
- ✅ Cortex Search is just an enhancement for semantic capabilities

---

**Your unstructured data is fully loaded and integrated at the database level. The remaining 2 steps just add AI-powered search and agent capabilities!** 🚀

