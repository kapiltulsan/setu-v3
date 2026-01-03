-- Create table for CSV mappings
CREATE TABLE IF NOT EXISTS sys.csv_mappings (
    id SERIAL PRIMARY KEY,
    provider TEXT NOT NULL,
    csv_column TEXT NOT NULL,
    db_column TEXT NOT NULL,
    is_required BOOLEAN DEFAULT TRUE,
    default_value TEXT,
    data_type TEXT DEFAULT 'text', -- 'date', 'float', 'text'
    UNIQUE(provider, db_column)
);

-- Index for fast lookup
CREATE INDEX idx_csv_mappings_provider ON sys.csv_mappings(provider);

-- Seed ZERODHA mappings (Based on what we know works)
INSERT INTO sys.csv_mappings (provider, csv_column, db_column, data_type, is_required) VALUES
('ZERODHA', 'symbol', 'symbol', 'text', true),
('ZERODHA', 'exchange', 'exchange', 'text', true),
('ZERODHA', 'trade_date', 'trade_date', 'date', true),
('ZERODHA', 'type', 'txn_type', 'text', true), -- Note: We handle trade_type alias in code, but primary is type
('ZERODHA', 'quantity', 'quantity', 'float', true),
('ZERODHA', 'price', 'price', 'float', true),
('ZERODHA', 'order_id', 'order_id', 'text', true),
('ZERODHA', 'trade_id', 'external_trade_id', 'text', true);

-- Seed some potential DHAN mappings (Placeholder/Guess based on common formats, user can update)
INSERT INTO sys.csv_mappings (provider, csv_column, db_column, data_type, is_required) VALUES
('DHAN', 'Symbol', 'symbol', 'text', true),
('DHAN', 'Exchange', 'exchange', 'text', true),
('DHAN', 'Date', 'trade_date', 'date', true),
('DHAN', 'Type', 'txn_type', 'text', true),
('DHAN', 'Qty', 'quantity', 'float', true),
('DHAN', 'Price', 'price', 'float', true),
('DHAN', 'Order ID', 'order_id', 'text', true),
('DHAN', 'Trade ID', 'external_trade_id', 'text', true);
