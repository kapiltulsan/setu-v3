import os
import json
import datetime
from typing import List, Dict, Any
from SmartApi import SmartConnect
from .base import BaseBroker
from db_logger import EnterpriseLogger
import config

logger = EnterpriseLogger("broker_angel")

class AngelOneClient(BaseBroker):
    def __init__(self, credential_id: str):
        super().__init__(credential_id, "ANGEL_ONE")
        self.smart_api = None
        
    def login(self) -> bool:
        """
        Note: The actual login often happens via redirect. 
        This method will check if a valid session exists in tokens.json
        """
        try:
            with open(config.TOKENS_FILE, 'r') as f:
                tokens = json.load(f)
                session_data = tokens.get(self.credential_id)
                
                if session_data and "jwtToken" in session_data:
                    api_key = os.getenv(f"{self.credential_id}_API_KEY")
                    self.smart_api = SmartConnect(api_key=api_key)
                    self.smart_api.setAccessToken(session_data["jwtToken"])
                    # Verification call can be added here
                    return True
        except Exception as e:
            logger.log("error", f"Angel Session Load Failed for {self.credential_id}", error=str(e))
            
        return False

    def get_orders(self) -> List[Dict[str, Any]]:
        return []

    def get_holdings(self) -> List[Dict[str, Any]]:
        return []

    def get_positions(self) -> List[Dict[str, Any]]:
        return []

    def get_historical_data(self, symbol: str, token: str, from_date, to_date, interval: str) -> List[Dict[str, Any]]:
        """
        Fetches historical data from Angel One.
        Note: Angel One uses different tokens than Zerodha. We must map 'symbol' to Angel's token.
        """
        if not self.smart_api: 
            if not self.login():
                return []

        angel_token = self._get_angel_token(symbol)
        if not angel_token:
            logger.log("error", f"Angel Token not found for {symbol}")
            return []
            
        # Map Interval
        # Zerodha: day, 60minute, 5minute
        # Angel: ONE_DAY, ONE_HOUR, FIVE_MINUTE
        interval_map = {
            "day": "ONE_DAY",
            "60minute": "ONE_HOUR", 
            "5minute": "FIVE_MINUTE"
        }
        angel_interval = interval_map.get(interval, "ONE_DAY")
        
        try:
            # Angel API expects strings in formatting
            # fromdate: "YYYY-MM-DD HH:MM"
            f_str = from_date.strftime("%Y-%m-%d %H:%M")
            t_str = to_date.strftime("%Y-%m-%d %H:%M")
            
            params = {
                "exchange": "NSE",
                "symboltoken": angel_token,
                "interval": angel_interval,
                "fromdate": f_str,
                "todate": t_str
            }
            
            data = self.smart_api.getCandleData(params)
            
            if data and "data" in data:
                # Transform to standard format compatible with data_collector
                # Angel Returns: [timestamp, open, high, low, close, volume]
                # We need: {'date': datetime, 'open': float, ...}
                standardized = []
                for row in data["data"]:
                    # Row: ["2021-02-17T00:00:00+05:30", 123.0, ...]
                    ts_str = row[0]
                    # Parse ISO with Timezone
                    dt = datetime.datetime.fromisoformat(ts_str)
                    
                    standardized.append({
                        "date": dt,
                        "open": row[1],
                        "high": row[2],
                        "low": row[3],
                        "close": row[4],
                        "volume": row[5]
                    })
                return standardized
            else:
                return []
                
        except Exception as e:
            logger.log("error", f"Angel History Fetch Failed for {symbol}", error=str(e))
            return []

    def _get_angel_token(self, symbol: str) -> str:
        """
        Maps a Trading Symbol (e.g. RELIANCE-EQ) to Angel Script Token.
        Uses a static/cached master json from Angel.
        """
        # This implementation fetches the master JSON on demand and caches it in memory.
        # In a production system, this should likely be in a DB or Redis.
        if not hasattr(self, "_token_map"):
            self._token_map = self._load_angel_master()
            
        # Clean symbol: Zerodha might send 'RELIANCE', but we assume NSE Equity for now
        # Angel usually matches 'RELIANCE-EQ'
        keys_to_try = [symbol, f"{symbol}-EQ"]
        
        for k in keys_to_try:
            if k in self._token_map:
                return self._token_map[k]
        
        return None

    def _load_angel_master(self):
        import requests
        url = "https://margincalculator.angelbroking.com/OpenAPI_File/files/OpenAPIScripMaster.json"
        try:
            r = requests.get(url, timeout=10)
            data = r.json()
            mapping = {}
            for item in data:
                # We only care about NSE Equity for now to keep it small
                if item.get("exch_seg") == "NSE":
                    mapping[item["symbol"]] = item["token"]
            return mapping
        except Exception as e:
            logger.log("error", "Failed to fetch Angel Master", error=str(e))
            return {}
