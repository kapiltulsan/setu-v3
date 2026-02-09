-- Migration 018: Add NSE Historical Data Tables
-- Created: Jan 2026

-- 1. Create market_data_daily table
CREATE TABLE IF NOT EXISTS ohlc.market_data_daily (
    symbol TEXT NOT NULL,
    trade_date DATE NOT NULL,
    series TEXT,
    open_price DOUBLE PRECISION,
    high_price DOUBLE PRECISION,
    low_price DOUBLE PRECISION,
    close_price DOUBLE PRECISION,
    volume BIGINT,
    delivery_qty BIGINT,
    delivery_pct DOUBLE PRECISION,
    PRIMARY KEY (symbol, trade_date)
);

-- 2. Create indices_daily table
CREATE TABLE IF NOT EXISTS ohlc.indices_daily (
    index_name TEXT NOT NULL,
    trade_date DATE NOT NULL,
    open_value DOUBLE PRECISION,
    high_value DOUBLE PRECISION,
    low_value DOUBLE PRECISION,
    close_value DOUBLE PRECISION,
    volume BIGINT,
    pe_ratio DOUBLE PRECISION,
    pb_ratio DOUBLE PRECISION,
    div_yield DOUBLE PRECISION,
    PRIMARY KEY (index_name, trade_date)
);

-- Note: Using BIGINT for volume/delivery_qty to handle values > 2.1bn.
