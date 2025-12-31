-- 012_create_scanner_tables.sql

-- 1. sys.scanners: Stores the definition of the scanner logic
CREATE TABLE IF NOT EXISTS sys.scanners (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    description TEXT,
    source_universe TEXT NOT NULL, -- e.g., 'Nifty 50', 'All NSE', 'Bank Nifty'
    logic_config JSONB NOT NULL,   -- The rules engine configuration
    schedule_cron TEXT,            -- e.g., '0 9 * * *' (Optional)
    is_active BOOLEAN DEFAULT TRUE,
    last_run_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. trading.scanner_results: Stores historical execution results
CREATE TABLE IF NOT EXISTS trading.scanner_results (
    id SERIAL PRIMARY KEY,
    scanner_id INT REFERENCES sys.scanners(id) ON DELETE CASCADE,
    run_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    symbol TEXT NOT NULL,
    match_data JSONB,              -- Key-value pairs of values that triggered the match (e.g., {"RSI": 65, "Close": 102})
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Index for fast retrieval of results for a specific scanner
CREATE INDEX IF NOT EXISTS idx_scanner_results_scanner_id ON trading.scanner_results(scanner_id);
CREATE INDEX IF NOT EXISTS idx_scanner_results_run_date ON trading.scanner_results(run_date);
