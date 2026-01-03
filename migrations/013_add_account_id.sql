-- Migration: Add account_id to Trading Tables
-- Description: Adds account_id column to support multi-user/multi-broker architecture. 
--              Updates unique constraints to include account_id.

-- 1. Orders
ALTER TABLE trading.orders ADD COLUMN IF NOT EXISTS account_id TEXT DEFAULT 'default';
-- Order ID is usually unique globally per broker, but might crash if multiple brokers use same ID format (unlikely).
-- Keeping PK as order_id for now, but adding index on account_id.
CREATE INDEX IF NOT EXISTS idx_orders_account_id ON trading.orders (account_id);

-- 2. Portfolio (Holdings)
ALTER TABLE trading.portfolio ADD COLUMN IF NOT EXISTS account_id TEXT DEFAULT 'default';
-- Drop old constraint and add new one
ALTER TABLE trading.portfolio DROP CONSTRAINT IF EXISTS portfolio_date_symbol_key;
ALTER TABLE trading.portfolio ADD CONSTRAINT portfolio_unique_entry UNIQUE (date, symbol, account_id);

-- 3. Positions
ALTER TABLE trading.positions ADD COLUMN IF NOT EXISTS account_id TEXT DEFAULT 'default';
ALTER TABLE trading.positions DROP CONSTRAINT IF EXISTS positions_date_symbol_product_key;
ALTER TABLE trading.positions ADD CONSTRAINT positions_unique_entry UNIQUE (date, symbol, product, account_id);

-- 4. Trades
ALTER TABLE trading.trades ADD COLUMN IF NOT EXISTS account_id TEXT DEFAULT 'default';
CREATE INDEX IF NOT EXISTS idx_trades_account_id ON trading.trades (account_id);

-- 5. Daily PnL
ALTER TABLE trading.daily_pnl ADD COLUMN IF NOT EXISTS account_id TEXT DEFAULT 'default';
ALTER TABLE trading.daily_pnl DROP CONSTRAINT IF EXISTS daily_pnl_date_key;
ALTER TABLE trading.daily_pnl ADD CONSTRAINT daily_pnl_unique_entry UNIQUE (date, account_id);
