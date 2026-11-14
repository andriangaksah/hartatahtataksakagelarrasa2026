UPDATE gelar_rasa_2026.dbo.merged_data
SET 
    -- PM2.5
    pm25_ug_m3 = CASE 
        WHEN table_name IN ('BJB_01_Banjarbaru_AQMS', 'MDN_01_Medan_AQMS', 'PSW_01_Pesawaran_AQMS')
             AND TRY_CAST(pm25_ppm AS FLOAT) IS NOT NULL 
             AND TRY_CAST(temperature_c AS FLOAT) IS NOT NULL 
        THEN CAST(
            TRY_CAST(pm25_ppm AS FLOAT) * (101325.0 / (287.052874 * (TRY_CAST(temperature_c AS FLOAT) + 273.15))) * 1000.0 
            AS FLOAT)
        ELSE TRY_CAST(pm25_ppm AS FLOAT)
    END,

    -- PM10
    pm10_ug_m3 = CASE 
        WHEN table_name IN ('BJB_01_Banjarbaru_AQMS', 'MDN_01_Medan_AQMS', 'PSW_01_Pesawaran_AQMS')
             AND TRY_CAST(pm10_ppm AS FLOAT) IS NOT NULL 
             AND TRY_CAST(temperature_c AS FLOAT) IS NOT NULL 
        THEN CAST(
            TRY_CAST(pm10_ppm AS FLOAT) * (101325.0 / (287.052874 * (TRY_CAST(temperature_c AS FLOAT) + 273.15))) * 1000.0 
            AS FLOAT)
        ELSE TRY_CAST(pm10_ppm AS FLOAT)
    END,

    -- SO2
    so2_ug_m3 = CASE 
        WHEN table_name IN ('BJB_01_Banjarbaru_AQMS', 'MDN_01_Medan_AQMS', 'PSW_01_Pesawaran_AQMS')
             AND TRY_CAST(so2_ppm AS FLOAT) IS NOT NULL 
             AND TRY_CAST(temperature_c AS FLOAT) IS NOT NULL 
        THEN CAST(
            TRY_CAST(so2_ppm AS FLOAT) * 64.0638 * (1000.0 / (22.414 * ((273.15 + TRY_CAST(temperature_c AS FLOAT)) / 273.15)))
            AS FLOAT)
        ELSE TRY_CAST(so2_ppm AS FLOAT)
    END,

    -- CO
    co_ug_m3 = CASE 
        WHEN table_name IN ('BJB_01_Banjarbaru_AQMS', 'MDN_01_Medan_AQMS', 'PSW_01_Pesawaran_AQMS')
             AND TRY_CAST(co_ppm AS FLOAT) IS NOT NULL 
             AND TRY_CAST(temperature_c AS FLOAT) IS NOT NULL 
        THEN CAST(
            TRY_CAST(co_ppm AS FLOAT) * 28.0101 * (1000.0 / (22.414 * ((273.15 + TRY_CAST(temperature_c AS FLOAT)) / 273.15)))
            AS FLOAT)
        ELSE TRY_CAST(co_ppm AS FLOAT)
    END,

    -- O3
    o3_ug_m3 = CASE 
        WHEN table_name IN ('BJB_01_Banjarbaru_AQMS', 'MDN_01_Medan_AQMS', 'PSW_01_Pesawaran_AQMS')
             AND TRY_CAST(o3_ppm AS FLOAT) IS NOT NULL 
             AND TRY_CAST(temperature_c AS FLOAT) IS NOT NULL 
        THEN CAST(
            TRY_CAST(o3_ppm AS FLOAT) * 47.9982 * (1000.0 / (22.414 * ((273.15 + TRY_CAST(temperature_c AS FLOAT)) / 273.15)))
            AS FLOAT)
        ELSE TRY_CAST(o3_ppm AS FLOAT)
    END,

    -- NO2
    no2_ug_m3 = CASE 
        WHEN table_name IN ('BJB_01_Banjarbaru_AQMS', 'MDN_01_Medan_AQMS', 'PSW_01_Pesawaran_AQMS')
             AND TRY_CAST(no2_ppm AS FLOAT) IS NOT NULL 
             AND TRY_CAST(temperature_c AS FLOAT) IS NOT NULL 
        THEN CAST(
            TRY_CAST(no2_ppm AS FLOAT) * 46.0055 * (1000.0 / (22.414 * ((273.15 + TRY_CAST(temperature_c AS FLOAT)) / 273.15)))
            AS FLOAT)
        ELSE TRY_CAST(no2_ppm AS FLOAT)
    END
WHERE table_name IN ('BJB_01_Banjarbaru_AQMS', 'MDN_01_Medan_AQMS', 'PSW_01_Pesawaran_AQMS');
GO