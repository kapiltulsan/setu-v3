-- Migration for Stock Scanner Module
-- 1. Create Scanners Table
CREATE TABLE IF NOT EXISTS sys.scanners (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    description TEXT,
    source_universe TEXT DEFAULT 'Nifty 50',
    logic_config JSONB NOT NULL, -- Stores the full strategy (Universe, Primary, Refiner)
    schedule_cron TEXT, -- NULL = Manual, otherwise cron string
    last_run_at TIMESTAMP WITH TIME ZONE,
    last_match_count INTEGER DEFAULT 0,
    last_run_stats JSONB DEFAULT '{}'::jsonb, -- Stores funnel counts (universe, primary, refiner)
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. Create Scanner Results Table
CREATE TABLE IF NOT EXISTS trading.scanner_results (
    id SERIAL PRIMARY KEY,
    scanner_id INTEGER REFERENCES sys.scanners(id) ON DELETE CASCADE,
    run_date TIMESTAMP WITH TIME ZONE NOT NULL,
    symbol TEXT NOT NULL,
    match_data JSONB NOT NULL, -- Snapshot of data at time of match (close, rsi, etc.)
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 3. Indexes
CREATE INDEX IF NOT EXISTS idx_scanner_results_scanner_id ON trading.scanner_results(scanner_id);
CREATE INDEX IF NOT EXISTS idx_scanner_results_run_date ON trading.scanner_results(run_date);
