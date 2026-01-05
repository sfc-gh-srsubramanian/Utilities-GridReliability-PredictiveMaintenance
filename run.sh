#!/bin/bash

##############################################################################
# Grid Reliability & Predictive Maintenance - Runtime Operations
##############################################################################
# This script provides runtime operations for the deployed platform
##############################################################################

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Default values
CONNECTION="default"
DATABASE="UTILITIES_GRID_RELIABILITY"
WAREHOUSE="GRID_RELIABILITY_WH"

# Check for SQL command
if command -v snow &> /dev/null; then
    SQL_CMD="snow sql"
elif command -v snowsql &> /dev/null; then
    SQL_CMD="snowsql"
else
    echo -e "${RED}✗ Error: Neither 'snow' nor 'snowsql' command found${NC}"
    exit 1
fi

# Function to execute SQL
exec_sql() {
    local sql="$1"
    if [ "$SQL_CMD" = "snow sql" ]; then
        echo "$sql" | snow sql -c "$CONNECTION" -D "database=${DATABASE}" -D "warehouse=${WAREHOUSE}"
    else
        echo "$sql" | snowsql -c "$CONNECTION" -d "$DATABASE" -w "$WAREHOUSE"
    fi
}

# Function to execute SQL file
exec_sql_file() {
    local file="$1"
    if [ "$SQL_CMD" = "snow sql" ]; then
        snow sql -f "$file" -c "$CONNECTION" -D "database=${DATABASE}" -D "warehouse=${WAREHOUSE}"
    else
        snowsql -c "$CONNECTION" -d "$DATABASE" -w "$WAREHOUSE" -f "$file"
    fi
}

# Show usage
show_usage() {
    echo -e "${BLUE}Grid Reliability - Runtime Operations${NC}"
    echo ""
    echo "Usage: $0 [COMMAND] [OPTIONS]"
    echo ""
    echo "Commands:"
    echo "  ${GREEN}status${NC}              Check deployment status and row counts"
    echo "  ${GREEN}validate${NC}            Run validation queries"
    echo "  ${GREEN}query${NC} 'SQL'         Execute custom SQL query"
    echo "  ${GREEN}test-agents${NC}         Test Intelligence Agents"
    echo "  ${GREEN}generate-data${NC}       Regenerate sample data"
    echo "  ${GREEN}sample-queries${NC}      Run sample integration queries"
    echo "  ${GREEN}help${NC}                Show this help message"
    echo ""
    echo "Options:"
    echo "  -c, --connection NAME  Use specific connection (default: default)"
    echo ""
    echo "Examples:"
    echo "  $0 status"
    echo "  $0 query 'SELECT COUNT(*) FROM RAW.ASSET_MASTER'"
    echo "  $0 test-agents"
    echo "  $0 validate -c prod"
}

# Check status
check_status() {
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║            Grid Reliability - Deployment Status               ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    echo -e "${YELLOW}Checking infrastructure...${NC}"
    exec_sql "
    USE DATABASE ${DATABASE};
    SHOW SCHEMAS;
    "
    echo ""
    
    echo -e "${YELLOW}Checking data counts...${NC}"
    exec_sql "
    USE DATABASE ${DATABASE};
    SELECT 'ASSET_MASTER' AS TABLE_NAME, COUNT(*) AS ROW_COUNT FROM RAW.ASSET_MASTER
    UNION ALL
    SELECT 'SENSOR_READINGS', COUNT(*) FROM RAW.SENSOR_READINGS
    UNION ALL
    SELECT 'MAINTENANCE_HISTORY', COUNT(*) FROM RAW.MAINTENANCE_HISTORY
    UNION ALL
    SELECT 'MAINTENANCE_LOGS', COUNT(*) FROM UNSTRUCTURED.MAINTENANCE_LOG_DOCUMENTS
    UNION ALL
    SELECT 'TECHNICAL_MANUALS', COUNT(*) FROM UNSTRUCTURED.TECHNICAL_MANUALS
    UNION ALL
    SELECT 'VISUAL_INSPECTIONS', COUNT(*) FROM UNSTRUCTURED.VISUAL_INSPECTION_RECORDS
    UNION ALL
    SELECT 'CV_DETECTIONS', COUNT(*) FROM UNSTRUCTURED.CV_DETECTIONS
    UNION ALL
    SELECT 'MODEL_PREDICTIONS', COUNT(*) FROM ML.MODEL_PREDICTIONS;
    "
    echo ""
    
    echo -e "${GREEN}✓ Status check complete${NC}"
}

# Run validation queries
run_validation() {
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║              Running Validation Queries                        ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    if [ -f "sql/99_sample_queries.sql" ]; then
        exec_sql_file "sql/99_sample_queries.sql"
    else
        echo -e "${YELLOW}No validation queries file found${NC}"
    fi
    
    echo -e "${GREEN}✓ Validation complete${NC}"
}

# Test agents
test_agents() {
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║            Testing Intelligence Agents                         ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    echo -e "${YELLOW}Checking for Intelligence Agents...${NC}"
    exec_sql "
    USE DATABASE ${DATABASE};
    SHOW AGENTS IN SCHEMA ANALYTICS;
    "
    echo ""
    
    echo -e "${GREEN}✓ Agent check complete${NC}"
    echo -e "${YELLOW}To interact with agents, use Snowsight UI or Snowflake Cortex${NC}"
}

# Run sample queries
run_sample_queries() {
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║              Running Sample Queries                            ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    if [ -f "sql/99_sample_queries.sql" ]; then
        exec_sql_file "sql/99_sample_queries.sql"
    else
        echo -e "${YELLOW}No sample queries file found${NC}"
    fi
    
    echo -e "${GREEN}✓ Sample queries complete${NC}"
}

# Generate data
generate_data() {
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║              Generating Sample Data                            ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    echo -e "${YELLOW}Running data generators...${NC}"
    python3 python/data_generators/generate_asset_data.py
    python3 python/data_generators/generate_sensor_data.py
    
    echo -e "${GREEN}✓ Data generation complete${NC}"
}

# Execute custom query
execute_query() {
    local query="$1"
    echo -e "${BLUE}Executing query...${NC}"
    echo ""
    exec_sql "USE DATABASE ${DATABASE}; ${query};"
    echo ""
    echo -e "${GREEN}✓ Query complete${NC}"
}

# Main command dispatcher
COMMAND="$1"
shift || true

# Parse options
while [[ $# -gt 0 ]]; do
    case $1 in
        -c|--connection)
            CONNECTION="$2"
            shift 2
            ;;
        *)
            break
            ;;
    esac
done

# Execute command
case "$COMMAND" in
    status)
        check_status
        ;;
    validate)
        run_validation
        ;;
    query)
        if [ -z "$1" ]; then
            echo -e "${RED}Error: Query string required${NC}"
            echo "Usage: $0 query 'SELECT * FROM ...'"
            exit 1
        fi
        execute_query "$1"
        ;;
    test-agents)
        test_agents
        ;;
    generate-data)
        generate_data
        ;;
    sample-queries)
        run_sample_queries
        ;;
    help|--help|-h|"")
        show_usage
        ;;
    *)
        echo -e "${RED}Unknown command: $COMMAND${NC}"
        echo ""
        show_usage
        exit 1
        ;;
esac

