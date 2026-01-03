import os
import psycopg2
from dotenv import load_dotenv
load_dotenv()
from modules.portfolio.logic import get_db_connection

def inspect():
    conn = get_db_connection()
    if not conn: return
    try:
        cur = conn.cursor()
        print("--- COLUMNS ---")
        cur.execute("""
            SELECT a.attname, format_type(a.atttypid, a.atttypmod) AS type,
                   a.attnotnull,
                   (SELECT substring(pg_get_expr(d.adbin, d.adrelid) for 128)
                    FROM pg_attrdef d
                    WHERE d.adrelid = a.attrelid AND d.adnum = a.attnum AND a.atthasdef) AS default
            FROM pg_attribute a
            WHERE a.attrelid = 'trading.trades'::regclass
              AND a.attnum > 0
              AND NOT a.attisdropped
            ORDER BY a.attnum
        """)
        for row in cur.fetchall():
            print(f"{row[0]}: {row[1]}, NOT NULL: {row[2]}, Default: {row[3]}")
    finally:
        conn.close()

if __name__ == "__main__":
    inspect()
