import os
import psycopg2
from dotenv import load_dotenv
load_dotenv()
from modules.portfolio.logic import get_db_connection

def check_advanced():
    conn = get_db_connection()
    if not conn: return
    try:
        cur = conn.cursor()
        
        # 1. Check if it's a hypertable
        print("--- TIMESCALEDB HYPERTABLE CHECK ---")
        try:
            cur.execute("SELECT * FROM _timescaledb_catalog.hypertable WHERE table_name = 'trades'")
            res = cur.fetchall()
            if res:
                print(f"Table 'trades' IS a hypertable.")
            else:
                print("Table 'trades' is NOT a hypertable.")
        except:
            print("TimescaleDB catalog not found or accessible.")

        # 2. Check for RULES (pg_rewrite)
        print("\n--- RULES CHECK (pg_rewrite) ---")
        cur.execute("""
            SELECT rulename, definition 
            FROM pg_rules 
            WHERE tablename = 'trades' AND schemaname = 'trading'
        """)
        rules = cur.fetchall()
        if rules:
            for r in rules:
                print(f"Rule: {r[0]}, Def: {r[1]}")
        else:
            print("No rules found.")
            
        # 3. Check for TRIGGERS (raw check)
        print("\n--- RAW TRIGGER CHECK ---")
        cur.execute("""
            SELECT tgname 
            FROM pg_trigger 
            WHERE tgrelid = 'trading.trades'::regclass
        """)
        triggers = cur.fetchall()
        for t in triggers:
            print(f"Trigger: {t[0]}")

    finally:
        conn.close()

if __name__ == "__main__":
    check_advanced()
