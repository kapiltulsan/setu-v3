import os
import psycopg2
from dotenv import load_dotenv
load_dotenv()
from modules.portfolio.logic import get_db_connection

def exhaustive_check():
    conn = get_db_connection()
    if not conn: return
    try:
        cur = conn.cursor()
        print("--- ALL COLUMNS IN trading.trades ---")
        cur.execute("""
            SELECT column_name, ordinal_position, is_nullable, column_default
            FROM information_schema.columns 
            WHERE table_schema = 'trading' AND table_name = 'trades'
            ORDER BY ordinal_position
        """)
        for row in cur.fetchall():
            print(f"{row[1]}. {row[0]} (Nullable: {row[2]}, Default: {row[3]})")
            
        print("\n--- CHECKING FOR transaction_type EVERYWHERE ---")
        cur.execute("""
            SELECT table_schema, table_name, column_name, is_nullable
            FROM information_schema.columns 
            WHERE column_name = 'transaction_type'
        """)
        results = cur.fetchall()
        if results:
            for r in results:
                print(f"Found in {r[0]}.{r[1]} (Nullable: {r[3]})")
        else:
            print("Not found anywhere.")
            
    finally:
        conn.close()

if __name__ == "__main__":
    exhaustive_check()
