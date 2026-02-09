import sys
import os
import unittest
from unittest.mock import MagicMock

# Add project root to path
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from modules.brokers.angel import AngelOneClient

class TestAngelMapping(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        # We don't need valid credentials for mapping tests
        cls.client = AngelOneClient("DUMMY_CRED")
        # Pre-load the token map once
        cls.client._token_map = cls.client._load_angel_master()

    def setUp(self):
        self.client = self.__class__.client

    def test_nifty_50_mapping(self):
        # Zerodha Style: "NIFTY 50"
        # Angel Symbol: "Nifty 50", Angel Name: "NIFTY"
        # Both should resolve to 99926000
        token = self.client._get_angel_token("NIFTY 50")
        print(f"DEBUG: NIFTY 50 -> {token}")
        self.assertEqual(token, "99926000")

    def test_bank_nifty_mapping(self):
        # Zerodha Style: "NIFTY BANK"
        # Angel Symbol: "Nifty Bank", Angel Name: "BANKNIFTY"
        # Should resolve to 99926009
        token = self.client._get_angel_token("NIFTY BANK")
        print(f"DEBUG: NIFTY BANK -> {token}")
        self.assertEqual(token, "99926009")

    def test_equity_mapping(self):
        # Zerodha Style: "RELIANCE"
        # Angel Symbol: "RELIANCE-EQ", Angel Name: "RELIANCE"
        # Should resolve to 2885
        token = self.client._get_angel_token("RELIANCE")
        print(f"DEBUG: RELIANCE -> {token}")
        self.assertEqual(token, "2885")

    def test_tcs_mapping(self):
        # Zerodha Style: "TCS"
        # Angel Symbol: "TCS-EQ"
        # Should resolve to 11536
        token = self.client._get_angel_token("TCS")
        print(f"DEBUG: TCS -> {token}")
        self.assertEqual(token, "11536")

    def test_nifty_it_mapping(self):
        # Should resolve to 99926008
        token = self.client._get_angel_token("NIFTY IT")
        print(f"DEBUG: NIFTY IT -> {token}")
        self.assertEqual(token, "99926008")

if __name__ == "__main__":
    unittest.main()
