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

### 2. 🔐 Zerodha Gateway (Auth)
- **Status**:
  - `ONLINE`: Token is valid for today.
  - `OFFLINE`: Token is missing or expired.
- **Action**:
  - If `OFFLINE`, click **"🔄 Login to Zerodha"**.
  - This redirects you to Kite. Login there, and you will be automatically returned to the dashboard.
  - The token is saved to `tokens.json`.

### 3. 🌙 Midnight Jobs
- **Purpose**: Daily market data collection and maintenance.
- **Status Indicators**:
  - `SUCCESS`: Job completed successfully.
  - `FAILURE`: Job failed (check logs).
  - `WARNING`: Job finished but with non-critical issues.
- **Refresh**: The tile updates automatically every 30 seconds.

### 4. ⏰ Auto-Schedule Status
- **On Linux/Pi**: Managed via `systemd` (runs daily at 00:30).
- **On Windows**: Managed via `Task Scheduler` (runs daily at 00:30).
- Check `tools/` folder for setup scripts.

### 4. 📜 Live Logs
- Displays the last 100 log entries from the application.
- **Color Coding**:
  - `INFO` (Green): Normal operations.
  - `WARNING` (Orange): Non-critical issues.
  - `ERROR` (Red): Attention required.
- **Path**: Logs are stored locally in `logs/SetuV3/Python/<YYYY-MM-DD>/`.

---

## 🛠️ Common Workflows

### 🔄 Daily Morning Setup
1. Open the **Dashboard**.
2. Check **Zerodha Gateway** tile.
3. If `OFFLINE`, perform the login flow.
4. Verify **System Health** is green.

### 🏃‍♂️ Running Midnight Jobs Manually
If a job failed or you need to re-run data collection, you have two options:

**Option A: Via Dashboard (Recommended)**
1. Go to the **Midnight Jobs** tile.
2. Click the **"▶ Run Now"** button.
3. Confirm the action.

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
  
  # If running manually
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
