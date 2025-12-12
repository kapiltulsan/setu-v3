# Deployment Guide (Raspberry Pi 5)

This guide covers how to set up modules and automate deployment on your Raspberry Pi 5.

## 1. Initial Setup

### Prerequisites
- Raspberry Pi OS (64-bit recommended)
- Python 3.10+
- PostgreSQL 14+ with TimescaleDB

### Clone & Install
```bash
cd /home/pi
git clone <your-repo-url> setu-v3
cd setu-v3

# Setup Python Environment
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

### Configure Environment
Create the `.env` file:
```bash
cp .env.example .env
nano .env  # Enter your DB and API credentials
```

## 2. Setting up Systemd Service
To keep the application running in the background and restart on boot/crash.

1. Create a service file:
   ```bash
   sudo nano /etc/systemd/system/setu-admin.service
   ```

2. Add the following content (adjust paths if needed):
   ```ini
   [Unit]
   Description=Setu V3 Admin Dashboard
   After=network.target postgresql.service

   [Service]
   User=pi
   WorkingDirectory=/home/pi/setu-v3
   Environment="PATH=/home/pi/setu-v3/venv/bin"
   ExecStart=/home/pi/setu-v3/venv/bin/python app.py
   Restart=always

   [Install]
   WantedBy=multi-user.target
   ```

3. Enable and start the service:
   ```bash
   sudo systemctl daemon-reload
   sudo systemctl enable setu-admin
   sudo systemctl start setu-admin
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
journalctl -u setu-admin -f
```
