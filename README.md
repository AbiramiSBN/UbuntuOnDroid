# UbuntuOnDroid

Run a full Ubuntu desktop or command-line environment directly on your Android device using **Termux** — no root required.

## 🚀 Overview
UbuntuOnDroid uses **proot-distro** inside Termux to install and launch Ubuntu 23.10 (or later).  
It also includes setup steps for **GNOME Desktop** and **VNC** access, so you can enjoy a complete Linux experience on mobile.

## 🧩 Features
- No root access needed  
- Ubuntu 23.10 (or newer)  
- GNOME desktop environment  
- VNC server for remote GUI access  
- Themed with Ubuntu’s **Yaru** look and feel  

## 📦 Installation

1. Update Termux and install dependencies:
   ```bash
   pkg update -y
   pkg install proot-distro -y


2. Install Ubuntu:

   ```bash
   proot-distro install ubuntu
   ```

3. Log in:

   ```bash
   proot-distro login ubuntu
   ```

4. (Optional) Run the setup script:

   ```bash
   bash install_ubuntu_gnome.sh
   ```

## 🖥️ Start GNOME Desktop

After setup:

```bash
proot-distro login ubuntu
vncserver
```

Then connect from any VNC Viewer app to:

```
localhost:5901
```

## 🧹 Fixing Issues

If GNOME shows session or systemd errors:

```bash
find /usr -type f -iname "*login1*" -exec rm -f {} \;
```
