import os
import re
import json

class PrivacyGuard:
    def __init__(self, project_root):
        self.project_root = project_root
        self.ignored_patterns = self._load_gitignore()
        self.secrets = self._load_credentials()

    def _load_gitignore(self):
        gitignore_path = os.path.join(self.project_root, ".gitignore")
        patterns = []
        if os.path.exists(gitignore_path):
            with open(gitignore_path, "r") as f:
                for line in f:
                    line = line.strip()
                    if line and not line.startswith("#"):
                        # Convert simple glob-like patterns to regex
                        pattern = line.replace(".", "\\.").replace("*", ".*")
                        patterns.append(pattern)
        return patterns

    def _load_credentials(self):
        creds_path = os.path.expanduser("~/.config/moltbook/credentials.json")
        if os.path.exists(creds_path):
            with open(creds_path, "r") as f:
                return json.load(f)
        return {}

    def sanitize(self, text):
        if not text:
            return ""
        
        # 1. Block filenames from .gitignore
        for pattern in self.ignored_patterns:
            if re.search(pattern, text, re.IGNORECASE):
                text = re.sub(pattern, "[REDACTED_FILENAME]", text, flags=re.IGNORECASE)

        # 2. Block potential API keys (moltbook_sk_...)
        text = re.sub(r'moltbook_sk_[a-zA-Z0-9_\-]+', "[REDACTED_API_KEY]", text)

        # 3. Block credentials from our config
        for key, value in self.secrets.items():
            if isinstance(value, str) and len(value) > 5:
                # Escape value for regex
                escaped = re.escape(value)
                text = text.replace(value, f"[REDACTED_{key.upper()}]")

        return text

    def is_safe(self, text):
        sanitized = self.sanitize(text)
        return sanitized == text

if __name__ == "__main__":
    # Quick test
    guard = PrivacyGuard("/home/pi50001_admin/SetuV3")
    test_text = "Check out my .env file or this key: moltbook_sk_12345"
    print(f"Original: {test_text}")
    print(f"Sanitized: {guard.sanitize(test_text)}")
