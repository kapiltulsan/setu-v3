-- 009_observability_redesign.sql
-- Migration for Setu V3 Observability & Automation Suite

-- 1. Job Triggers Table for "Run Now" functionality
CREATE TABLE IF NOT EXISTS sys.job_triggers (
    id SERIAL PRIMARY KEY,
    job_name TEXT NOT NULL REFERENCES sys.scheduled_jobs(name) ON DELETE CASCADE,
    params JSONB DEFAULT '{}',
    triggered_by TEXT DEFAULT 'system',
    triggered_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    processed_at TIMESTAMP WITH TIME ZONE,
    status TEXT DEFAULT 'PENDING' CHECK (status IN ('PENDING', 'PROCESSED', 'FAILED')),
    execution_id UUID, -- Link to execution if available
    error_message TEXT
);

-- Index for fast polling of pending triggers
CREATE INDEX IF NOT EXISTS idx_job_triggers_pending ON sys.job_triggers(status) WHERE status = 'PENDING';

-- 2. Ensure Service Status is robust (In case 005 wasn't fully applied or needs update)
CREATE TABLE IF NOT EXISTS sys.service_status (
    service_name TEXT PRIMARY KEY,
    last_heartbeat TIMESTAMP WITH TIME ZONE,
    status TEXT,
    info JSONB
);

-- 3. Indexes for Log Analysis and History
CREATE INDEX IF NOT EXISTS idx_job_history_job_start ON sys.job_history(job_name, start_time DESC);
CREATE INDEX IF NOT EXISTS idx_job_history_status ON sys.job_history(status);

-- 4. Function to cleanup old triggers (Retention Policy)
CREATE OR REPLACE FUNCTION sys.cleanup_old_triggers() RETURNS void AS $$
BEGIN
    DELETE FROM sys.job_triggers WHERE triggered_at < NOW() - INTERVAL '7 days';
END;
$$ LANGUAGE plpgsql;
