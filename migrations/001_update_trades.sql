-- Rename zerodha_order_id to broker_order_id
ALTER TABLE trading.trades 
RENAME COLUMN zerodha_order_id TO broker_order_id;

-- Add new columns with defaults where necessary to avoid issues with existing data
ALTER TABLE trading.trades
ADD COLUMN broker_name TEXT DEFAULT 'Zerodha',
ADD COLUMN isin TEXT,
ADD COLUMN product_type TEXT DEFAULT 'CNC', -- Defaulting to CNC for existing records
ADD COLUMN total_charges NUMERIC(10, 2) DEFAULT 0,
ADD COLUMN net_amount NUMERIC(14, 2),
ADD COLUMN currency TEXT DEFAULT 'INR',
ADD COLUMN notes TEXT;

-- Update column types/constraints
ALTER TABLE trading.trades
ALTER COLUMN price TYPE NUMERIC(14, 4),
ALTER COLUMN product_type SET NOT NULL,
ALTER COLUMN transaction_type SET NOT NULL;

-- Add constraints
ALTER TABLE trading.trades
ADD CONSTRAINT check_txn_type CHECK (transaction_type IN ('BUY', 'SELL')),
ADD CONSTRAINT check_prod_type CHECK (product_type IN ('CNC', 'MIS', 'NRML', 'CO'));
