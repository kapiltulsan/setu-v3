-- 006_add_midnight_batch.sql
-- Add Midnight Batch and Sync jobs
INSERT INTO sys.scheduled_jobs (name, description, command, schedule_cron, is_enabled)
VALUES 
    ('midnight_batch', 'Daily Maintenance Batch (Sync + OHLC)', 'python tools/run_midnight_jobs.py', '30 00 * * *', true),
    ('sync_master', 'Sync Master Symbols', 'python tools/sync_master.py', '0 0 1 1 *', false), -- Manual only
    ('sync_constituents', 'Sync Index Constituents', 'python tools/sync_constituents.py', '0 0 1 1 *', false) -- Manual only
ON CONFLICT (name) DO UPDATE 
SET command = EXCLUDED.command; -- Update command just in case

-- Disable market_data_day since it's covered by midnight_batch? 
-- Or keep it as a backup at 17:30?
-- User's prompt implied "schedule job for getting order and portfolio", which is 17:00.
-- Midnight batch is 00:30.
-- Keeping market_data_day enabled for "End of Day" fetch is fine.
