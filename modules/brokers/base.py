from abc import ABC, abstractmethod
from typing import List, Dict, Any, Optional
import datetime

class BaseBroker(ABC):
    """
    Abstract base class for all broker adapters.
    """
    
    def __init__(self, credential_id: str, broker_name: str):
        self.credential_id = credential_id
        self.broker_name = broker_name
        self.is_connected = False
        
    @abstractmethod
    def login(self) -> bool:
        """Establishes session with the broker."""
        pass
        
    @abstractmethod
    def get_orders(self) -> List[Dict[str, Any]]:
        """
        Fetches orders for the day.
        Returns standardized list of dicts.
        """
        pass
        
    @abstractmethod
    def get_holdings(self) -> List[Dict[str, Any]]:
        """
        Fetches long-term holdings.
        """
        pass
        
    @abstractmethod
    def get_positions(self) -> List[Dict[str, Any]]:
        """
        Fetches open positions (Intraday/F&O).
        """
        pass
    
    @abstractmethod
    def get_historical_data(self, symbol: str, token: str, 
                          from_date: datetime.datetime, 
                          to_date: datetime.datetime, 
                          interval: str) -> List[Dict[str, Any]]:
        """
        Fetches OHLC data.
        """
        pass
