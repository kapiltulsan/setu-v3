import os
import sys
# Add parent directory to path
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

import requests
import pandas as pd
import io
import psycopg2
from psycopg2.extensions import connection, cursor
from psycopg2.extras import execute_batch
from dotenv import load_dotenv
from db_logger import EnterpriseLogger

# Config
load_dotenv()
logger = EnterpriseLogger("sync_constituents")

# --- SQL Queries ---
GET_INDEX_SOURCES_SQL = "SELECT index_name, source_url FROM ref.index_source WHERE is_active = TRUE"
DELETE_MAPPING_SQL = "DELETE FROM ref.index_mapping"
INSERT_MAPPING_SQL = """
    INSERT INTO ref.index_mapping (index_name, stock_symbol) 
    VALUES (%s, %s) 
    ON CONFLICT (index_name, stock_symbol) DO NOTHING
"""

# --- Functions ---

def get_db_connection() -> connection:
    return psycopg2.connect(
        host=os.getenv("DB_HOST"),
        database=os.getenv("DB_NAME"),
        user=os.getenv("DB_USER"),
        password=os.getenv("DB_PASS")
    )

def fetch_all_constituents(cur: cursor) -> list[tuple[str, str]]:
    all_mappings = []
    headers = {'User-Agent': 'Mozilla/5.0'}
    
    # 1. Fetch URLs from Database
    cur.execute(GET_INDEX_SOURCES_SQL)
    sources = cur.fetchall() # Returns list of (name, url)
    
    logger.log("info", f"Loaded {len(sources)} index configurations from DB.")

    # 2. Loop through DB results
    import time
    for index_name, url in sources:
        if not url:
            logger.log("warning", f"Skipping {index_name} because URL is empty.")
            continue
            
        logger.log("info", f"Fetching {index_name}...", url=url)
        
        max_retries = 3
        success = False
        
        for attempt in range(1, max_retries + 1):
            try:
                response = requests.get(url, headers=headers, timeout=30) # Increased timeout
                
                if response.status_code == 200:
                    df = pd.read_csv(io.StringIO(response.text))
                    df.columns = [c.strip() for c in df.columns]

                    if 'Symbol' in df.columns:
                        symbols = df['Symbol'].unique().tolist()
                        for sym in symbols:
                            all_mappings.append((index_name, sym))
                        logger.log("info", f"Parsed {index_name}", count=len(symbols))
                        success = True
                        break # Success
                    else:
                        logger.log("warning", f"Column 'Symbol' not found in {index_name}")
                        success = True # Fetched but invalid content, don't retry
                        break
                else:
                    logger.log("warning", f"Retry {attempt}/{max_retries}: Status {response.status_code} for {index_name}")
            
            except Exception as e:
                logger.log("warning", f"Retry {attempt}/{max_retries}: Failed {index_name} - {str(e)}")
            
            if attempt < max_retries:
                time.sleep(2) # Backoff
        
        if not success:
            logger.log("error", f"Permanently failed to download {index_name} after {max_retries} attempts.")
            
    return all_mappings

def sync_constituents() -> None:
    try:
        logger.log("info", "Starting Index Mapping Sync...")

        with get_db_connection() as conn:
            with conn.cursor() as cur:
                # Stage 1: Fetch (Pass cursor to read config from DB)
                all_mappings = fetch_all_constituents(cur)
                total_mappings = len(all_mappings)

                if not all_mappings:
                    logger.log("warning", "No mappings fetched. Aborting.")
                    return

                # Stage 2: Write
                logger.log("info", "Starting DB transaction...")
                
                cur.execute(DELETE_MAPPING_SQL)
                logger.log("info", "Deleted old data.")

                logger.log("info", f"Inserting {total_mappings} mappings...")
                execute_batch(cur, INSERT_MAPPING_SQL, all_mappings)
                rows_written = cur.rowcount
                
                # Stage 3: Auto-Activate Symbols
                # As per requirement: Any symbol found in an index source should be marked active
                logger.log("info", "Auto-activating mapped symbols...")
                cur.execute("""
                    UPDATE ref.symbol 
                    SET is_active = TRUE, updated_at = NOW() 
                    WHERE trading_symbol IN (SELECT DISTINCT stock_symbol FROM ref.index_mapping)
                      AND is_active = FALSE
                """)
                activated_count = cur.rowcount
                logger.log("info", f"Activated {activated_count} previously inactive symbols.")

        logger.log("info", "Sync Complete", total_mappings=total_mappings, rows_written=rows_written)
        print(f"✅ Mapping Complete. Inserted {total_mappings} relationships from DB configuration.")

    except Exception as e:
        logger.log("error", "Mapping Sync Failed", error=str(e))
        print(f"❌ Failed: {e}")

if __name__ == "__main__":
    sync_constituents()