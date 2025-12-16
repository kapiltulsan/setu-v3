-- Migration: Add Portfolio and Trade Tables
-- Description: Adds tables for storing raw trades, historical portfolio snapshots, and daily P&L.

-- 1. Trades Table (Raw Execution)
CREATE TABLE IF NOT EXISTS trading.trades (
    id SERIAL PRIMARY KEY,
    symbol TEXT NOT NULL,
    exchange TEXT DEFAULT 'NSE',
    trade_date TIMESTAMP WITH TIME ZONE NOT NULL,
    txn_type TEXT NOT NULL CHECK (txn_type IN ('BUY', 'SELL')),
    quantity NUMERIC(14,4) NOT NULL,
    price NUMERIC(14,4) NOT NULL,
    fees NUMERIC(14,4) DEFAULT 0,
    net_amount NUMERIC(14,4) NOT NULL,
    source TEXT DEFAULT 'MANUAL', -- ZERODHA, SMALLCASE, MANUAL
    external_trade_id TEXT,       -- Broker's Trade ID
    order_id TEXT,                -- Broker's Order ID
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Index for faster querying by symbol and date
CREATE INDEX IF NOT EXISTS idx_trades_symbol_date ON trading.trades (symbol, trade_date);
CREATE INDEX IF NOT EXISTS idx_trades_date ON trading.trades (trade_date);


-- 2. Portfolio Table (Historical Snapshots)
CREATE TABLE IF NOT EXISTS trading.portfolio (
    id SERIAL PRIMARY KEY,
    date DATE NOT NULL,
    symbol TEXT NOT NULL,
    total_quantity NUMERIC(14,4) NOT NULL,
    average_price NUMERIC(14,4) NOT NULL,
    invested_value NUMERIC(14,4) NOT NULL,
    current_value NUMERIC(14,4), -- Updated via jobs/market data
    pnl NUMERIC(14,4),           -- Unrealized P&L
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(date, symbol)
);

-- Index for retrieving specific day's portfolio
CREATE INDEX IF NOT EXISTS idx_portfolio_date ON trading.portfolio (date);


-- 3. Daily P&L Table (Summary)
CREATE TABLE IF NOT EXISTS trading.daily_pnl (
    id SERIAL PRIMARY KEY,
    date DATE NOT NULL UNIQUE,
    realized_pnl NUMERIC(14,4) DEFAULT 0,
    unrealized_pnl NUMERIC(14,4) DEFAULT 0,
    charges NUMERIC(14,4) DEFAULT 0,
    net_pnl NUMERIC(14,4) DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
