import os
import pandas as pd
import psycopg2
from psycopg2.extras import RealDictCursor, execute_values
from datetime import datetime
from db_logger import EnterpriseLogger

logger = EnterpriseLogger("mod_portfolio")

DB_HOST = os.getenv("DB_HOST", "localhost")
DB_NAME = os.getenv("DB_NAME")
DB_USER = os.getenv("DB_USER")
DB_PASS = os.getenv("DB_PASS")

def get_db_connection():
    try:
        return psycopg2.connect(host=DB_HOST, database=DB_NAME, user=DB_USER, password=DB_PASS)
    except Exception as e:
        logger.log("error", "DB Connection Failed", error=str(e))
        return None

def process_zerodha_file(file_obj):
    """
    Parse Zerodha Tradebook CSV and insert into DB.
    """
    conn = None
    try:
        df = pd.read_csv(file_obj)
        
        # basic validation
        required_cols = ['symbol', 'exchange', 'trade_date', 'type', 'quantity', 'price', 'order_id', 'trade_id']
        missing = [col for col in required_cols if col not in df.columns]
        if missing:
            # Try mapping common variations if needed, or fail
            return False, f"Missing columns: {missing}"

        # Clean and Prepare Data
        trades_to_insert = []
        for _, row in df.iterrows():
            # Zerodha format expected: 
            # symbol, exchange, trade_date (YYYY-MM-DD), type (buy/sell), quantity, price, order_id, trade_id
            
            try:
                # Parse Date (Handle various formats if needed)
                date_str = str(row['trade_date'])
                # Attempt standard format ISO
                trade_dt = pd.to_datetime(date_str).to_pydatetime()
                
                txn_type = str(row['type']).strip().upper() # BUY/SELL
                
                trades_to_insert.append((
                    row['symbol'],
                    row['exchange'],
                    trade_dt,
                    txn_type,
                    abs(float(row['quantity'])),
                    float(row['price']),
                    0.0, # fees (not always in tradebook, default 0)
                    float(row['quantity']) * float(row['price']),
                    'ZERODHA',
                    str(row['trade_id']),
                    str(row['order_id'])
                ))
            except Exception as e:
                logger.log("error", "Row parse error", error=str(e), row=row.to_dict())
                continue
        
        if not trades_to_insert:
             return False, "No valid trades found to insert."

        conn = get_db_connection()
        cur = conn.cursor()
        
        # Bulk Insert
        insert_sql = """
            INSERT INTO trading.trades 
            (symbol, exchange, trade_date, txn_type, quantity, price, fees, net_amount, source, external_trade_id, order_id)
            VALUES %s
        """
        execute_values(cur, insert_sql, trades_to_insert)
        conn.commit()
        
        # Trigger Portfolio Recalculation (Async or Sync? Sync for now)
        recalc_success, recalc_msg = calculate_portfolio()
        
        return True, f"Imported {len(trades_to_insert)} trades. {recalc_msg}"

    except Exception as e:
        logger.log("error", "Zerodha Upload Failed", error=str(e), exc_info=True)
        return False, str(e)
    finally:
        if conn: conn.close()

def process_smallcase_file(file_obj):
    """
    Parse Smallcase Orders CSV.
    Smallcase logic is trickier. Assuming 'Orders' export.
    """
    return False, "Smallcase import not yet implemented (waiting for file sample)"

def calculate_portfolio():
    """
    Replay all trades to build Historial Portfolio and P&L.
    Simple approach: Delete all portfolio entries and rebuild from scratch (safe).
    """
    conn = None
    try:
        conn = get_db_connection()
        cur = conn.cursor()
        
        # 1. Fetch all trades sorted by date
        cur.execute("SELECT * FROM trading.trades ORDER BY trade_date ASC")
        trades = cur.fetchall() # RealDictCursor not used here, standard tuples usually
        
        # We need RealDictCursor for easier handling or just map indexing
        # Let's re-fetch with dict cursor to be safe
        cur.close()
        cur = conn.cursor(cursor_factory=RealDictCursor)
        cur.execute("SELECT * FROM trading.trades ORDER BY trade_date ASC, id ASC")
        trades = cur.fetchall()
        
        # In-memory Portfolio State: { symbol: { qty: 0, avg_price: 0, invested: 0 } }
        # We also need to store 'Daily States' to write to DB
        
        holdings = {} 
        
        # Clean current portfolio table to rebuild?
        # Maybe just truncate for now as we are doing full rebuild
        cur.execute("TRUNCATE TABLE trading.portfolio")
        
        for trade in trades:
            sym = trade['symbol']
            qty = float(trade['quantity'])
            price = float(trade['price'])
            txn = trade['txn_type'] # BUY / SELL
            
            if sym not in holdings:
                holdings[sym] = {'qty': 0.0, 'invested': 0.0}
            
            if txn == 'BUY':
                holdings[sym]['qty'] += qty
                holdings[sym]['invested'] += (qty * price)
            elif txn == 'SELL':
                # FIFO / Average Price Logic for P&L?
                # For weighted average price tracking:
                # When selling, we reduce Qty and Invested Amount proportionally?
                # Or do we keep Invested Amount based on Avg Price?
                
                # Standard Avg Price Method:
                # Sell reduces Qty. Invested Value reduces by (Sell Qty * current Avg Price)
                # Realized P&L = (Sell Price - Avg Price) * Sell Qty
                
                current_qty = holdings[sym]['qty']
                if current_qty > 0:
                    avg_price = holdings[sym]['invested'] / current_qty
                    
                    # Reduce invested value
                    cost_of_sold = qty * avg_price
                    holdings[sym]['invested'] -= cost_of_sold
                    holdings[sym]['qty'] -= qty
                    
                    # Store Realized P&L somewhere? (Not implementing daily_pnl detail yet)
                else:
                    # Short selling or data error
                    pass
            
            # Remove dust
            if holdings[sym]['qty'] <= 0.0001:
                holdings[sym]['qty'] = 0
                holdings[sym]['invested'] = 0
                
        # Bulk Insert Current Snapshot (As if "Today")
        # In a real historical system, we would insert for EACH date.
        # For this MVP, let's just create the "Current" view in `trading.portfolio` 
        # but the table struct has 'date'. We can insert with today's date.
        
        today = datetime.now().strftime('%Y-%m-%d')
        items = []
        for sym, data in holdings.items():
            if data['qty'] > 0:
                avg = data['invested'] / data['qty']
                items.append((
                    today,
                    sym,
                    data['qty'],
                    avg,
                    data['invested'],
                    0, # Current Value (unknown, jobs will update)
                    0  # Unrelized PnL (unknown)
                ))
        
        if items:
            insert_port_sql = """
                INSERT INTO trading.portfolio 
                (date, symbol, total_quantity, average_price, invested_value, current_value, pnl)
                VALUES %s
                ON CONFLICT (date, symbol) DO UPDATE
                SET total_quantity=EXCLUDED.total_quantity,
                    average_price=EXCLUDED.average_price,
                    invested_value=EXCLUDED.invested_value;
            """
            execute_values(cur, insert_port_sql, items)
        
        conn.commit()
        return True, "Portfolio recalculated successfully."
        
    except Exception as e:
        logger.log("error", "Portfolio Calc Failed", error=str(e), exc_info=True)
        if conn: conn.rollback()
        return False, str(e)
    finally:
        if conn: conn.close()

def get_portfolio_summary():
    conn = get_db_connection()
    if not conn: return []
    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            # Get latest available portfolio state
            cur.execute("""
                SELECT * FROM trading.portfolio 
                WHERE date = (SELECT MAX(date) FROM trading.portfolio)
                ORDER BY symbol
            """)
            return cur.fetchall()
    finally:
        conn.close()

def get_pnl_summary():
    return {} # TODO

