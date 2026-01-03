-- Add new columns to trading.trades
ALTER TABLE trading.trades 
ADD COLUMN IF NOT EXISTS isin TEXT,
ADD COLUMN IF NOT EXISTS segment TEXT,
ADD COLUMN IF NOT EXISTS series TEXT;

-- Add skip_cols to sys.broker_configs
ALTER TABLE sys.broker_configs
ADD COLUMN IF NOT EXISTS skip_cols INTEGER DEFAULT 0;
