#!/bin/bash
# ========================================================
# FPL Grid Reliability: Automated Sensor Data Load
# ========================================================
# Usage: ./load_sensor_data.sh
# Estimated Time: 10-15 seconds
# ========================================================

set -e  # Exit on error

echo "=========================================="
echo "FPL Grid Reliability - Sensor Data Load"
echo "=========================================="
echo ""

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# Check if generated data exists
if [ ! -d "generated_data" ]; then
    echo "❌ Error: generated_data directory not found"
    echo "   Please run the data generator first:"
    echo "   python3 data/data_generator.py"
    exit 1
fi

# Count JSON files
FILE_COUNT=$(ls generated_data/sensor_readings_batch_*.json 2>/dev/null | wc -l)
if [ "$FILE_COUNT" -eq 0 ]; then
    echo "❌ Error: No sensor data files found"
    echo "   Please run the data generator first:"
    echo "   python3 data/data_generator.py"
    exit 1
fi

echo "✓ Found $FILE_COUNT sensor data files"
echo ""

# Get passphrase from snowsql config
PASSPHRASE=$(grep "private_key_passphrase" ~/.snowsql/config | cut -d'=' -f2 | tr -d ' ')

if [ -z "$PASSPHRASE" ]; then
    echo "❌ Error: Could not find private_key_passphrase in ~/.snowsql/config"
    exit 1
fi

export SNOWSQL_PRIVATE_KEY_PASSPHRASE="$PASSPHRASE"

echo "Step 1: Uploading JSON files to Snowflake stage..."
echo "==========================================="

snowsql -c demo_tools -d UTILITIES_GRID_RELIABILITY -s RAW -o exit_on_error=true -o friendly=false << 'EOF'
-- Create file format and stage
CREATE OR REPLACE FILE FORMAT JSON_FORMAT TYPE = 'JSON' COMPRESSION = 'AUTO' STRIP_OUTER_ARRAY = FALSE;
CREATE OR REPLACE STAGE SENSOR_DATA_STAGE FILE_FORMAT = JSON_FORMAT;

-- Upload files
PUT file://generated_data/sensor_readings_batch_1.json @SENSOR_DATA_STAGE AUTO_COMPRESS=TRUE;
PUT file://generated_data/sensor_readings_batch_2.json @SENSOR_DATA_STAGE AUTO_COMPRESS=TRUE;
PUT file://generated_data/sensor_readings_batch_3.json @SENSOR_DATA_STAGE AUTO_COMPRESS=TRUE;
PUT file://generated_data/sensor_readings_batch_4.json @SENSOR_DATA_STAGE AUTO_COMPRESS=TRUE;

-- List uploaded files
LIST @SENSOR_DATA_STAGE;
EOF

echo ""
echo "Step 2: Loading data into SENSOR_READINGS table..."
echo "==========================================="

snowsql -c demo_tools -d UTILITIES_GRID_RELIABILITY -s RAW -o exit_on_error=true -o friendly=false << 'EOF'
-- Load data using COPY INTO
COPY INTO SENSOR_READINGS (
    ASSET_ID, READING_TIMESTAMP, OIL_TEMPERATURE_C, WINDING_TEMPERATURE_C,
    LOAD_CURRENT_A, LOAD_VOLTAGE_KV, AMBIENT_TEMP_C, HUMIDITY_PCT,
    VIBRATION_MM_S, ACOUSTIC_DB, DISSOLVED_H2_PPM, DISSOLVED_CO_PPM,
    DISSOLVED_CO2_PPM, DISSOLVED_CH4_PPM, BUSHING_TEMP_C, TAP_POSITION,
    PARTIAL_DISCHARGE_PC, POWER_FACTOR
)
FROM (
    SELECT 
        $1:ASSET_ID::VARCHAR(50),
        $1:READING_TIMESTAMP::TIMESTAMP,
        $1:OIL_TEMPERATURE_C::NUMBER(5,2),
        $1:WINDING_TEMPERATURE_C::NUMBER(5,2),
        $1:LOAD_CURRENT_A::NUMBER(10,2),
        $1:LOAD_VOLTAGE_KV::NUMBER(10,2),
        $1:AMBIENT_TEMP_C::NUMBER(5,2),
        $1:HUMIDITY_PCT::NUMBER(5,2),
        $1:VIBRATION_MM_S::NUMBER(8,4),
        $1:ACOUSTIC_DB::NUMBER(5,2),
        $1:DISSOLVED_H2_PPM::NUMBER(10,2),
        $1:DISSOLVED_CO_PPM::NUMBER(10,2),
        $1:DISSOLVED_CO2_PPM::NUMBER(10,2),
        $1:DISSOLVED_CH4_PPM::NUMBER(10,2),
        $1:BUSHING_TEMP_C::NUMBER(5,2),
        $1:TAP_POSITION::NUMBER(3,0),
        $1:PARTIAL_DISCHARGE_PC::NUMBER(8,2),
        $1:POWER_FACTOR::NUMBER(5,4)
    FROM @SENSOR_DATA_STAGE
)
ON_ERROR = 'CONTINUE'
FORCE = TRUE;

-- Verify load
SELECT 
    COUNT(*) AS TOTAL_READINGS,
    COUNT(DISTINCT ASSET_ID) AS UNIQUE_ASSETS,
    MIN(READING_TIMESTAMP) AS EARLIEST_READING,
    MAX(READING_TIMESTAMP) AS LATEST_READING
FROM SENSOR_READINGS;
EOF

echo ""
echo "=========================================="
echo "✅ SENSOR DATA LOAD COMPLETE!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "1. Retrain ML models:"
echo "   snowsql -c demo_tools -d UTILITIES_GRID_RELIABILITY -s ML"
echo "   CALL TRAIN_FAILURE_PREDICTION_MODELS();"
echo ""
echo "2. Generate predictions:"
echo "   CALL SCORE_ASSETS();"
echo ""
echo "3. View results:"
echo "   SELECT * FROM ANALYTICS.VW_HIGH_RISK_ASSETS;"
echo ""

