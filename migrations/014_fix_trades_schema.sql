-- Add missing columns to trading.trades

ALTER TABLE trading.trades ADD COLUMN IF NOT EXISTS exchange text;
ALTER TABLE trading.trades ADD COLUMN IF NOT EXISTS txn_type text;
ALTER TABLE trading.trades ADD COLUMN IF NOT EXISTS fees numeric DEFAULT 0;
ALTER TABLE trading.trades ADD COLUMN IF NOT EXISTS net_amount numeric DEFAULT 0;
ALTER TABLE trading.trades ADD COLUMN IF NOT EXISTS source text;
ALTER TABLE trading.trades ADD COLUMN IF NOT EXISTS external_trade_id text;
ALTER TABLE trading.trades ADD COLUMN IF NOT EXISTS order_id text;

-- Add constraint for uniqueness if not exists
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'trades_external_trade_id_source_key') THEN
        ALTER TABLE trading.trades ADD CONSTRAINT trades_external_trade_id_source_key UNIQUE (external_trade_id, source);
    END IF;
END $$;
