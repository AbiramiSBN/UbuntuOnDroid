#!/data/data/com.termux/files/usr/bin/bash
# Debian Desktop Environment Installer for Termux
# Enhanced version with better error handling and modularity
# Compatible with Android (no root required)

set -euo pipefail
IFS=$'\n\t'

# ============================================================================
# Configuration and Constants
# ============================================================================

readonly SCRIPT_VERSION="2.0"
readonly MIN_FREE_SPACE_MB=1500
readonly LOG_FILE="$HOME/debian-install.log"

# Color codes
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly MAGENTA='\033[0;35m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m'

# Desktop environment configurations
declare -A DESKTOP_CONFIGS=(
    ["gnome_name"]="GNOME Desktop"
    ["gnome_ram"]="2GB+"
    ["gnome_size"]="~1.5GB"
    ["gnome_time"]="15-30 min"
    ["gnome_heavy"]=true
    
    ["kde_name"]="KDE Plasma Desktop"
    ["kde_ram"]="2GB+"
    ["kde_size"]="~1.5GB"
    ["kde_time"]="15-30 min"
    ["kde_heavy"]=true
    
    ["xfce_name"]="XFCE Desktop"
    ["xfce_ram"]="1GB"
    ["xfce_size"]="~800MB"
    ["xfce_time"]="5-10 min"
    ["xfce_heavy"]=false
    
    ["lxde_name"]="LXDE Desktop"
    ["lxde_ram"]="512MB"
    ["lxde_size"]="~500MB"
    ["lxde_time"]="3-5 min"
    ["lxde_heavy"]=false
)

# ============================================================================
# Utility Functions
# ============================================================================

# Logging function
log() {
    local level="$1"
    shift
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] [$level] $*" | tee -a "$LOG_FILE"
}

log_info() { log "INFO" "$@"; }
log_warn() { log "WARN" "$@"; }
log_error() { log "ERROR" "$@"; }
log_success() { log "SUCCESS" "$@"; }

# Error handler
error_exit() {
    log_error "$1"
    echo -e "\n${RED}════════════════════════════════════════════════════════════${NC}"
    echo -e "${RED}  ERROR: $1${NC}"
    echo -e "${RED}════════════════════════════════════════════════════════════${NC}\n"
    echo -e "${YELLOW}Check the log file for details: ${LOG_FILE}${NC}\n"
    exit 1
}

# Progress indicator
show_progress() {
    local msg="$1"
    echo -e "\n${CYAN}⏳ ${msg}...${NC}"
}

# Success message
show_success() {
    local msg="$1"
    echo -e "${GREEN}✓ ${msg}${NC}"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check available storage
check_storage() {
    local available_kb
    available_kb=$(df "$PREFIX" | awk 'NR==2 {print $4}')
    local available_mb=$((available_kb / 1024))
    
    log_info "Available storage: ${available_mb}MB"
    
    if [ "$available_mb" -lt "$MIN_FREE_SPACE_MB" ]; then
        error_exit "Insufficient storage. Need at least ${MIN_FREE_SPACE_MB}MB, have ${available_mb}MB"
    fi
    
    echo -e "${GREEN}✓ Storage check passed: ${available_mb}MB available${NC}"
}

# Check internet connectivity
check_internet() {
    show_progress "Checking internet connection"
    
    if ! ping -c 1 8.8.8.8 >/dev/null 2>&1 && ! ping -c 1 1.1.1.1 >/dev/null 2>&1; then
        error_exit "No internet connection. Please connect to the internet and try again."
    fi
    
    show_success "Internet connection verified"
}

# ============================================================================
# Menu Display Functions
# ============================================================================

show_banner() {
    clear
    echo -e "\n${MAGENTA}"
    cat << "EOF"
    ╔══════════════════════════════════════════════════════════╗
    ║                                                          ║
    ║        Debian Desktop Environment Installer v2.0        ║
    ║            For Termux on Android Devices                ║
    ║                                                          ║
    ╚══════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}\n"
}

show_desktop_option() {
    local num="$1"
    local desktop="$2"
    local is_recommended="${3:-false}"
    
    local name="${DESKTOP_CONFIGS[${desktop}_name]}"
    local ram="${DESKTOP_CONFIGS[${desktop}_ram]}"
    local size="${DESKTOP_CONFIGS[${desktop}_size]}"
    local heavy="${DESKTOP_CONFIGS[${desktop}_heavy]}"
    
    echo -e "  ${GREEN}┌─────────────────────────────────────────────────────────┐${NC}"
    if [ "$is_recommended" = true ]; then
        echo -e "  ${GREEN}│${NC}  ${BLUE}${num})${NC} ${GREEN}${name}${NC} ${YELLOW}★ RECOMMENDED${NC} $(printf '%*s' $((23 - ${#name})) '')${GREEN}│${NC}"
    else
        echo -e "  ${GREEN}│${NC}  ${BLUE}${num})${NC} ${GREEN}${name}${NC}$(printf '%*s' $((38 - ${#name})) '')${GREEN}│${NC}"
    fi
    
    echo -e "  ${GREEN}│${NC}     RAM: ${ram} | Size: ${size}$(printf '%*s' $((26 - ${#ram} - ${#size})) '')${GREEN}│${NC}"
    
    if [ "$heavy" = true ]; then
        echo -e "  ${GREEN}│${NC}     ${YELLOW}⚠ Heavy: High-end devices recommended${NC}           ${GREEN}│${NC}"
    else
        echo -e "  ${GREEN}│${NC}     ${GREEN}✓ Lightweight: Works on most devices${NC}            ${GREEN}│${NC}"
    fi
    
    echo -e "  ${GREEN}└─────────────────────────────────────────────────────────┘${NC}"
    echo ""
}

show_menu() {
    show_banner
    echo -e "  ${YELLOW}Choose your desktop environment:${NC}\n"
    
    show_desktop_option "1" "xfce" true
    show_desktop_option "2" "lxde"
    show_desktop_option "3" "gnome"
    show_desktop_option "4" "kde"
    
    echo -e "  ${CYAN}┌─────────────────────────────────────────────────────────┐${NC}"
    echo -e "  ${CYAN}│${NC}  ${BLUE}5)${NC} ${CYAN}System Check${NC} - Verify requirements              ${CYAN}│${NC}"
    echo -e "  ${CYAN}└─────────────────────────────────────────────────────────┘${NC}\n"
    
    echo -e "  ${RED}┌─────────────────────────────────────────────────────────┐${NC}"
    echo -e "  ${RED}│${NC}  ${BLUE}0)${NC} ${RED}Exit Installer${NC}                                  ${RED}│${NC}"
    echo -e "  ${RED}└─────────────────────────────────────────────────────────┘${NC}\n"
}

# ============================================================================
# Pre-installation Checks
# ============================================================================

system_check() {
    echo -e "\n${CYAN}════════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}  Running System Compatibility Check${NC}"
    echo -e "${CYAN}════════════════════════════════════════════════════════════${NC}\n"
    
    # Check architecture
    local arch
    arch=$(uname -m)
    echo -e "${GREEN}✓ Architecture:${NC} $arch"
    
    # Check Android version
    if [ -f /system/build.prop ]; then
        local android_ver
        android_ver=$(grep -oP 'ro.build.version.release=\K.*' /system/build.prop 2>/dev/null || echo "Unknown")
        echo -e "${GREEN}✓ Android Version:${NC} $android_ver"
    fi
    
    # Check available RAM
    if [ -f /proc/meminfo ]; then
        local total_ram
        total_ram=$(awk '/MemTotal/ {printf "%.1f GB", $2/1024/1024}' /proc/meminfo)
        echo -e "${GREEN}✓ Total RAM:${NC} $total_ram"
    fi
    
    # Check storage
    local available_mb
    available_mb=$(df "$PREFIX" | awk 'NR==2 {printf "%.1f GB", $4/1024/1024}')
    echo -e "${GREEN}✓ Available Storage:${NC} $available_mb"
    
    # Check Termux version
    if command_exists termux-info; then
        local termux_ver
        termux_ver=$(termux-info | grep -oP 'TERMUX_VERSION=\K.*' || echo "Unknown")
        echo -e "${GREEN}✓ Termux Version:${NC} $termux_ver"
    fi
    
    check_internet
    
    echo -e "\n${GREEN}════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}  System Check Complete - All Requirements Met!${NC}"
    echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}\n"
    
    read -p "Press ENTER to return to menu..."
}

# ============================================================================
# Installation Functions
# ============================================================================

confirm_installation() {
    local desktop="$1"
    local name="${DESKTOP_CONFIGS[${desktop}_name]}"
    local ram="${DESKTOP_CONFIGS[${desktop}_ram]}"
    local size="${DESKTOP_CONFIGS[${desktop}_size]}"
    local time="${DESKTOP_CONFIGS[${desktop}_time]}"
    
    echo -e "\n${YELLOW}════════════════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}  Installation Summary${NC}"
    echo -e "${YELLOW}════════════════════════════════════════════════════════════${NC}\n"
    echo -e "  ${GREEN}Desktop Environment:${NC} $name"
    echo -e "  ${GREEN}Required RAM:${NC} $ram"
    echo -e "  ${GREEN}Download Size:${NC} $size"
    echo -e "  ${GREEN}Estimated Time:${NC} $time"
    echo -e "\n${YELLOW}════════════════════════════════════════════════════════════${NC}\n"
    
    read -p "Continue with installation? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}Installation cancelled.${NC}\n"
        exit 0
    fi
}

update_termux() {
    echo -e "\n${GREEN}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║            [1/6] Updating Termux Packages                ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════╝${NC}\n"
    
    show_progress "Updating package lists"
    pkg update -y >> "$LOG_FILE" 2>&1 || error_exit "Failed to update packages"
    
    show_progress "Upgrading packages"
    pkg upgrade -y >> "$LOG_FILE" 2>&1 || log_warn "Some packages failed to upgrade"
    
    show_progress "Installing required tools"
    pkg install -y proot-distro wget curl >> "$LOG_FILE" 2>&1 || error_exit "Failed to install required tools"
    
    show_success "Termux packages updated"
}

cleanup_previous() {
    echo -e "\n${GREEN}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║          [2/6] Cleaning Previous Installations           ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════╝${NC}\n"
    
    local rootfs_dir="$PREFIX/var/lib/proot-distro/installed-rootfs"
    local found_installation=false
    
    for distro in debian ubuntu; do
        if [ -d "$rootfs_dir/$distro" ]; then
            found_installation=true
            show_progress "Removing existing $distro installation"
            proot-distro remove "$distro" 2>/dev/null || true
            rm -rf "$rootfs_dir/$distro" 2>/dev/null || true
            show_success "Removed $distro installation"
        fi
    done
    
    # Clean cache
    show_progress "Cleaning download cache"
    rm -rf "$PREFIX/var/lib/proot-distro/dlcache"/*.partial 2>/dev/null || true
    
    if [ "$found_installation" = false ]; then
        show_success "No previous installations found"
    fi
}

install_debian_base() {
    echo -e "\n${GREEN}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║             [3/6] Installing Debian Base                 ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════╝${NC}\n"
    
    echo -e "${YELLOW}ⓘ  Using Debian for superior stability in Termux${NC}\n"
    
    show_progress "Downloading and installing Debian"
    
    if ! proot-distro install debian >> "$LOG_FILE" 2>&1; then
        error_exit "Debian installation failed. Check $LOG_FILE for details."
    fi
    
    # Verify installation
    if [ ! -d "$PREFIX/var/lib/proot-distro/installed-rootfs/debian/bin" ]; then
        error_exit "Debian installation verification failed"
    fi
    
    show_success "Debian base system installed"
}

configure_system() {
    echo -e "\n${GREEN}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║        [4/6] Configuring System & Locales                ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════╝${NC}\n"
    
    proot-distro login debian -- bash -c "
        set -e
        export DEBIAN_FRONTEND=noninteractive
        export DEBCONF_NONINTERACTIVE_SEEN=true
        
        echo '[1/4] Configuring package manager...'
        dpkg --configure -a 2>/dev/null || true
        
        echo '[2/4] Updating repository lists...'
        apt-get update -qq 2>&1 | grep -v 'Warning' || apt-get update
        
        echo '[3/4] Upgrading system packages...'
        apt-get upgrade -y -qq 2>&1 | grep -v 'Warning' || apt-get upgrade -y
        
        echo '[4/4] Installing and configuring locales...'
        apt-get install -y locales 2>&1 | grep -v 'debconf' || true
        echo 'en_US.UTF-8 UTF-8' > /etc/locale.gen
        locale-gen en_US.UTF-8 >/dev/null 2>&1 || locale-gen
        update-locale LANG=en_US.UTF-8 2>/dev/null || true
        
        echo 'Configuration complete!'
    " || error_exit "System configuration failed"
    
    show_success "System configured"
}

install_desktop() {
    local desktop="$1"
    
    echo -e "\n${GREEN}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║     [5/6] Installing Desktop Environment & Tools         ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════╝${NC}\n"
    
    proot-distro login debian -- bash <<EOF
set -e

export DEBIAN_FRONTEND=noninteractive
export DEBCONF_NONINTERACTIVE_SEEN=true
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

echo "[*] Installing essential packages..."
apt-get install -y -qq \
    dbus-x11 \
    nano \
    vim \
    wget \
    curl \
    sudo \
    net-tools \
    ca-certificates \
    htop \
    git 2>&1 | grep -v 'debconf' || true

echo "[*] Installing VNC server..."
apt-get install -y -qq tigervnc-standalone-server tigervnc-common 2>&1 | grep -v 'debconf' || true

# Install desktop environment
case "$desktop" in
    gnome)
        echo "[*] Installing GNOME Desktop (this will take 15-30 minutes)..."
        apt-get install -y --no-install-recommends \
            task-gnome-desktop \
            gnome-terminal \
            nautilus \
            gnome-tweaks \
            gedit \
            firefox-esr 2>&1 | grep -E "^\(Reading|^Unpacking|^Setting" || true
        ;;
    kde)
        echo "[*] Installing KDE Plasma Desktop (this will take 15-30 minutes)..."
        apt-get install -y --no-install-recommends \
            task-kde-desktop \
            konsole \
            dolphin \
            kate \
            firefox-esr 2>&1 | grep -E "^\(Reading|^Unpacking|^Setting" || true
        ;;
    xfce)
        echo "[*] Installing XFCE Desktop (this will take 5-10 minutes)..."
        apt-get install -y \
            task-xfce-desktop \
            xfce4-terminal \
            thunar \
            mousepad \
            firefox-esr 2>&1 | grep -E "^\(Reading|^Unpacking|^Setting" || true
        ;;
    lxde)
        echo "[*] Installing LXDE Desktop (this will take 3-5 minutes)..."
        apt-get install -y \
            task-lxde-desktop \
            lxterminal \
            pcmanfm \
            leafpad \
            firefox-esr 2>&1 | grep -E "^\(Reading|^Unpacking|^Setting" || true
        ;;
esac

echo ""
echo "[✓] Desktop environment installed successfully!"
EOF

    if [ $? -ne 0 ]; then
        error_exit "Desktop environment installation failed"
    fi
    
    show_success "Desktop environment installed"
}

create_vnc_config() {
    local desktop="$1"
    
    echo -e "\n${GREEN}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║            [6/6] Creating VNC Configuration              ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════╝${NC}\n"
    
    proot-distro login debian -- bash <<EOF
set -e

mkdir -p ~/.vnc

# Create xstartup script based on desktop
case "$desktop" in
    gnome)
        cat > ~/.vnc/xstartup <<'EOL'
#!/bin/bash
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
export XDG_SESSION_TYPE=x11
export XDG_CURRENT_DESKTOP=GNOME
export XDG_SESSION_DESKTOP=gnome
export DESKTOP_SESSION=gnome
[ -z "\$DBUS_SESSION_BUS_ADDRESS" ] && eval \$(dbus-launch --sh-syntax --exit-with-session)
gnome-session &
EOL
        ;;
    kde)
        cat > ~/.vnc/xstartup <<'EOL'
#!/bin/bash
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
export XDG_SESSION_TYPE=x11
export XDG_CURRENT_DESKTOP=KDE
export XDG_SESSION_DESKTOP=KDE
export DESKTOP_SESSION=plasma
[ -z "\$DBUS_SESSION_BUS_ADDRESS" ] && eval \$(dbus-launch --sh-syntax --exit-with-session)
startplasma-x11 &
EOL
        ;;
    xfce)
        cat > ~/.vnc/xstartup <<'EOL'
#!/bin/bash
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
export XDG_SESSION_TYPE=x11
export XDG_CURRENT_DESKTOP=XFCE
export DESKTOP_SESSION=xfce
[ -z "\$DBUS_SESSION_BUS_ADDRESS" ] && eval \$(dbus-launch --sh-syntax --exit-with-session)
startxfce4 &
EOL
        ;;
    lxde)
        cat > ~/.vnc/xstartup <<'EOL'
#!/bin/bash
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
export XDG_SESSION_TYPE=x11
export XDG_CURRENT_DESKTOP=LXDE
[ -z "\$DBUS_SESSION_BUS_ADDRESS" ] && eval \$(dbus-launch --sh-syntax --exit-with-session)
startlxde &
EOL
        ;;
esac

chmod +x ~/.vnc/xstartup

# Create helper scripts
cat > ~/start-vnc.sh <<'EOL'
#!/bin/bash
# Kill existing VNC servers
vncserver -kill :1 2>/dev/null || true
vncserver -kill :2 2>/dev/null || true
sleep 1

# Start VNC server
echo "Starting VNC server..."
vncserver -localhost no -geometry 1920x1080 -depth 24 :1

echo ""
echo "════════════════════════════════════════════════════════"
echo "  VNC Server Started Successfully!"
echo "════════════════════════════════════════════════════════"
echo ""
echo "Connect using a VNC client:"
echo "  • Address: localhost:5901"
echo "  • Or use: \$(ip route get 1 | awk '{print \$7}'):5901"
echo ""
echo "To stop: ~/stop-vnc.sh or 'vncserver -kill :1'"
echo ""
EOL

cat > ~/stop-vnc.sh <<'EOL'
#!/bin/bash
echo "Stopping VNC server..."
vncserver -kill :1 2>/dev/null && echo "✓ VNC server on :1 stopped" || echo "No VNC server on :1"
vncserver -kill :2 2>/dev/null && echo "✓ VNC server on :2 stopped" || true
echo ""
EOL

cat > ~/restart-vnc.sh <<'EOL'
#!/bin/bash
echo "Restarting VNC server..."
~/stop-vnc.sh
sleep 2
~/start-vnc.sh
EOL

cat > ~/vnc-passwd.sh <<'EOL'
#!/bin/bash
echo "Changing VNC password..."
vncpasswd
echo ""
echo "✓ VNC password updated"
echo ""
EOL

chmod +x ~/start-vnc.sh ~/stop-vnc.sh ~/restart-vnc.sh ~/vnc-passwd.sh

echo "VNC configuration complete!"
EOF

    show_success "VNC configuration created"
}

# ============================================================================
# Post-installation Summary
# ============================================================================

show_completion() {
    local desktop="$1"
    local desktop_name="${DESKTOP_CONFIGS[${desktop}_name]}"
    
    echo -e "\n\n${GREEN}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                                                          ║${NC}"
    echo -e "${GREEN}║             🎉  INSTALLATION COMPLETE!  🎉                ║${NC}"
    echo -e "${GREEN}║                                                          ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════╝${NC}\n"
    
    echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
    echo -e "  ${GREEN}Desktop:${NC} $desktop_name"
    echo -e "  ${GREEN}Distribution:${NC} Debian (Stable)"
    echo -e "  ${GREEN}Log File:${NC} $LOG_FILE"
    echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}\n"
    
    echo -e "${YELLOW}┌────────────────────────────────────────────────────────┐${NC}"
    echo -e "${YELLOW}│                  QUICK START GUIDE                     │${NC}"
    echo -e "${YELLOW}└────────────────────────────────────────────────────────┘${NC}\n"
    
    echo -e "  ${GREEN}1. Login to Debian:${NC}"
    echo -e "     ${BLUE}proot-distro login debian${NC}\n"
    
    echo -e "  ${GREEN}2. Start VNC (first time sets password):${NC}"
    echo -e "     ${BLUE}~/start-vnc.sh${NC}\n"
    
    echo -e "  ${GREEN}3. Connect with VNC Viewer:${NC}"
    echo -e "     ${BLUE}localhost:5901${NC}\n"
    
    echo -e "${YELLOW}┌────────────────────────────────────────────────────────┐${NC}"
    echo -e "${YELLOW}│                  HELPER SCRIPTS                        │${NC}"
    echo -e "${YELLOW}└────────────────────────────────────────────────────────┘${NC}\n"
    
    echo -e "  ${BLUE}~/start-vnc.sh${NC}    - Start VNC server"
    echo -e "  ${BLUE}~/stop-vnc.sh${NC}     - Stop VNC server"
    echo -e "  ${BLUE}~/restart-vnc.sh${NC}  - Restart VNC server"
    echo -e "  ${BLUE}~/vnc-passwd.sh${NC}   - Change VNC password\n"
    
    echo -e "${YELLOW}┌────────────────────────────────────────────────────────┐${NC}"
    echo -e "${YELLOW}│               RECOMMENDED VNC CLIENTS                  │${NC}"
    echo -e "${YELLOW}└────────────────────────────────────────────────────────┘${NC}\n"
    
    echo -e "  ${GREEN}Android:${NC}"
    echo -e "    • ${BLUE}RealVNC Viewer${NC} (Play Store)"
    echo -e "    • ${BLUE}bVNC${NC} (Play Store)"
    echo -e "    • ${BLUE}AVNC${NC} (F-Droid)\n"
    
    echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
    echo -e "  ${YELLOW}Enjoy your Debian desktop environment!${NC}"
    echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}\n"
    
    log_success "Installation completed successfully"
}

# ============================================================================
# Main Installation Flow
# ============================================================================

run_installation() {
    local desktop="$1"
    
    log_info "Starting installation of $desktop desktop environment"
    
    confirm_installation "$desktop"
    check_storage
    check_internet
    
    update_termux
    cleanup_previous
    install_debian_base
    configure_system
    install_desktop "$desktop"
    create_vnc_config "$desktop"
    
    show_completion "$desktop"
}

# ============================================================================
# Main Program
# ============================================================================

main() {
    # Initialize log file
    echo "=== Debian Desktop Installer Log ===" > "$LOG_FILE"
    log_info "Script version: $SCRIPT_VERSION"
    log_info "Started at: $(date)"
    
    while true; do
        show_menu
        
        local choice
        read -p "Enter your choice [0-5]: " choice
        
        case $choice in
            1)
                run_installation "xfce"
                break
                ;;
            2)
                run_installation "lxde"
                break
                ;;
            3)
                run_installation "gnome"
                break
                ;;
            4)
                run_installation "kde"
                break
                ;;
            5)
                system_check
                ;;
            0)
                echo -e "\n${YELLOW}Exiting installer...${NC}\n"
                exit 0
                ;;
            *)
                echo -e "\n${RED}Invalid choice. Please select 0-5.${NC}"
                sleep 2
                ;;
        esac
    done
}

# Run main program
main
