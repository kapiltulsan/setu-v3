import json
import os
import datetime
from typing import List, Dict, Any
from kiteconnect import KiteConnect
from .base import BaseBroker
import config
from db_logger import EnterpriseLogger

logger = EnterpriseLogger("broker_zerodha")

class ZerodhaClient(BaseBroker):
    def __init__(self, credential_id: str):
        super().__init__(credential_id, "ZERODHA")
        self.kite = None
        # In current setup, API Key is in env, but ideally should look up via credential_id
        # For now, maintaining backward compat with .env KITE_API_KEY if specific one not found
        # (Assuming Env keys might be prefixed like KAP_ZERODHA_API_KEY later)
        self.api_key = os.getenv(f"{credential_id}_API_KEY") or os.getenv("KITE_API_KEY")
        
    def login(self) -> bool:
        try:
            # Load tokens from tokens.json
            if not os.path.exists(config.TOKENS_FILE):
                logger.log("error", "Tokens file not found")
                return False

            with open(config.TOKENS_FILE, "r") as f:
                tokens_data = json.load(f)

            # Support both old simple format and new keyed format
            if self.credential_id in tokens_data:
                access_token = tokens_data[self.credential_id]["access_token"]
            elif "access_token" in tokens_data:
                 # Fallback for single-user legacy
                 access_token = tokens_data["access_token"]
            else:
                 logger.log("error", f"No token found for {self.credential_id}")
                 return False

            self.kite = KiteConnect(api_key=self.api_key)
            self.kite.set_access_token(access_token)
            self.is_connected = True
            return True
            
        except Exception as e:
            logger.log("error", "Zerodha Login Failed", exc_info=True)
            return False

    def get_orders(self) -> List[Dict[str, Any]]:
        if not self.is_connected: self.login()
        # Fetch and Standardize
        raw_orders = self.kite.orders()
        # Mapping logic can go here if we want to strictly standardize keys
        # For now, passing raw as schema largely matches Zerodha
        return raw_orders

    def get_holdings(self) -> List[Dict[str, Any]]:
        if not self.is_connected: self.login()
        return self.kite.holdings()

    def get_positions(self) -> List[Dict[str, Any]]:
        if not self.is_connected: self.login()
        positions = self.kite.positions()
        return positions.get('net', [])

    def get_historical_data(self, symbol: str, token: str, from_date, to_date, interval: str) -> List[Dict[str, Any]]:
        if not self.is_connected: self.login()
        return self.kite.historical_data(int(token), from_date, to_date, interval)
