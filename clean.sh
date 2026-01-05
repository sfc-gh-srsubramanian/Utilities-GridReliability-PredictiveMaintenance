#!/bin/bash

##############################################################################
# Grid Reliability & Predictive Maintenance - Cleanup Script
##############################################################################
# This script removes the deployed platform from Snowflake
# WARNING: This will delete all data and objects!
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
FORCE=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -c|--connection)
            CONNECTION="$2"
            shift 2
            ;;
        --force)
            FORCE=true
            shift
            ;;
        --prefix)
            PREFIX="$2"
            DATABASE="${PREFIX}_${DATABASE}"
            WAREHOUSE="${PREFIX}_${WAREHOUSE}"
            shift 2
            ;;
        -h|--help)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  -c, --connection NAME  Use specific connection (default: default)"
            echo "  --prefix PREFIX        Match prefix used during deployment"
            echo "  --force                Skip confirmation prompt"
            echo "  -h, --help            Show this help message"
            echo ""
            echo "Examples:"
            echo "  $0                     # Clean with confirmation"
            echo "  $0 --force             # Clean without confirmation"
            echo "  $0 --prefix DEV        # Clean DEV deployment"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Check for SQL command
if command -v snow &> /dev/null; then
    SQL_CMD="snow sql"
elif command -v snowsql &> /dev/null; then
    SQL_CMD="snowsql"
else
    echo -e "${RED}✗ Error: Neither 'snow' nor 'snowsql' command found${NC}"
    exit 1
fi

echo -e "${RED}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${RED}║              ⚠️  WARNING: CLEANUP OPERATION                    ║${NC}"
echo -e "${RED}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}This will DELETE the following:${NC}"
echo -e "  • Database: ${RED}${DATABASE}${NC}"
echo -e "  • Warehouse: ${RED}${WAREHOUSE}${NC}"
echo -e "  • All data and objects within"
echo ""

if [ "$FORCE" = false ]; then
    read -p "Are you sure you want to continue? (type 'YES' to confirm): " CONFIRM
    if [ "$CONFIRM" != "YES" ]; then
        echo -e "${YELLOW}Cleanup cancelled${NC}"
        exit 0
    fi
fi

echo ""
echo -e "${BLUE}Starting cleanup...${NC}"
echo ""

# Execute cleanup
CLEANUP_SQL="
-- Drop agents if they exist
USE DATABASE ${DATABASE};
DROP AGENT IF EXISTS ANALYTICS.GRID_INTELLIGENCE_AGENT;

-- Drop database
DROP DATABASE IF EXISTS ${DATABASE};

-- Drop warehouse
DROP WAREHOUSE IF EXISTS ${WAREHOUSE};
"

if [ "$SQL_CMD" = "snow sql" ]; then
    echo "$CLEANUP_SQL" | snow sql -c "$CONNECTION"
else
    echo "$CLEANUP_SQL" | snowsql -c "$CONNECTION"
fi

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║              ✓ CLEANUP COMPLETED                               ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}All resources have been removed from Snowflake${NC}"
echo ""
echo -e "To redeploy: ${YELLOW}./deploy.sh${NC}"
echo ""

