SELECT 
    table_name,
    -- Menghitung durasi dalam menit
    DATEDIFF(MINUTE, TRY_CAST(timestamp_start AS DATETIME2), TRY_CAST(timestamp_end AS DATETIME2)) AS duration_minutes,
    COUNT(*) AS total_data
FROM gelar_rasa_2026.dbo.merged_data
GROUP BY 
    table_name,
    DATEDIFF(MINUTE, TRY_CAST(timestamp_start AS DATETIME2), TRY_CAST(timestamp_end AS DATETIME2))
ORDER BY 
    table_name, 
    duration_minutes ASC;