# Deployment Guide (Raspberry Pi 5)

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
2. Update Python dependencies.
3. Remind you to run migrations or restart the service.

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

## 5. Accessing via Tailscale

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

## 6. Troubleshooting

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
