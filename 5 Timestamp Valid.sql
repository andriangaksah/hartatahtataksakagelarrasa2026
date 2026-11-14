-- Tambahkan kolom baru jika belum ada (menggunakan DATETIME agar format .000 hilang)
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'merged_data' AND COLUMN_NAME = 'timestamp_start_valid')
    ALTER TABLE gelar_rasa_2026.dbo.merged_data ADD timestamp_start_valid DATETIME NULL;

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'merged_data' AND COLUMN_NAME = 'timestamp_end_valid')
    ALTER TABLE gelar_rasa_2026.dbo.merged_data ADD timestamp_end_valid DATETIME NULL;

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'merged_data' AND COLUMN_NAME = 'duration_minutes')
    ALTER TABLE gelar_rasa_2026.dbo.merged_data ADD duration_minutes FLOAT NULL;
GO

-- Update data ke dalam tabel merged_data
UPDATE gelar_rasa_2026.dbo.merged_data
SET 
    timestamp_start_valid = TRY_CAST(timestamp_start AS DATETIME),
    timestamp_end_valid = TRY_CAST(timestamp_end AS DATETIME),
    
    -- Hitung durasi dalam MENIT:
    -- Pastikan KEDUANYA NOT NULL DAN end < start, baru dibalik. Jika ada yang NULL, biarkan perhitungan aman.
    duration_minutes = CASE 
        WHEN TRY_CAST(timestamp_start AS DATETIME) IS NULL OR TRY_CAST(timestamp_end AS DATETIME) IS NULL THEN NULL
        ELSE 
            DATEDIFF(SECOND, 
                CASE 
                    WHEN TRY_CAST(timestamp_end AS DATETIME) < TRY_CAST(timestamp_start AS DATETIME) 
                    THEN TRY_CAST(timestamp_end AS DATETIME) 
                    ELSE TRY_CAST(timestamp_start AS DATETIME) 
                END,
                CASE 
                    WHEN TRY_CAST(timestamp_end AS DATETIME) < TRY_CAST(timestamp_start AS DATETIME) 
                    THEN TRY_CAST(timestamp_start AS DATETIME) 
                    ELSE TRY_CAST(timestamp_end AS DATETIME) 
                END
            ) / 60.0
    END;
GO

-- Hasil akhir
SELECT * FROM gelar_rasa_2026.dbo.merged_data;