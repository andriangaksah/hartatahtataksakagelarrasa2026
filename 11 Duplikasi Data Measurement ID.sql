SELECT
    table_name,
    measurement_id,
    COUNT(*) AS total_duplicate
FROM [gelar_rasa_2026].[dbo].[merged_data]
GROUP BY
    table_name,
    measurement_id
HAVING COUNT(*) > 1
ORDER BY total_duplicate DESC;