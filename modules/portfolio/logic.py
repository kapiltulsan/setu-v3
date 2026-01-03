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

def get_csv_mapping(source):
    """Fetch column mappings for a specific broker source from DB."""
    conn = get_db_connection()
    if not conn: return {}
    try:
        cur = conn.cursor(cursor_factory=RealDictCursor)
        cur.execute("SELECT csv_column, db_column, data_type, is_required FROM sys.csv_mappings WHERE provider = %s", (source,))
        rows = cur.fetchall()
        
        mapping = {row['csv_column']: row['db_column'] for row in rows}
        required = [row['db_column'] for row in rows if row['is_required']]
        return mapping, required
    finally:
        conn.close()

def get_all_csv_mappings(provider=None):
    """Fetch all mappings grouped by provider."""
    conn = get_db_connection()
    if not conn: return {}
    try:
        cur = conn.cursor(cursor_factory=RealDictCursor)
        if provider:
            cur.execute("SELECT * FROM sys.csv_mappings WHERE provider = %s ORDER BY db_column", (provider,))
        else:
            cur.execute("SELECT * FROM sys.csv_mappings ORDER BY provider, db_column")
        rows = cur.fetchall()
        
        # Group by provider
        grouped = {}
        for row in rows:
            prov = row['provider']
            if prov not in grouped: grouped[prov] = []
            grouped[prov].append(row)
        
        if provider:
            return grouped.get(provider, [])
        return grouped
    finally:
        conn.close()

def upsert_csv_mapping(provider, csv_col, db_col, is_required=True, data_type='text'):
    """Insert or Update a mapping."""
    conn = get_db_connection()
    if not conn: return False, "DB Connection Failed"
    try:
        cur = conn.cursor()
        sql = """
            INSERT INTO sys.csv_mappings (provider, csv_column, db_column, is_required, data_type)
            VALUES (%s, %s, %s, %s, %s)
            ON CONFLICT (provider, db_column) 
            DO UPDATE SET csv_column = EXCLUDED.csv_column, is_required = EXCLUDED.is_required
        """
        cur.execute(sql, (provider, csv_col, db_col, is_required, data_type))
        conn.commit()
        return True, "Mapping saved."
    except Exception as e:
        logger.log("error", "Mapping Upsert Failed", error=str(e))
        return False, str(e)
    finally:
        conn.close()

def process_zerodha_file(file_obj, account_id, source='ZERODHA'):
    return process_tradebook_file(file_obj, account_id, source)

def get_broker_config(provider):
    """Fetch skip_rows etc for a provider."""
    conn = get_db_connection()
    if not conn: return {'skip_rows': 0, 'header_row': 0, 'skip_cols': 0}
    try:
        cur = conn.cursor(cursor_factory=RealDictCursor)
        cur.execute("SELECT * FROM sys.broker_configs WHERE provider = %s", (provider,))
        row = cur.fetchone()
        return row if row else {'skip_rows': 0, 'header_row': 0, 'skip_cols': 0}
    finally:
        conn.close()

def upsert_broker_config(provider, skip_rows=0, header_row=0, skip_cols=0):
    """Update broker config."""
    conn = get_db_connection()
    if not conn: return False
    try:
        cur = conn.cursor()
        sql = """
            INSERT INTO sys.broker_configs (provider, skip_rows, header_row, skip_cols)
            VALUES (%s, %s, %s, %s)
            ON CONFLICT (provider) DO UPDATE 
            SET skip_rows = EXCLUDED.skip_rows, 
                header_row = EXCLUDED.header_row, 
                skip_cols = EXCLUDED.skip_cols,
                updated_at = CURRENT_TIMESTAMP
        """
        cur.execute(sql, (provider, skip_rows, header_row, skip_cols))
        conn.commit()
        return True
    finally:
        conn.close()

def preview_csv_file(file_obj, skip_rows=0, skip_cols=0):
    """
    Read CSV and return headers and first 3 rows.
    """
    try:
        # Reset file pointer
        file_obj.seek(0)
        
        # Read with skip rows
        df = pd.read_csv(file_obj, skiprows=skip_rows, nrows=3, dtype=str)
        
        # Drop first N columns
        if skip_cols > 0:
            df = df.iloc[:, skip_cols:]
        
        headers = list(df.columns)
        samples = df.to_dict(orient='records')
        
        return {'headers': headers, 'samples': samples}
    except Exception as e:
        return {'error': str(e)}

def process_tradebook_file(file_obj, account_id, source):
    """
    Parse Tradebook CSV and insert into DB using dynamic mappings.
    """
    conn = None
    try:
        # 0. Fetch Config
        config = get_broker_config(source)
        skip_rows = config.get('skip_rows', 0)
        skip_cols = config.get('skip_cols', 0)
        
        # Fetch Mappings
        col_map, required_db_cols = get_csv_mapping(source)
        if not col_map:
             return False, f"No CSV mappings found for broker: {source}"

        # 1. Read CSV (treat all as string initially to avoid type issues)
        file_obj.seek(0) # Ensure start
        df = pd.read_csv(file_obj, skiprows=skip_rows, dtype=str)
        
        # Drop Columns
        if skip_cols > 0:
             df = df.iloc[:, skip_cols:]

        # 2. Rename Columns (CSV Header -> DB Column)
        # Normalize CSV columns to handle case sensitivity (e.g. 'Symbol' vs 'symbol')
        df_cols_norm = {c.strip(): c for c in df.columns}
        rename_dict = {}
        
        for csv_col, db_col in col_map.items():
            # Try exact match first, then case-insensitive
            if csv_col in df.columns:
                rename_dict[csv_col] = db_col
            elif csv_col.strip() in df_cols_norm:
                 rename_dict[df_cols_norm[csv_col.strip()]] = db_col
            else:
                pass
                
        df.rename(columns=rename_dict, inplace=True)
               
        # 3. Validation
        missing = [col for col in required_db_cols if col not in df.columns]
        if missing:
            return False, f"Missing required columns for {source}: {missing}. Found: {list(df.columns)}"

        # 4. Process Rows
        trades_to_insert = []
        for _, row in df.iterrows():
            try:
                # Parse Date (Flexible)
                date_str = str(row['trade_date'])
                try:
                    trade_dt = pd.to_datetime(date_str).to_pydatetime()
                except:
                    trade_dt = datetime.now() 
                
                # Parse Numbers
                qty = abs(float(row['quantity']))
                price = float(row['price'])
                
                # Check for IDs (handle NaN/None)
                ext_trade_id = str(row.get('external_trade_id', ''))
                order_id = str(row.get('order_id', ''))
                
                # New Fields
                isin = str(row.get('isin', ''))
                segment = str(row.get('segment', ''))
                series = str(row.get('series', ''))
                if isin == 'nan': isin = ''
                if segment == 'nan': segment = ''
                if series == 'nan': series = ''

                # Fix Transaction Type
                raw_txn = str(row.get('txn_type', '')).strip().upper()
                txn_type = 'BUY' if raw_txn in ['BUY', 'B'] else 'SELL' if raw_txn in ['SELL', 'S'] else raw_txn

                trades_to_insert.append((
                    row['symbol'],
                    row['exchange'],
                    trade_dt,
                    txn_type,
                    qty,
                    price,
                    0.0, # fees
                    qty * price, # net_amount
                    source,
                    ext_trade_id,
                    order_id,
                    account_id,
                    isin,     # NEW
                    segment,  # NEW
                    series    # NEW
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
            (symbol, exchange, trade_date, txn_type, quantity, price, fees, net_amount, source, external_trade_id, order_id, account_id, isin, segment, series)
            VALUES %s
            ON CONFLICT (external_trade_id, source) DO NOTHING
        """
        execute_values(cur, insert_sql, trades_to_insert)
        conn.commit()
        
        # Trigger Portfolio Recalculation
        recalc_success, recalc_msg = calculate_portfolio()
        
        return True, f"Imported {len(trades_to_insert)} trades for {account_id} via {source}. {recalc_msg}"

    except Exception as e:
        logger.log("error", f"{source} Upload Failed", error=str(e), exc_info=True)
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
    Rebuilds 'trading.portfolio' for ALL accounts.
    """
    conn = None
    try:
        conn = get_db_connection()
        cur = conn.cursor(cursor_factory=RealDictCursor)
        
        # 1. Fetch all trades sorted by date
        with open("debug_logic_output.txt", "w") as df:
            df.write(f"DEBUG: Connecting to {DB_NAME} as {DB_USER}\n")
            cur.execute('SELECT * FROM "trading"."trades"')
            trades = cur.fetchall()
            df.write(f"DEBUG: Fetched {len(trades)} trades.\n")
            if len(trades) > 0:
                 df.write(f"Sample trade: {trades[0]}\n")
        
        # In-memory Portfolio State: { account_id: { symbol: { qty: 0, avg_price: 0, invested: 0 } } }
        holdings = {} 
        
        # Clean current portfolio table
        cur.execute("TRUNCATE TABLE trading.portfolio")
        
        for trade in trades:
            acc_id = trade.get('account_id', 'default_account')
            sym = trade['symbol']
            qty = float(trade['quantity'])
            price = float(trade['price'])
            txn = trade['txn_type'] # BUY / SELL
            
            if acc_id not in holdings:
                holdings[acc_id] = {}
            if sym not in holdings[acc_id]:
                holdings[acc_id][sym] = {'qty': 0.0, 'invested': 0.0}
            
            port_state = holdings[acc_id][sym]
            
            if txn == 'BUY':
                port_state['qty'] += qty
                port_state['invested'] += (qty * price)
            elif txn == 'SELL':
                current_qty = port_state['qty']
                if current_qty > 0:
                    avg_price = port_state['invested'] / current_qty
                    cost_of_sold = qty * avg_price
                    port_state['invested'] -= cost_of_sold
                    port_state['qty'] -= qty
                else:
                    pass # Short selling logic ignored for now
            
            # Remove dust
            if port_state['qty'] <= 0.0001:
                port_state['qty'] = 0
                port_state['invested'] = 0
                
        # Bulk Insert
        today = datetime.now().strftime('%Y-%m-%d')
        items = []
        for acc_id, symbols in holdings.items():
            for sym, data in symbols.items():
                if data['qty'] > 0:
                    avg = 0
                    if data['qty'] > 0:
                        avg = data['invested'] / data['qty']
                        
                    items.append((
                        today,
                        sym,
                        data['qty'],
                        avg,
                        data['invested'],
                        0, # Current Value 
                        0, # Unrealized PnL
                        acc_id
                    ))
        
        if items:
            insert_port_sql = """
                INSERT INTO trading.portfolio 
                (date, symbol, total_quantity, average_price, invested_value, current_value, pnl, account_id)
                VALUES %s
                ON CONFLICT (date, symbol, account_id) DO UPDATE
                SET total_quantity=EXCLUDED.total_quantity,
                    average_price=EXCLUDED.average_price,
                    invested_value=EXCLUDED.invested_value;
            """
            execute_values(cur, insert_port_sql, items)
        
        conn.commit()
        return True, f"Portfolio recalculated for {len(holdings)} accounts."
        
    except Exception as e:
        logger.log("error", "Portfolio Calc Failed", error=str(e), exc_info=True)
        if conn: conn.rollback()
        return False, str(e)
    finally:
        if conn: conn.close()

def get_portfolio_summary(account_id=None):
    conn = get_db_connection()
    if not conn: return []
    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            # Base Query
            sql = """
                SELECT * FROM trading.portfolio 
                WHERE date = (SELECT MAX(date) FROM trading.portfolio)
            """
            params = []
            
            if account_id:
                sql += " AND account_id = %s"
                params.append(account_id)
                
            sql += " ORDER BY symbol"
            
            cur.execute(sql, tuple(params))
            return cur.fetchall()
            
    finally:
        conn.close()

def get_pnl_summary(account_id=None):
    return {} # TODO

