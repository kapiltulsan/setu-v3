
import os
import sys
import pandas as pd
from dotenv import load_dotenv
import psycopg2
from psycopg2.extras import RealDictCursor

load_dotenv()

from modules.scanner_engine import get_db_connection

conn = get_db_connection()
if conn:
    with conn.cursor() as cur:
        with open("debug_results.txt", "w") as f:
            f.write("--- Checking for NIFTY symbols in ohlc.candles_1d ---\n")
            cur.execute("SELECT DISTINCT symbol FROM ohlc.candles_1d WHERE symbol ILIKE '%NIFTY%' LIMIT 50")
            rows = cur.fetchall()
            for r in rows:
                f.write(f"{r}\n")
            
            f.write("\n--- Checking specific count for 'NIFTY 50' ---\n")
            cur.execute("SELECT count(*) FROM ohlc.candles_1d WHERE symbol = 'NIFTY 50'")
            cnt = cur.fetchone()[0]
            f.write(f"Count for 'NIFTY 50': {cnt}\n")

            f.write("\n--- Checking specific count for 'Nifty 50' ---\n")
            cur.execute("SELECT count(*) FROM ohlc.candles_1d WHERE symbol = 'Nifty 50'")
            cnt = cur.fetchone()[0]
            f.write(f"Count for 'Nifty 50': {cnt}\n")

            f.write("\n--- Checking constituents for 'NIFTY 50' in ref.index_mapping ---\n")
            cur.execute("SELECT stock_symbol FROM ref.index_mapping WHERE index_name = 'NIFTY 50' LIMIT 10")
            rows = cur.fetchall()
            f.write(f"Constituents count: {len(rows)} (limit 10)\n")
            f.write(f"Sample: {rows}\n")
    conn.close()
