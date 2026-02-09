import time
import json
import os
import requests
import sys
from datetime import datetime, timedelta
from privacy import PrivacyGuard

# Add project root to sys.path to import modules
sys.path.append("/home/pi50001_admin/SetuV3")
from modules.notifier import send_notification

class MoltMonitor:
    BASE_URL = "https://www.moltbook.com/api/v1"

    def __init__(self):
        self.project_root = "/home/pi50001_admin/SetuV3"
        self.creds = self._load_creds()
        self.guard = PrivacyGuard(self.project_root)
        self.api_key = self.creds.get("api_key")
        self.findings_path = os.path.join(self.project_root, "moltbot/findings.json")
        self.queue_path = os.path.join(self.project_root, "moltbot/post_queue.json")
        self.state_path = os.path.join(self.project_root, "moltbot/state.json")
        self.headers = {
            "Authorization": f"Bearer {self.api_key}",
            "Content-Type": "application/json"
        }
        self.state = self._load_state()
        self.activity_log_path = os.path.join(self.project_root, "moltbot/ACTIVITY.md")

    def _load_creds(self):
        creds_path = os.path.expanduser("~/.config/moltbook/credentials.json")
        try:
            with open(creds_path, "r") as f:
                return json.load(f)
        except Exception:
            return {}

    def _load_state(self):
        if os.path.exists(self.state_path):
            with open(self.state_path, "r") as f:
                return json.load(f)
        return {
            "last_post_time": 0, 
            "last_summary_time": 0,
            "last_scout_time": 0,
            "own_posts": [],
            "pending_comments": [],
            "scouted_posts": []
        }

    def _save_state(self):
        with open(self.state_path, "w") as f:
            json.dump(self.state, f, indent=2)

    def _save_finding(self, finding):
        findings = []
        if os.path.exists(self.findings_path):
            with open(self.findings_path, "r") as f:
                try:
                    findings = json.load(f)
                except:
                    findings = []
        findings.append({"timestamp": time.ctime(), "data": finding})
        findings = findings[-50:]
        with open(self.findings_path, "w") as f:
            json.dump(findings, f, indent=2)

    def add_to_queue(self, submolt, title, content):
        queue = []
        if os.path.exists(self.queue_path):
            with open(self.queue_path, "r") as f:
                queue = json.load(f)
        
        queue.append({
            "submolt": submolt,
            "title": title,
            "content": content,
            "added_at": time.time()
        })
        
        with open(self.queue_path, "w") as f:
            json.dump(queue, f, indent=2)
        print(f"Added to queue: {title}")

    def process_queue(self):
        if not os.path.exists(self.queue_path):
            return

        with open(self.queue_path, "r") as f:
            queue = json.load(f)
        
        if not queue:
            return

        # Check cooldown (30 mins = 1800 seconds)
        now = time.time()
        if now - self.state.get("last_post_time", 0) < 1805:
            return

        post = queue.pop(0)
        print(f"[{time.ctime()}] Processing queue: {post['title']}")
        
        resp = self.post_to_moltbook(post['submolt'], post['title'], post['content'])
        
        if resp.get("success"):
            self.state["last_post_time"] = time.time()
            post_id = resp.get("post", {}).get("id")
            if post_id:
                self.state["own_posts"].append(post_id)
            self._save_state()
            self._log_activity(f"📈 Successfully posted: **{post['title']}** to `m/{post['submolt']}`")
            print(f"Successfully posted: {post['title']}")
        else:
            print(f"Failed to post: {resp.get('error')}")
            # Re-queue if it wasn't a formatting error? (Optional)
            if "once every 30 minutes" not in resp.get("error", ""):
                queue.insert(0, post)

        with open(self.queue_path, "w") as f:
            json.dump(queue, f, indent=2)

    def post_to_moltbook(self, submolt, title, content):
        sanitized_content = self.guard.sanitize(content)
        sanitized_title = self.guard.sanitize(title)
        url = f"{self.BASE_URL}/posts"
        payload = {"submolt": submolt, "title": sanitized_title, "content": sanitized_content}
        try:
            resp = requests.post(url, headers=self.headers, json=payload)
            return resp.json()
        except Exception as e:
            return {"success": False, "error": str(e)}

    def check_for_engagement(self):
        # Check comments on own posts
        for post_id in self.state.get("own_posts", [])[-10:]:
            url = f"{self.BASE_URL}/posts/{post_id}/comments"
            try:
                resp = requests.get(url, headers=self.headers)
                if resp.status_code == 200:
                    data = resp.json()
                    self._process_comments(post_id, data.get("comments", []))
            except Exception as e:
                print(f"Error checking engagement for {post_id}: {e}")
        
        # Periodic summary check
        now = time.time()
        # Summary every 1 hour OR if 10+ comments are waiting
        if self.state.get("pending_comments") and (now - self.state.get("last_summary_time", 0) > 3600 or len(self.state["pending_comments"]) >= 10):
            self._send_batch_summary()

        # Periodic Scouting Run (Every 4 hours)
        if now - self.state.get("last_scout_time", 0) > 14400:
            self.check_community_trends()

    def check_community_trends(self):
        print(f"[{time.ctime()}] Starting Alpha Scouting Run...")
        submolts = ["quantmolt", "trading", "depin", "passiveincome"]
        keywords = ["breakout", "strategy", "backtest", "squeeze", "trend", "passive income", "depin", "monetization", "node", "mining", "bandwidth"]
        
        found_alpha = []
        for sm in submolts:
            url = f"{self.BASE_URL}/submolts/{sm}/posts"
            try:
                resp = requests.get(url, headers=self.headers)
                if resp.status_code == 200:
                    posts = resp.json().get("posts", [])
                    for post in posts[:15]: # Scan top 15
                        title = post.get("title", "").lower()
                        if any(k in title for k in keywords):
                            if post.get("id") not in [p.get("id") for p in self.state.get("scouted_posts", [])]:
                                summary = self._extract_alpha_summary(post)
                                found_alpha.append(summary)
                                self.state.setdefault("scouted_posts", []).append(post)
            except Exception as e:
                print(f"Scouting error in {sm}: {e}")

        if found_alpha:
            self.state["last_scout_time"] = time.time()
            self._save_state()
            self._log_activity(f"🚁 Completed Alpha Scouting Run. Found **{len(found_alpha)}** new potential alpha threads.")
            self._notify_scout_findings(found_alpha)

    def _log_activity(self, text):
        timestamp = datetime.now().strftime("%Y-%m-%d %H:%M")
        log_entry = f"\n## [{timestamp}] - {text}\n"
        try:
            with open(self.activity_log_path, "a") as f:
                f.write(log_entry)
        except Exception as e:
            print(f"Failed to write to activity log: {e}")

    def _extract_alpha_summary(self, post):
        return {
            "id": post.get("id"),
            "author": post.get("author", {}).get("name", "Unknown"),
            "title": post.get("title"),
            "content_preview": post.get("content", "")[:150],
            "engagement": f"{post.get('upvotes')}↑ / {post.get('comments_count')} comments",
            "url": f"https://www.moltbook.com/post/{post.get('id')}"
        }

    def _notify_scout_findings(self, findings):
        details = [f"Found {len(findings)} potential alpha threads:"]
        summary_lines = []
        for f in findings:
            summary_lines.append(f"🔍 {f['title']} by {f['author']} ({f['engagement']})")
            summary_lines.append(f"   Preview: {f['content_preview']}...")
            summary_lines.append(f"   Link: {f['url']}\n")

        send_notification(
            subject="🚁 MoltSwarm Scouting Report",
            details=details,
            technicals={"Findings": "\n".join(summary_lines)},
            actionable=["Review these strategies for our backtester", "Ask me to draft deep-dive questions for these authors"],
            severity="INFO"
        )

    def _process_comments(self, post_id, comments):
        new_found = False
        for comment in comments:
            comment_id = comment.get("id")
            if f"seen_{comment_id}" not in self.state:
                # Add to pending list for summary
                self.state.setdefault("pending_comments", []).append({
                    "author": comment.get("author", {}).get("name", "Unknown"),
                    "content": comment.get("content", "")[:100] + "...",
                    "post_id": post_id,
                    "timestamp": time.ctime()
                })
                # Mark as seen
                self.state[f"seen_{comment_id}"] = True
                new_found = True
        
        if new_found:
            self._save_state()
            self._draft_suggested_replies()

    def _draft_suggested_replies(self):
        pending = self.state.get("pending_comments", [])
        if not pending:
            return

        drafts = []
        for c in pending:
            author = c['author']
            content = c['content']
            # Simple heuristic-based drafting (as an AI interface)
            if "polars" in content.lower():
                draft = f"@{author} Great suggestion! We are actually evaluating Polars for the next sprint. The lazy execution model on large OHLCV datasets is definitely the move. Do you have a preferred schema for time-series data?"
            elif "drawdown" in content.lower() or "risk" in content.lower():
                draft = f"@{author} Absolutely. We've found that the ATR-based Chandelier stop reduces drawdown by ~12% compared to fixed %. Still looking for ways to optimize for high-volatility gaps though!"
            else:
                draft = f"@{author} Intrigued by your feedback. We are currently refining this strategy for the NSE market. Any specific indicators you'd recommend combining with this logic?"
            
            drafts.append({
                "post_id": c['post_id'],
                "comment_author": author,
                "suggested_reply": draft
            })

        if drafts:
            self.state["pending_drafts"] = drafts
            self._save_state()
            self._notify_drafts(drafts)

    def _notify_drafts(self, drafts):
        details = [f"I have drafted {len(drafts)} suggested replies for your approval:"]
        summary = "\n".join([f"To {d['comment_author']}: {d['suggested_reply']}" for d in drafts])
        
        send_notification(
            subject="📝 MoltSwarm: Suggested Replies",
            details=details,
            technicals={"Drafts": summary},
            actionable=["Approve these by saying 'Post drafts'", "Ask me to rewrite a specific reply"],
            severity="INFO"
        )

    def _send_batch_summary(self):
        comments = self.state.get("pending_comments", [])
        if not comments:
            return

        summary_lines = [f"- {c['author']}: {c['content']}" for c in comments]
        
        send_notification(
            subject="📊 Moltbook Community Pulse (Summary)",
            details=[f"We have {len(comments)} new interactions on your strategies:"],
            technicals={"Comments": "\n".join(summary_lines)},
            actionable=["Check Moltbook for full context", "Ask me to draft replies"],
            severity="INFO"
        )
        
        # Clear pending and update time
        self.state["pending_comments"] = []
        self.state["last_summary_time"] = time.time()
        self._save_state()

    def check_dms(self):
        # DMs remain immediate as they are direct 1:1 interactions
        url = f"{self.BASE_URL}/agents/dm/check"
        try:
            resp = requests.get(url, headers=self.headers)
            if resp.status_code == 200:
                data = resp.json()
                if data.get("has_activity"):
                    print(f"[{time.ctime()}] DM Activity detected: {data.get('summary')}")
                    self._handle_dm_activity(data)
            else:
                print(f"[{time.ctime()}] DM API Error: {resp.status_code}")
        except Exception as e:
            print(f"[{time.ctime()}] DM Connection failed: {e}")

    def _handle_dm_activity(self, data):
        summary = data.get("summary", "New activity on Moltbook")
        self._save_finding(data)
        send_notification(
            subject="🦞 Moltbook Direct Activity",
            details=[summary],
            technicals={"Type": "DIRECT_MESSAGE"},
            actionable=["Reply to DM immediately"],
            severity="IMPORTANT" # DMs are higher priority
        )

    def run(self):
        print(f"[{time.ctime()}] MoltMonitor (Intelligent Mode) started")
        while True:
            self.check_dms()
            self.process_queue()
            self.check_for_engagement()
            time.sleep(120)

if __name__ == "__main__":
    monitor = MoltMonitor()
    monitor.run()
