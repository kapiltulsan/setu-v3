# 📘 Setu V3 Runbook

This document outlines the standard operating procedures (SOPs) for managing and using the Setu V3 infrastructure.

## 🖥️ Dashboard Operations

**Frontend (Main):** `http://<YOUR_PI_IP>:3000` (User Dashboard)
**Backend (Admin):** `http://<YOUR_PI_IP>:5000` (System Dashboard)

The dashboard is the central command center. It is divided into 4 main tiles:

### 1. ⚡ System Health
- **CPU/RAM/Disk**: Monitors resource usage.
  - **Green**: Healthy
  - **Orange**: Warning (>60% Load)
  - **Red**: Critical (>80% Load)
- **Database**: Shows current DB size and active connections.
- **Refresh Rate**: Use the dropdown (top-right) to change how often metrics update (default: 5s).

### 2. 🔐 Broker Gateways (Auth)
- **Zerodha**:
  - `ONLINE`: Token is valid for today.
  - `OFFLINE`: Token is missing or expired.
  - Click **"🔄 Login to Zerodha"** if offline.
- **AngelOne**:
  - Status is displayed alongside Zerodha.
  - Click **"🔄 Login to Angel One"** to initiate SmartAPI publisher login.
  - Tokens are saved to `tokens.json`.

### 3. ⏰ Platform Scheduler (Admin Panel)
- **Location**: Admin Dashboard (`:5000`) > Scheduler Tile.
- **Purpose**: Centralized management of all background jobs (Midnight Batch, Market Data, Sync).
- **Features**:
  - **Status**: View current status (Pending, Running, Success, Failure).
  - **Actions**: Manually Trigger ("Run Now") or Disable jobs.
  - **History**: View last run time and duration.


### 4. ⏰ Auto-Schedule Status
- **Service**: Managed by `setu-admin` (Internal Scheduler).
- **Verification**: Check the **Scheduler Tile** on the Admin Panel.
- **Logs**: `logs/scheduler/service.log`

### 5. 💰 Portfolio Collector
- **Purpose**: Fetches Order Book, Holdings, and Net Positions once per day.
- **Run**: `python portfolio_collector.py`
- **Output**: Writes to `trading.orders`, `trading.portfolio`, and `trading.positions`.


### 5. 🔔 Notifications (Telegram)
- Get alerts for Expired Tokens and Job Failures.
- **Setup**: Configure `TELEGRAM_BOT_TOKEN` and `CHAT_ID` in `.env`.
- **Test**: Run `python -m modules.notifier -t "Test" -m "Hello"` to send a test alert.

### 6. 📜 Live Logs
- Displays the last 100 log entries from the application.
- **Color Coding**:
  - `INFO` (Green): Normal operations.
  - `WARNING` (Orange): Non-critical issues.
  - `ERROR` (Red): Attention required.
- **Path**: Logs are stored locally in `logs/SetuV3/Python/<YYYY-MM-DD>/`.

### 7. 🔍 Stock Scanner
- **Location**: Frontend > Scanners.
- **Purpose**: Create and run technical rules to filter stocks.
- **Workflow**:
  1. Click "+ New Scanner".
  2. Define Universe (e.g., NIFTY 50), Filters (Layer 2), and Refiners (Layer 3).
  3. Save and Click "Run Now".
  4. View results in the "Latest Results" table or "History" tab.

---

## 🛠️ Common Workflows

### 🔄 Daily Morning Setup
1. Open the **Dashboard**.
2. Check **Zerodha Gateway** tile.
3. If `OFFLINE`, perform the login flow.
4. Verify **System Health** is green.

### 🏃‍♂️ Running Midnight Jobs Manually
If a job failed or you need to re-run data collection, you have two options:

**Option A: Via Admin Panel (Recommended)**
1. Go to the **Admin Dashboard** (`http://<IP>:5000`).
2. Locate the **Scheduler** tile.
3. Find **midnight_batch** in the list.
4. Click **"Run Now"**.

**Option B: Via Terminal**
1. SSH into the server (or open terminal locally).
2. Run the job script:
   ```bash
   python tools/run_midnight_jobs.py
   ```
3. Watch the **Midnight Jobs** tile on the dashboard for progress.

### 📊 Viewing Charts
1. Click **"Open Charts ↗"** in the Market Data tile.
2. This opens the advanced charting interface (currently under development).

---

## ❓ Troubleshooting

### 1. Dashboard Won't Load
- **Check if app is running**:
  ```bash
  ps aux | grep app.py
  ```
- **Restart the service**:
  ```bash
  # If using systemd
  sudo systemctl restart setu-dashboard
  # OR
  sudo systemctl restart setu-admin
  
   # If running manually (Windows)
   .\tools\start_dev.ps1
   
   # If running manually (Linux/Mac)
   # Frontend
   cd frontend && npm run dev
   # Backend
   python app.py
  ```

### 2. "Token Invalid" Errors in Logs
- The Zerodha session has expired.
- Go to the Dashboard > Zerodha Gateway and click **"Force Re-Login"**.

### 3. Database Connection Failed
- Check Postgres service:
  ```bash
  sudo systemctl status postgresql
  ```
- Verify credentials in `.env` file.

### 4. High CPU/Temp Warning
- Check if a heavy backtest or data job is running.
- Ensure the Raspberry Pi fan is spinning (if applicable).
