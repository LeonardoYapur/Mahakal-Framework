#!/bin/bash

# ─────────────────────────────────────────────────────────────────
# MAHAKAL FRAMEWORK INSTALLER 
# Author: CYBER-MRINAL
# Description: Installs all dependencies and sets up mahakal.sh
# ─────────────────────────────────────────────────────────────────

set -e

SCRIPT_NAME="mahakal.sh"
GIT=".git"
PATH_GIT="/usr/local/bin"
INSTALL_NAME="mahakal"
INSTALL_PATH="/usr/local/bin/$INSTALL_NAME"
LOG_FILE="/var/log/mahakal.log"
REQUIRED_CMDS=("whois" "nmap" "curl" "wpscan" "whatweb" "wafw00f" "dnsrecon" "dnsenum" "subfinder" "httprobe" "amass" "john" "hydra" "medusa" "hashcat" "gobuster" "ffuf" "nikto" "masscan" "unicornscan" "enum4linux-ng" "sqlmap" "ufw" "fail2ban" "inxi")

# ─────────────────────────────────────────────────────────────────

log() {
    echo "[$(date +'%F %T')] $1" | tee -a "$LOG_FILE"
}

# ─────────────────────────────────────────────────────────────────
detect_distro() {
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        echo "$ID"
    else
        echo "unknown"
    fi
}

# ─────────────────────────────────────────────────────────────────
install_missing_packages() {
    distro=$(detect_distro)
    echo -e "\033[1;31m"
    log " >> Detected distro: $distro"
    echo ""
    echo -e "\033[0m"

    case "$distro" in
        kali|debian|ubuntu)
            PKG_INSTALL="sudo apt-get install -y"
            sudo apt-get update
            ;;
        arch|manjaro|artix|athenaos)
            PKG_INSTALL="sudo pacman -S --noconfirm"
            sudo pacman -Sy
            ;;
        *)
            echo " >> ❌ Unsupported distro: $distro"
            log " >> Unsupported distro: $distro"
            exit 1
            ;;
    esac

    for cmd in "${REQUIRED_CMDS[@]}"; do
        if ! command -v "$cmd" >/dev/null 2>&1; then
            log " >> Installing missing dependency: $cmd"
            $PKG_INSTALL "$cmd"
        else
            log " >> Dependency already installed: $cmd"
        fi
    done

    # Additional Tool Installations
    if [[ "$distro" == "garuda" || "$distro" == "arch" || "$distro" == "manjaro" || "$distro" == "artix" || "$distro" == "athenaos" ]]; then
        if ! command -v torctl >/dev/null 2>&1; then
            log " >> Installing torctl & shodan for Arch-based system..."
            $PKG_INSTALL torctl
            $PKG_INSTALL python-shodan
        else
            log " >> torctl & shodan already installed."
        fi
    fi

    # Kali-anonsurf installation prompt
    if [[ "$distro" == "kali" || "$distro" == "debian" || "$distro" == "ubuntu" ]]; then
        echo ""
        echo -e "\033[1;34m[🔒] Do you want to install kali-anonsurf (for anonymity)?\033[0m"
        read -rp "➡️  Install 'kali-anonsurf' from GitHub? [y/N]: " install_anonsurf
    
        case "$install_anonsurf" in
            y|Y)
                if [[ ! -d "/opt/kali-anonsurf" ]]; then
                    log " >> Cloning kali-anonsurf repository..."
                    sudo git clone https://github.com/Und3rf10w/kali-anonsurf.git /opt/kali-anonsurf
                    cd /opt/kali-anonsurf
                    sudo bash installer.sh || log " >> Warning: installer.sh may require manual intervention."
                    cd -
                else
                    log " >> kali-anonsurf already exists in /opt."
                fi
                ;;
            *)
                echo -e "\033[1;36m[ℹ️] Skipped anonsurf installation. You can manually check:\033[0m"
                echo -e "\033[1;32m🔗 https://github.com/Und3rf10w/kali-anonsurf\033[0m"
                log " >> Skipped anonsurf install by user choice."
                ;;
        esac
    fi
}

# ─────────────────────────────────────────────────────────────────
validate_script() {
    if [[ ! -f "$SCRIPT_NAME" ]]; then
        echo -e "\033[1;31m"
        echo "❌ Cannot find $SCRIPT_NAME in the current directory."
        log "Script missing: $SCRIPT_NAME"
        echo -e "\033[0m"
        exit 1
    fi
    chmod +x "$SCRIPT_NAME"
    log "$SCRIPT_NAME made executable."
}

# ─────────────────────────────────────────────────────────────────
install_system_wide() {
    sudo cp "$SCRIPT_NAME" "$INSTALL_PATH"
    sudo cp -r "$GIT" "$PATH_GIT"
    sudo chmod +x "$INSTALL_PATH"
    log "->> Installed as system command: $INSTALL_NAME"
    echo "->> ✅ Tool is now available as: $INSTALL_NAME"
}

# ─────────────────────────────────────────────────────────────────
main() {
    echo -e "\033[1;33m"
    echo "    🔧 Setting up MAHAKAL Framework..."
    log "<==== SETUP START ====>"
    echo -e "\033[0m"

    install_missing_packages
    validate_script

    echo ""
    echo -e "\033[1;33m"
    read -rp "➡️  Install system-wide as '$INSTALL_NAME'? [y/N]: " choice
    case "$choice" in
        y|Y) install_system_wide ;;
        *) echo "ℹ️  Skipped system-wide install. Use ./mahakal.sh to run." ;;
    esac
    echo -e "\033[0m"
    
    echo -e "\033[1;33m"
    echo "      ✅ Setup complete Jai Mahakal...."
    echo "'AI' you can install using 'mahakal' script just do this -> 'cd ai' & 'intdeb' or for arch 'intarch'"
    log "<==== SETUP COMPLETE ====>"
    echo -e "\033[0m"
}

main
