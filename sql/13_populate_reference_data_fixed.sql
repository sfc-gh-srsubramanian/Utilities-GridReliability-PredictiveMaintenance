/*******************************************************************************
 * POPULATE REFERENCE DATA - SCADA_EVENTS & WEATHER_DATA
 *******************************************************************************/

USE DATABASE UTILITIES_GRID_RELIABILITY;
USE WAREHOUSE GRID_RELIABILITY_WH;
USE SCHEMA RAW;

-- ============================================================================
-- POPULATE SCADA_EVENTS  
-- ============================================================================

TRUNCATE TABLE IF EXISTS SCADA_EVENTS;

INSERT INTO SCADA_EVENTS (
    ASSET_ID,
    EVENT_TIMESTAMP,
    EVENT_TYPE,
    EVENT_CODE,
    EVENT_DESCRIPTION,
    SEVERITY,
    ACKNOWLEDGED,
    ACKNOWLEDGED_BY,
    ACKNOWLEDGED_TS
)
WITH asset_list AS (
    SELECT ASSET_ID FROM ASSET_MASTER WHERE STATUS = 'ACTIVE'
),
hourly_sequence AS (
    SELECT DATEADD(hour, -SEQ4(), CURRENT_TIMESTAMP()) as EVENT_TS
    FROM TABLE(GENERATOR(ROWCOUNT => 4320))  -- 180 days * 24 hours
)
SELECT
    al.ASSET_ID,
    hs.EVENT_TS as EVENT_TIMESTAMP,
    CASE UNIFORM(1, 10, RANDOM())
        WHEN 1 THEN 'ALARM'
        WHEN 2 THEN 'WARNING'  
        WHEN 3 THEN 'ERROR'
        ELSE 'INFO'
    END as EVENT_TYPE,
    'EVT-' || LPAD(UNIFORM(100, 999, RANDOM()), 3, '0') as EVENT_CODE,
    CASE UNIFORM(1, 8, RANDOM())
        WHEN 1 THEN 'High oil temperature detected'
        WHEN 2 THEN 'Load exceeding threshold'
        WHEN 3 THEN 'Cooling system performance degraded'
        WHEN 4 THEN 'Bushing temperature elevated'
        WHEN 5 THEN 'H2 concentration increasing'
        WHEN 6 THEN 'Vibration levels abnormal'
        WHEN 7 THEN 'Partial discharge detected'
        ELSE 'Normal operational status'
    END as EVENT_DESCRIPTION,
    UNIFORM(1, 5, RANDOM()) as SEVERITY,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 70 THEN TRUE ELSE FALSE END as ACKNOWLEDGED,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 70 THEN 'OPERATOR-' || LPAD(UNIFORM(1, 15, RANDOM()), 2, '0') ELSE NULL END as ACKNOWLEDGED_BY,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 70 THEN DATEADD(hour, UNIFORM(1, 24, RANDOM()), hs.EVENT_TS) ELSE NULL END as ACKNOWLEDGED_TS
FROM asset_list al
CROSS JOIN hourly_sequence hs
WHERE UNIFORM(0, 100, RANDOM()) < 5  -- 5% of possible combinations
LIMIT 10000;

SELECT 'SCADA_EVENTS loaded: ' || COUNT(*) || ' records' AS STATUS FROM SCADA_EVENTS;

-- ============================================================================
-- POPULATE WEATHER_DATA
-- ============================================================================

TRUNCATE TABLE IF EXISTS WEATHER_DATA;

INSERT INTO WEATHER_DATA (
    ASSET_ID,
    OBSERVATION_TIMESTAMP,
    TEMPERATURE_C,
    HUMIDITY_PCT,
    WIND_SPEED_KMH,
    WIND_DIRECTION_DEG,
    PRECIPITATION_MM,
    ATMOSPHERIC_PRESSURE_HPA,
    CLOUD_COVER_PCT,
    SOLAR_IRRADIANCE_WM2,
    WEATHER_CONDITION,
    LIGHTNING_DETECTED,
    LIGHTNING_DISTANCE_KM,
    SEVERE_WEATHER_ALERT
)
WITH asset_locations AS (
    SELECT ASSET_ID FROM ASSET_MASTER WHERE STATUS = 'ACTIVE'
),
hourly_sequence AS (
    SELECT DATEADD(hour, -SEQ4(), CURRENT_TIMESTAMP()) as OBS_TS
    FROM TABLE(GENERATOR(ROWCOUNT => 4320))  -- 180 days * 24 hours
)
SELECT
    al.ASSET_ID,
    hs.OBS_TS as OBSERVATION_TIMESTAMP,
    
    -- Temperature (Florida climate: 15-35°C range with seasonal/daily variation)
    ROUND(25 + 8 * SIN((MONTH(hs.OBS_TS) - 1) * 3.14159 / 6) + 4 * SIN((HOUR(hs.OBS_TS) - 6) * 3.14159 / 12) + UNIFORM(-3, 3, RANDOM()), 1) as TEMPERATURE_C,
    
    -- Humidity (60-90% range)
    ROUND(75 + 10 * SIN((MONTH(hs.OBS_TS) - 1) * 3.14159 / 6) + UNIFORM(-10, 10, RANDOM()), 1) as HUMIDITY_PCT,
    
    -- Wind speed (0-30 km/h)
    ROUND(10 + 8 * UNIFORM(0, 1, RANDOM()) + UNIFORM(0, 5, RANDOM()), 1) as WIND_SPEED_KMH,
    
    -- Wind direction (0-359 degrees)
    UNIFORM(0, 359, RANDOM()) as WIND_DIRECTION_DEG,
    
    -- Precipitation (most days dry, occasional rain)
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 15 THEN ROUND(UNIFORM(0.1, 20, RANDOM()), 1) ELSE 0 END as PRECIPITATION_MM,
    
    -- Atmospheric pressure (normal range)
    ROUND(1013 + UNIFORM(-10, 10, RANDOM()), 1) as ATMOSPHERIC_PRESSURE_HPA,
    
    -- Cloud cover (0-100%)
    UNIFORM(0, 100, RANDOM()) as CLOUD_COVER_PCT,
    
    -- Solar irradiance (0-1000 W/m²)
    CASE 
        WHEN HOUR(hs.OBS_TS) BETWEEN 6 AND 18 
        THEN ROUND(1000 * SIN((HOUR(hs.OBS_TS) - 6) * 3.14159 / 12) * UNIFORM(0.5, 1.0, RANDOM()), 0)
        ELSE 0
    END as SOLAR_IRRADIANCE_WM2,
    
    -- Weather condition
    CASE UNIFORM(1, 10, RANDOM())
        WHEN 1 THEN 'THUNDERSTORM'
        WHEN 2 THEN 'RAIN'
        WHEN 3 THEN 'RAIN'
        WHEN 4 THEN 'CLOUDY'
        WHEN 5 THEN 'CLOUDY'
        WHEN 6 THEN 'PARTLY_CLOUDY'
        WHEN 7 THEN 'PARTLY_CLOUDY'
        ELSE 'CLEAR'
    END as WEATHER_CONDITION,
    
    -- Lightning (rare)
    CASE WHEN UNIFORM(0, 1000, RANDOM()) < 3 THEN TRUE ELSE FALSE END as LIGHTNING_DETECTED,
    
    -- Lightning distance
    CASE WHEN UNIFORM(0, 1000, RANDOM()) < 3 THEN ROUND(UNIFORM(0.5, 25, RANDOM()), 1) ELSE NULL END as LIGHTNING_DISTANCE_KM,
    
    -- Severe weather alert (very rare)
    CASE WHEN UNIFORM(0, 10000, RANDOM()) < 5 THEN TRUE ELSE FALSE END as SEVERE_WEATHER_ALERT

FROM asset_locations al
CROSS JOIN hourly_sequence hs
WHERE UNIFORM(0, 100, RANDOM()) < 3  -- Sample 3% for performance
LIMIT 15000;

SELECT 'WEATHER_DATA loaded: ' || COUNT(*) || ' records' AS STATUS FROM WEATHER_DATA;

-- ============================================================================
-- VERIFICATION
-- ============================================================================

SELECT 
    'SCADA_EVENTS' as TABLE_NAME,
    COUNT(*) as TOTAL_RECORDS,
    COUNT(DISTINCT ASSET_ID) as UNIQUE_ASSETS,
    MIN(EVENT_TIMESTAMP) as EARLIEST,
    MAX(EVENT_TIMESTAMP) as LATEST
FROM SCADA_EVENTS
UNION ALL
SELECT 
    'WEATHER_DATA',
    COUNT(*),
    COUNT(DISTINCT ASSET_ID),
    MIN(OBSERVATION_TIMESTAMP),
    MAX(OBSERVATION_TIMESTAMP)
FROM WEATHER_DATA;

SELECT EVENT_TYPE, COUNT(*) as COUNT FROM SCADA_EVENTS GROUP BY EVENT_TYPE ORDER BY COUNT DESC;

SELECT '✅ Reference data complete!' as STATUS;

