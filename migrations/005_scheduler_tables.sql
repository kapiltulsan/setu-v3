-- 005_scheduler_tables.sql
-- Create schema 'sys' if it doesn't exist
CREATE SCHEMA IF NOT EXISTS sys;

-- sys.scheduled_jobs: Configuration for background jobs
CREATE TABLE IF NOT EXISTS sys.scheduled_jobs (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,          -- Unique identifier (e.g., 'market_data_day')
    description TEXT,                   -- Human readable info
    command TEXT NOT NULL,              -- Full shell command (e.g., 'python tools/data_collector.py day')
    schedule_cron TEXT NOT NULL,        -- Crontab expression (e.g., '0 17 * * *')
    is_enabled BOOLEAN DEFAULT TRUE,    -- Toggle
    max_retries INT DEFAULT 0,
    timeout_sec INT DEFAULT 3600,       -- Kill job if runs longer than this
    last_run_at TIMESTAMP WITH TIME ZONE,
    next_run_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- sys.job_history: Execution logs
CREATE TABLE IF NOT EXISTS sys.job_history (
    id SERIAL PRIMARY KEY,
    job_id INT REFERENCES sys.scheduled_jobs(id) ON DELETE CASCADE,
    status TEXT NOT NULL CHECK (status IN ('RUNNING', 'SUCCESS', 'FAILURE', 'TIMEOUT')),
    start_time TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    end_time TIMESTAMP WITH TIME ZONE,
    duration_seconds NUMERIC(10, 2),
    log_path TEXT,                      -- Path to filesystem log
    exit_message TEXT,
    retry_count INT DEFAULT 0
);

-- sys.service_status: Heartbeat for the scheduler service
CREATE TABLE IF NOT EXISTS sys.service_status (
    service_name TEXT PRIMARY KEY,
    last_heartbeat TIMESTAMP WITH TIME ZONE,
    status TEXT,
    info JSONB
);

-- Seed Initial Data
INSERT INTO sys.scheduled_jobs (name, description, command, schedule_cron, is_enabled)
VALUES 
    ('portfolio_sync', 'Daily Portfolio Sync from Zerodha', 'python portfolio_collector.py', '15 17 * * *', true),
    ('market_data_day', 'Daily OHLC Data Collection', 'python data_collector.py day', '30 17 * * *', true),
    ('market_data_60m', 'Hourly OHLC Data Collection', 'python data_collector.py 60minute', '0 18 * * *', true)
ON CONFLICT (name) DO NOTHING;
