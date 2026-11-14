WITH duplicate_timestamp AS (
    SELECT
        table_name,
        timestamp_start
    FROM [gelar_rasa_2026].[dbo].[merged_data]
    GROUP BY
        table_name,
        timestamp_start
    HAVING COUNT(*) > 1
)
SELECT m.*
FROM [gelar_rasa_2026].[dbo].[merged_data] m
INNER JOIN duplicate_timestamp d
    ON m.table_name = d.table_name
   AND m.timestamp_start = d.timestamp_start
ORDER BY
    m.table_name,
    m.timestamp_start;