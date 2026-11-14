SELECT 
    table_name,
    -- Menghitung durasi absolut dalam menit, jika ada yang NULL atau minus akan ditangani
    ISNULL(
        DATEDIFF(MINUTE, 
            CASE WHEN timestamp_end < timestamp_start THEN timestamp_end ELSE timestamp_start END,
            CASE WHEN timestamp_end < timestamp_start THEN timestamp_start ELSE timestamp_end END
        ), 0
    ) AS duration_minutes,
    COUNT(*) AS total_data
FROM gelar_rasa_2026.dbo.merged_data
GROUP BY 
    table_name,
    ISNULL(
        DATEDIFF(MINUTE, 
            CASE WHEN timestamp_end < timestamp_start THEN timestamp_end ELSE timestamp_start END,
            CASE WHEN timestamp_end < timestamp_start THEN timestamp_start ELSE timestamp_end END
        ), 0
    )
ORDER BY 
    table_name, 
    duration_minutes ASC;