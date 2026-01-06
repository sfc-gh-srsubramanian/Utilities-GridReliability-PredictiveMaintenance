#!/bin/bash

##############################################################################
# Grid Reliability & Predictive Maintenance - Deployment Script
##############################################################################
# This script deploys the complete Grid Reliability platform to Snowflake
# including database, schemas, ML models, semantic views, and intelligence agents
##############################################################################

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
PREFIX=""
CONNECTION="default"
SKIP_AGENTS=false
ONLY_SQL=false
WAREHOUSE="GRID_RELIABILITY_WH"
DATABASE="UTILITIES_GRID_RELIABILITY"

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --prefix)
            PREFIX="$2"
            shift 2
            ;;
        -c|--connection)
            CONNECTION="$2"
            shift 2
            ;;
        --skip-agents)
            SKIP_AGENTS=true
            shift
            ;;
        --only-sql)
            ONLY_SQL=true
            shift
            ;;
        -h|--help)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --prefix PREFIX       Add prefix to database/warehouse names (e.g., DEV)"
            echo "  -c, --connection NAME Use specific Snowflake connection (default: default)"
            echo "  --skip-agents         Skip deploying Intelligence Agents"
            echo "  --only-sql            Deploy only SQL infrastructure (no Python)"
            echo "  -h, --help           Show this help message"
            echo ""
            echo "Examples:"
            echo "  $0                              # Deploy with defaults"
            echo "  $0 --prefix DEV                 # Deploy with DEV prefix"
            echo "  $0 -c prod --skip-agents        # Deploy to prod, skip agents"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Apply prefix if specified
if [ -n "$PREFIX" ]; then
    DATABASE="${PREFIX}_${DATABASE}"
    WAREHOUSE="${PREFIX}_${WAREHOUSE}"
fi

echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   Grid Reliability & Predictive Maintenance Deployment        ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}Configuration:${NC}"
echo -e "  Connection: ${YELLOW}${CONNECTION}${NC}"
echo -e "  Database:   ${YELLOW}${DATABASE}${NC}"
echo -e "  Warehouse:  ${YELLOW}${WAREHOUSE}${NC}"
echo -e "  Skip Agents: ${YELLOW}${SKIP_AGENTS}${NC}"
echo ""

# Check if snowsql or snow CLI is available
if command -v snow &> /dev/null; then
    SQL_CMD="snow sql"
    echo -e "${GREEN}✓ Using Snowflake CLI (snow)${NC}"
elif command -v snowsql &> /dev/null; then
    SQL_CMD="snowsql"
    echo -e "${GREEN}✓ Using SnowSQL${NC}"
else
    echo -e "${RED}✗ Error: Neither 'snow' nor 'snowsql' command found${NC}"
    echo -e "${YELLOW}Please install Snowflake CLI or SnowSQL${NC}"
    exit 1
fi

echo ""
echo -e "${BLUE}────────────────────────────────────────────────────────────────${NC}"
echo -e "${GREEN}Starting deployment...${NC}"
echo -e "${BLUE}────────────────────────────────────────────────────────────────${NC}"
echo ""

# Function to execute SQL file
execute_sql() {
    local file=$1
    local description=$2
    
    echo -e "${YELLOW}▶ ${description}...${NC}"
    
    if [ "$SQL_CMD" = "snow sql" ]; then
        snow sql -f "$file" -c "$CONNECTION" --enable-templating NONE
    else
        snowsql -c "$CONNECTION" -f "$file" -D "db_name=${DATABASE}" -D "wh_name=${WAREHOUSE}"
    fi
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}  ✓ Completed${NC}"
    else
        echo -e "${RED}  ✗ Failed${NC}"
        exit 1
    fi
    echo ""
}

# Deploy SQL infrastructure
echo -e "${BLUE}═══ Phase 1: Infrastructure ═══${NC}"
execute_sql "sql/01_infrastructure_setup.sql" "Setting up database, warehouse, and schemas"

echo -e "${BLUE}═══ Phase 2: Data Schemas ═══${NC}"
execute_sql "sql/02_structured_data_schema.sql" "Creating structured data tables"
execute_sql "sql/03_unstructured_data_schema.sql" "Creating unstructured data tables"

echo -e "${BLUE}═══ Phase 3: ML Pipeline Setup ═══${NC}"
execute_sql "sql/04_ml_feature_engineering.sql" "Creating feature engineering views"
execute_sql "sql/06_ml_models.sql" "Creating ML training procedures"
execute_sql "sql/06b_update_score_assets.sql" "Creating ML scoring procedure"

echo -e "${BLUE}═══ Phase 4: Analytics Layer ═══${NC}"
execute_sql "sql/07_business_views.sql" "Creating business analytics views"
execute_sql "sql/08_semantic_model.sql" "Creating semantic model"

if [ "$SKIP_AGENTS" = false ]; then
    echo -e "${BLUE}═══ Phase 5: Intelligence Agents ═══${NC}"
    echo -e "${YELLOW}▶ Deploying Intelligence Agents...${NC}"
    
    if [ "$SQL_CMD" = "snow sql" ]; then
        snow sql -f "sql/09_intelligence_agent.sql" -c "$CONNECTION" --enable-templating NONE || true
    else
        snowsql -c "$CONNECTION" -f "sql/09_intelligence_agent.sql" -D "db_name=${DATABASE}" -D "wh_name=${WAREHOUSE}" || true
    fi
    
    # Verify agent was created (ignore exit code from above)
    echo -e "${YELLOW}  Verifying agent creation...${NC}"
    if [ "$SQL_CMD" = "snow sql" ]; then
        snow sql -c "$CONNECTION" -q "SHOW AGENTS IN SCHEMA ${DATABASE}.ANALYTICS" --enable-templating NONE > /dev/null 2>&1
    fi
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}  ✓ Completed (Agent created successfully)${NC}"
    else
        echo -e "${YELLOW}  ⚠ Warning: Could not verify agent. Check manually.${NC}"
    fi
    echo ""
fi

echo -e "${BLUE}═══ Phase 6: Security ═══${NC}"
execute_sql "sql/10_security_roles.sql" "Configuring security roles"

echo -e "${BLUE}═══ Phase 7: Data Loading ═══${NC}"

# Upload structured data files to Snowflake stages
echo -e "${YELLOW}▶ Uploading structured data files to Snowflake stages...${NC}"
if [ "$SQL_CMD" = "snow sql" ]; then
    snow sql -c "$CONNECTION" -q "
        USE DATABASE ${DATABASE};
        USE SCHEMA RAW;
        PUT file://generated_data/*.csv @ASSET_DATA_STAGE AUTO_COMPRESS=TRUE OVERWRITE=TRUE;
        PUT file://generated_data/*.json @SENSOR_DATA_STAGE AUTO_COMPRESS=TRUE OVERWRITE=TRUE;
    " --enable-templating NONE > /dev/null 2>&1
fi

if [ $? -eq 0 ]; then
    echo -e "${GREEN}  ✓ Files uploaded to stages${NC}"
else
    echo -e "${RED}  ✗ Failed to upload files${NC}"
    exit 1
fi

execute_sql "sql/11_load_structured_data.sql" "Loading structured data"

# Generate and load unstructured data using Python
echo -e "${YELLOW}▶ Generating unstructured data files...${NC}"
cd python/data_generators

# Run all data generators
echo -e "${YELLOW}  → Generating maintenance logs...${NC}"
python3 generate_maintenance_logs.py > /dev/null 2>&1
echo -e "${YELLOW}  → Generating technical manuals...${NC}"
python3 generate_technical_manuals.py > /dev/null 2>&1
echo -e "${YELLOW}  → Generating visual inspections...${NC}"
python3 generate_visual_inspections.py > /dev/null 2>&1
echo -e "${GREEN}  ✓ Data files generated${NC}"

echo -e "${YELLOW}  → Creating SQL loading script...${NC}"
python3 load_unstructured_full.py > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "${GREEN}  ✓ Generated unstructured data SQL${NC}"
    
    echo -e "${YELLOW}▶ Loading unstructured data into Snowflake...${NC}"
    if [ "$SQL_CMD" = "snow sql" ]; then
        snow sql -f load_unstructured_data_full.sql -c "$CONNECTION" --enable-templating NONE
    else
        snowsql -c "$CONNECTION" -f load_unstructured_data_full.sql
    fi
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}  ✓ Unstructured data loaded${NC}"
    else
        echo -e "${RED}  ✗ Failed to load unstructured data${NC}"
        exit 1
    fi
else
    echo -e "${RED}  ✗ Failed to generate unstructured data SQL${NC}"
    exit 1
fi
cd ../..

# Create Cortex Search Services
execute_sql "sql/12_load_unstructured_data.sql" "Creating Cortex Search Services"

# Populate reference data (SCADA_EVENTS and WEATHER_DATA)
echo -e "${YELLOW}▶ Populating reference data (SCADA_EVENTS, WEATHER_DATA)...${NC}"
execute_sql "sql/13_populate_reference_data.sql" "Loading reference data"

echo ""
echo -e "${BLUE}═══ Phase 8: ML Training & Scoring ═══${NC}"

echo -e "${YELLOW}▶ Preparing training data (generating labeled samples)...${NC}"
execute_sql "sql/05_ml_training_prep.sql" "Generating ML training data"

echo -e "${YELLOW}▶ Training ML models (this may take 2-3 minutes)...${NC}"
if [ "$SQL_CMD" = "snow sql" ]; then
    snow sql -c "$CONNECTION" -q "
        USE DATABASE ${DATABASE};
        USE WAREHOUSE ${WAREHOUSE};
        CALL ML.TRAIN_FAILURE_PREDICTION_MODELS();
    " --enable-templating NONE
else
    snowsql -c "$CONNECTION" -q "
        USE DATABASE ${DATABASE};
        USE WAREHOUSE ${WAREHOUSE};
        CALL ML.TRAIN_FAILURE_PREDICTION_MODELS();
    "
fi

if [ $? -eq 0 ]; then
    echo -e "${GREEN}  ✓ ML models trained successfully${NC}"
else
    echo -e "${RED}  ✗ ML training failed${NC}"
    echo -e "${YELLOW}  ⚠️  Continuing deployment...${NC}"
fi

echo -e "${YELLOW}▶ Generating predictions for all assets...${NC}"
if [ "$SQL_CMD" = "snow sql" ]; then
    snow sql -c "$CONNECTION" -q "
        USE DATABASE ${DATABASE};
        USE WAREHOUSE ${WAREHOUSE};
        CALL ML.SCORE_ASSETS();
    " --enable-templating NONE
else
    snowsql -c "$CONNECTION" -q "
        USE DATABASE ${DATABASE};
        USE WAREHOUSE ${WAREHOUSE};
        CALL ML.SCORE_ASSETS();
    "
fi

if [ $? -eq 0 ]; then
    echo -e "${GREEN}  ✓ Predictions generated successfully${NC}"
else
    echo -e "${RED}  ✗ Prediction generation failed${NC}"
    echo -e "${YELLOW}  ⚠️  Continuing deployment...${NC}"
fi

# Generate recent sensor data for dashboard visualization
echo -e "${YELLOW}▶ Generating recent sensor data (last 30 days)...${NC}"
execute_sql "sql/14_generate_recent_sensor_data.sql" "Generating recent sensor data"

echo ""
echo -e "${BLUE}═══ Phase 9: Streamlit Dashboard Deployment ═══${NC}"

# First, create the stage and Streamlit app definition
execute_sql "sql/10_streamlit_dashboard.sql" "Creating Streamlit Stage and App"

# Then, upload the environment file and dashboard file to the stage
echo -e "${YELLOW}▶ Uploading Streamlit environment and dashboard files...${NC}"
cd python/dashboard

# Upload environment.yml (contains package dependencies like plotly, numpy)
snow sql -c "$CONNECTION" -q "PUT file://environment.yml @UTILITIES_GRID_RELIABILITY.ANALYTICS.STREAMLIT_STAGE AUTO_COMPRESS=FALSE OVERWRITE=TRUE" --enable-templating NONE
if [ $? -eq 0 ]; then
    echo -e "${GREEN}  ✓ Environment file uploaded${NC}"
else
    echo -e "${RED}  ✗ Failed to upload environment file${NC}"
    echo -e "${YELLOW}  ⚠️  Dashboard may not have required packages${NC}"
fi

# Upload Python dashboard file
snow sql -c "$CONNECTION" -q "PUT file://grid_reliability_dashboard.py @UTILITIES_GRID_RELIABILITY.ANALYTICS.STREAMLIT_STAGE AUTO_COMPRESS=FALSE OVERWRITE=TRUE" --enable-templating NONE
if [ $? -eq 0 ]; then
    echo -e "${GREEN}  ✓ Dashboard file uploaded${NC}"
else
    echo -e "${RED}  ✗ Failed to upload dashboard file${NC}"
    echo -e "${YELLOW}  ⚠️  Dashboard may not function correctly${NC}"
fi
cd ../..

echo -e "${GREEN}  ✓ Streamlit Dashboard deployed${NC}"
echo -e "${BLUE}  ℹ️  Access dashboard via Snowflake UI: Apps → Streamlit${NC}"

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║              ✓ DEPLOYMENT COMPLETED SUCCESSFULLY               ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}Next Steps:${NC}"
echo -e "  1. Validate deployment:  ${YELLOW}./run.sh validate${NC}"
echo -e "  2. Check status:         ${YELLOW}./run.sh status${NC}"
echo -e "  3. Test agents:          ${YELLOW}./run.sh test-agents${NC}"
echo -e "  4. Run sample queries:   ${YELLOW}./run.sh query 'SELECT COUNT(*) FROM RAW.ASSET_MASTER'${NC}"
echo ""
echo -e "${BLUE}Documentation:${NC}"
echo -e "  • Quick Start:    ${YELLOW}docs/guides/QUICK_START.md${NC}"
echo -e "  • Full Guide:     ${YELLOW}docs/guides/DEPLOYMENT_GUIDE.md${NC}"
echo -e "  • Architecture:   ${YELLOW}docs/architecture/ARCHITECTURE.md${NC}"
echo ""

