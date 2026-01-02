from .base import BaseBroker
from .zerodha import ZerodhaClient
from .dhan import DhanClient
from .angel import AngelOneClient

# Mapping from portfolio_rules.json broker names to Classes
BROKER_MAP = {
    "ZERODHA": ZerodhaClient,
    "DHAN": DhanClient,
    "ANGEL_ONE": AngelOneClient
}

def get_broker_client(broker_name: str, credential_id: str) -> BaseBroker:
    """
    Factory to return the appropriate broker client.
    """
    client_cls = BROKER_MAP.get(broker_name)
    if not client_cls:
        raise ValueError(f"Unknown Broker: {broker_name}")
    
    return client_cls(credential_id)
