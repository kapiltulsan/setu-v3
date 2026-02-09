-- Migration 019: Expand NSE Historical Data Tables
-- Created: Jan 2026

-- 1. Expand market_data_daily table
ALTER TABLE ohlc.market_data_daily
ADD COLUMN IF NOT EXISTS prev_close DOUBLE PRECISION,
ADD COLUMN IF NOT EXISTS last_price DOUBLE PRECISION,
ADD COLUMN IF NOT EXISTS avg_price DOUBLE PRECISION,
ADD COLUMN IF NOT EXISTS turnover_lacs DOUBLE PRECISION,
ADD COLUMN IF NOT EXISTS no_of_trades BIGINT;

-- 2. Expand indices_daily table
ALTER TABLE ohlc.indices_daily
ADD COLUMN IF NOT EXISTS points_change DOUBLE PRECISION,
ADD COLUMN IF NOT EXISTS change_pct DOUBLE PRECISION,
ADD COLUMN IF NOT EXISTS turnover_cr DOUBLE PRECISION;

-- 3. Clear existing data to allow full refill with complete columns
TRUNCATE TABLE ohlc.market_data_daily;
TRUNCATE TABLE ohlc.indices_daily;
