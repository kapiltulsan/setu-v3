import os
import psycopg2
from dotenv import load_dotenv
load_dotenv()
from modules.portfolio.logic import get_db_connection

def clean_fix():
    conn = get_db_connection()
    if not conn:
        print("Failed to connect to DB.")
        return
        
    try:
        cur = conn.cursor()
        
        # 1. Drop existing table
        print("Dropping trading.trades (CASCADE)...")
        cur.execute("DROP TABLE IF EXISTS trading.trades CASCADE")
        
        # 2. Re-create table using official DDL
        print("Re-creating trading.trades...")
        cur.execute("""
            CREATE TABLE trading.trades (
                trade_id bigserial NOT NULL,
                broker_order_id text NULL,
                symbol text NOT NULL,
                exchange_code text DEFAULT 'NSE'::text NULL,
                quantity int4 NOT NULL,
                price numeric(14, 4) NOT NULL,
                trade_date timestamptz DEFAULT now() NULL,
                holder_name text DEFAULT 'Primary'::text NULL,
                strategy_name text DEFAULT 'Manual'::text NULL,
                created_at timestamptz DEFAULT now() NULL,
                broker_name text DEFAULT 'Zerodha'::text NULL,
                isin text NULL,
                product_type text DEFAULT 'CNC'::text NULL,
                total_charges numeric(10, 2) DEFAULT 0 NULL,
                net_amount numeric(14, 2) NULL,
                currency text DEFAULT 'INR'::text NULL,
                notes text NULL,
                account_id text DEFAULT 'default'::text NULL,
                exchange text NULL,
                txn_type text NOT NULL,
                fees numeric DEFAULT 0 NULL,
                "source" text NULL,
                external_trade_id text NULL,
                order_id text NULL,
                segment text NULL,
                series text NULL,
                CONSTRAINT check_prod_type CHECK ((product_type = ANY (ARRAY['CNC'::text, 'MIS'::text, 'NRML'::text, 'CO'::text]))),
                CONSTRAINT trades_external_trade_id_source_key UNIQUE (external_trade_id, source),
                CONSTRAINT trades_pkey PRIMARY KEY (trade_id),
                CONSTRAINT trades_zerodha_order_id_key UNIQUE (broker_order_id)
            )
        """)
        
        # 3. Create Indexes
        print("Creating indexes...")
        cur.execute("CREATE INDEX idx_trades_account_id ON trading.trades USING btree (account_id)")
        cur.execute("CREATE INDEX idx_trades_date ON trading.trades USING btree (trade_date)")
        cur.execute("CREATE INDEX idx_trades_symbol_date ON trading.trades USING btree (symbol, trade_date)")
        cur.execute("CREATE INDEX ix_trades_strategy ON trading.trades USING btree (strategy_name)")
        cur.execute("CREATE INDEX ix_trades_symbol ON trading.trades USING btree (symbol)")
        
        conn.commit()
        print("Success: Table trading.trades re-created successfully.")
        
    except Exception as e:
        conn.rollback()
        print(f"Error: {e}")
    finally:
        conn.close()

if __name__ == "__main__":
    clean_fix()
