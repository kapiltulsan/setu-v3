CREATE TABLE IF NOT EXISTS trading.orders (
    order_id TEXT PRIMARY KEY,
    exchange_order_id TEXT,
    symbol TEXT NOT NULL,
    exchange TEXT,
    txn_type TEXT,
    quantity INTEGER,
    price NUMERIC(14,4),
    status TEXT,
    order_timestamp TIMESTAMP WITH TIME ZONE,
    average_price NUMERIC(14,4),
    filled_quantity INTEGER,
    variety TEXT,
    validity TEXT,
    product TEXT,
    tag TEXT,
    status_message TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS trading.positions (
    id SERIAL PRIMARY KEY,
    date DATE NOT NULL,
    symbol TEXT NOT NULL,
    exchange TEXT,
    product TEXT,
    quantity INTEGER,
    average_price NUMERIC(14,4),
    last_price NUMERIC(14,4),
    pnl NUMERIC(14,4),
    m2m NUMERIC(14,4),
    realised NUMERIC(14,4),
    unrealised NUMERIC(14,4),
    value NUMERIC(14,4),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(date, symbol, product)
);
