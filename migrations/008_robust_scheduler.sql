-- 008_robust_scheduler.sql

-- 1. Ensure sys.job_history has all needed columns (handling potential skew between 002 and 005)
ALTER TABLE sys.job_history ADD COLUMN IF NOT EXISTS output_summary TEXT;
ALTER TABLE sys.job_history DROP CONSTRAINT IF EXISTS job_history_status_check;
ALTER TABLE sys.job_history ADD CONSTRAINT job_history_status_check CHECK (status IN ('RUNNING', 'SUCCESS', 'FAILURE', 'TIMEOUT', 'CRASHED', 'WARNING'));

-- 2. Create sys.app_logs for high-priority DB logging
CREATE TABLE IF NOT EXISTS sys.app_logs (
    id SERIAL PRIMARY KEY,
    history_id INT REFERENCES sys.job_history(id) ON DELETE CASCADE,
    level VARCHAR(10) NOT NULL,
    message TEXT NOT NULL,
    module TEXT,
    timestamp TIMESTAMPTZ DEFAULT NOW(),
    metadata JSONB
);

CREATE INDEX IF NOT EXISTS idx_app_logs_history_id ON sys.app_logs(history_id);
CREATE INDEX IF NOT EXISTS idx_app_logs_timestamp ON sys.app_logs(timestamp DESC);

-- 3. Utility Function: Cleanup Zombies (can be called by scheduler on start)
CREATE OR REPLACE FUNCTION sys.cleanup_zombie_jobs() RETURNS INT AS $$
DECLARE
    updated_count INT;
BEGIN
    UPDATE sys.job_history
    SET status = 'CRASHED',
        end_time = NOW(),
        output_summary = 'Job marked as CRASHED during scheduler startup cleanup.'
    WHERE status = 'RUNNING' AND start_time < NOW() - INTERVAL '1 hour'; -- Safety buffer
    
    GET DIAGNOSTICS updated_count = ROW_COUNT;
    RETURN updated_count;
END;
$$ LANGUAGE plpgsql;
