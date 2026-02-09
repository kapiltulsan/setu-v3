#!/bin/bash

SERVICE_NAME="moltbot-monitor"
SERVICE_FILE="$HOME/.config/systemd/user/$SERVICE_NAME.service"
WORKING_DIR="/home/pi50001_admin/SetuV3/moltbot"

mkdir -p "$HOME/.config/systemd/user/"

echo "Creating systemd service file at $SERVICE_FILE"

cat <<EOF > "$SERVICE_FILE"
[Unit]
Description=Moltbook Monitor & Privacy Guard
After=network.target

[Service]
Type=simple
WorkingDirectory=$WORKING_DIR
ExecStart=/usr/bin/python3 $WORKING_DIR/monitor.py
Restart=always
RestartSec=10

[Install]
WantedBy=default.target
EOF

systemctl --user daemon-reload
systemctl --user enable "$SERVICE_NAME"
systemctl --user start "$SERVICE_NAME"

echo "Service $SERVICE_NAME installed and started!"
echo "Check status with: systemctl --user status $SERVICE_NAME"
echo "Check logs with: journalctl --user -u $SERVICE_NAME -f"
