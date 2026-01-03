"""
MODULE: PORTFOLIO COLLECTOR
===========================
Purpose:
  Syncs Trade and Portfolio data from various brokers (Zerodha, Dhan, etc.) to the database.
  Supports multiple accounts as defined in portfolio_rules.json.

Usage:
  Run daily (preferably during market hours or end-of-day).
"""

import os
import sys
import datetime
import traceback
import psycopg2
from psycopg2.extras import execute_batch
from dotenv import load_dotenv
from db_logger import EnterpriseLogger
from modules import notifier
import config
from modules.brokers import get_broker_client

# --- Config ---
load_dotenv()
logger = EnterpriseLogger("portfolio_collector")

# --- SQL Queries ---
# Note: Queries now include account_id

UPSERT_ORDER_SQL = """
    INSERT INTO trading.orders (
        order_id, exchange_order_id, symbol, exchange, txn_type, quantity, price, status, 
        order_timestamp, average_price, filled_quantity, variety, validity, product, tag, status_message, account_id
    )
    VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
    ON CONFLICT (order_id) DO UPDATE 
    SET status = EXCLUDED.status,
        filled_quantity = EXCLUDED.filled_quantity,
        average_price = EXCLUDED.average_price,
        order_timestamp = EXCLUDED.order_timestamp,
        status_message = EXCLUDED.status_message,
        account_id = EXCLUDED.account_id;
"""

UPSERT_HOLDING_SQL = """
    INSERT INTO trading.portfolio (
        date, symbol, total_quantity, average_price, invested_value, current_value, pnl, account_id
    )
    VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
    ON CONFLICT (date, symbol, account_id) DO UPDATE 
    SET total_quantity = EXCLUDED.total_quantity,
        average_price = EXCLUDED.average_price,
        invested_value = EXCLUDED.invested_value,
        current_value = EXCLUDED.current_value,
        pnl = EXCLUDED.pnl;
"""

UPSERT_POSITION_SQL = """
    INSERT INTO trading.positions (
        date, symbol, exchange, product, quantity, average_price, last_price, 
        pnl, m2m, realised, unrealised, value, account_id
    )
    VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
    ON CONFLICT (date, symbol, product, account_id) DO UPDATE 
    SET quantity = EXCLUDED.quantity,
        average_price = EXCLUDED.average_price,
        last_price = EXCLUDED.last_price,
        pnl = EXCLUDED.pnl,
        m2m = EXCLUDED.m2m,
        realised = EXCLUDED.realised,
        unrealised = EXCLUDED.unrealised,
        value = EXCLUDED.value;
"""

def get_db_connection():
    return psycopg2.connect(
        host=os.getenv("DB_HOST", "localhost"),
        database=os.getenv("DB_NAME"),
        user=os.getenv("DB_USER"),
        password=os.getenv("DB_PASS"),
        port=os.getenv("DB_PORT", "5432")
    )

def process_account(conn, user, acc_type, account_id, details):
    """
    Syncs data for a single account.
    """
    broker_name = details.get("broker")
    credential_id = details.get("credential_id")
    api_type = details.get("api_type")
    
    print(f"🔹 Processing {user} | {acc_type} ({broker_name})...")
    
    try:
        broker = get_broker_client(broker_name, credential_id)
        if not broker.login():
            print(f"⚠️ Login failed for {account_id}. Skipping.")
            return {"status": "failed", "msg": "Login Failed"}
            
        cur = conn.cursor()
        today = datetime.datetime.now().date()
        stats = {"orders": 0, "holdings": 0, "positions": 0}

        # 1. Orders
        if api_type == "trade_execution":
            orders = broker.get_orders()
            order_rows = []
            for o in orders:
                # Adapter should normalize, put explicit mapping if needed
                order_rows.append((
                    o.get('order_id'), o.get('exchange_order_id'), o.get('tradingsymbol'), o.get('exchange'),
                    o.get('transaction_type'), o.get('quantity'), o.get('price'), o.get('status'),
                    o.get('order_timestamp'), o.get('average_price'), o.get('filled_quantity'),
                    o.get('variety'), o.get('validity'), o.get('product'), o.get('tag'), o.get('status_message'),
                    account_id 
                ))
            if order_rows:
                execute_batch(cur, UPSERT_ORDER_SQL, order_rows)
                stats["orders"] = len(order_rows)

        # 2. Holdings
        holdings = broker.get_holdings()
        holding_rows = []
        for h in holdings:
            symbol = h.get('tradingsymbol')
            qty = h.get('quantity', 0)
            avg_price = h.get('average_price', 0)
            last_price = h.get('last_price', 0)
            pnl = h.get('pnl', 0)
            # Zerodha PnL calc
            invested = qty * avg_price
            current_val = qty * last_price
            
            holding_rows.append((
                today, symbol, qty, avg_price, invested, current_val, pnl, account_id
            ))
        if holding_rows:
            execute_batch(cur, UPSERT_HOLDING_SQL, holding_rows)
            stats["holdings"] = len(holding_rows)

        # 3. Positions
        positions = broker.get_positions()
        position_rows = []
        for p in positions:
            position_rows.append((
                today,
                p.get('tradingsymbol'),
                p.get('exchange'),
                p.get('product'),
                p.get('quantity', 0),
                p.get('average_price'),
                p.get('last_price'),
                p.get('pnl'),
                p.get('m2m'),
                p.get('realised'),
                p.get('unrealised'),
                p.get('value'),
                account_id
            ))
        if position_rows:
            execute_batch(cur, UPSERT_POSITION_SQL, position_rows)
            stats["positions"] = len(position_rows)

        conn.commit()
        return {"status": "success", "stats": stats}

    except Exception as e:
        conn.rollback()
        logger.log("error", f"Error processing {account_id}", exc_info=True)
        return {"status": "error", "msg": str(e)}

def main():
    start_time = datetime.datetime.now()
    logger.log("info", "Starting Portfolio Collection")
    print(f"🚀 Starting Multi-Broker Portfolio Collection at {start_time}")
    
    conn = None
    results = {}
    
    try:
        conn = get_db_connection()
        
        # Iterate over all operational accounts
        for user, acc_type, account_id, details in config.get_operational_accounts():
            res = process_account(conn, user, acc_type, account_id, details)
            results[account_id] = res
            
    except Exception as e:
        print(f"🔥 Critical Failure: {e}")
        logger.log("error", "Portfolio Collection Crashed", exc_info=True)
    finally:
        if conn: conn.close()
        
    # Summary
    success_count = sum(1 for k,v in results.items() if v['status'] == 'success')
    print(f"\n✅ Finished. Processed {len(results)} accounts. Success: {success_count}")
    
    # Notify
    summary = "\n".join([f"{k}: {v.get('status')} {v.get('stats', v.get('msg'))}" for k,v in results.items()])
    notifier.send_notification(
        "Portfolio Sync Report",
        summary,
        priority="default" if success_count == len(results) else "high"
    )

if __name__ == "__main__":
    main()
