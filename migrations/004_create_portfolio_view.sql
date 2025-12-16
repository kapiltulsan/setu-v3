-- Migration: Create Portfolio View for Data Collector
-- Description: Creates a view 'trading.portfolio_view' that data_collector.py relies on.
-- Use the latest snapshot from trading.portfolio.

DROP VIEW IF EXISTS trading.portfolio_view CASCADE;

CREATE OR REPLACE VIEW trading.portfolio_view AS
SELECT 
    symbol,
    total_quantity as net_quantity,
    average_price,
    invested_value,
    current_value,
    pnl,
    date as snapshot_date
FROM trading.portfolio
WHERE date = (SELECT MAX(date) FROM trading.portfolio);
