USE gelar_rasa_2026;
GO

-- Hapus tabel hasil sebelumnya
IF OBJECT_ID('dbo.merged_data', 'U') IS NOT NULL
    DROP TABLE dbo.merged_data;
GO

DECLARE @TableName NVARCHAR(256);
DECLARE @SQL NVARCHAR(MAX);
DECLARE @UnionAll NVARCHAR(MAX) = '';
DECLARE @SelectColumns NVARCHAR(MAX);

-- Cursor seluruh tabel AQMS
DECLARE table_cursor CURSOR LOCAL FAST_FORWARD FOR
    SELECT TABLE_NAME
    FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_SCHEMA = 'dbo'
      AND TABLE_TYPE = 'BASE TABLE'
      AND TABLE_NAME LIKE '%AQMS%';

OPEN table_cursor;
FETCH NEXT FROM table_cursor INTO @TableName;

WHILE @@FETCH_STATUS = 0
BEGIN

    -- Ambil seluruh kolom unik dari semua tabel AQMS
    SELECT @SelectColumns = STUFF((
        SELECT
            ', ' +
            CASE
                WHEN EXISTS (
                    SELECT 1
                    FROM INFORMATION_SCHEMA.COLUMNS x
                    WHERE x.TABLE_SCHEMA = 'dbo'
                      AND x.TABLE_NAME = @TableName
                      AND x.COLUMN_NAME = c.COLUMN_NAME
                )
                THEN
                    CASE
                        WHEN c.COLUMN_NAME IN (
                            'measurement_id',
                            'sensor_id',
                            'qc_flag'
                        )
                            THEN 'CAST(t.' + QUOTENAME(c.COLUMN_NAME)
                                 + ' AS VARCHAR(100))'

                        WHEN c.COLUMN_NAME IN (
                            'timestamp_start',
                            'timestamp_end'
                        )
                            THEN 'TRY_CAST(t.' + QUOTENAME(c.COLUMN_NAME) + ' AS DATETIME)'

                        WHEN c.COLUMN_NAME LIKE '%ppm%'
                          OR c.COLUMN_NAME LIKE '%ug_m3%'
                          OR c.COLUMN_NAME IN (
                              'temperature_c',
                              'humidity_pct',
                              'wind_speed_ms'
                          )
                            THEN 'TRY_CONVERT(FLOAT, t.'
                                 + QUOTENAME(c.COLUMN_NAME) + ')'

                        WHEN c.COLUMN_NAME = 'wind_direction_deg'
                            THEN 'TRY_CONVERT(INT, t.'
                                 + QUOTENAME(c.COLUMN_NAME) + ')'

                        ELSE 't.' + QUOTENAME(c.COLUMN_NAME)
                    END
                ELSE
                    CASE
                        WHEN c.COLUMN_NAME LIKE '%ppm%'
                          OR c.COLUMN_NAME LIKE '%ug_m3%'
                          OR c.COLUMN_NAME IN (
                              'temperature_c',
                              'humidity_pct',
                              'wind_speed_ms'
                          )
                            THEN 'CAST(NULL AS FLOAT)'

                        WHEN c.COLUMN_NAME IN (
                            'timestamp_start',
                            'timestamp_end'
                        )
                            THEN 'CAST(NULL AS DATETIME)'

                        WHEN c.COLUMN_NAME = 'wind_direction_deg'
                            THEN 'CAST(NULL AS INT)'

                        WHEN c.COLUMN_NAME IN (
                            'measurement_id',
                            'sensor_id',
                            'qc_flag'
                        )
                            THEN 'CAST(NULL AS VARCHAR(100))'

                        ELSE 'CAST(NULL AS VARCHAR(MAX))'
                    END
            END +
            ' AS ' + QUOTENAME(c.COLUMN_NAME)

        FROM (
            SELECT DISTINCT COLUMN_NAME
            FROM INFORMATION_SCHEMA.COLUMNS
            WHERE TABLE_SCHEMA = 'dbo'
              AND TABLE_NAME IN (
                  SELECT TABLE_NAME
                  FROM INFORMATION_SCHEMA.TABLES
                  WHERE TABLE_SCHEMA = 'dbo'
                    AND TABLE_TYPE = 'BASE TABLE'
                    AND TABLE_NAME LIKE '%AQMS%'
              )
        ) c
        ORDER BY c.COLUMN_NAME
        FOR XML PATH(''), TYPE
    ).value('.', 'NVARCHAR(MAX)'), 1, 2, '');

    -- Susun SELECT untuk setiap tabel
    SET @SQL =
        'SELECT ''' + REPLACE(@TableName, '''', '''''') +
        ''' AS table_name, ' +
        @SelectColumns +
        ' FROM dbo.' + QUOTENAME(@TableName) + ' AS t';

    -- Gabungkan menggunakan UNION ALL
    IF @UnionAll = ''
        SET @UnionAll = @SQL;
    ELSE
        SET @UnionAll = @UnionAll +
                        CHAR(13) + ' UNION ALL ' +
                        CHAR(13) + @SQL;

    FETCH NEXT FROM table_cursor INTO @TableName;
END;

CLOSE table_cursor;
DEALLOCATE table_cursor;

-- Buat tabel merged_data
IF @UnionAll <> ''
BEGIN
    SET @SQL =
        'SELECT * INTO dbo.merged_data
         FROM (' + @UnionAll + ') AS CombinedData;';

    EXEC sp_executesql @SQL;

    PRINT 'Berhasil membuat dbo.merged_data!';
END
ELSE
BEGIN
    PRINT 'Tidak ditemukan tabel AQMS!';
END;
GO

-- Tampilkan hasil penggabungan
SELECT *
FROM dbo.merged_data;