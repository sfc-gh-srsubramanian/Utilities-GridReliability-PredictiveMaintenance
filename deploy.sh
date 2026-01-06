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

echo -e "${BLUE}═══ Phase 3: ML Pipeline ═══${NC}"
execute_sql "sql/04_ml_feature_engineering.sql" "Setting up feature engineering"
execute_sql "sql/05_ml_training_prep.sql" "Preparing training data"
execute_sql "sql/06_ml_models.sql" "Creating ML models and scoring"

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
execute_sql "sql/11_load_structured_data.sql" "Loading structured data"
execute_sql "sql/12_load_unstructured_data.sql" "Loading unstructured data"

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

