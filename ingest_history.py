import os
import time
import random
import logging
import pandas as pd
from datetime import datetime, timedelta
from dotenv import load_dotenv
import requests
from urllib.parse import quote_plus
from sqlalchemy import create_engine, Column, String, Integer, Float, Date, MetaData, Table, select, func, BigInteger
from sqlalchemy.orm import declarative_base, sessionmaker
from sqlalchemy.dialects.postgresql import insert

# Setup Logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

# Load Environment Variables
load_dotenv()

DB_HOST = os.getenv("DB_HOST")
DB_PORT = os.getenv("DB_PORT")
DB_NAME = os.getenv("DB_NAME")
DB_USER = os.getenv("DB_USER")
DB_PASS = os.getenv("DB_PASS")

# URL encode the password to handle special characters like '@'
encoded_pass = quote_plus(DB_PASS)
DATABASE_URL = f"postgresql://{DB_USER}:{encoded_pass}@{DB_HOST}:{DB_PORT}/{DB_NAME}"

# SQLAlchemy Setup
Base = declarative_base()

class MarketDataDaily(Base):
    __tablename__ = 'market_data_daily'
    __table_args__ = {'schema': 'ohlc'}
    symbol = Column(String, primary_key=True)
    trade_date = Column(Date, primary_key=True)
    series = Column(String)
    prev_close = Column(Float)
    open_price = Column(Float)
    high_price = Column(Float)
    low_price = Column(Float)
    last_price = Column(Float)
    close_price = Column(Float)
    avg_price = Column(Float)
    volume = Column(BigInteger)
    turnover_lacs = Column(Float)
    no_of_trades = Column(BigInteger)
    delivery_qty = Column(BigInteger)
    delivery_pct = Column(Float)

class IndexDataDaily(Base):
    __tablename__ = 'indices_daily'
    __table_args__ = {'schema': 'ohlc'}
    index_name = Column(String, primary_key=True)
    trade_date = Column(Date, primary_key=True)
    open_value = Column(Float)
    high_value = Column(Float)
    low_value = Column(Float)
    close_value = Column(Float)
    points_change = Column(Float)
    change_pct = Column(Float)
    volume = Column(BigInteger)
    turnover_cr = Column(Float)
    pe_ratio = Column(Float)
    pb_ratio = Column(Float)
    div_yield = Column(Float)

engine = create_engine(DATABASE_URL)
Session = sessionmaker(bind=engine)

# Ingestion Start Dates (Known data availability on NSE archives)
# sec_bhavdata_full started around June 2019
MARKET_DATA_START_DATE = datetime(2019, 6, 1).date()
# Index data is available much earlier
INDEX_DATA_START_DATE = datetime(2012, 1, 1).date()

# Stealth Protocol Constants
USER_AGENTS = [
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36",
    "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
]

class NSEStealthSession:
    def __init__(self):
        self.session = None
        self.request_count = 0
        self.initialize_session()

    def initialize_session(self):
        if self.session:
            self.session.close()
            logger.info("Destroying session and cooling down for 120 seconds...")
            time.sleep(120)

        self.session = requests.Session()
        self.session.headers.update({
            "User-Agent": random.choice(USER_AGENTS),
            "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7",
            "Accept-Encoding": "gzip, deflate, br",
            "Accept-Language": "en-US,en;q=0.9",
            "Referer": "https://www.nseindia.com/"
        })
        
        # Initial hit to establish cookies
        try:
            logger.info("Establishing fresh session cookies from nseindia.com...")
            self.session.get("https://www.nseindia.com", timeout=15)
            # NSE sometimes needs a second hit or a specific page to be solid
            self.session.get("https://www.nseindia.com/all-reports", timeout=15)
        except Exception as e:
            logger.error(f"Failed to initialize session: {e}")
            raise

        self.request_count = 0

    def get(self, url):
        self.request_count += 1
        if self.request_count > 50:
            self.initialize_session()

        response = self.session.get(url, timeout=20)
        
        if response.status_code == 403:
            logger.critical("403 FORBIDDEN DETECTED. IMMEDIATE KILL SWITCH ACTIVATED.")
            os._exit(1)
        
        return response

    def sleep(self, duration=None):
        """Standardized sleep with jitter."""
        if duration is None:
            duration = random.uniform(15, 30)
        logger.info(f"Sleeping for {duration:.2f} seconds...")
        time.sleep(duration)

def get_missing_dates(start_date, end_date):
    """Identifies all weekdays in range that are missing from market_data_daily."""
    # freq='B' generates business days (Mon-Fri)
    all_days = pd.date_range(start=start_date, end=end_date, freq='B').date.tolist()
    
    with Session() as session:
        # Get existing dates from the database
        existing = session.query(MarketDataDaily.trade_date).distinct().all()
        existing_set = {row[0] for row in existing}
    
    missing_dates = [d for d in all_days if d not in existing_set]
    return sorted(missing_dates) # Oldest first

def upsert_market_data(df):
    if df.empty:
        return
    
    # Filter for SERIES == 'EQ'
    if 'SERIES' in df.columns:
        df['SERIES'] = df['SERIES'].str.strip()
    
    df = df[df['SERIES'] == 'EQ'].copy()
    if df.empty:
        return

    # Column Mapping
    # SYMBOL -> symbol, DATE1 -> trade_date, SERIES -> series, OPEN_PRICE -> open_price, 
    # HIGH_PRICE -> high_price, LOW_PRICE -> low_price, CLOSE_PRICE -> close_price, 
    # TTL_TRD_QNTY -> volume, DELIV_QTY -> delivery_qty, DELIV_PER -> delivery_pct
    
    # Map and rename
    columns = {
        'SYMBOL': 'symbol',
        'DATE1': 'trade_date',
        'SERIES': 'series',
        'PREV_CLOSE': 'prev_close',
        'OPEN_PRICE': 'open_price',
        'HIGH_PRICE': 'high_price',
        'LOW_PRICE': 'low_price',
        'LAST_PRICE': 'last_price',
        'CLOSE_PRICE': 'close_price',
        'AVG_PRICE': 'avg_price',
        'TTL_TRD_QNTY': 'volume',
        'TURNOVER_LACS': 'turnover_lacs',
        'NO_OF_TRADES': 'no_of_trades',
        'DELIV_QTY': 'delivery_qty',
        'DELIV_PER': 'delivery_pct'
    }
    
    # Check which columns are actually present (sometimes case varies)
    present_cols = {orig: target for orig, target in columns.items() if orig in df.columns}
    
    processed_df = df[list(present_cols.keys())].rename(columns=present_cols)
    if 'symbol' in processed_df.columns:
        processed_df['symbol'] = processed_df['symbol'].str.strip()
    
    # Data Cleaning
    processed_df['trade_date'] = pd.to_datetime(processed_df['trade_date']).dt.date
    if 'delivery_qty' in processed_df.columns:
        processed_df['delivery_qty'] = pd.to_numeric(processed_df['delivery_qty'], errors='coerce').fillna(0).astype('int64')
    if 'volume' in processed_df.columns:
        processed_df['volume'] = pd.to_numeric(processed_df['volume'], errors='coerce').fillna(0).astype('int64')
    if 'no_of_trades' in processed_df.columns:
        processed_df['no_of_trades'] = pd.to_numeric(processed_df['no_of_trades'], errors='coerce').fillna(0).astype('int64')
    
    # Clean numeric floats
    float_cols = ['prev_close', 'open_price', 'high_price', 'low_price', 'last_price', 'close_price', 'avg_price', 'turnover_lacs', 'delivery_pct']
    for col in float_cols:
        if col in processed_df.columns:
            processed_df[col] = pd.to_numeric(processed_df[col], errors='coerce').fillna(0.0)
    
    data = processed_df.to_dict(orient='records')
    
    with engine.connect() as conn:
        stmt = insert(MarketDataDaily).values(data)
        update_cols = {c.name: c for c in stmt.excluded if not c.primary_key}
        upsert_stmt = stmt.on_conflict_do_update(
            index_elements=['symbol', 'trade_date'],
            set_=update_cols
        )
        conn.execute(upsert_stmt)
        conn.commit()
    logger.info(f"Upserted {len(data)} rows into market_data_daily")

def upsert_index_data(df):
    if df.empty:
        return

    # Column Mapping
    # Index Name -> index_name, Index Date -> trade_date, Open Index Value -> open_value, 
    # High Index Value -> high_value, Low Index Value -> low_value, Closing Index Value -> close_value, 
    # Volume -> volume, P/E -> pe_ratio, P/B -> pb_ratio, Div Yield -> div_yield
    
    columns = {
        'Index Name': 'index_name',
        'Index Date': 'trade_date',
        'Open Index Value': 'open_value',
        'High Index Value': 'high_value',
        'Low Index Value': 'low_value',
        'Closing Index Value': 'close_value',
        'Points Change': 'points_change',
        'Change(%)': 'change_pct',
        'Volume': 'volume',
        'Turnover (Rs. Cr.)': 'turnover_cr',
        'P/E': 'pe_ratio',
        'P/B': 'pb_ratio',
        'Div Yield': 'div_yield'
    }
    
    present_cols = {orig: target for orig, target in columns.items() if orig in df.columns}
    processed_df = df[list(present_cols.keys())].rename(columns=present_cols)
    
    # Data Cleaning
    processed_df['trade_date'] = pd.to_datetime(processed_df['trade_date'], format='%d-%m-%Y').dt.date
    numeric_cols = ['open_value', 'high_value', 'low_value', 'close_value', 'volume', 'pe_ratio', 'pb_ratio', 'div_yield', 'points_change', 'change_pct', 'turnover_cr']
    for col in numeric_cols:
        if col in processed_df.columns:
            processed_df[col] = pd.to_numeric(processed_df[col], errors='coerce').fillna(0.0)
    
    if 'volume' in processed_df.columns:
        processed_df['volume'] = processed_df['volume'].astype('int64')
    
    data = processed_df.to_dict(orient='records')
    
    with engine.connect() as conn:
        stmt = insert(IndexDataDaily).values(data)
        update_cols = {c.name: c for c in stmt.excluded if not c.primary_key}
        upsert_stmt = stmt.on_conflict_do_update(
            index_elements=['index_name', 'trade_date'],
            set_=update_cols
        )
        conn.execute(upsert_stmt)
        conn.commit()
    logger.info(f"Upserted {len(data)} rows into indices_daily")

def main():
    # Attempt to create tables on start
    Base.metadata.create_all(engine)
    
    # Determine target range
    backfill_days = int(os.getenv("OHLC_BACKFILL_DAYS_DAILY", 5000))
    end_date = (datetime.now() - timedelta(days=1)).date()
    start_date = (datetime.now() - timedelta(days=backfill_days)).date()
    
    logger.info(f"Checking for missing data between {start_date} and {end_date}...")
    missing_dates = get_missing_dates(start_date, end_date)
    
    if not missing_dates:
        logger.info("All data is up to date according to the backfill range.")
        return
    
    logger.info(f"Found {len(missing_dates)} missing dates. Starting farthest-first ingestion...")
    
    stealth = NSEStealthSession()
    
    for current_date in missing_dates:
        date_str = current_date.strftime("%d%m%Y")
        processed_any = False
        
        # Source A: Market Data
        if current_date >= MARKET_DATA_START_DATE:
            url_a = f"https://nsearchives.nseindia.com/products/content/sec_bhavdata_full_{date_str}.csv"
            logger.info(f"Fetching Market Data for {current_date}...")
            try:
                resp_a = stealth.get(url_a)
                if resp_a.status_code == 200:
                    from io import StringIO
                    df_a = pd.read_csv(StringIO(resp_a.text))
                    df_a.columns = [c.strip() for c in df_a.columns]
                    upsert_market_data(df_a)
                    processed_any = True
                elif resp_a.status_code == 404:
                    logger.info(f"{current_date} is likely a Holiday (Market Data 404)")
            except Exception as e:
                logger.error(f"Error processing Market Data for {current_date}: {e}")

        # Source B: Index Data
        if current_date >= INDEX_DATA_START_DATE:
            url_b = f"https://nsearchives.nseindia.com/content/indices/ind_close_all_{date_str}.csv"
            logger.info(f"Fetching Index Data for {current_date}...")
            try:
                resp_b = stealth.get(url_b)
                if resp_b.status_code == 200:
                    from io import StringIO
                    df_b = pd.read_csv(StringIO(resp_b.text))
                    df_b.columns = [c.strip() for c in df_b.columns]
                    upsert_index_data(df_b)
                    processed_any = True
                elif resp_b.status_code == 404:
                    logger.info(f"{current_date} is likely a Holiday (Index Data 404)")
            except Exception as e:
                logger.error(f"Error processing Index Data for {current_date}: {e}")

        # Targeted Sleep only if we actually hit the server or processed data
        if processed_any:
            stealth.sleep()
        else:
            # Short jitter for 404s to avoid getting blocked but still move fast
            stealth.sleep(random.uniform(2, 5))

if __name__ == "__main__":
    main()
