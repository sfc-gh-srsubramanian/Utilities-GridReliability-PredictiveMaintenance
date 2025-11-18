# 🔧 Column Name Corrections

## Quick Reference: Use These Correct Names

### ❌ WRONG → ✅ CORRECT

| Context | Wrong Name | Correct Name |
|---------|-----------|--------------|
| **Predictions Table** | `ML.PREDICTIONS` | `ML.MODEL_PREDICTIONS` |
| **Risk Level** | `RISK_CATEGORY` | `ALERT_LEVEL` |
| **Maintenance Finding** | `FINDING` | `DOCUMENT_TEXT` |
| **Asset Name** | `ASSET_NAME` | `LOCATION_SUBSTATION` (for location) |

---

## ✅ Corrected Example Queries

### Example 1: High-Risk Assets with Maintenance History

```sql
SELECT 
    a.ASSET_ID,
    a.LOCATION_SUBSTATION AS SUBSTATION_NAME,
    a.ASSET_TYPE,
    
    -- ML Predictions (correct table and columns)
    mp.FAILURE_PROBABILITY,
    mp.PREDICTED_RUL_DAYS,
    mp.ALERT_LEVEL AS RISK_CATEGORY,  -- ✅ Correct: ALERT_LEVEL
    
    -- Maintenance Logs
    m.DOCUMENT_DATE AS LAST_MAINTENANCE_DOC,
    m.DOCUMENT_TEXT AS FINDING,  -- ✅ Correct: DOCUMENT_TEXT
    m.SEVERITY_LEVEL AS MAINT_SEVERITY

FROM RAW.ASSET_MASTER a
JOIN ML.MODEL_PREDICTIONS mp  -- ✅ Correct: MODEL_PREDICTIONS
    ON a.ASSET_ID = mp.ASSET_ID
JOIN UNSTRUCTURED.MAINTENANCE_LOG_DOCUMENTS m 
    ON a.ASSET_ID = m.ASSET_ID

WHERE mp.ALERT_LEVEL IN ('HIGH', 'CRITICAL')  -- ✅ Correct: ALERT_LEVEL
  AND m.SEVERITY_LEVEL IN ('HIGH', 'CRITICAL')
  
ORDER BY mp.FAILURE_PROBABILITY DESC
LIMIT 20;
```

---

### Example 2: Sensor Alerts + CV Detections

```sql
SELECT 
    a.ASSET_ID,
    a.LOCATION_SUBSTATION AS SUBSTATION,  -- ✅ Correct column
    a.ASSET_TYPE,
    
    -- Sensor data (correct columns)
    sr.OIL_TEMPERATURE_C,  -- ✅ Correct: OIL_TEMPERATURE_C (not OIL_TEMP_C)
    sr.LOAD_CURRENT_A,
    sr.VIBRATION_MM_S,
    
    -- CV Detections (correct columns)
    cv.DETECTION_TYPE,
    cv.SEVERITY_LEVEL,
    cv.CONFIDENCE_SCORE,
    cv.DETECTED_AT_COMPONENT,
    cv.REQUIRES_IMMEDIATE_ACTION

FROM RAW.ASSET_MASTER a
JOIN RAW.SENSOR_READINGS sr 
    ON a.ASSET_ID = sr.ASSET_ID
JOIN UNSTRUCTURED.VISUAL_INSPECTIONS vi 
    ON a.ASSET_ID = vi.ASSET_ID
JOIN UNSTRUCTURED.CV_DETECTIONS cv 
    ON vi.INSPECTION_ID = cv.INSPECTION_ID

WHERE sr.OIL_TEMPERATURE_C > 80  -- ✅ Correct column name
  AND cv.REQUIRES_IMMEDIATE_ACTION = TRUE
  
ORDER BY sr.OIL_TEMPERATURE_C DESC
LIMIT 20;
```

---

## 📋 Complete Column Reference

### RAW.ASSET_MASTER
- ✅ `ASSET_ID` (primary key)
- ✅ `LOCATION_SUBSTATION` (not ASSET_NAME or SUBSTATION_NAME)
- ✅ `ASSET_TYPE`
- ✅ `MANUFACTURER`
- ✅ `CRITICALITY_SCORE`
- ✅ `CUSTOMERS_AFFECTED`

### RAW.SENSOR_READINGS
- ✅ `ASSET_ID`
- ✅ `READING_TIMESTAMP`
- ✅ `OIL_TEMPERATURE_C` (not OIL_TEMP_C)
- ✅ `LOAD_CURRENT_A`
- ✅ `VIBRATION_MM_S`
- ✅ `ACOUSTIC_DB`

### ML.MODEL_PREDICTIONS (not ML.PREDICTIONS)
- ✅ `ASSET_ID`
- ✅ `FAILURE_PROBABILITY`
- ✅ `PREDICTED_RUL_DAYS`
- ✅ `ALERT_LEVEL` (not RISK_CATEGORY)
- ✅ `ANOMALY_SCORE`
- ✅ `RISK_SCORE`

### UNSTRUCTURED.MAINTENANCE_LOG_DOCUMENTS
- ✅ `DOCUMENT_ID`
- ✅ `ASSET_ID`
- ✅ `DOCUMENT_TEXT` (not FINDING)
- ✅ `SEVERITY_LEVEL`
- ✅ `DOCUMENT_DATE`
- ✅ `TECHNICIAN_NAME`

### UNSTRUCTURED.CV_DETECTIONS
- ✅ `DETECTION_ID`
- ✅ `ASSET_ID`
- ✅ `DETECTION_TYPE`
- ✅ `SEVERITY_LEVEL`
- ✅ `CONFIDENCE_SCORE`
- ✅ `REQUIRES_IMMEDIATE_ACTION`
- ✅ `DETECTED_AT_COMPONENT`

---

## 🎯 Use This Instead

**For all validated, working queries:**
👉 **Open `VALIDATED_INTEGRATION_QUERIES.sql`**

This file contains 10 ready-to-run queries with:
- ✅ All correct table names
- ✅ All correct column names
- ✅ Tested and validated against your actual schema
- ✅ Comments explaining each query

---

## 🔍 Quick Validation Test

Run this to confirm your integration is working:

```sql
USE DATABASE UTILITIES_GRID_RELIABILITY;
USE WAREHOUSE GRID_RELIABILITY_WH;

-- Test: Join all data sources
SELECT 
    a.ASSET_ID,
    a.LOCATION_SUBSTATION,
    COUNT(DISTINCT sr.READING_ID) AS SENSOR_READINGS,
    COUNT(DISTINCT m.DOCUMENT_ID) AS MAINTENANCE_LOGS,
    COUNT(DISTINCT vi.INSPECTION_ID) AS INSPECTIONS
FROM RAW.ASSET_MASTER a
LEFT JOIN RAW.SENSOR_READINGS sr ON a.ASSET_ID = sr.ASSET_ID
LEFT JOIN UNSTRUCTURED.MAINTENANCE_LOG_DOCUMENTS m ON a.ASSET_ID = m.ASSET_ID
LEFT JOIN UNSTRUCTURED.VISUAL_INSPECTIONS vi ON a.ASSET_ID = vi.ASSET_ID
GROUP BY 1,2
HAVING COUNT(DISTINCT m.DOCUMENT_ID) > 0
LIMIT 10;
```

**Expected:** Should return 10 assets with sensor readings, maintenance logs, and inspections.

---

✅ **All corrections applied in `VALIDATED_INTEGRATION_QUERIES.sql`**

