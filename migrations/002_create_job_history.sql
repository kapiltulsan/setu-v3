-- Migration: Create Job History Table
-- Description: Tracks execution status of midnight jobs and other scheduled tasks.

CREATE SCHEMA IF NOT EXISTS sys;

CREATE TABLE IF NOT EXISTS sys.job_history (
    id SERIAL PRIMARY KEY,
    job_name TEXT NOT NULL,
    start_time TIMESTAMPTZ DEFAULT NOW(),
    end_time TIMESTAMPTZ,
    status TEXT CHECK (status IN ('RUNNING', 'SUCCESS', 'FAILURE', 'WARNING')),
    details TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Index for faster queries on dashboard
CREATE INDEX IF NOT EXISTS idx_job_history_job_name ON sys.job_history(job_name);
CREATE INDEX IF NOT EXISTS idx_job_history_start_time ON sys.job_history(start_time DESC);
