import os
import sys
import json
import datetime
import traceback
import psycopg2
from psycopg2.extras import execute_batch
from kiteconnect import KiteConnect
from dotenv import load_dotenv
from db_logger import EnterpriseLogger
from modules import notifier
import config

# --- Config ---
load_dotenv()
API_KEY = os.getenv("KITE_API_KEY")

logger = EnterpriseLogger("portfolio_collector")

# --- SQL Queries ---
UPSERT_ORDER_SQL = """
    INSERT INTO trading.orders (
        order_id, exchange_order_id, symbol, exchange, txn_type, quantity, price, status, 
        order_timestamp, average_price, filled_quantity, variety, validity, product, tag, status_message
    )
    VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
    ON CONFLICT (order_id) DO UPDATE 
    SET status = EXCLUDED.status,
        filled_quantity = EXCLUDED.filled_quantity,
        average_price = EXCLUDED.average_price,
        order_timestamp = EXCLUDED.order_timestamp,
        status_message = EXCLUDED.status_message;
"""

UPSERT_HOLDING_SQL = """
    INSERT INTO trading.portfolio (
        date, symbol, total_quantity, average_price, invested_value, current_value, pnl
    )
    VALUES (%s, %s, %s, %s, %s, %s, %s)
    ON CONFLICT (date, symbol) DO UPDATE 
    SET total_quantity = EXCLUDED.total_quantity,
        average_price = EXCLUDED.average_price,
        invested_value = EXCLUDED.invested_value,
        current_value = EXCLUDED.current_value,
        pnl = EXCLUDED.pnl;
"""

UPSERT_POSITION_SQL = """
    INSERT INTO trading.positions (
        date, symbol, exchange, product, quantity, average_price, last_price, 
        pnl, m2m, realised, unrealised, value
    )
    VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
    ON CONFLICT (date, symbol, product) DO UPDATE 
    SET quantity = EXCLUDED.quantity,
        average_price = EXCLUDED.average_price,
        last_price = EXCLUDED.last_price,
        pnl = EXCLUDED.pnl,
        m2m = EXCLUDED.m2m,
        realised = EXCLUDED.realised,
        unrealised = EXCLUDED.unrealised,
        value = EXCLUDED.value;
"""

def load_kite_session() -> KiteConnect:
    try:
        with open(config.TOKENS_FILE, "r") as f:
            tokens = json.load(f)
        kite = KiteConnect(api_key=API_KEY)
        kite.set_access_token(tokens["access_token"])
        return kite
    except Exception as e:
        logger.log("error", "Session Load Failed", exc_info=True)
        raise e

def get_db_connection():
    return psycopg2.connect(
        host=os.getenv("DB_HOST"),
        database=os.getenv("DB_NAME"),
        user=os.getenv("DB_USER"),
        password=os.getenv("DB_PASS")
    )

def main():
    start_time = datetime.datetime.now()
    logger.log("info", "Starting Portfolio Collection")
    print(f"🚀 Starting Portfolio Collection at {start_time}")
    
    conn = None
    try:
        kite = load_kite_session()
        conn = get_db_connection()
        cur = conn.cursor()
        
        today = datetime.datetime.now().date()
        
        # 1. Fetch & Save Orders
        print("📦 Fetching Orders...")
        orders = kite.orders()
        order_rows = []
        for o in orders:
            order_rows.append((
                o.get('order_id'), o.get('exchange_order_id'), o.get('tradingsymbol'), o.get('exchange'),
                o.get('transaction_type'), o.get('quantity'), o.get('price'), o.get('status'),
                o.get('order_timestamp'), o.get('average_price'), o.get('filled_quantity'),
                o.get('variety'), o.get('validity'), o.get('product'), o.get('tag'), o.get('status_message')
            ))
            
        if order_rows:
            execute_batch(cur, UPSERT_ORDER_SQL, order_rows)
            conn.commit()
            print(f"✅ Saved {len(order_rows)} orders.")
        else:
            print("ℹ️ No orders found.")

        # 2. Fetch & Save Holdings
        print("💼 Fetching Holdings...")
        holdings = kite.holdings()
        holding_rows = []
        for h in holdings:
            symbol = h.get('tradingsymbol')
            qty = h.get('quantity', 0)
            avg_price = h.get('average_price', 0)
            last_price = h.get('last_price', 0)
            pnl = h.get('pnl', 0)
            
            invested = qty * avg_price
            current_val = qty * last_price
            
            holding_rows.append((
                today, symbol, qty, avg_price, invested, current_val, pnl
            ))
            
        if holding_rows:
            execute_batch(cur, UPSERT_HOLDING_SQL, holding_rows)
            conn.commit()
            print(f"✅ Saved {len(holding_rows)} holdings.")
        else:
            print("ℹ️ No holdings found.")

        # 3. Fetch & Save Positions (Net)
        print("📊 Fetching Positions...")
        positions_response = kite.positions()
        net_positions = positions_response.get('net', [])
        
        position_rows = []
        for p in net_positions:
            qty = p.get('quantity', 0)
            # if qty == 0: continue # Optional: skip closed positions? keeping for now.
            
            position_rows.append((
                today,
                p.get('tradingsymbol'),
                p.get('exchange'),
                p.get('product'),
                qty,
                p.get('average_price'),
                p.get('last_price'),
                p.get('pnl'),
                p.get('m2m'),
                p.get('realised'),
                p.get('unrealised'),
                p.get('value')
            ))
            
        if position_rows:
            execute_batch(cur, UPSERT_POSITION_SQL, position_rows)
            conn.commit()
            print(f"✅ Saved {len(position_rows)} positions.")
        else:
            print("ℹ️ No positions found.")

        # Initialize notifier string
        summary = f"Orders: {len(order_rows)}\nHoldings: {len(holding_rows)}\nPositions: {len(position_rows)}"
        
        logger.log("info", "Portfolio Collection Complete", orders=len(order_rows), holdings=len(holding_rows))
        notifier.send_notification("Portfolio Sync Success", summary)
        
    except Exception as e:
        error_msg = str(e)
        print(f"❌ Error: {error_msg}")
        traceback.print_exc()
        logger.log("error", "Portfolio Collection Failed", exc_info=True)
        notifier.send_notification("Portfolio Sync Failed", f"Error: {error_msg}", priority="high")
    finally:
        if conn:
            conn.close()

if __name__ == "__main__":
    main()
