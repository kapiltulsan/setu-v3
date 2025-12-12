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
    for index_name, url in sources:
        logger.log("info", f"Fetching {index_name}...", url=url)
        try:
            response = requests.get(url, headers=headers, timeout=15)
            
            if response.status_code == 200:
                df = pd.read_csv(io.StringIO(response.text))
                df.columns = [c.strip() for c in df.columns]

                if 'Symbol' in df.columns:
                    symbols = df['Symbol'].unique().tolist()
                    for sym in symbols:
                        all_mappings.append((index_name, sym))
                    logger.log("info", f"Parsed {index_name}", count=len(symbols))
                else:
                    logger.log("warning", f"Column 'Symbol' not found in {index_name}")
            else:
                logger.log("warning", f"Could not download {index_name} (Status: {response.status_code})")
                
        except Exception as e:
            logger.log("error", f"Failed to process {index_name}", error=str(e))

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

        logger.log("info", "Sync Complete", total_mappings=total_mappings, rows_written=rows_written)
        print(f"✅ Mapping Complete. Inserted {total_mappings} relationships from DB configuration.")

    except Exception as e:
        logger.log("error", "Mapping Sync Failed", error=str(e))
        print(f"❌ Failed: {e}")

if __name__ == "__main__":
    sync_constituents()