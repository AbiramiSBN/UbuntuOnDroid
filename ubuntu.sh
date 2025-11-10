#!/data/data/com.termux/files/usr/bin/bash
# Ubuntu 23.10 with GNOME desktop via Termux + proot-distro
# Compatible with Android (no root required)

set -e

echo "[*] Updating Termux packages..."
pkg update -y
pkg install proot-distro -y

echo "[*] Installing Ubuntu 23.10..."
proot-distro install ubuntu

echo "[*] Logging into Ubuntu for setup..."
proot-distro login ubuntu -- bash <<'EOF'

echo "[*] Updating Ubuntu repositories..."
apt update -y

echo "[*] Installing GNOME desktop and utilities..."
apt install -y gnome-shell gnome-terminal gnome-tweaks \
gnome-shell-extensions gnome-shell-extension-ubuntu-dock \
nautilus nano gedit dbus-x11 tigervnc-standalone-server

echo "[*] Installing Ubuntu themes..."
apt install -y yaru-theme-gtk yaru-theme-icon

echo "[*] Setting up VNC server startup script..."
mkdir -p ~/.vnc
cat > ~/.vnc/xstartup <<'EOL'
#!/bin/bash
export XDG_CURRENT_DESKTOP="GNOME"
service dbus start
gnome-shell --x11
EOL
chmod +x ~/.vnc/xstartup

echo "[*] Fixing systemd-related GNOME issues..."
find /usr -type f -iname "*login1*" -exec rm -f {} \;

echo "[*] Setup complete inside Ubuntu!"
echo "To start GNOME desktop via VNC, run: vncserver"
EOF

echo "[*] Ubuntu GNOME installation complete!"
echo "Run the following to start your desktop environment:"
echo "proot-distro login ubuntu"
echo "vncserver"
