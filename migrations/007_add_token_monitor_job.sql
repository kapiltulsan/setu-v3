
-- Migration: Add token_monitor to scheduler
-- Description: Migrates the token monitoring job from cron to central scheduler
-- Schedule: 08:30 AM Mon-Fri

INSERT INTO sys.scheduled_jobs (name, schedule_cron, command, is_enabled, description)
VALUES (
    'token_monitor',
    '30 08 * * 1-5',
    'python tools/token_monitor.py',
    TRUE,
    'Monitors login token validity every 30 mins from 8:30 AM'
)
ON CONFLICT (name) DO UPDATE 
SET schedule_cron = EXCLUDED.schedule_cron,
    command = EXCLUDED.command,
    is_enabled = EXCLUDED.is_enabled;
