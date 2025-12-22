import os
import psycopg2
from dotenv import load_dotenv

load_dotenv()

DB_HOST = os.getenv("DB_HOST")
DB_NAME = os.getenv("DB_NAME")
DB_USER = os.getenv("DB_USER")
DB_PASS = os.getenv("DB_PASS")

SQL_COMMANDS = [
    """
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
    """,
    """
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
    """
]

def apply_migration():
    try:
        conn = psycopg2.connect(
            host=DB_HOST,
            database=DB_NAME,
            user=DB_USER,
            password=DB_PASS
        )
        cur = conn.cursor()
        
        print("🚀 Applying Migration 005: Create Order and Positions tables...")
        
        for sql in SQL_COMMANDS:
            cur.execute(sql)
            
        conn.commit()
        print("✅ Migration Successful!")
        
        cur.close()
        conn.close()
        
    except Exception as e:
        print(f"❌ Migration Failed: {e}")

if __name__ == "__main__":
    apply_migration()
