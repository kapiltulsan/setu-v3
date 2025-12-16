# 🔌 Connecting VS Code to Raspberry Pi 5

To let the AI Assistant (and yourself) see files, run commands, and debug errors **directly on the Raspberry Pi**, you should use the **VS Code Remote - SSH** extension.

This allows your local VS Code on Windows to act as if it is running correctly inside the Pi OS.

## Prerequisites

1.  **Tailscale IP** of your Pi (e.g., `100.x.y.z`).
2.  **SSH Access** enabled on the Pi (`sudo raspi-config` > Interface Options > SSH).
3.  **VS Code Extension**: Install [Remote - SSH](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-ssh).

## Setup Steps

### 1. Configure SSH Host
1.  Open VS Code Command Palette (`Ctrl+Shift+P`).
2.  Type **"Remote-SSH: Open SSH Configuration File"**.
3.  Select the first file (usually `C:\Users\...\.ssh\config`).
4.  Add your Pi's details:

    ```ini
    Host setu-pi5
        HostName <YOUR_TAILSCALE_IP>
        User pi50001_admin
    ```

### 2. Connect to Host
1.  Click the **Blue Remote Button** (bottom-left corner of VS Code) or press `Ctrl+Shift+P`.
2.  Select **"Remote-SSH: Connect to Host..."**.
3.  Choose `setu-pi5`.
4.  Enter your Pi's password if prompted.

### 3. Open the Project
1.  Once connected (green indicator in bottom-left), click **Open Folder**.
2.  Navigate to `/home/pi50001_admin/SetuV3`.
3.  Click **OK**.

## 🎉 Result
The AI Assistant now runs **inside** the Pi.
- I can see the **actual** `/home/pi50001_admin/SetuV3` files.
- I can run terminals commands like `systemctl status` directly.
- I can inspect local logs and fixing deployment issues in real-time.
