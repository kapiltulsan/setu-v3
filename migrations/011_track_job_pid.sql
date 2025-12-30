-- 011_track_job_pid.sql
-- Add PID column to job_history to track running process IDs

ALTER TABLE sys.job_history
ADD COLUMN IF NOT EXISTS pid INT;
