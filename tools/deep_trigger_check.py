import os
import psycopg2
from dotenv import load_dotenv
load_dotenv()
from modules.portfolio.logic import get_db_connection

def deep_trigger_check():
    conn = get_db_connection()
    if not conn: return
    try:
        cur = conn.cursor()
        cur.execute("""
            SELECT tgname, tgenabled, tgtype
            FROM pg_trigger 
            WHERE tgrelid = 'trading.trades'::regclass
        """)
        rows = cur.fetchall()
        if rows:
            print("--- TRIGGERS ON trading.trades ---")
            for row in rows:
                print(f"Trigger: {row[0]}, Enabled: {row[1]}, Type: {row[2]}")
        else:
            print("No triggers found on trading.trades via pg_trigger.")
            
        print("\n--- DEPENDENCIES ON trading.trades ---")
        cur.execute("""
            SELECT objid::regclass, refobjid::regclass, deptype
            FROM pg_depend
            WHERE refobjid = 'trading.trades'::regclass
        """)
        for row in cur.fetchall():
            print(row)
    finally:
        conn.close()

if __name__ == "__main__":
    deep_trigger_check()
