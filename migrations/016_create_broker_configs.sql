-- Create table for Broker CSV Configuration
CREATE TABLE IF NOT EXISTS sys.broker_configs (
    provider TEXT PRIMARY KEY,
    skip_rows INTEGER DEFAULT 0,
    header_row INTEGER DEFAULT 0, -- 0-indexed row number where header is located
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Seed ZERODHA config
INSERT INTO sys.broker_configs (provider, skip_rows, header_row) VALUES
('ZERODHA', 0, 0)
ON CONFLICT (provider) DO NOTHING;

-- Seed DHAN config (Placeholder)
INSERT INTO sys.broker_configs (provider, skip_rows, header_row) VALUES
('DHAN', 0, 0)
ON CONFLICT (provider) DO NOTHING;
