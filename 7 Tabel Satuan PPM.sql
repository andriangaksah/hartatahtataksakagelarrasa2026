USE gelar_rasa_2026;
GO

DECLARE @SQL NVARCHAR(MAX);
DECLARE @Conditions NVARCHAR(MAX);

SELECT @Conditions = STRING_AGG(
    CAST(
        'NULLIF(LTRIM(RTRIM(CAST('
        + QUOTENAME(name)
        + ' AS NVARCHAR(MAX)))), '''') IS NOT NULL'
        AS NVARCHAR(MAX)
    ),
    ' AND '
)
FROM sys.columns
WHERE object_id = OBJECT_ID('dbo.merged_data')
  AND name LIKE '%ppm%';

SET @SQL = '
SELECT
    table_name AS table_name,
    COUNT(*) AS total_data
FROM dbo.merged_data
WHERE ' + @Conditions + '
GROUP BY table_name
ORDER BY table_name;
';

EXEC sp_executesql @SQL;