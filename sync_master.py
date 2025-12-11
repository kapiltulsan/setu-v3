import os

import json

import psycopg2

from psycopg2.extensions import connection, cursor

from psycopg2.extras import execute_batch

from kiteconnect import KiteConnect

from dotenv import load_dotenv

from db_logger import EnterpriseLogger



# Config

load_dotenv()

API_KEY = os.getenv("KITE_API_KEY")

logger = EnterpriseLogger("sync_master")



# --- SQL Queries ---



GET_ACTIVE_EXCHANGES_SQL = "SELECT exchange_code FROM ref.exchange WHERE is_active = TRUE"



UPSERT_SYMBOLS_SQL = """

    INSERT INTO ref.symbol

    (exchange_code, symbol, trading_symbol, instrument_token, segment, lot_size, is_index)

    VALUES (%s, %s, %s, %s, %s, %s, (%s = 'INDEX'))

    ON CONFLICT (exchange_code, symbol)

    DO UPDATE SET

        instrument_token = EXCLUDED.instrument_token,

        trading_symbol = EXCLUDED.trading_symbol,

        updated_at = NOW();

"""



# --- Functions ---



def get_db_connection() -> connection:

    """Establishes and returns a new database connection."""

    return psycopg2.connect(

        host=os.getenv("DB_HOST"),

        database=os.getenv("DB_NAME"),

        user=os.getenv("DB_USER"),

        password=os.getenv("DB_PASS")

    )



import config

def load_kite_session() -> KiteConnect:
    # ...
    try:
        with open(config.TOKENS_FILE, "r") as f:
            tokens = json.load(f)

        kite = KiteConnect(api_key=API_KEY)

        kite.set_access_token(tokens["access_token"])

        return kite

    except Exception as e:

        logger.log("error", "Session Load Failed", error=str(e))

        raise e



def get_active_exchanges(cur: cursor) -> list[str]:

    """Fetches the list of active exchanges from the database."""

    cur.execute(GET_ACTIVE_EXCHANGES_SQL)

    # Returns a list like ['NSE', 'BSE']

    exchanges = [row[0] for row in cur.fetchall()]

    return exchanges



def sync_instruments():

    """

    Main ETL process to sync instrument master data from Kite API to the database.

    - Fetches active exchanges from the DB.

    - Downloads instrument lists for each exchange.

    - Performs a bulk UPSERT into the ref.symbol table within a single transaction.

    """



    try:

        kite = load_kite_session()

        logger.log("info", "Starting master data sync...")



        # Use context managers for atomic transactions and resource management

        with get_db_connection() as conn:

            with conn.cursor() as cur:

                # 1. Get active exchanges from the database (e.g., ['NSE'])

                target_exchanges = get_active_exchanges(cur)

                logger.log("info", "Found active exchanges in DB", exchanges=target_exchanges)



                all_instruments_to_upsert = []

                # 2. Fetch instruments for all exchanges first

                for exchange in target_exchanges:

                    logger.log("info", f"Downloading instruments for: {exchange}")

                    try:

                        instruments = kite.instruments(exchange)

                        for inst in instruments:

                            all_instruments_to_upsert.append((

                                inst['exchange'],

                                inst['name'],

                                inst['tradingsymbol'],

                                inst['instrument_token'],

                                inst['segment'],

                                inst['lot_size'],

                                inst['instrument_type']  # Used for is_index logic

                            ))

                        logger.log("info", f"Fetched {len(instruments)} instruments for {exchange}")

                    except Exception as k_err:

                        logger.log("error", f"Kite failed to fetch {exchange}, skipping...", error=str(k_err))

                        # Continue to next exchange, but the transaction will be rolled back later

                        raise k_err # Re-raise to abort the entire transaction



                # 3. Perform a single, atomic bulk upsert

                if all_instruments_to_upsert:

                    logger.log("info", "Starting database bulk upsert...")

                    execute_batch(cur, UPSERT_SYMBOLS_SQL, all_instruments_to_upsert)

                    logger.log("info", "Database bulk upsert complete.")

            # The 'with conn' block will commit the transaction here if all steps succeeded



        total_upserted = len(all_instruments_to_upsert)

        logger.log("info", "Master sync complete", total_symbols=total_upserted)

        print(f"✅ Sync Complete. Total Symbols Upserted: {total_upserted}")



    except Exception as e:

        logger.log("error", "Master Sync Failed", error=str(e))

        print(f"❌ Failed: {e}")



if __name__ == "__main__":

    sync_instruments()