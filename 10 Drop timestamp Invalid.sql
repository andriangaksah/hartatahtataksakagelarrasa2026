ALTER TABLE [gelar_rasa_2026].[dbo].[merged_data] 
DROP COLUMN timestamp_start, timestamp_end;

EXEC sp_rename '[gelar_rasa_2026].[dbo].[merged_data].[timestamp_start_valid]', 'timestamp_start', 'COLUMN';
EXEC sp_rename '[gelar_rasa_2026].[dbo].[merged_data].[timestamp_end_valid]', 'timestamp_end', 'COLUMN';