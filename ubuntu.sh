#!/data/data/com.termux/files/usr/bin/bash
# Ubuntu with Desktop Environment via Termux + proot-distro
# Compatible with Android (no root required)

set -e

# Color codes for better output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to display menu
show_menu() {
    clear
    echo ""
    echo ""
    echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}║                                                              ║${NC}"
    echo -e "${BLUE}║          Ubuntu Desktop Environment Installer                ║${NC}"
    echo -e "${BLUE}║              For Termux on Android Devices                   ║${NC}"
    echo -e "${BLUE}║                                                              ║${NC}"
    echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo ""
    echo -e "  ${YELLOW}Choose your desktop environment:${NC}"
    echo ""
    echo ""
    echo -e "  ${GREEN}┌─────────────────────────────────────────────────────────┐${NC}"
    echo -e "  ${GREEN}│${NC}  ${BLUE}1)${NC} ${GREEN}GNOME Desktop${NC}                                    ${GREEN}│${NC}"
    echo -e "  ${GREEN}│${NC}     Modern and feature-rich interface                ${GREEN}│${NC}"
    echo -e "  ${GREEN}│${NC}     ${YELLOW}⚠ Heavy: Requires 2GB+ RAM${NC}                        ${GREEN}│${NC}"
    echo -e "  ${GREEN}│${NC}     Best for: High-end devices                       ${GREEN}│${NC}"
    echo -e "  ${GREEN}└─────────────────────────────────────────────────────────┘${NC}"
    echo ""
    echo -e "  ${GREEN}┌─────────────────────────────────────────────────────────┐${NC}"
    echo -e "  ${GREEN}│${NC}  ${BLUE}2)${NC} ${GREEN}KDE Plasma Desktop${NC}                               ${GREEN}│${NC}"
    echo -e "  ${GREEN}│${NC}     Beautiful and highly customizable                ${GREEN}│${NC}"
    echo -e "  ${GREEN}│${NC}     ${YELLOW}⚠ Heavy: Requires 2GB+ RAM${NC}                        ${GREEN}│${NC}"
    echo -e "  ${GREEN}│${NC}     Best for: Power users who love customization     ${GREEN}│${NC}"
    echo -e "  ${GREEN}└─────────────────────────────────────────────────────────┘${NC}"
    echo ""
    echo -e "  ${GREEN}┌─────────────────────────────────────────────────────────┐${NC}"
    echo -e "  ${GREEN}│${NC}  ${BLUE}3)${NC} ${GREEN}XFCE Desktop${NC}                                     ${GREEN}│${NC}"
    echo -e "  ${GREEN}│${NC}     Lightweight and fast performance                 ${GREEN}│${NC}"
    echo -e "  ${GREEN}│${NC}     ${GREEN}✓ Recommended: Works on most devices${NC}              ${GREEN}│${NC}"
    echo -e "  ${GREEN}│${NC}     Best for: Daily use, smooth experience           ${GREEN}│${NC}"
    echo -e "  ${GREEN}└─────────────────────────────────────────────────────────┘${NC}"
    echo ""
    echo ""
    echo -e "  ${RED}┌─────────────────────────────────────────────────────────┐${NC}"
    echo -e "  ${RED}│${NC}  ${BLUE}0)${NC} ${RED}Exit Installer${NC}                                    ${RED}│${NC}"
    echo -e "  ${RED}└─────────────────────────────────────────────────────────┘${NC}"
    echo ""
    echo ""
}

# Get user choice
get_choice() {
    local choice
    read -p "Enter your choice [1-3]: " choice
    echo "$choice"
}

# Main menu
show_menu
CHOICE=$(get_choice)

case $CHOICE in
    1)
        DESKTOP="gnome"
        echo ""
        echo -e "${YELLOW}═══════════════════════════════════════════════════════${NC}"
        echo -e "${YELLOW}⚠  WARNING: GNOME Desktop Selected${NC}"
        echo -e "${YELLOW}═══════════════════════════════════════════════════════${NC}"
        echo ""
        echo -e "  ${RED}System Requirements:${NC}"
        echo -e "    • Minimum 2GB RAM"
        echo -e "    • 2GB+ free storage"
        echo -e "    • High-end Android device recommended"
        echo ""
        echo -e "  ${YELLOW}Installation Size: ~1.5GB${NC}"
        echo -e "  ${YELLOW}Installation Time: 15-30 minutes${NC}"
        echo ""
        read -p "  Press ENTER to continue or Ctrl+C to cancel..."
        ;;
    2)
        DESKTOP="kde"
        echo ""
        echo -e "${YELLOW}═══════════════════════════════════════════════════════${NC}"
        echo -e "${YELLOW}⚠  WARNING: KDE Plasma Desktop Selected${NC}"
        echo -e "${YELLOW}═══════════════════════════════════════════════════════${NC}"
        echo ""
        echo -e "  ${RED}System Requirements:${NC}"
        echo -e "    • Minimum 2GB RAM"
        echo -e "    • 2GB+ free storage"
        echo -e "    • High-end Android device recommended"
        echo ""
        echo -e "  ${YELLOW}Installation Size: ~1.5GB${NC}"
        echo -e "  ${YELLOW}Installation Time: 15-30 minutes${NC}"
        echo ""
        read -p "  Press ENTER to continue or Ctrl+C to cancel..."
        ;;
    3)
        DESKTOP="xfce"
        echo ""
        echo -e "${GREEN}═══════════════════════════════════════════════════════${NC}"
        echo -e "${GREEN}✓  XFCE Desktop Selected (Recommended)${NC}"
        echo -e "${GREEN}═══════════════════════════════════════════════════════${NC}"
        echo ""
        echo -e "  ${GREEN}System Requirements:${NC}"
        echo -e "    • Minimum 1GB RAM"
        echo -e "    • 1GB free storage"
        echo -e "    • Works on most Android devices"
        echo ""
        echo -e "  ${GREEN}Installation Size: ~800MB${NC}"
        echo -e "  ${GREEN}Installation Time: 5-10 minutes${NC}"
        echo ""
        read -p "  Press ENTER to continue..."
        ;;
    0)
        echo ""
        echo -e "${RED}Exiting installer...${NC}"
        echo ""
        exit 0
        ;;
    *)
        echo ""
        echo -e "${RED}═══════════════════════════════════════════════════════${NC}"
        echo -e "${RED}  ERROR: Invalid choice selected${NC}"
        echo -e "${RED}═══════════════════════════════════════════════════════${NC}"
        echo ""
        exit 1
        ;;
esac

echo ""
echo ""
echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}║                  Starting Installation                       ║${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
echo ""

echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║             [1/5] Updating Termux Packages                   ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""
pkg update -y && pkg upgrade -y
pkg install -y proot-distro wget
echo ""
echo -e "${GREEN}✓ Termux packages updated successfully${NC}"
echo ""

# Check if Ubuntu is already installed
if [ -d "$PREFIX/var/lib/proot-distro/installed-rootfs/ubuntu" ]; then
    echo ""
    echo -e "${YELLOW}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${YELLOW}║          Ubuntu Installation Already Detected               ║${NC}"
    echo -e "${YELLOW}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "  ${YELLOW}An existing Ubuntu installation was found.${NC}"
    echo -e "  ${YELLOW}Existing installations may have configuration issues.${NC}"
    echo ""
    echo ""
    echo -e "  ${GREEN}What would you like to do?${NC}"
    echo ""
    echo -e "  ${GREEN}┌─────────────────────────────────────────────────────────┐${NC}"
    echo -e "  ${GREEN}│${NC}  ${BLUE}1)${NC} Remove and do fresh install ${YELLOW}(Recommended)${NC}        ${GREEN}│${NC}"
    echo -e "  ${GREEN}│${NC}     Clean slate, fixes any issues                    ${GREEN}│${NC}"
    echo -e "  ${GREEN}└─────────────────────────────────────────────────────────┘${NC}"
    echo ""
    echo -e "  ${YELLOW}┌─────────────────────────────────────────────────────────┐${NC}"
    echo -e "  ${YELLOW}│${NC}  ${BLUE}2)${NC} Keep existing and continue setup                 ${YELLOW}│${NC}"
    echo -e "  ${YELLOW}│${NC}     Use this only if previous install was successful ${YELLOW}│${NC}"
    echo -e "  ${YELLOW}└─────────────────────────────────────────────────────────┘${NC}"
    echo ""
    echo -e "  ${RED}┌─────────────────────────────────────────────────────────┐${NC}"
    echo -e "  ${RED}│${NC}  ${BLUE}3)${NC} Exit installer                                    ${RED}│${NC}"
    echo -e "  ${RED}└─────────────────────────────────────────────────────────┘${NC}"
    echo ""
    read -p "  Enter your choice [1-3]: " REINSTALL_CHOICE
    echo ""
    
    case $REINSTALL_CHOICE in
        1)
            echo -e "${GREEN}[*] Removing existing Ubuntu installation...${NC}"
            proot-distro remove ubuntu
            echo -e "${GREEN}✓ Removed successfully${NC}"
            echo ""
            ;;
        2)
            echo -e "${YELLOW}[*] Keeping existing installation...${NC}"
            echo ""
            ;;
        3)
            echo -e "${RED}Exiting installer...${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid choice. Exiting.${NC}"
            exit 1
            ;;
    esac
fi

# Install Ubuntu if not present
if [ ! -d "$PREFIX/var/lib/proot-distro/installed-rootfs/ubuntu" ]; then
    echo ""
    echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║              [2/5] Installing Ubuntu Base                    ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}  ⓘ  If you see locale errors below, don't worry!${NC}"
    echo -e "${YELLOW}     They will be fixed automatically in the next step.${NC}"
    echo ""
    
    # Install Ubuntu (may show locale errors - that's normal)
    proot-distro install ubuntu 2>&1 | grep -v "Bad file descriptor" || true
    
    echo ""
    echo -e "${GREEN}✓ Ubuntu base system installed${NC}"
    echo ""
fi

echo ""
echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║         [3/5] Applying Automatic System Fixes                ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Immediate locale fix after installation
proot-distro login ubuntu -- bash -c "
export DEBIAN_FRONTEND=noninteractive
export DEBCONF_NONINTERACTIVE_SEEN=true

echo '  [Step 1/4] Cleaning up broken configurations...'
rm -f /var/lib/dpkg/info/locales.* 2>/dev/null || true
rm -f /var/cache/debconf/*.dat 2>/dev/null || true
dpkg --configure -a 2>/dev/null || true
echo '  ✓ Cleanup complete'
echo ''

echo '  [Step 2/4] Updating package lists...'
apt-get clean
apt-get update -qq
echo '  ✓ Package lists updated'
echo ''

echo '  [Step 3/4] Reinstalling locale packages...'
apt-get install -y --reinstall locales 2>&1 | grep -v 'debconf' || apt-get install -y locales
echo '  ✓ Locale packages installed'
echo ''

echo '  [Step 4/4] Generating locales...'
echo 'en_US.UTF-8 UTF-8' > /etc/locale.gen
locale-gen en_US.UTF-8 > /dev/null 2>&1
update-locale LANG=en_US.UTF-8
echo '  ✓ Locales generated'
echo ''
" 2>&1 | grep -v "Bad file descriptor" | grep -v "debconf"

echo ""
echo -e "${GREEN}✓ All system fixes applied successfully!${NC}"
echo -e "${GREEN}✓ Ubuntu is ready for desktop environment installation${NC}"
echo ""

echo ""
echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║      [4/5] Installing Desktop Environment & Packages         ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""

echo -e "${GREEN}[*] Installing desktop environment and packages...${NC}"
proot-distro login ubuntu -- bash <<EOF

set -e

export DEBIAN_FRONTEND=noninteractive
export DEBCONF_NONINTERACTIVE_SEEN=true
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

DESKTOP_ENV="$DESKTOP"

echo "[*] Updating Ubuntu repositories..."
apt-get update
apt-get upgrade -y

echo "[*] Installing essential packages..."
apt-get install -y \
    dbus-x11 \
    nano \
    wget \
    curl \
    sudo \
    net-tools \
    software-properties-common

echo "[*] Installing VNC server..."
apt-get install -y tigervnc-standalone-server tigervnc-common

# Install selected desktop environment
if [ "\$DESKTOP_ENV" = "gnome" ]; then
    echo "[*] Installing GNOME desktop environment..."
    echo "[*] This may take 15-30 minutes depending on your connection..."
    
    # Install GNOME in stages
    apt-get install -y --no-install-recommends \
        gnome-session \
        gnome-shell \
        gnome-terminal \
        nautilus \
        gnome-control-center
    
    apt-get install -y --no-install-recommends \
        gnome-tweaks \
        gnome-backgrounds \
        firefox
    
elif [ "\$DESKTOP_ENV" = "kde" ]; then
    echo "[*] Installing KDE Plasma desktop environment..."
    echo "[*] This may take 15-30 minutes depending on your connection..."
    
    apt-get install -y --no-install-recommends \
        kde-plasma-desktop \
        plasma-workspace \
        konsole \
        dolphin \
        kate \
        firefox \
        kwin-x11
    
elif [ "\$DESKTOP_ENV" = "xfce" ]; then
    echo "[*] Installing XFCE desktop environment..."
    echo "[*] This may take 5-10 minutes depending on your connection..."
    
    apt-get install -y \
        xfce4 \
        xfce4-goodies \
        xfce4-terminal \
        firefox-esr
fi

echo "[*] Setting up VNC password directory..."
mkdir -p ~/.vnc

echo "[*] Creating VNC startup script for \$DESKTOP_ENV..."
if [ "\$DESKTOP_ENV" = "gnome" ]; then
    cat > ~/.vnc/xstartup <<'EOL'
#!/bin/bash
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS

export XDG_SESSION_TYPE=x11
export XDG_CURRENT_DESKTOP=GNOME
export XDG_SESSION_DESKTOP=gnome
export GNOME_SHELL_SESSION_MODE=ubuntu
export DESKTOP_SESSION=gnome

if [ -z "\$DBUS_SESSION_BUS_ADDRESS" ]; then
    eval \$(dbus-launch --sh-syntax --exit-with-session)
fi

gnome-session &
EOL

elif [ "\$DESKTOP_ENV" = "kde" ]; then
    cat > ~/.vnc/xstartup <<'EOL'
#!/bin/bash
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS

export XDG_SESSION_TYPE=x11
export XDG_CURRENT_DESKTOP=KDE
export XDG_SESSION_DESKTOP=KDE
export DESKTOP_SESSION=plasma

if [ -z "\$DBUS_SESSION_BUS_ADDRESS" ]; then
    eval \$(dbus-launch --sh-syntax --exit-with-session)
fi

startplasma-x11 &
EOL

elif [ "\$DESKTOP_ENV" = "xfce" ]; then
    cat > ~/.vnc/xstartup <<'EOL'
#!/bin/bash
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS

export XDG_SESSION_TYPE=x11
export XDG_CURRENT_DESKTOP=XFCE
export DESKTOP_SESSION=xfce

if [ -z "\$DBUS_SESSION_BUS_ADDRESS" ]; then
    eval \$(dbus-launch --sh-syntax --exit-with-session)
fi

startxfce4 &
EOL
fi

chmod +x ~/.vnc/xstartup

echo "[*] Creating helper scripts..."
cat > ~/start-vnc.sh <<'EOL'
#!/bin/bash
# Kill any existing VNC servers
vncserver -kill :1 2>/dev/null || true

# Start VNC server
vncserver -localhost no -geometry 1920x1080 -depth 24 :1

echo ""
echo "VNC Server started!"
echo "Connect using a VNC client to:"
echo "  Address: localhost:5901"
echo "  (or use your device's IP address from local network)"
echo ""
echo "To stop: vncserver -kill :1"
EOL

cat > ~/stop-vnc.sh <<'EOL'
#!/bin/bash
vncserver -kill :1
echo "VNC server stopped"
EOL

chmod +x ~/start-vnc.sh ~/stop-vnc.sh

echo ""
echo "========================================"
echo "Setup complete inside Ubuntu!"
echo "========================================"
echo ""
echo "Desktop Environment: \$DESKTOP_ENV"
echo ""
echo "NEXT STEPS:"
echo "1. Exit this session: exit"
echo "2. Login to Ubuntu: proot-distro login ubuntu"
echo "3. Start VNC: vncserver"
echo "4. Set a VNC password when prompted"
echo "5. Connect with VNC viewer to localhost:5901"
echo ""
echo "Helper scripts created:"
echo "  ~/start-vnc.sh - Start VNC server"
echo "  ~/stop-vnc.sh  - Stop VNC server"
echo ""
EOF

echo ""
echo ""
echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║                                                              ║${NC}"
echo -e "${GREEN}║              🎉  INSTALLATION COMPLETE!  🎉                   ║${NC}"
echo -e "${GREEN}║                                                              ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo ""
echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
echo -e "  ${GREEN}Desktop Environment Installed:${NC} $(echo $DESKTOP | tr '[:lower:]' '[:upper:]')"
echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
echo ""
echo ""
echo -e "${YELLOW}┌──────────────────────────────────────────────────────────────┐${NC}"
echo -e "${YELLOW}│                    HOW TO START USING                        │${NC}"
echo -e "${YELLOW}└──────────────────────────────────────────────────────────────┘${NC}"
echo ""
echo -e "  ${GREEN}Step 1:${NC} Login to Ubuntu"
echo -e "          ${BLUE}proot-distro login ubuntu${NC}"
echo ""
echo -e "  ${GREEN}Step 2:${NC} Start VNC Server (first time will ask for password)"
echo -e "          ${BLUE}vncserver${NC}"
echo -e "          ${YELLOW}or use:${NC} ${BLUE}~/start-vnc.sh${NC}"
echo ""
echo -e "  ${GREEN}Step 3:${NC} Connect with VNC Viewer"
echo -e "          ${BLUE}Address: localhost:5901${NC}"
echo -e "          ${YELLOW}or your device IP: YOUR_IP:5901${NC}"
echo ""
echo ""
echo -e "${YELLOW}┌──────────────────────────────────────────────────────────────┐${NC}"
echo -e "${YELLOW}│               RECOMMENDED VNC CLIENTS                        │${NC}"
echo -e "${YELLOW}└──────────────────────────────────────────────────────────────┘${NC}"
echo ""
echo -e "  ${GREEN}For Android:${NC}"
echo -e "    • ${BLUE}RealVNC Viewer${NC}     (Google Play Store)"
echo -e "    • ${BLUE}bVNC${NC}               (Google Play Store)"
echo -e "    • ${BLUE}AVNC${NC}               (F-Droid)"
echo ""
echo -e "  ${GREEN}Or use Termux's built-in VNC viewer:${NC}"
echo -e "    ${BLUE}pkg install tigervnc${NC}"
echo -e "    ${BLUE}vncviewer localhost:5901${NC}"
echo ""
echo ""
echo -e "${YELLOW}┌──────────────────────────────────────────────────────────────┐${NC}"
echo -e "${YELLOW}│                   QUICK START GUIDE                          │${NC}"
echo -e "${YELLOW}└──────────────────────────────────────────────────────────────┘${NC}"
echo ""
echo -e "  ${GREEN}Start VNC Server:${NC}"
echo -e "    ${BLUE}proot-distro login ubuntu${NC}"
echo -e "    ${BLUE}~/start-vnc.sh${NC}"
echo ""
echo -e "  ${GREEN}Stop VNC Server:${NC}"
echo -e "    ${BLUE}~/stop-vnc.sh${NC}"
echo -e "    ${YELLOW}or:${NC} ${BLUE}vncserver -kill :1${NC}"
echo ""
echo -e "  ${GREEN}Restart VNC Server:${NC}"
echo -e "    ${BLUE}vncserver -kill :1 && vncserver${NC}"
echo ""
echo ""
echo -e "${GREEN}════════════════════════════════════════════════════════════════${NC}"
echo -e "  ${YELLOW}Need help? Check the Ubuntu documentation or forums${NC}"
echo -e "${GREEN}════════════════════════════════════════════════════════════════${NC}"
echo ""
echo ""
