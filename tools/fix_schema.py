import os
import psycopg2
from dotenv import load_dotenv
load_dotenv()
from modules.portfolio.logic import get_db_connection

def fix():
    conn = get_db_connection()
    if not conn: return
    try:
        cur = conn.cursor()
        
        # Check if transaction_type exists
        cur.execute("""
            SELECT 1 FROM information_schema.columns 
            WHERE table_schema = 'trading' AND table_name = 'trades' AND column_name = 'transaction_type'
        """)
        has_old = cur.fetchone()
        
        # Check if txn_type exists
        cur.execute("""
            SELECT 1 FROM information_schema.columns 
            WHERE table_schema = 'trading' AND table_name = 'trades' AND column_name = 'txn_type'
        """)
        has_new = cur.fetchone()
        
        if has_old:
            if not has_new:
                print("Renaming transaction_type to txn_type...")
                cur.execute("ALTER TABLE trading.trades RENAME COLUMN transaction_type TO txn_type")
            else:
                print("Both columns exist. Merging data and dropping transaction_type...")
                cur.execute("UPDATE trading.trades SET txn_type = transaction_type WHERE txn_type IS NULL")
                cur.execute("ALTER TABLE trading.trades DROP COLUMN transaction_type")
        elif not has_new:
             print("Neither transaction_type nor txn_type found. This is problematic.")
        
        # Ensure txn_type is NOT NULL
        print("Ensuring txn_type is NOT NULL...")
        # Check current nulls
        cur.execute("UPDATE trading.trades SET txn_type = 'BUY' WHERE txn_type IS NULL")
        cur.execute("ALTER TABLE trading.trades ALTER COLUMN txn_type SET NOT NULL")

        # Handle legacy NO NULL columns
        for col in ['holder_name', 'strategy_name', 'product_type']:
            print(f"Making {col} nullable if exists...")
            try:
                cur.execute(f"ALTER TABLE trading.trades ALTER COLUMN {col} DROP NOT NULL")
            except:
                pass
        
        conn.commit()
        print("Schema fixed.")
    except Exception as e:
        print(f"Error: {e}")
        conn.rollback()
    finally:
        conn.close()

if __name__ == "__main__":
    fix()
