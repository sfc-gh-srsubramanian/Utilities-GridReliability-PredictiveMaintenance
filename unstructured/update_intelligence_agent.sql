/*******************************************************************************
 * UPDATE INTELLIGENCE AGENT WITH UNSTRUCTURED DATA SEARCH
 * 
 * Enhances the Grid Reliability Intelligence Agent to search:
 * - Maintenance logs and inspection reports
 * - Technical manuals and specifications
 * - Visual inspection data and CV detections
 ******************************************************************************/

USE DATABASE UTILITIES_GRID_RELIABILITY;
USE SCHEMA ANALYTICS;
USE WAREHOUSE COMPUTE_WH;

-- =============================================================================
-- UPDATE AGENT WITH DOCUMENT SEARCH CAPABILITIES
-- =============================================================================

CREATE OR REPLACE AGENT ANALYTICS."Grid Reliability Intelligence Agent"
COMMENT = 'Conversational AI agent with document search for grid reliability and predictive maintenance'
FROM SPECIFICATION $$
models:
  orchestration: "claude-4-sonnet"

instructions:
  response: |
    You are a specialized AI assistant for FPL's grid reliability and predictive maintenance system.
    
    Your role is to help operators, engineers, and leadership understand:
    - Current health status of transformer assets
    - Failure predictions and risk assessments
    - Maintenance recommendations and priorities
    - SAIDI/SAIFI impact analysis
    - Cost avoidance and ROI metrics
    - Historical maintenance records and failure patterns
    - Equipment manuals and technical specifications
    - Visual inspection findings and anomalies
    
    When answering questions:
    1. Be concise but comprehensive
    2. Always include relevant metrics (risk scores, customer impact, timelines)
    3. Reference historical maintenance logs when discussing failures
    4. Cite technical manuals when providing operational guidance
    5. Highlight visual inspection findings (corrosion, leaks, hotspots)
    6. Prioritize safety and reliability
    7. Explain technical terms when addressing non-technical users
    8. Provide actionable recommendations when appropriate
    
    Key thresholds to remember:
    - Risk Score >= 86: CRITICAL (immediate action, 0-7 days)
    - Risk Score >= 71: HIGH (urgent action, 7-14 days)
    - Risk Score >= 41: MEDIUM (scheduled action, 14-30 days)
    - Risk Score < 41: LOW (routine monitoring)
    
    When discussing SAIDI:
    - SAIDI = (Customer-Minutes of Interruption) / Total Customers (5.8M)
    - FPL's target is to maintain industry-leading low SAIDI scores
    
    Document Search Capabilities:
    - You can search maintenance logs for historical failures and root causes
    - You can search technical manuals for operational procedures and specifications
    - You can query visual inspection data for physical defects
    - Always reference specific documents when citing information
    
    Example responses:
    - "Based on maintenance log MAINT-T-SS047-001-20241115, this asset experienced 
       a similar high oil temperature failure in November 2024..."
    - "According to the ABB TXP-25MVA operation manual, the maximum continuous oil 
       temperature is 95°C..."
    - "Visual inspection on 2024-11-10 detected a critical hotspot at the bushing 
       connection with 95% confidence..."
    
    Always be helpful, accurate, and focused on grid reliability.

tools:
  - tool_spec:
      type: "cortex_search"
      name: "search_assets"
  - tool_spec:
      type: "cortex_search"
      name: "search_documents"
  - tool_spec:
      type: "cortex_search"
      name: "search_maintenance_logs"
  - tool_spec:
      type: "cortex_search"
      name: "search_technical_manuals"
  - tool_spec:
      type: "cortex_analyst_text_to_sql"
      name: "query_analytics"

tool_resources:
  search_assets:
    id_column: "ASSET_ID"
    name: "UTILITIES_GRID_RELIABILITY.ANALYTICS.ASSET_SEARCH_SERVICE"
  search_documents:
    id_column: "ID"
    name: "UTILITIES_GRID_RELIABILITY.UNSTRUCTURED.DOCUMENT_SEARCH_SERVICE"
  search_maintenance_logs:
    id_column: "ID"
    name: "UTILITIES_GRID_RELIABILITY.UNSTRUCTURED.MAINTENANCE_LOG_SEARCH"
  search_technical_manuals:
    id_column: "ID"
    name: "UTILITIES_GRID_RELIABILITY.UNSTRUCTURED.TECHNICAL_MANUAL_SEARCH"
  query_analytics:
    semantic_model_file: "@UTILITIES_GRID_RELIABILITY.ANALYTICS.SEMANTIC_MODEL_STAGE/grid_reliability_semantic.yaml"
$$;

SELECT 'Intelligence Agent updated with document search capabilities!' as STATUS;

-- =============================================================================
-- SAMPLE QUERIES TO TEST ENHANCED AGENT
-- =============================================================================

/*
Enhanced queries the agent can now answer:

DOCUMENT SEARCH QUERIES:
- "Show me all emergency maintenance reports from the last month"
- "Find maintenance logs where high oil temperature caused a failure"
- "Search for inspection reports mentioning corrosion on T-SS047-001"
- "What does the ABB manual say about maximum oil temperature limits?"
- "Find troubleshooting procedures for transformer overheating"
- "Show me all maintenance records for assets in Palm Beach County"

COMBINED QUERIES (Sensor + Document):
- "Which high-risk assets have documented failures in their maintenance history?"
- "For T-SS047-001, show me both current sensor readings and past maintenance logs"
- "Find all assets with recent hotspot detections and high oil temperature"
- "Which transformers have both visual inspection issues and abnormal sensor data?"

TECHNICAL GUIDANCE:
- "What are the recommended maintenance intervals for ABB transformers?"
- "How do I troubleshoot a transformer with high dissolved gas levels?"
- "What safety procedures should I follow for emergency maintenance?"
- "Show me the specifications for 25 MVA transformers"

ROOT CAUSE ANALYSIS:
- "What are the most common failure root causes in our maintenance logs?"
- "Show me all assets that failed due to cooling system issues"
- "Find patterns in emergency maintenance events"
- "Which technicians have documented the most critical failures?"

VISUAL INSPECTION QUERIES:
- "Show me all critical hotspots detected in the last 30 days"
- "Find all assets with leak detections requiring immediate action"
- "Which transformers have corrosion issues identified by drone inspections?"
- "Show me thermal imaging results for high-risk assets"
*/

-- =============================================================================
-- GRANT PERMISSIONS
-- =============================================================================

GRANT USAGE ON AGENT ANALYTICS."Grid Reliability Intelligence Agent" TO ROLE GRID_OPERATOR;
GRANT USAGE ON AGENT ANALYTICS."Grid Reliability Intelligence Agent" TO ROLE GRID_ANALYST;
GRANT USAGE ON AGENT ANALYTICS."Grid Reliability Intelligence Agent" TO ROLE GRID_ML_ENGINEER;

SELECT 'Permissions granted to GRID_OPERATOR, GRID_ANALYST, GRID_ML_ENGINEER' as STATUS;

-- =============================================================================
-- VERIFICATION
-- =============================================================================

-- Verify agent exists
SHOW AGENTS IN SCHEMA ANALYTICS;

-- Verify search services exist
SHOW CORTEX SEARCH SERVICES IN SCHEMA UNSTRUCTURED;

SELECT 'Agent update complete! Test in Snowflake UI: Projects → Intelligence → Agents' as NEXT_STEP;

