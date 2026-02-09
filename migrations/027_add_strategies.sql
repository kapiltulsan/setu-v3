-- Migration 027: Add Strategies and Strategy columns to Portfolio

-- Create Strategies table
CREATE TABLE IF NOT EXISTS ref.strategies (
    strategy_id SERIAL PRIMARY KEY,
    name TEXT UNIQUE NOT NULL,
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Insert default strategy
INSERT INTO ref.strategies (name, description) 
VALUES ('Open', 'Default strategy for unassigned portfolio items')
ON CONFLICT (name) DO NOTHING;

-- Add strategy_name to trading.trades
ALTER TABLE trading.trades ADD COLUMN IF NOT EXISTS strategy_name TEXT DEFAULT 'Open';

-- Add strategy_name to trading.portfolio
ALTER TABLE trading.portfolio ADD COLUMN IF NOT EXISTS strategy_name TEXT DEFAULT 'Open';

-- Update unique constraint for trading.portfolio
-- First drop existing constraint if it exists (assuming it was on date, symbol, account_id)
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'portfolio_date_symbol_account_id_key') THEN
        ALTER TABLE trading.portfolio DROP CONSTRAINT portfolio_date_symbol_account_id_key;
    END IF;
END $$;

ALTER TABLE trading.portfolio 
ADD CONSTRAINT portfolio_date_symbol_account_id_strategy_key 
UNIQUE (date, symbol, account_id, strategy_name);

-- Update portfolios to ensure strategy_name is set for existing records
UPDATE trading.trades SET strategy_name = 'Open' WHERE strategy_name IS NULL;
UPDATE trading.portfolio SET strategy_name = 'Open' WHERE strategy_name IS NULL;
