SELECT
    table_name,
    timestamp_start,
    COUNT(*) AS total_duplicate
FROM [gelar_rasa_2026].[dbo].[merged_data]
GROUP BY
    table_name,
    timestamp_start
HAVING COUNT(*) > 1
ORDER BY total_duplicate DESC;