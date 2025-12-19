# Deployment Guide (Raspberry Pi 5)

> [!CAUTION]
> **STRICT RULE: DO NOT EDIT CODE DIRECTLY ON THIS SERVER (PRODUCTION).**
> All changes must be made on your **Development System**, pushed to GitHub, and then pulled here.

## 0. Deployment Workflow
1.  **Develop:** Make changes on your local PC (Dev System).
2.  **Commit & Push:** Push changes to GitHub (`git push origin dev` -> merge to `main`).
3.  **Deploy:** Pull changes on this Pi (`git pull origin main`) and restart services.

This guide covers how to set up modules and automate deployment on your Raspberry Pi 5.

## 1. Initial Setup

### Prerequisites
- Raspberry Pi OS (64-bit recommended)
- Python 3.10+
- PostgreSQL 14+ with TimescaleDB
- **Node.js 20+** (Required for Dashboard)

### Install Node.js (via NVM)
```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
source ~/.bashrc
nvm install 20
nvm use 20
nvm alias default 20
```

### Clone & Install
```bash
cd /home/pi50001_admin
git clone <your-repo-url> setu-v3
cd setu-v3

# Setup Python Environment
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

# Setup Frontend
cd frontend
npm install
npm run build
cd ..
```

### Configure Environment
Create the `.env` file **in the root directory** (this configures the Backend):
```bash
cp .env.example .env
nano .env  # Enter your DB and API credentials
```

## 2. Setting up Systemd Services
To keep the application running in the background and restart on boot/crash.

### Backend Service (Flask)

1. Copy the provided service file:
   ```bash
   sudo cp systemd/setu-admin.service /etc/systemd/system/
   ```

2. (Optional) If your project path is different from `/home/pi50001_admin/SetuV3`, edit the file:
   ```bash
   sudo nano /etc/systemd/system/setu-admin.service
   ```

### Frontend Service (Next.js)

1. Copy the provided service file:
   ```bash
   sudo cp systemd/setu-dashboard.service /etc/systemd/system/
   ```

2. **IMPORTANT**: Update the Node.js path in the service file.
   First, find where your node is installed:
   ```bash
   which node
   # OR if using nvm
   nvm which current
   ```
   
   Then edit the service file and update the `Environment="PATH=..."` line to match your node bin path:
   ```bash
   sudo nano /etc/systemd/system/setu-dashboard.service
   ```

3. Enable and start both services:
   ```bash
   sudo systemctl daemon-reload
   sudo systemctl enable setu-admin
   sudo systemctl enable setu-dashboard
   sudo systemctl start setu-admin
   sudo systemctl start setu-dashboard
   ```

## 3. Updating the Application
When you have pushed new code to Git, run the deployment script on the Pi:

```bash
chmod +x deploy.sh
./deploy.sh
```

This script will:
1. Pull the latest code.
2. Update Python dependencies and Frontend.
3. Automatically update `systemd` service files from the repo.
4. Restart the services.

### Restarting the Service
After updating code, always restart the service:
```bash
sudo systemctl restart setu-admin
```

### Checking Logs
To see the application output:
```bash
sudo journalctl -u setu-admin -f
```

## 4. Setting up Midnight Jobs (Data Collection)
Automate data collection (Symbols, Indices, OHLC) to run daily at 00:30.

1. Copy systemd files:
   ```bash
   sudo cp systemd/setu-midnight-jobs.service /etc/systemd/system/
   sudo cp systemd/setu-midnight-jobs.timer /etc/systemd/system/
   ```

2. Enable and start the timer:
   ```bash
   sudo systemctl daemon-reload
   sudo systemctl enable setu-midnight-jobs.timer
   sudo systemctl start setu-midnight-jobs.timer
   ```

3. Check timer status:
   ```bash
   systemctl list-timers --all | grep setu
   ```

## 5. Setting up Notifications (Telegram)

To receive alerts to your mobile when Zerodha token expires:

1.  **Create a Telegram Bot**:
    -   Search for `@BotFather` on Telegram.
    -   Send `/newbot`.
    -   Copy the HTTP API Token.
2.  **Get Chat ID**:
    -   Start a chat with your new bot.
    -   Search for `@userinfobot` to get your ID.
3.  **Update Config**:
    -   Edit `.env` inside `setu-v3`:
        ```bash
        NOTIFIER_TYPE=telegram
        TELEGRAM_BOT_TOKEN=YOUR_TOKEN
        TELEGRAM_CHAT_ID=YOUR_ID
        DASHBOARD_URL=http://pi5-setu:3000
        ```

### Advanced: Using a Telegram Group
To send alerts to a group instead of a single person:
1.  **Create a New Group** on Telegram.
2.  **Add your Bot** to the group as a member.
3.  **Promote to Admin**: Click Group Info > Edit > Administrators > Add Admin > Select your Bot (Required for the bot to read/write freely).
4.  **Get Group ID**:
    -   Send a dummy message in the group (e.g., "Hello").
    -   Open this URL in your browser (replace `<TOKEN>` with your Bot Token):
        `https://api.telegram.org/bot<TOKEN>/getUpdates`
    -   Look for `"chat":{"id":-100xxxxxxxxx,"title":"...`.
    -   The ID starting with `-100` is your **Group Chat ID**.
5.  **Update .env**: Use this ID in `TELEGRAM_CHAT_ID`.
### 4. Setup Cron Job (Nagging Monitor)
    -   Edit crontab: `crontab -e`
    -   Add the following line to run the Smart Monitor daily at 8:30 AM:
        ```bash
        # Run Token Monitor at 8:30 AM (Loops internally every 30m until success or 4 PM)
        30 8 * * 1-5 cd /home/pi50001_admin/setu-v3 && /home/pi50001_admin/setu-v3/venv/bin/python tools/token_monitor.py >> logs/cron_monitor.log 2>&1
        ```

### 5. CLI Usage (Scripts/Cron)
You can use the notification system from the command line in any script:
```bash
# General Usage
python -m modules.notifier -t "Title" -m "Message Body" -p "high"

# Example: Notify on deploy success
python -m modules.notifier -t "Deployment" -m "Deploy Script Ran Successfully"
```

## 6. Accessing via Tailscale

To securely access your dashboard from anywhere without opening public ports, use [Tailscale](https://tailscale.com/).

### Enable Tailscale Serve
This will expose your local port 3000 (Next.js dashboard) to your Tailnet.

1. Run the following command on your Pi:
   ```bash
   sudo tailscale serve --bg 3000
   ```
   *Note: `--bg` runs it in the background.*

2. Get your device name or IP:
   ```bash
   tailscale ip -4
   ```

3. Access the dashboard from any device on your Tailnet:
   ```
   http://<your-pi-tailscale-ip>:3000
   ```
   *Or use the MagicDNS name if enabled.*

## 7. Troubleshooting

### `npm: command not found`
- This means NVM isn't loaded or Node isn't installed.
- **Fix**: Run `source ~/.bashrc` or reinstall Node via NVM as shown in Section 1.

### `Failed to restart setu-dashboard.service: Unit not found`
- You skipped step 2 ("Setting up Systemd Services").
- **Fix**: Run the `sudo cp` commands listed in Section 2 to install the service files.

### Dashboard not accessible on port 3000
- Check if the service is running: `sudo systemctl status setu-dashboard`
- Check logs: `sudo journalctl -u setu-dashboard -f`
- If logs show "Exit status 1", it might be a Node path issue. Verify the `Environment="PATH=..."` line in `/etc/systemd/system/setu-dashboard.service`.
