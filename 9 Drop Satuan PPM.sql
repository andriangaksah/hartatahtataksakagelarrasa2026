DECLARE @ColName NVARCHAR(256);
DECLARE @DropSQL NVARCHAR(MAX);

-- Cursor untuk mencari seluruh kolom di tabel merged_data yang mengandung kata 'ppm'
DECLARE ppm_cursor CURSOR LOCAL FAST_FORWARD FOR
    SELECT COLUMN_NAME
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = 'dbo'
      AND TABLE_NAME = 'merged_data'
      AND COLUMN_NAME LIKE '%ppm%';

OPEN ppm_cursor;
FETCH NEXT FROM ppm_cursor INTO @ColName;

WHILE @@FETCH_STATUS = 0
BEGIN
    -- Susun perintah ALTER TABLE untuk drop kolom
    SET @DropSQL = 'ALTER TABLE gelar_rasa_2026.dbo.merged_data DROP COLUMN ' + QUOTENAME(@ColName) + ';';
    
    -- Jalankan perintah drop
    EXEC sp_executesql @DropSQL;
    
    PRINT 'Kolom ' + @ColName + ' berhasil dihapus!';

    FETCH NEXT FROM ppm_cursor INTO @ColName;
END;

CLOSE ppm_cursor;
DEALLOCATE ppm_cursor;
GO

-- Cek daftar kolom yang tersisa di tabel merged_data
SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'dbo'
  AND TABLE_NAME = 'merged_data'
ORDER BY COLUMN_NAME;