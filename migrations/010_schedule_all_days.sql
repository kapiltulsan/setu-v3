-- 010_schedule_all_days.sql
-- Update token_monitor to run on all days (remove Mon-Fri restriction)

UPDATE sys.scheduled_jobs
SET schedule_cron = '30 08 * * *', -- Was 30 08 * * 1-5
    description = 'Monitors login token validity every 30 mins from 8:30 AM (Daily)',
    updated_at = NOW()
WHERE name = 'token_monitor';
