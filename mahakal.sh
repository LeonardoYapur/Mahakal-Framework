#!/bin/bash

# Configuration
LOGFILE="/var/log/mahakal.log"
BACKUP_DIR="/var/backups/mahakal"
SCRIPT_PATH="$(realpath "$0")"
HISTORY_FILE="/var/.mahakal_command_history"

# Load history from file if it exists
if [[ -f "$HISTORY_FILE" ]]; then
    history -r "$HISTORY_FILE"
fi

# Function to check if the script is run as root
check_root() {
    if [ "$EUID" -ne 0 ]; then
        echo -e "\033[1;31m"  # Red color
        echo "                                                <}--o(RUN-THIS-SCRIPT-WITH-SUDO)o--{>"
        echo -e "\033[0m"  # Reset color
        exit 1
    fi
}

# Function to save history to file
save_history() {
    history -a "$HISTORY_FILE"
}

# Function to log messages
log_message() {
    local level="$1"
    local message="$2"
    echo "$(date '+%Y-%m-%d %H:%M:%S') [$level] $message" >> $LOGFILE
}

# Function to send alerts
send_alert() {
    local message="$1"
    echo "Sending alert: $message"  # Debugging line
}

# Function to display a futuristic banner
display_banner() {
    echo -e "\033[1;36m"  # Cyan color
    echo " "
    echo "                                               _ ____ _    _  _ ____ _  _ ____ _  _ ____ _                   "
    echo "                                               | |__| | __ |\/| |__| |__| |__| |_/  |__| |                   "
    echo "                                              _| |  | |    |  | |  | |  | |  | | \_ |  | |___               "
    echo -e "\033[1;31m"
    echo "                                                       <)--o(CYBER-MRINAL)o--(>                     "
    echo -e "\033[0;36m"
    echo "                                       👤 User >> $(whoami)   ⏱️Time >>  $(date '+%H:%M:%S')  🧠  $(hostname)  "
    echo -e "\033[0m"
}

display_fuck_banner1() {
    echo "   ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣤⣤⣤⣄⡀⠄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⠀⠀   "
    echo "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⣿⣿⣿⣿⣿⣿⣿⣷India🇮🇳⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡈⠀⠀⠀⠀ "
    echo "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠂⠀⠀⠀⠀⠀          "
    echo "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠁⠀⠀⠀⠀⠀          "
    echo "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢿⣿⣿⣿⣿⣿⣿⣿⡿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⠀⠀⠂⠀⠀⠀⠀⠀⠀           "
    echo "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠻⠿⠿⠿⠟⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠅⠀⠀⠀⠀⠀⠀⠀            "
    echo "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣶⣿⣿⣶⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠⠀⠀⠀⠀⠀⠀⠄⠀⠀⠀⠀⠀⠀⠀⠀             "
    echo "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⣿⣿⣿⣿⣿⣿⣿⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠⠀⠀⠀⡄⠀⠀⠀⠀⠀⠀⠀⠀            "
    echo "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⠀⠀⠀⡀⠀⠈⠀⠀⠀⠀⠀⠀            "
    echo "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠑⠀⠀⠀⠀⠀⠀⠀⠂⠄⠀⠀⠀⠀⠀⠀⠀⠀            "
    echo "⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⠀⠀⠀⠀⠀⠀⠀⠀            "
    echo "⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠⠀⠀⠀⠀⠐⠀⠀⠀⠀⠀⠀⠀⠀⠀            "
    echo "⠀⠀⠀⠀⠀⠀⠀⠀⣸⣿⣿⣿⣿⣿⣿⣿⣿⡟⣿⣿⣿⣿⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣤⣶⣾⣿⣶⣶⣤⡀⠀⠀           "
    echo "⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⣿⣿⣿⣿⣿⣿⡿⠀⠘⢿⣿⣿⣿⣷⡀⠀⠐⠀⠀⠀⠀⠀⠀⠠⠀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⡤pakistan🇵🇰⠀ "
    echo "⠀⠀⠀⠀⠀⠀⠀⣼⣿⣿⣿⣿⣿⣿⣿⣿⠇⠀⠀⠈⠻⣿⣿⣿⣿⣆⠂⠀⠀⢀⠀⠀⠈⠀⢰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀         "
    echo "⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⡟⠀⣀⣤⣶⣶⣌⠻⣿⣿⣿⣷⡄⠀⠀⠀⠀⢀⠀⣸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠀       "
    echo "⠀⠀⠀⠀⠀⠀⠀⠹⣿⣿⣿⣿⣿⣿⣿⠁⣰⣿⣿⣿⣿⣿⣦⣙⢿⣿⣿⣿⠄⠀⠀⠀⠀⡂⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⠀⠀      "
    echo "⠀⠀⠀⠀⠀⠀⠀⠀⢿⣿⣿⣿⣿⣿⣿⠀⣿⣿⣿⣿⣿⣿⣿⣿⣦⣹⣟⣫⣼⣿⣿⣶⣿⣿⣿⣿⣿⣿⣯⡉⠉⠉⠁⠀⠀⠀⠀     "
    echo "⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠐⠀⠀⠀     "
    echo "⠀⠀⠀⠀⠀⠀⠀⠀⠈⣿⣿⣿⣿⣿⣿⡆⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠁⠀⠀⠀⠀⠀    "
    echo "⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⡇⠀⢻⣿⣿⣿⣿⣿⡇⠀⠀⠈⠉⠉⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⠉⠀⠀⠀⠀⠀⠀⠀     "
    echo "⠀⣠⣴⣶⣶⣶⣶⣶⣶⣾⣿⣿⣿⣿⣿⡇⠀⠸⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠹⢿⣿⣿⢿⣿⣿⣿⡿⠀⠀⠀⠀⠀⠀⠀⠀    "
    echo "⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⢰⣶⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠃⢸⣿⣿⣿⣧⣄⣐⣀⣀⣀⣀⣀⡀   "
    echo "⠸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⢸⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿   "
    echo "⠀⠀⠉⠉⠙⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠁⠛⠛⠛⠛⠛⠛⠛⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠊⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠁   "
    echo " "
}

display_blowjob_banner() {
    echo "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⣤⣄⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀  "
    echo "⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣴⣿⣿⣿⣿⣿⣿⣿⣦⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀  "
    echo "⠀⠀⠀⠀⠀⠀⠀⠀⣸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀   "
    echo "⠀⠀⠀⠀⠀⠀⠀⢰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀   "
    echo "⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠁INDIA⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"⠀
    echo "⠀⠀⠀⠀⠀⠀⠀⠀⠸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀   "
    echo "⠀⠀⠀⠀⣀⣤⣤⣄⡀⠈⠻⣿⣿⣿⣿⣿⣿⣿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀   "
    echo "⠀⢀⣴⣿⣿⣿⣿⣿⣿⣦⠀⠀⠈⠉⠉⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀   "
    echo "⢀⣾⣿⣿⠟⣻⣿⣿⡟⣿⣧⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀    "
    echo "⢸⣿⣿⣿⣼⣿⣿⣿⣿⣼⡻⠓⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀    "
    echo "⢸⣿⣿⣿⣌⢻⣿⣿⣿⣿⣿⣤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀    "
    echo "⢸⣿⣿⣿⣿⣦⣙⢿⣿⣿⣿⣿⣷⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀    "
    echo "⢸⣿⣿⣿⣿⣿⣿⣦⡙⢿⣿⣿⣿⣿⣿⣤⣀⠀⠀⠠⣶⡶⣶⣶⣶⣤⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀    "
    echo "⠈⢿⣿⣿⣿⣿⣿⣿⣿⣦⡙⢿⣿⣿⣿⣿⣿⣿⣿⣷⣶⣶⣶⣶⣯⣿⣿⣶⣴⣤⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠄⠀⠀    "
    echo "⠀⠸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⠹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠆ PAKISTAN⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐⠀⠀⠀⠀"
    echo "⠀⠀⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡄⠉⠉⣿⣯⣝⣋⡛⠟⠿⠿⠿⠿⠿⣿⡿⠿⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⠀⠂⠀⠀⠀    "
    echo "⠀⠀⠈⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡄⠀⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⠀⠂⠀⠀⠀⠀     "
    echo "⠀⠀⠀⠘⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣄⠈⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⢃⣤⣴⣿⣿⣿⣿⣶⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠄⠀⠀⠀⠀⠀     "
    echo "⠀⠀⠀⠀⠘⢿⣿⣿⡿⢿⣿⣿⣿⣿⣿⣿⡄⠀⠈⠛⠿⠿⠿⠿⠟⠋⠁⢐⣿⣿⣟⣻⣿⣟⢿⣿⣿⣿⣦⡀⠀⠀⠀⠀⠐⠀⠄⠀⠀⠀⠀⠀⠀    "
    echo "⠀⠀⠀⠀⠀⠈⣿⣿⣿⣷⣬⣍⣛⣛⠿⣿⣿⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⣘⣿⣿⣿⣿⣿⣿⣎⢿⣿⣿⣿⣿⣦⡀⠀⠀⠀⠘⠀⠀⠀⠀⠀⠀⠀    "
    echo "⠀⠀⠀⠀⠀⠀⢿⣿⣿⣿⣿⣿⣿⣿⣷⣦⣭⣿⣷⡀⠀⠀⠀⠀⠀⣤⣶⣿⣿⣿⣿⣿⣿⣿⣩⣿⣿⣿⣿⣿⣿⣷⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀    "
    echo "⠀⠀⠀⠀⠀⠀⠘⠻⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣦⣤⣀⣤⣾⣿⣿⣿⣿⣿⣿⣿⣻⣽⣿⣿⣿⣿⣿⣿⣿⣿⣿⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀   "
    echo "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠙⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠋⠀⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⠀⠀⠀⠀⠀⠀⠀⠀   "
    echo "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⣷⣦⣭⣝⡛⠿⣿⣿⣿⣿⣿⡿⠛⠁⠀⠀⠀⠀⠹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⠀⠀⠀⠀⠀⠀⠀    "
    echo "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣿⣿⣿⣿⣷⣶⣾⣿⡍⠉⠀⠀⠀⠀⠀⠀⠀⠀⠈⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣇⠀⠀⠀⠀⠀⠀     "
    echo "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣹⣿⣿⣿⣿⣿⣿⣿⡇⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡆⠀⠀⠀⠀⠀     "
    echo "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⣿⣿⣿⣿⣿⣿⣿⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀     "
    echo "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⣿⣿⣿⣿⣿⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠀⠀⠀⠀⠀⠀     "
    echo "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⣿⣿⣿⣿⣿⡿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋⠀⠀⠀⠀⠀⠀⠀     "
    echo "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⣿⣿⣿⣿⣿⣿⡿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀     "
    echo "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣿⣿⣿⣿⣿⣿⣿⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣶⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀     "
    echo "⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣼⣿⣿⣿⣿⣿⣿⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣤⣄⠀   "
    echo "⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⣿⣿⣿⣿⣿⣿⣿⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡆   "
    echo "⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟   "
    echo "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢿⣿⣿⣿⡿⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⠀   "
    echo "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀       "
}

# Main function to run user commands
run_user_commands() {
    local current_section="HOME"

    while true; do
        # Read input with readline support
        read -e -p "$(echo -e "\033[1;31m($(date +"%I:%M:%S %p"))\033[1;34m-(MAHAKAL)\033[0m-(${current_section})> ")" user_command

        # Exit the loop if the user types 'exit'
        if [[ "$user_command" == "exit" ]]; then
            break   
        fi

        # If the input is empty, continue to the next iteration
        if [[ -z "$user_command" ]]; then
            continue
        fi

        # Add the command to history
        history -s "$user_command"

        # Execute the command if it's valid
        case "$user_command" in
            "exit")
                break
                ;;
            "mip")
                echo -e "\033[1;32m"  # Green color
                echo "Your IP address is: $(curl -s ifconfig.me)"
                echo -e "\033[0m"  # Reset color
                log_message "INFO" "User checked IP address"
                ;;
            "cd nmap")
                current_section="NMAP"
                manage_nmap_commands
                current_section="HOME"
                ;;
            "cd curl")
                current_section="CURL"
                manage_curl_commands
                current_section="HOME"
                ;;
            "cd whatweb")
                current_section="WHATWEB"
                manage_whatweb_commands
                current_section="HOME"
                ;;
            "cd wpscan")
                current_section="WPSCAN"
                manage_wpscan_commands
                current_section="HOME"
                ;;
            "cd waf")
                current_section="WAFW00F"
                manage_wafw00f_commands
                current_section="HOME"
                ;;
            "cd subfinder")
                current_section="SUBFINDER"
                manage_subfinder_commands
                current_section="HOME"
                ;;
            "cd dnsrecon")
                current_section="DNSRECON"
                manage_dnsrecon_commands
                current_section="HOME"
                ;;
            "cd dnsenum")
                current_section="DNSENUM"
                manage_dnsenum_commands
                current_section="HOME"
                ;;
            "cd httprobe")
                current_section="HTTPROBE"
                manage_httprobe_commands
                current_section="HOME"
                ;;
            "cd whois")
                current_section="WHOIS"
                manage_whois_commands
                current_section="HOME"
                ;;
            "cd amass")
                current_section="AMASS"
                manage_amass_commands
                current_section="HOME"
                ;;
            "cd hydra")
                current_section="HYDRA"
                manage_hydra_commands
                current_section="HOME"
                ;;
            "cd medusa")
                current_section="MEDUSA"
                manage_medusa_commands
                current_section="HOME"
                ;;
            "cd john")
                current_section="JOHN"
                manage_john_commands
                current_section="HOME"
                ;;
            "cd hashcat")
                current_section="HASHCAT"
                manage_hashcat_commands
                current_section="HOME"
                ;;
            "cd gobuster")
                current_section="GOBUSTER"
                manage_gobuster_commands
                current_section="HOME"
                ;;
            "cd ffuf")
                current_section="FFUF"
                manage_ffuf_commands
                current_section="HOME"
                ;;
            "cd nikto")
                current_section="NIKTO"
                manage_nikto_commands
                current_section="HOME"
                ;;
            "cd masscan")
                current_section="MASSCAN"
                manage_masscan_commands
                current_section="HOME"
                ;;
            "cd unic")
                current_section="UNICORNSCAN"
                manage_unicornscan_commands
                current_section="HOME"
                ;;
            "cd enumli")
                current_section="ENUM4LINUX"
                manage_enum4linux_commands
                current_section="HOME"
                ;;
            "cd sqlmap")
                current_section="SQLMAP"
                manage_sqlmap_commands
                current_section="HOME"
                ;;
            "cd ai")
                current_section="AI"
                chat_ai
                current_section="HOME"
                ;;
            "cd css")
                current_section="CSS"
                check_sys_status
                current_section="HOME"
                ;;
            "cd anony")
                current_section="ANONY"
                traffic_anony
                current_section="HOME"
                ;;
            "cd ufw")
                current_section="UFW"
                manage_firewall
                current_section="HOME"
                ;;
            "banner")
                display_banner
                ;;
            "dstyle")
                display_fuck_banner1
                ;;
            "bjob")
                display_blowjob_banner
                ;;
            "clear")
                clear  # Clear the terminal
                ;;
            "cd ..")
                current_section="HOME"  # Only set to HOME when "back" is entered
                ;;
            "ls")
                echo -e "\033[1;33m" "\n       AVALIABLE DIRECTORIES (AD): \033[0m"
                echo -e "\033[1;32m"
                echo "     >>>   1.  ai          - Chat with ai"
                echo "     >>>   2.  nmap        - Network scanning and enumeration"
                echo "     >>>   3.  css         - Check system status"
                echo "     >>>   4.  anony       - Anonymous network traffic manager"
                echo "     >>>   5.  curl        - Curl use for recon purpose"
                echo "     >>>   6.  whatweb     - Use whatweb commands"
                echo "     >>>   7.  wpscan      - Scan wordpress website using wpscan"
                echo "     >>>   8.  waf         - WAFW00F for web application firewall detection"
                echo "     >>>   9.  subfinder   - Subdomain finder"
                echo "     >>>  10.  dnsrecon    - DNS reconnaissance tool"
                echo "     >>>  11.  dnsenum     - DNS enumeration tool"
                echo "     >>>  12.  httprobe    - HTTP probing tool"
                echo "     >>>  13.  mip         - Show your public IP address (JUST USE 'mip' DON'T USE 'cd mip')"
                echo "     >>>  14.  whois       - Perform a WHOIS lookup"
                echo "     >>>  15.  amass       - Amass for DNS enumeration"
                echo "     >>>  16.  hydra       - Hydra for brute-force attacks"
                echo "     >>>  17.  medusa      - Medusa for brute-force attacks"
                echo "     >>>  18.  gobuster    - Directory brute-forcing tool"
                echo "     >>>  19.  hashcat     - Hashcat for password cracking"
                echo "     >>>  20.  john        - John the Ripper for password cracking"
                echo "     >>>  21.  nikto       - Nikto for web server scanning"
                echo "     >>>  22.  masscan     - Masscan for fast port scanning"
                echo "     >>>  23.  ffuf        - Fuzzing tool"
                echo "     >>>  24.  unic        - Unicornscan for network scanning"
                echo "     >>>  25.  enumli      - Enumeration tool for Linux systems"
                echo "     >>>  26.  sqlmap      - SQL injection and database takeover tool"  
                echo "     >>>  27.  ufw         - Manage firewall rules"           
                echo -e "\033[1;31m" "\n->> Usage: cd ai (TO ENTER AI SECTION) \033[0m" # Red color
                echo ""
                ;;
            "help")
                echo -e "\033[1;33m" "\n        GLOBAL HELP (GH): \033[0m"
                echo -e "\033[1;32m"
                echo "     >>>   1. ls        - List avaliable security tools in this framework"
                echo "     >>>   2. cd        - To enter New Choosen Section (cd ffuf)"
                echo "     >>>   3. cd ..     - To get back from one section to HOME menu (If 'cd ..' is not working then use 'exit' command)"
                echo "     >>>   4. clear     - Clear the terminal"
                echo "     >>>   5. exit      - Exit the command interface"
                echo "     >>>   6. banner    - To show the banner"
                echo "     >>>   7. dstyle    - Just enjoy Indian hackers (Fun purpose)"
                echo "     >>>   8. bjob      - Just enjoy Indian Hackers (Fun purpose)"
                echo "     >>>   9. mip       - Show your public IP address (JUST USE 'mip' DON'T USE 'cd mip')"
                echo -e "\033[1;31m"  # Red color
                echo ">> By pressing CTRL+C the whole script stops (BE CAREFULL)"
                echo ">> If you see any warning while useing 'cd ..' then check your section name or execute 'exit' command to exit from the section."
                echo -e "\033[0m"  # Reset color
                ;;
            *)
                echo -e "\033[1;31m"
                echo "-->> Invalid Command. Please use 'help/ls' to see the commands."
                echo -e "\033[0m"  # Reset color
                ;;
        esac

        # Save history to file
        save_history
    done
}

manage_nmap_commands() {
    local current_section="NMAP"

    if [[ -f "$HISTORY_FILE" ]]; then
        history -r "$HISTORY_FILE"
    fi

    while true; do
        read -e -p "$(echo -e "\033[1;31m($(date +"%I:%M:%S %p"))\033[1;34m-(MAHAKAL)\033[0m-(${current_section})> ")" input
        [[ "$input" == "exit" ]] && break
        [[ -z "$input" ]] && continue

        history -s "$input"

        local cmd=$(echo "$input" | awk '{print $1}')
        local target=$(echo "$input" | cut -d' ' -f2-)

        case $input in
            "cd ..")
                return
                ;;
            "mip")
                echo -e "\033[1;32m"  # Green color
                echo "Your IP address is: $(curl -s ifconfig.me)"
                echo -e "\033[0m"  # Reset color
                log_message "INFO" "User checked IP address"
                ;;
            "cd curl")
                current_section="CURL"
                manage_curl_commands
                current_section="NMAP"
                ;;
            "cd whatweb")
                current_section="WHATWEB"
                manage_whatweb_commands
                current_section="NMAP"
                ;;
            "cd wpscan")
                current_section="WPSCAN"
                manage_wpscan_commands
                current_section="NMAP"
                ;;
            "cd ai")
                current_section="AI"
                chat_ai
                current_section="NMAP"
                ;;
            "cd css")
                current_section="CSS"
                check_sys_status
                current_section="NMAP"
                ;;
            "cd anony")
                current_section="ANONY"
                traffic_anony
                current_section="NMAP"
                ;;
            "cd waf")
                current_section="WAFW00F"
                traffic_anony
                current_section="NMAP"
                ;;
            "cd subfinder")
                current_section="SUBFINDER"
                manage_subfinder_commands
                current_section="NMAP"
                ;;
            "cd dnsrecon")
                current_section="DNSRECON"
                manage_dnsrecon_commands
                current_section="NMAP"
                ;;
            "cd dnsenum")
                current_section="DNSENUM"
                manage_dnsenum_commands
                current_section="NMAP"
                ;;
            "cd httprobe")
                current_section="HTTPROBE"
                manage_httprobe_commands
                current_section="NMAP"
                ;;
            "cd whois")
                current_section="WHOIS"
                manage_whois_commands
                current_section="NMAP"
                ;;
            "cd amass")
                current_section="AMASS"
                manage_amass_commands
                current_section="NMAP"
                ;;
            "cd hydra")
                current_section="HYDRA"
                manage_hydra_commands
                current_section="NMAP"
                ;;
            "cd medusa")
                current_section="MEDUSA"
                manage_medusa_commands
                current_section="NMAP"
                ;;
            "cd john")
                current_section="JOHN"
                manage_john_commands
                current_section="NMAP"
                ;;
            "cd hashcat")
                current_section="HASHCAT"
                manage_hashcat_commands
                current_section="NMAP"
                ;;
            "cd gobuster")
                current_section="GOBUSTER"
                manage_gobuster_commands
                current_section="NMAP"
                ;;
            "cd ffuf")
                current_section="FFUF"
                manage_ffuf_commands
                current_section="NMAP"
                ;;
            "cd nikto")
                current_section="NIKTO"
                manage_nikto_commands
                current_section="NMAP"
                ;;
            "cd masscan")
                current_section="MASSCAN"
                manage_masscan_commands
                current_section="NMAP"
                ;;
            "cd unic")
                current_section="UNICORNSCAN"
                manage_unicornscan_commands
                current_section="NMAP"
                ;;
            "cd enumli")
                current_section="ENUM4LINUX"
                manage_enum4linux_commands
                current_section="NMAP"
                ;;
            "cd sqlmap")
                current_section="SQLMAP"
                manage_sqlmap_commands
                current_section="NMAP"
                ;;
            "jai mahakal")
                current_section="HOME"
                ;;
            "cd ufw")
                current_section="UFW"
                manage_firewall
                current_section="NMAP"
                ;;
        esac

        case $cmd in
            "nver")
                echo -e "\033[1;32m       CHECKING NMAP VERSION...\033[0m"
                log_message "INFO" "Checking Nmap version"
                nmap --version | grep version
                ;;
            "ls")
                echo -e "\033[1;33m\n        NMAP COMMANDS: \033[0m"
                echo -e "\033[1;32m"
                echo "     >>>  nver                  - Show Nmap version"
                echo "     >>>  quick [target]        - Quick scan"
                echo "     >>>  full [target]         - Full TCP port scan"
                echo "     >>>  stealth [target]      - Stealth SYN scan"
                echo "     >>>  osdetect [target]     - OS & Service detection"
                echo "     >>>  vuln [target]         - Vulnerability scan"
                echo "     >>>  evade [target]        - Firewall evasion scan"
                echo "     >>>  topports [target]     - Scan top 100 ports"
                echo "     >>>  udp [target]          - Top 50 UDP ports"
                echo "     >>>  firewalk [target]     - Firewall rule tracing"
                echo "     >>>  httpenum [target]     - HTTP service enumeration"
                echo "     >>>  ftpbrute [target]     - Brute-force FTP"
                echo "     >>>  smbcheck [target]     - SMB shares check"
                echo "     >>>  snmpenum [target]     - SNMP enum (UDP 161)"
                echo "     >>>  bannergrab [target]   - TCP banner grab"
                echo "     >>>  scriptscan [target]   - All default scripts"
                echo "     >>>  slow [target]         - Stealth IDS bypass scan"
                echo "     >>>  custom [args]         - Custom Nmap command"
                echo "     >>>  dnsbrute [target]     - Brute-force DNS subdomains"
                echo "     >>>  traceroute [target]   - Trace route to target"
                echo "     >>>  ipv6scan [target]     - IPv6 scanning"
                echo "     >>>  reverse [target]      - Reverse DNS lookup"
                echo "     >>>  sshcheck [target]     - SSH enumeration"
                echo "     >>>  mysqlenum [target]    - MySQL service enumeration"
                echo "     >>>  rdpenum [target]      - RDP protocol scan"
                echo "     >>>  smtpcheck [target]    - SMTP command check"
                echo "     >>>  rdns [CIDR]           - Reverse DNS for IP range"
                echo "     >>>  allports [target]     - Full TCP + UDP port scan"
                echo "     >>>  quickscan [target]    - Host discovery only"
                echo "     >>>  webvuln [target]      - Scan common HTTP vulns"
                echo -e "\033[0m"
                ;;
            "quick") [[ -z "$target" ]] && echo -e "\033[1;31mUsage: quick [target]\033[0m" && continue
                echo -e "\033[1;32m>>> Quick scan on $target...\033[0m"
                log_message "INFO" "Running quick scan on $target"
                nmap -T4 -F "$target"
                ;;
            "full") [[ -z "$target" ]] && echo -e "\033[1;31mUsage: full [target]\033[0m" && continue
                log_message "INFO" "Running full TCP scan on $target"
                echo -e "\033[1;32m>>> Full TCP scan on $target...\033[0m"
                nmap -T4 -p- "$target"
                ;;
            "stealth") [[ -z "$target" ]] && echo -e "\033[1;31mUsage: stealth [target]\033[0m" && continue
                log_message "INFO" "Running SYN scan on $target"
                echo -e "\033[1;32m>>> SYN scan on $target...\033[0m"
                nmap -sS -T4 "$target"
                ;;
            "osdetect") [[ -z "$target" ]] && echo -e "\033[1;31mUsage: osdetect [target]\033[0m" && continue
                log_message "INFO" "Running OS detection on $target"
                echo -e "\033[1;32m>>> OS detection on $target...\033[0m"
                nmap -A "$target"
                ;;
            "vuln") [[ -z "$target" ]] && echo -e "\033[1;31mUsage: vuln [target]\033[0m" && continue
                log_message "INFO" "Running vulnerability scan on $target"
                echo -e "\033[1;32m>>> Vulnerability scan on $target...\033[0m"
                nmap --script vuln "$target"
                ;;
            "evade") [[ -z "$target" ]] && echo -e "\033[1;31mUsage: evade [target]\033[0m" && continue
                log_message "INFO" "Running evasion scan on $target"
                echo -e "\033[1;32m>>> Evasion scan on $target...\033[0m"
                nmap -f -D RND:10 "$target"
                ;;
            "topports") [[ -z "$target" ]] && echo -e "\033[1;31mUsage: topports [target]\033[0m" && continue
                log_message "INFO" "Running top 100 ports scan on $target"
                echo -e "\033[1;32m>>> Top 100 ports scan on $target...\033[0m"
                nmap --top-ports 100 -T4 "$target"
                ;;
            "udp") [[ -z "$target" ]] && echo -e "\033[1;31mUsage: udp [target]\033[0m" && continue
                log_message "INFO" "Running top 50 UDP ports scan on $target"
                echo -e "\033[1;32m>>> UDP scan on $target...\033[0m"
                nmap -sU --top-ports 50 "$target"
                ;;
            "firewalk") [[ -z "$target" ]] && echo -e "\033[1;31mUsage: firewalk [target]\033[0m" && continue
                log_message "INFO" "Tracing firewall behavior on $target"
                echo -e "\033[1;32m>>> Tracing firewall behavior on $target...\033[0m"
                nmap -sS --traceroute "$target"
                ;;
            "httpenum") [[ -z "$target" ]] && echo -e "\033[1;31mUsage: httpenum [target]\033[0m" && continue
                log_message "INFO" "Enumerating HTTP services on $target"
                echo -e "\033[1;32m>>> Enumerating HTTP services on $target...\033[0m"
                nmap -p 80,443 --script http-enum "$target"
                ;;
            "ftpbrute") [[ -z "$target" ]] && echo -e "\033[1;31mUsage: ftpbrute [target]\033[0m" && continue
                log_message "INFO" "Brute-forcing FTP login on $target"
                echo -e "\033[1;32m>>> Brute-forcing FTP login on $target...\033[0m"
                nmap -p 21 --script ftp-brute "$target"
                ;;
            "smbcheck") [[ -z "$target" ]] && echo -e "\033[1;31mUsage: smbcheck [target]\033[0m" && continue
                log_message "INFO" "Checking SMB shares on $target"
                echo -e "\033[1;32m>>> Checking SMB shares on $target...\033[0m"
                nmap -p 445 --script smb-enum-shares "$target"
                ;;
            "snmpenum") [[ -z "$target" ]] && echo -e "\033[1;31mUsage: snmpenum [target]\033[0m" && continue
                log_message "INFO" "Enumerating SNMP on $target"
                echo -e "\033[1;32m>>> Enumerating SNMP on $target...\033[0m"
                nmap -sU -p 161 --script snmp-info "$target"
                ;;
            "bannergrab") [[ -z "$target" ]] && echo -e "\033[1;31mUsage: bannergrab [target]\033[0m" && continue
                log_message "INFO" "Grabbing TCP banners on $target"
                echo -e "\033[1;32m>>> Grabbing TCP banners on $target...\033[0m"
                nmap -sV "$target"
                ;;
            "scriptscan") [[ -z "$target" ]] && echo -e "\033[1;31mUsage: scriptscan [target]\033[0m" && continue
                log_message "INFO" "Running all default scripts on $target"
                echo -e "\033[1;32m>>> Running all default scripts on $target...\033[0m"
                nmap -sC "$target"
                ;;
            "slow") [[ -z "$target" ]] && echo -e "\033[1;31mUsage: slow [target]\033[0m" && continue
                log_message "INFO" "Running stealth scan to avoid detection on $target"
                echo -e "\033[1;32m>>> Running stealth scan to avoid detection...\033[0m"
                nmap -sS -T1 --scan-delay 1s "$target"
                ;;
            "custom") [[ -z "$target" ]] && echo -e "\033[1;31mUsage: custom [nmap args]\033[0m" && continue
                log_message "INFO" "Running custom Nmap command on $target"
                echo -e "\033[1;32m>>> Running custom: nmap $target\033[0m"
                nmap $target
                ;;
            "dnsbrute") [[ -z "$target" ]] && echo -e "\033[1;31mUsage: dnsbrute [domain]\033[0m" && continue
                log_message "INFO" "Running DNS subdomain brute-force on $target"
                echo -e "\033[1;32m>>> Brute-forcing DNS on $target...\033[0m"
                nmap -p 53 --script dns-brute "$target"
                ;;
            "traceroute") [[ -z "$target" ]] && echo -e "\033[1;31mUsage: traceroute [target]\033[0m" && continue
                log_message "INFO" "Running traceroute on $target"
                echo -e "\033[1;32m>>> Running traceroute on $target...\033[0m"
                nmap --traceroute "$target"
                ;;
            "ipv6scan") [[ -z "$target" ]] && echo -e "\033[1;31mUsage: ipv6scan [IPv6 address]\033[0m" && continue
                log_message "INFO" "Running IPv6 scan on $target"
                echo -e "\033[1;32m>>> Running IPv6 scan on $target...\033[0m"
                nmap -6 "$target"
                ;;
            "reverse") [[ -z "$target" ]] && echo -e "\033[1;31mUsage: reverse [target IP]\033[0m" && continue
                log_message "INFO" "Running reverse DNS on $target"
                echo -e "\033[1;32m>>> Performing reverse DNS lookup on $target...\033[0m"
                nmap -sL "$target"
                ;;
            "sshcheck") [[ -z "$target" ]] && echo -e "\033[1;31mUsage: sshcheck [target]\033[0m" && continue
                log_message "INFO" "Checking SSH version and config on $target"
                echo -e "\033[1;32m>>> Checking SSH on $target...\033[0m"
                nmap -p 22 --script ssh2-enum-algos,ssh-hostkey "$target"
                ;;
            "mysqlenum") [[ -z "$target" ]] && echo -e "\033[1;31mUsage: mysqlenum [target]\033[0m" && continue
                log_message "INFO" "Enumerating MySQL on $target"
                echo -e "\033[1;32m>>> Enumerating MySQL service on $target...\033[0m"
                nmap -p 3306 --script mysql-enum "$target"
                ;;
            "rdpenum") [[ -z "$target" ]] && echo -e "\033[1;31mUsage: rdpenum [target]\033[0m" && continue
                log_message "INFO" "Checking RDP service on $target"
                echo -e "\033[1;32m>>> Checking RDP service on $target...\033[0m"
                nmap -p 3389 --script rdp-enum-encryption "$target"
                ;;
            "smtpcheck") [[ -z "$target" ]] && echo -e "\033[1;31mUsage: smtpcheck [target]\033[0m" && continue
                log_message "INFO" "SMTP check on $target"
                echo -e "\033[1;32m>>> Checking SMTP service on $target...\033[0m"
                nmap -p 25 --script smtp-commands "$target"
                ;;
            "rdns") [[ -z "$target" ]] && echo -e "\033[1;31mUsage: rdns [CIDR or IP list]\033[0m" && continue
                log_message "INFO" "Listing reverse DNS for $target"
                echo -e "\033[1;32m>>> Listing PTR records for $target...\033[0m"
                nmap -sL "$target"
                ;;
            "allports") [[ -z "$target" ]] && echo -e "\033[1;31mUsage: allports [target]\033[0m" && continue
                log_message "INFO" "Running full TCP and UDP scan on $target"
                echo -e "\033[1;32m>>> Scanning all ports TCP and UDP on $target...\033[0m"
                nmap -sS -sU -p T:1-65535,U:1-1000 "$target"
                ;;
            "quickscan") [[ -z "$target" ]] && echo -e "\033[1;31mUsage: quickscan [target]\033[0m" && continue
                log_message "INFO" "Host discovery scan on $target"
                echo -e "\033[1;32m>>> Running host discovery on $target...\033[0m"
                nmap -sn "$target"
                ;;
            "webvuln") [[ -z "$target" ]] && echo -e "\033[1;31mUsage: webvuln [target]\033[0m" && continue
                log_message "INFO" "Checking for common web vulns on $target"
                echo -e "\033[1;32m>>> Checking for web vulns on $target...\033[0m"
                nmap --script http-sql-injection,http-xssed,http-methods "$target"
                ;;
            "banner")
                display_banner
                ;;
            "dstyle")
                display_fuck_banner1
                ;;
            "bjob")
                display_blowjob_banner
                ;;
            "help")
                echo -e "\033[1;33m" "\n        GLOBAL HELP (GH): \033[0m"
                echo -e "\033[1;32m"
                echo "     >>>   1. ls        - List avaliable security tools in this framework"
                echo "     >>>   2. cd        - To enter New Choosen Section (cd ffuf)"
                echo "     >>>   3. cd ..     - To get back from one section to HOME menu (If 'cd ..' is not working then use 'exit' command)"
                echo "     >>>   4. clear     - Clear the terminal"
                echo "     >>>   5. exit      - Exit the command interface"
                echo "     >>>   6. banner    - To show the banner"
                echo "     >>>   7. dstyle    - Just enjoy Indian hackers (Fun purpose)"
                echo "     >>>   8. bjob      - Just enjoy Indian Hackers (Fun purpose)"
                echo "     >>>   9. mip       - Show your public IP address (JUST USE 'mip' DON'T USE 'cd mip')"
                echo -e "\033[1;31m"  # Red color
                echo ">> By pressing CTRL+C the whole script stops (BE CAREFULL)"
                echo ">> If you see any warning while useing 'cd ..' then check your section name or execute 'exit' command to exit from the section."
                echo -e "\033[0m"  # Reset color
                ;;
            "clear")
                clear
                ;;
            *)
                echo -e "\033[1;31m"
                echo "-->> Invalid Command. Please use 'help/ls' to see the commands."
                echo -e "\033[0m"  # Reset color
                ;;
        esac

        history -a "$HISTORY_FILE"
    done
}

manage_curl_commands() {
    local current_section="CURL"

    if [[ -f "$HISTORY_FILE" ]]; then
        history -r "$HISTORY_FILE"
    fi

    while true; do
        read -e -p "$(echo -e "\033[1;31m($(date +"%I:%M:%S %p"))\033[1;34m-(MAHAKAL)\033[0m-(${current_section})> ")" input
        [[ "$input" == "exit" ]] && break
        [[ -z "$input" ]] && continue

        history -s "$input"
        local cmd=$(echo "$input" | awk '{print $1}')
        local args=$(echo "$input" | cut -d' ' -f2-)

        case $input in
            "cd ..")
                return
                ;;
            "mip")
                echo -e "\033[1;32m"  # Green color
                echo "Your IP address is: $(curl -s ifconfig.me)"
                echo -e "\033[0m"  # Reset color
                log_message "INFO" "User checked IP address"
                ;;
            "cd nmap")
                current_section="NMAP"
                manage_nmap_commands
                current_section="CURL"
                ;;
            "cd whatweb")
                current_section="WHATWEB"
                manage_whatweb_commands
                current_section="CURL"
                ;;
            "cd wpscan")
                current_section="WPSCAN"
                manage_wpscan_commands
                current_section="CURL"
                ;;
            "cd ai")
                current_section="AI"
                chat_ai
                current_section="CURL"
                ;;
            "cd css")
                current_section="CSS"
                check_sys_status
                current_section="CURL"
                ;;
            "cd anony")
                current_section="ANONY"
                traffic_anony
                current_section="CURL"
                ;;
            "cd waf")
                current_section="WAFW00F"
                traffic_anony
                current_section="CURL"
                ;;
            "cd subfinder")
                current_section="SUBFINDER"
                manage_subfinder_commands
                current_section="CURL"
                ;;
            "cd dnsrecon")
                current_section="DNSRECON"
                manage_dnsrecon_commands
                current_section="CURL"
                ;;
            "cd dnsenum")
                current_section="DNSENUM"
                manage_dnsenum_commands
                current_section="CURL"
                ;;
            "cd httprobe")
                current_section="HTTPROBE"
                manage_httprobe_commands
                current_section="CURL"
                ;;
            "cd whois")
                current_section="WHOIS"
                manage_whois_commands
                current_section="CURL"
                ;;
            "cd amass")
                current_section="AMASS"
                manage_amass_commands
                current_section="CURL"
                ;;
            "cd hydra")
                current_section="HYDRA"
                manage_hydra_commands
                current_section="CURL"
                ;;
            "cd medusa")
                current_section="MEDUSA"
                manage_medusa_commands
                current_section="CURL"
                ;;
            "cd john")
                current_section="JOHN"
                manage_john_commands
                current_section="CURL"
                ;;
            "cd hashcat")
                current_section="HASHCAT"
                manage_hashcat_commands
                current_section="CURL"
                ;;
            "cd gobuster")
                current_section="GOBUSTER"
                manage_gobuster_commands
                current_section="CURL"
                ;;
            "cd ffuf")
                current_section="FFUF"
                manage_ffuf_commands
                current_section="CURL"
                ;;
            "cd nikto")
                current_section="NIKTO"
                manage_nikto_commands
                current_section="CURL"
                ;;
            "cd masscan")
                current_section="MASSCAN"
                manage_masscan_commands
                current_section="CURL"
                ;;
            "cd unic")
                current_section="UNICORNSCAN"
                manage_unicornscan_commands
                current_section="CURL"
                ;;
            "cd enumli")
                current_section="ENUM4LINUX"
                manage_enum4linux_commands
                current_section="CURL"
                ;;
            "cd sqlmap")
                current_section="SQLMAP"
                manage_sqlmap_commands
                current_section="CURL"
                ;;
            "cd ufw")
                current_section="UFW"
                manage_firewall
                current_section="CURL"
                ;;
        esac

        case $cmd in
            "ls")
                echo -e "\033[1;33m\n        CURL COMMANDS: \033[0m"
                echo -e "\033[1;32m"
                echo "     >>>  head [url]               - Show HTTP headers"
                echo "     >>>  get [url]                - GET request"
                echo "     >>>  post [url] [data]        - POST request"
                echo "     >>>  agent [url] [agent]      - Custom User-Agent"
                echo "     >>>  save [url] [file]        - Download to file"
                echo "     >>>  headersave [url] [file]  - Save headers to file"
                echo "     >>>  cookie [url] [cookie]    - Send cookie with request"
                echo "     >>>  upload [url] [file]      - Upload file as multipart/form-data"
                echo "     >>>  auth [url] [user:pass]   - Basic authentication"
                echo "     >>>  proxy [url] [ip:port]    - Use proxy"
                echo "     >>>  time [url]               - Show request time"
                echo "     >>>  ssl [url]                - Show SSL certificate info"
                echo "     >>>  redirect [url]           - Follow redirects"
                echo "     >>>  range [url] [range]      - Partial download (e.g., 0-99)"
                echo -e "\033[0m"
                ;;
            "head") [[ -z "$args" ]] && echo -e "\033[1;31mUsage: head [url]\033[0m" && continue
                log_message "INFO" "Getting headers from $args"
                curl -I "$args"
                ;;
            "get") [[ -z "$args" ]] && echo -e "\033[1;31mUsage: get [url]\033[0m" && continue
                log_message "INFO" "GET request to $args"
                curl -s "$args"
                ;;
            "post") 
                url=$(echo "$args" | awk '{print $1}')
                data=$(echo "$args" | cut -d' ' -f2-)
                [[ -z "$url" || -z "$data" ]] && echo -e "\033[1;31mUsage: post [url] [data]\033[0m" && continue
                log_message "INFO" "POST to $url with data $data"
                curl -X POST -d "$data" "$url"
                ;;
            "agent")
                url=$(echo "$args" | awk '{print $1}')
                agent=$(echo "$args" | cut -d' ' -f2-)
                [[ -z "$url" || -z "$agent" ]] && echo -e "\033[1;31mUsage: agent [url] [agent-string]\033[0m" && continue
                log_message "INFO" "GET $url with User-Agent $agent"
                curl -A "$agent" "$url"
                ;;
            "save")
                url=$(echo "$args" | awk '{print $1}')
                file=$(echo "$args" | cut -d' ' -f2-)
                [[ -z "$url" || -z "$file" ]] && echo -e "\033[1;31mUsage: save [url] [file]\033[0m" && continue
                log_message "INFO" "Downloading $url to $file"
                curl -o "$file" "$url"
                ;;
            "headersave")
                url=$(echo "$args" | awk '{print $1}')
                file=$(echo "$args" | cut -d' ' -f2-)
                [[ -z "$url" || -z "$file" ]] && echo -e "\033[1;31mUsage: headersave [url] [file]\033[0m" && continue
                log_message "INFO" "Saving headers of $url to $file"
                curl -s -D "$file" -o /dev/null "$url"
                ;;
            "cookie")
                url=$(echo "$args" | awk '{print $1}')
                cookie=$(echo "$args" | cut -d' ' -f2-)
                [[ -z "$url" || -z "$cookie" ]] && echo -e "\033[1;31mUsage: cookie [url] [cookie-data]\033[0m" && continue
                log_message "INFO" "Sending cookie to $url"
                curl --cookie "$cookie" "$url"
                ;;
            "upload")
                url=$(echo "$args" | awk '{print $1}')
                file=$(echo "$args" | cut -d' ' -f2-)
                [[ -z "$url" || -z "$file" ]] && echo -e "\033[1;31mUsage: upload [url] [file]\033[0m" && continue
                log_message "INFO" "Uploading $file to $url"
                curl -F "file=@$file" "$url"
                ;;
            "auth")
                url=$(echo "$args" | awk '{print $1}')
                creds=$(echo "$args" | cut -d' ' -f2-)
                [[ -z "$url" || -z "$creds" ]] && echo -e "\033[1;31mUsage: auth [url] [user:pass]\033[0m" && continue
                log_message "INFO" "Sending basic auth to $url"
                curl -u "$creds" "$url"
                ;;
            "proxy")
                url=$(echo "$args" | awk '{print $1}')
                proxy=$(echo "$args" | cut -d' ' -f2-)
                [[ -z "$url" || -z "$proxy" ]] && echo -e "\033[1;31mUsage: proxy [url] [proxy:port]\033[0m" && continue
                log_message "INFO" "Using proxy $proxy to access $url"
                curl -x "$proxy" "$url"
                ;;
            "ssl") [[ -z "$args" ]] && echo -e "\033[1;31mUsage: ssl [url]\033[0m" && continue
                log_message "INFO" "Fetching SSL info for $args"
                echo | openssl s_client -connect "$(echo $args | sed 's|http[s]*://||'):443" 2>/dev/null | openssl x509 -noout -issuer -subject -dates
                ;;
            "time") [[ -z "$args" ]] && echo -e "\033[1;31mUsage: time [url]\033[0m" && continue
                log_message "INFO" "Timing request to $args"
                curl -w "DNS: %{time_namelookup}s\nConnect: %{time_connect}s\nStart Transfer: %{time_starttransfer}s\nTotal: %{time_total}s\n" -o /dev/null -s "$args"
                ;;
            "redirect") [[ -z "$args" ]] && echo -e "\033[1;31mUsage: redirect [url]\033[0m" && continue
                log_message "INFO" "Following redirects for $args"
                curl -L "$args"
                ;;
            "range")
                url=$(echo "$args" | awk '{print $1}')
                range=$(echo "$args" | cut -d' ' -f2-)
                [[ -z "$url" || -z "$range" ]] && echo -e "\033[1;31mUsage: range [url] [range]\033[0m" && continue
                log_message "INFO" "Downloading range $range from $url"
                curl --range "$range" "$url"
                ;;
            "clear") 
                clear 
                ;;
            "banner")
                display_banner
                ;;
            "dstyle")
                display_fuck_banner1
                ;;
            "bjob")
                display_blowjob_banner
                ;;
            "help")
                echo -e "\033[1;33m" "\n        GLOBAL HELP (GH): \033[0m"
                echo -e "\033[1;32m"
                echo "     >>>   1. ls        - List avaliable security tools in this framework"
                echo "     >>>   2. cd        - To enter New Choosen Section (cd ffuf)"
                echo "     >>>   3. cd ..     - To get back from one section to HOME menu (If 'cd ..' is not working then use 'exit' command)"
                echo "     >>>   4. clear     - Clear the terminal"
                echo "     >>>   5. exit      - Exit the command interface"
                echo "     >>>   6. banner    - To show the banner"
                echo "     >>>   7. dstyle    - Just enjoy Indian hackers (Fun purpose)"
                echo "     >>>   8. bjob      - Just enjoy Indian Hackers (Fun purpose)"
                echo "     >>>   9. mip       - Show your public IP address (JUST USE 'mip' DON'T USE 'cd mip')"
                echo -e "\033[1;31m"  # Red color
                echo ">> By pressing CTRL+C the whole script stops (BE CAREFULL)"
                echo ">> If you see any warning while useing 'cd ..' then check your section name or execute 'exit' command to exit from the section."
                echo -e "\033[0m"  # Reset color
                ;;
            *)
                echo -e "\033[1;31m"
                echo "-->> Invalid Command. Please use 'help/ls' to see the commands."
                echo -e "\033[0m"  # Reset color
                ;;
        esac
        history -a "$HISTORY_FILE"
    done
}

manage_wpscan_commands() {
    local current_section="WPSCAN"

    if [[ -f "$HISTORY_FILE" ]]; then
        history -r "$HISTORY_FILE"
    fi

    while true; do
        read -e -p "$(echo -e "\033[1;31m($(date +"%I:%M:%S %p"))\033[1;34m-(MAHAKAL)\033[0m-(${current_section})> ")" input
        [[ "$input" == "exit" ]] && break
        [[ -z "$input" ]] && continue

        history -s "$input"
        local cmd=$(echo "$input" | awk '{print $1}')
        local args=$(echo "$input" | cut -d' ' -f2-)

        case $input in
            "cd ..")
                return
                ;;
            "mip")
                echo -e "\033[1;32m"  # Green color
                echo "Your IP address is: $(curl -s ifconfig.me)"
                echo -e "\033[0m"  # Reset color
                log_message "INFO" "User checked IP address"
                ;;
            "cd nmap")
                current_section="NMAP"
                manage_nmap_commands
                current_section="WPSCAN"
                ;;
            "cd curl")
                current_section="CURL"
                manage_curl_commands
                current_section="WPSCAN"
                ;;
            "cd whatweb")
                current_section="WHATWEB"
                manage_whatweb_commands
                current_section="WPSCAN"
                ;;
            "cd ai")
                current_section="AI"
                chat_ai
                current_section="WPSCAN"
                ;;
            "cd css")
                current_section="CSS"
                check_sys_status
                current_section="WPSCAN"
                ;;
            "cd anony")
                current_section="ANONY"
                traffic_anony
                current_section="WPSCAN"
                ;;
            "cd waf")
                current_section="WAFW00F"
                traffic_anony
                current_section="WPSCAN"
                ;;
            "cd subfinder")
                current_section="SUBFINDER"
                manage_subfinder_commands
                current_section="WPSCAN"
                ;;
            "cd dnsrecon")
                current_section="DNSRECON"
                manage_dnsrecon_commands
                current_section="WPSCAN"
                ;;
            "cd dnsenum")
                current_section="DNSENUM"
                manage_dnsenum_commands
                current_section="WPSCAN"
                ;;
            "cd httprobe")
                current_section="HTTPROBE"
                manage_httprobe_commands
                current_section="WPSCAN"
                ;;
            "cd whois")
                current_section="WHOIS"
                manage_whois_commands
                current_section="WPSCAN"
                ;;
            "cd amass")
                current_section="AMASS"
                manage_amass_commands
                current_section="WPSCAN"
                ;;
            "cd hydra")
                current_section="HYDRA"
                manage_hydra_commands
                current_section="WPSCAN"
                ;;
            "cd medusa")
                current_section="MEDUSA"
                manage_medusa_commands
                current_section="WPSCAN"
                ;;
            "cd john")
                current_section="JOHN"
                manage_john_commands
                current_section="WPSCAN"
                ;;
            "cd hashcat")
                current_section="HASHCAT"
                manage_hashcat_commands
                current_section="WPSCAN"
                ;;
            "cd gobuster")
                current_section="GOBUSTER"
                manage_gobuster_commands
                current_section="WPSCAN"
                ;;
            "cd ffuf")
                current_section="FFUF"
                manage_ffuf_commands
                current_section="WPSCAN"
                ;;
            "cd nikto")
                current_section="NIKTO"
                manage_nikto_commands
                current_section="WPSCAN"
                ;;
            "cd masscan")
                current_section="MASSCAN"
                manage_masscan_commands
                current_section="WPSCAN"
                ;;
            "cd unic")
                current_section="UNICORNSCAN"
                manage_unicornscan_commands
                current_section="WPSCAN"
                ;;
            "cd enumli")
                current_section="ENUM4LINUX"
                manage_enum4linux_commands
                current_section="WPSCAN"
                ;;
            "cd sqlmap")
                current_section="SQLMAP"
                manage_sqlmap_commands
                current_section="WPSCAN"
                ;;
            "cd ufw")
                current_section="UFW"
                manage_firewall
                current_section="WPSCAN"
                ;;
        esac

        case $cmd in
            "ls")
                echo -e "\033[1;33m\n        WPSCAN COMMANDS: \033[0m"
                echo -e "\033[1;32m"
                echo "     >>>  scan [url]                 - Basic scan"
                echo "     >>>  enumuser [url]             - Enumerate users"
                echo "     >>>  plugin [url]               - Plugin detection"
                echo "     >>>  theme [url]                - Theme detection"
                echo "     >>>  full [url]                 - Full scan (everything)"
                echo "     >>>  brute [url] [user] [list]  - Brute-force login"
                echo "     >>>  vp [url]                   - Vulnerable plugins only"
                echo "     >>>  vt [url]                   - Vulnerable themes only"
                echo "     >>>  api [url]                  - Use WPVulnDB API if set"
                echo "     >>>  timing [url]               - Time the scan"
                echo "     >>>  debug [url]                - Enable debugging"
                echo "     >>>  cookie [url] [cookie]      - Send session cookie"
                echo "     >>>  header [url] [headers]     - Add custom headers"
                echo "     >>>  proxy [url] [ip:port]      - Use proxy"
                echo "     >>>  useragent [url] [agent]    - Custom User-Agent"
                echo "     >>>  update                     - Update WPScan database"
                echo -e "\033[0m"
                ;;
            "scan") [[ -z "$args" ]] && echo -e "\033[1;31mUsage: scan [url]\033[0m" && continue
                log_message "INFO" "Running WPScan on $args"
                wpscan --url "$args"
                ;;
            "enumuser") [[ -z "$args" ]] && echo -e "\033[1;31mUsage: enumuser [url]\033[0m" && continue
                log_message "INFO" "Enumerating users on $args"
                wpscan --url "$args" --enumerate u
                ;;
            "plugin") [[ -z "$args" ]] && echo -e "\033[1;31mUsage: plugin [url]\033[0m" && continue
                log_message "INFO" "Detecting plugins on $args"
                wpscan --url "$args" --enumerate p
                ;;
            "theme") [[ -z "$args" ]] && echo -e "\033[1;31mUsage: theme [url]\033[0m" && continue
                log_message "INFO" "Detecting themes on $args"
                wpscan --url "$args" --enumerate t
                ;;
            "full") [[ -z "$args" ]] && echo -e "\033[1;31mUsage: full [url]\033[0m" && continue
                log_message "INFO" "Running full WPScan on $args"
                wpscan --url "$args" --enumerate ap,at,tt,u,vp,vt
                ;;
            "brute")
                url=$(echo "$args" | awk '{print $1}')
                user=$(echo "$args" | awk '{print $2}')
                wordlist=$(echo "$args" | awk '{print $3}')
                [[ -z "$url" || -z "$user" || -z "$wordlist" ]] && echo -e "\033[1;31mUsage: brute [url] [user] [wordlist]\033[0m" && continue
                log_message "INFO" "Brute-forcing $user at $url"
                wpscan --url "$url" --passwords "$wordlist" --username "$user"
                ;;
            "vp") [[ -z "$args" ]] && echo -e "\033[1;31mUsage: vp [url]\033[0m" && continue
                log_message "INFO" "Enumerating vulnerable plugins on $args"
                wpscan --url "$args" --enumerate vp
                ;;
            "vt") [[ -z "$args" ]] && echo -e "\033[1;31mUsage: vt [url]\033[0m" && continue
                log_message "INFO" "Enumerating vulnerable themes on $args"
                wpscan --url "$args" --enumerate vt
                ;;
            "api") [[ -z "$args" ]] && echo -e "\033[1;31mUsage: api [url]\033[0m" && continue
                log_message "INFO" "Running scan with API key on $args"
                wpscan --url "$args" --api-token "$WPSCAN_API_TOKEN"
                ;;
            "timing") [[ -z "$args" ]] && echo -e "\033[1;31mUsage: timing [url]\033[0m" && continue
                log_message "INFO" "Timing WPScan on $args"
                time wpscan --url "$args"
                ;;
            "debug") [[ -z "$args" ]] && echo -e "\033[1;31mUsage: debug [url]\033[0m" && continue
                log_message "INFO" "Running WPScan with debug on $args"
                wpscan --url "$args" --debug
                ;;
            "cookie")
                url=$(echo "$args" | awk '{print $1}')
                cookie=$(echo "$args" | cut -d' ' -f2-)
                [[ -z "$url" || -z "$cookie" ]] && echo -e "\033[1;31mUsage: cookie [url] [cookie-string]\033[0m" && continue
                log_message "INFO" "Scanning $url with cookie"
                wpscan --url "$url" --cookie "$cookie"
                ;;
            "header")
                url=$(echo "$args" | awk '{print $1}')
                headers=$(echo "$args" | cut -d' ' -f2-)
                [[ -z "$url" || -z "$headers" ]] && echo -e "\033[1;31mUsage: header [url] [headers]\033[0m" && continue
                log_message "INFO" "Scanning $url with custom headers"
                wpscan --url "$url" --headers "$headers"
                ;;
            "proxy")
                url=$(echo "$args" | awk '{print $1}')
                proxy=$(echo "$args" | cut -d' ' -f2-)
                [[ -z "$url" || -z "$proxy" ]] && echo -e "\033[1;31mUsage: proxy [url] [http://ip:port]\033[0m" && continue
                log_message "INFO" "Scanning $url via proxy $proxy"
                wpscan --url "$url" --proxy "$proxy"
                ;;
            "useragent")
                url=$(echo "$args" | awk '{print $1}')
                agent=$(echo "$args" | cut -d' ' -f2-)
                [[ -z "$url" || -z "$agent" ]] && echo -e "\033[1;31mUsage: useragent [url] [agent-string]\033[0m" && continue
                log_message "INFO" "Scanning $url with User-Agent: $agent"
                wpscan --url "$url" --user-agent "$agent"
                ;;
            "update")
                log_message "INFO" "Updating WPScan database"
                wpscan --update
                ;;
            "banner")
                display_banner
                ;;
            "dstyle")
                display_fuck_banner1
                ;;
            "bjob")
                display_blowjob_banner
                ;;
            "clear") 
                clear ;;
            "help")
                echo -e "\033[1;33m" "\n        GLOBAL HELP (GH): \033[0m"
                echo -e "\033[1;32m"
                echo "     >>>   1. ls        - List avaliable security tools in this framework"
                echo "     >>>   2. cd        - To enter New Choosen Section (cd ffuf)"
                echo "     >>>   3. cd ..     - To get back from one section to HOME menu (If 'cd ..' is not working then use 'exit' command)"
                echo "     >>>   4. clear     - Clear the terminal"
                echo "     >>>   5. exit      - Exit the command interface"
                echo "     >>>   6. banner    - To show the banner"
                echo "     >>>   7. dstyle    - Just enjoy Indian hackers (Fun purpose)"
                echo "     >>>   8. bjob      - Just enjoy Indian Hackers (Fun purpose)"
                echo "     >>>   9. mip       - Show your public IP address (JUST USE 'mip' DON'T USE 'cd mip')"
                echo -e "\033[1;31m"  # Red color
                echo ">> By pressing CTRL+C the whole script stops (BE CAREFULL)"
                echo ">> If you see any warning while useing 'cd ..' then check your section name or execute 'exit' command to exit from the section."
                echo -e "\033[0m"  # Reset color
                ;;
            *)
                echo -e "\033[1;31m"
                echo "-->> Invalid Command. Please use 'help/ls' to see the commands."
                echo -e "\033[0m"  # Reset color
                ;;
        esac
        history -a "$HISTORY_FILE"
    done
}

manage_whatweb_commands() {
    local current_section="WHATWEB"

    if [[ -f "$HISTORY_FILE" ]]; then
        history -r "$HISTORY_FILE"
    fi

    while true; do
        read -e -p "$(echo -e "\033[1;31m($(date +"%I:%M:%S %p"))\033[1;34m-(MAHAKAL)\033[0m-(${current_section})> ")" input
        [[ "$input" == "exit" ]] && break
        [[ -z "$input" ]] && continue

        history -s "$input"
        local cmd=$(echo "$input" | awk '{print $1}')
        local args=$(echo "$input" | cut -d' ' -f2-)

        case $input in
            "cd ..")
                return
                ;;
            "mip")
                echo -e "\033[1;32m"  # Green color
                echo "Your IP address is: $(curl -s ifconfig.me)"
                echo -e "\033[0m"  # Reset color
                log_message "INFO" "User checked IP address"
                ;;
            "cd nmap")
                current_section="NMAP"
                manage_nmap_commands
                current_section="WHATWEB"
                ;;
            "cd curl")
                current_section="CURL"
                manage_curl_commands
                current_section="WHATWEB"
                ;;
            "cd wpscan")
                current_section="WPSCAN"
                manage_wpscan_commands
                current_section="WHATWEB"
                ;;
            "cd ai")
                current_section="AI"
                chat_ai
                current_section="WHATWEB"
                ;;
            "cd css")
                current_section="CSS"
                check_sys_status
                current_section="WHATWEB"
                ;;
            "cd anony")
                current_section="ANONY"
                traffic_anony
                current_section="WHATWEB"
                ;;
            "cd waf")
                current_section="WAFW00F"
                traffic_anony
                current_section="WHATWEB"
                ;;
            "cd subfinder")
                current_section="SUBFINDER"
                manage_subfinder_commands
                current_section="WHATWEB"
                ;;
            "cd dnsrecon")
                current_section="DNSRECON"
                manage_dnsrecon_commands
                current_section="WHATWEB"
                ;;
            "cd dnsenum")
                current_section="DNSENUM"
                manage_dnsenum_commands
                current_section="WHATWEB"
                ;;
            "cd httprobe")
                current_section="HTTPROBE"
                manage_httprobe_commands
                current_section="WHATWEB"
                ;;
            "cd whois")
                current_section="WHOIS"
                manage_whois_commands
                current_section="WHATWEB"
                ;;
            "cd amass")
                current_section="AMASS"
                manage_amass_commands
                current_section="WHATWEB"
                ;;
            "cd hydra")
                current_section="HYDRA"
                manage_hydra_commands
                current_section="WHATWEB"
                ;;
            "cd medusa")
                current_section="MEDUSA"
                manage_medusa_commands
                current_section="WHATWEB"
                ;;
            "cd john")
                current_section="JOHN"
                manage_john_commands
                current_section="WHATWEB"
                ;;
            "cd hashcat")
                current_section="HASHCAT"
                manage_hashcat_commands
                current_section="WHATWEB"
                ;;
            "cd gobuster")
                current_section="GOBUSTER"
                manage_gobuster_commands
                current_section="WHATWEB"
                ;;
            "cd ffuf")
                current_section="FFUF"
                manage_ffuf_commands
                current_section="WHATWEB"
                ;;
            "cd nikto")
                current_section="NIKTO"
                manage_nikto_commands
                current_section="WHATWEB"
                ;;
            "cd masscan")
                current_section="MASSCAN"
                manage_masscan_commands
                current_section="WHATWEB"
                ;;
            "cd unic")
                current_section="UNICORNSCAN"
                manage_unicornscan_commands
                current_section="WHATWEB"
                ;;
            "cd enumli")
                current_section="ENUM4LINUX"
                manage_enum4linux_commands
                current_section="WHATWEB"
                ;;
            "cd sqlmap")
                current_section="SQLMAP"
                manage_sqlmap_commands
                current_section="WHATWEB"
                ;;
            "cd ufw")
                current_section="UFW"
                manage_firewall
                current_section="WHATWEB"
                ;;
        esac

        case $cmd in
            "ls")
                echo -e "\033[1;33m\n        WHATWEB COMMANDS: \033[0m"
                echo -e "\033[1;32m"
                echo "     >>>  scan [url]                - Basic scan"
                echo "     >>>  verbose [url]             - Verbose mode"
                echo "     >>>  aggressive [url]          - Aggressive fingerprinting"
                echo "     >>>  plugin [url]              - List plugins used"
                echo "     >>>  proxy [url] [proxy]       - Use proxy"
                echo "     >>>  header [url] [header]     - Send custom header"
                echo "     >>>  ua [url] [user-agent]     - Custom User-Agent"
                echo "     >>>  timeout [url] [seconds]   - Set timeout for request"
                echo "     >>>  no-redirect [url]         - Disable redirections"
                echo "     >>>  color [url]               - Enable colored output"
                echo "     >>>  pluginlist                - Show available plugins"
                echo "     >>>  input [file]              - Scan list of URLs"
                echo "     >>>  id [url]                  - Plugin IDs for target"
                echo "     >>>  random-agent [url]        - Randomize User-Agent"
                echo -e "\033[0m"
                ;;
            "scan") [[ -z "$args" ]] && echo -e "\033[1;31mUsage: scan [url]\033[0m" && continue
                log_message "INFO" "Scanning $args with WhatWeb"
                whatweb "$args"
                ;;
            "verbose") [[ -z "$args" ]] && echo -e "\033[1;31mUsage: verbose [url]\033[0m" && continue
                log_message "INFO" "Verbose scan on $args"
                whatweb -v "$args"
                ;;
            "aggressive") [[ -z "$args" ]] && echo -e "\033[1;31mUsage: aggressive [url]\033[0m" && continue
                log_message "INFO" "Aggressive scan on $args"
                whatweb -a 3 "$args"
                ;;
            "plugin") [[ -z "$args" ]] && echo -e "\033[1;31mUsage: plugin [url]\033[0m" && continue
                log_message "INFO" "Listing plugins for $args"
                whatweb -l "$args"
                ;;
            "proxy")
                url=$(echo "$args" | awk '{print $1}')
                proxy=$(echo "$args" | cut -d' ' -f2-)
                [[ -z "$url" || -z "$proxy" ]] && echo -e "\033[1;31mUsage: proxy [url] [proxy:port]\033[0m" && continue
                log_message "INFO" "Using proxy $proxy for $url"
                whatweb --proxy "$proxy" "$url"
                ;;
            "header")
                url=$(echo "$args" | awk '{print $1}')
                header=$(echo "$args" | cut -d' ' -f2-)
                [[ -z "$url" || -z "$header" ]] && echo -e "\033[1;31mUsage: header [url] [header]\033[0m" && continue
                log_message "INFO" "Sending header to $url"
                whatweb --header "$header" "$url"
                ;;
            "ua")
                url=$(echo "$args" | awk '{print $1}')
                agent=$(echo "$args" | cut -d' ' -f2-)
                [[ -z "$url" || -z "$agent" ]] && echo -e "\033[1;31mUsage: ua [url] [user-agent]\033[0m" && continue
                log_message "INFO" "Using custom User-Agent on $url"
                whatweb --user-agent "$agent" "$url"
                ;;
            "timeout")
                url=$(echo "$args" | awk '{print $1}')
                sec=$(echo "$args" | cut -d' ' -f2-)
                [[ -z "$url" || -z "$sec" ]] && echo -e "\033[1;31mUsage: timeout [url] [seconds]\033[0m" && continue
                log_message "INFO" "Timeout set for $url"
                whatweb --timeout "$sec" "$url"
                ;;
            "no-redirect") [[ -z "$args" ]] && echo -e "\033[1;31mUsage: no-redirect [url]\033[0m" && continue
                log_message "INFO" "Disabling redirection for $args"
                whatweb --no-redirect "$args"
                ;;
            "color") [[ -z "$args" ]] && echo -e "\033[1;31mUsage: color [url]\033[0m" && continue
                log_message "INFO" "Colored scan on $args"
                whatweb --colour "$args"
                ;;
            "pluginlist")
                log_message "INFO" "Listing all WhatWeb plugins"
                whatweb --list-plugins
                ;;
            "input") [[ -z "$args" ]] && echo -e "\033[1;31mUsage: input [file]\033[0m" && continue
                log_message "INFO" "Scanning URLs from file $args"
                whatweb --input-file="$args"
                ;;
            "id") [[ -z "$args" ]] && echo -e "\033[1;31mUsage: id [url]\033[0m" && continue
                log_message "INFO" "Plugin identification for $args"
                whatweb --log-brief="$args-summary.txt" "$args" && cat "$args-summary.txt"
                ;;
            "random-agent") [[ -z "$args" ]] && echo -e "\033[1;31mUsage: random-agent [url]\033[0m" && continue
                log_message "INFO" "Using random User-Agent for $args"
                whatweb --random-agent "$args"
                ;;
            "clear") 
                clear 
                ;;
            "banner")
                display_banner
                ;;
            "dstyle")
                display_fuck_banner1
                ;;
            "bjob")
                display_blowjob_banner
                ;;
            "help")
                echo -e "\033[1;33m" "\n        GLOBAL HELP (GH): \033[0m"
                echo -e "\033[1;32m"
                echo "     >>>   1. ls        - List avaliable security tools in this framework"
                echo "     >>>   2. cd        - To enter New Choosen Section (cd ffuf)"
                echo "     >>>   3. cd ..     - To get back from one section to HOME menu (If 'cd ..' is not working then use 'exit' command)"
                echo "     >>>   4. clear     - Clear the terminal"
                echo "     >>>   5. exit      - Exit the command interface"
                echo "     >>>   6. banner    - To show the banner"
                echo "     >>>   7. dstyle    - Just enjoy Indian hackers (Fun purpose)"
                echo "     >>>   8. bjob      - Just enjoy Indian Hackers (Fun purpose)"
                echo "     >>>   9. mip       - Show your public IP address (JUST USE 'mip' DON'T USE 'cd mip')"
                echo -e "\033[1;31m"  # Red color
                echo ">> By pressing CTRL+C the whole script stops (BE CAREFULL)"
                echo ">> If you see any warning while useing 'cd ..' then check your section name or execute 'exit' command to exit from the section."
                echo -e "\033[0m"  # Reset color
                ;;
            *)
                echo -e "\033[1;31m"
                echo "-->> Invalid Command. Please use 'help/ls' to see the commands."
                echo -e "\033[0m"  # Reset color
                ;;
        esac
        history -a "$HISTORY_FILE"
    done
}

manage_wafw00f_commands() {
    local current_section="WAFW00F"

    if [[ -f "$HISTORY_FILE" ]]; then history -r "$HISTORY_FILE"; fi

    while true; do
        read -e -p "$(echo -e "\033[1;31m($(date +"%I:%M:%S %p"))\033[1;34m-(MAHAKAL)\033[0m-(${current_section})> ")" input
        [[ "$input" == "exit" ]] && break
        [[ -z "$input" ]] && continue
        history -s "$input"

        local cmd=$(echo "$input" | awk '{print $1}')
        local args=$(echo "$input" | cut -d' ' -f2-)

        case $input in 
            "cd ..")
                return
                ;;
            "mip")
                echo -e "\033[1;32m"  # Green color
                echo "Your IP address is: $(curl -s ifconfig.me)"
                echo -e "\033[0m"  # Reset color
                log_message "INFO" "User checked IP address"
                ;;
            "cd nmap")
                current_section="NMAP"
                manage_nmap_commands
                current_section="WAFW00F"
                ;;
            "cd curl")
                current_section="CURL"
                manage_curl_commands
                current_section="WAFW00F"
                ;;
            "cd whatweb")
                current_section="WHATWEB"
                manage_whatweb_commands
                current_section="WAFW00F"
                ;;
            "cd wpscan")
                current_section="WPSCAN"
                manage_wpscan_commands
                current_section="WAFW00F"
                ;;
            "cd ai")
                current_section="AI"
                chat_ai
                current_section="WAFW00F"
                ;;
            "cd css")
                current_section="CSS"
                check_sys_status
                current_section="WAFW00F"
                ;;
            "cd anony")
                current_section="ANONY"
                traffic_anony
                current_section="WAFW00F"
                ;;
            "cd subfinder")
                current_section="SUBFINDER"
                manage_subfinder_commands
                current_section="WAFW00F"
                ;;
            "cd dnsrecon")
                current_section="DNSRECON"
                manage_dnsrecon_commands
                current_section="WAFW00F"
                ;;
            "cd dnsenum")
                current_section="DNSENUM"
                manage_dnsenum_commands
                current_section="WAFW00F"
                ;;
            "cd httprobe")
                current_section="HTTPROBE"
                manage_httprobe_commands
                current_section="WAFW00F"
                ;;
            "cd whois")
                current_section="WHOIS"
                manage_whois_commands
                current_section="WAFW00F"
                ;;
            "cd amass")
                current_section="AMASS"
                manage_amass_commands
                current_section="WAFW00F"
                ;;
            "cd hydra")
                current_section="HYDRA"
                manage_hydra_commands
                current_section="WAFW00F"
                ;;
            "cd medusa")
                current_section="MEDUSA"
                manage_medusa_commands
                current_section="WAFW00F"
                ;;
            "cd john")
                current_section="JOHN"
                manage_john_commands
                current_section="WAFW00F"
                ;;
            "cd hashcat")
                current_section="HASHCAT"
                manage_hashcat_commands
                current_section="WAFW00F"
                ;;
            "cd gobuster")
                current_section="GOBUSTER"
                manage_gobuster_commands
                current_section="WAFW00F"
                ;;
            "cd ffuf")
                current_section="FFUF"
                manage_ffuf_commands
                current_section="WAFW00F"
                ;;
            "cd nikto")
                current_section="NIKTO"
                manage_nikto_commands
                current_section="WAFW00F"
                ;;
            "cd masscan")
                current_section="MASSCAN"
                manage_masscan_commands
                current_section="WAFW00F"
                ;;
            "cd unic")
                current_section="UNICORNSCAN"
                manage_unicornscan_commands
                current_section="WAFW00F"
                ;;
            "cd enumli")
                current_section="ENUM4LINUX"
                manage_enum4linux_commands
                current_section="WAFW00F"
                ;;
            "cd sqlmap")
                current_section="SQLMAP"
                manage_sqlmap_commands
                current_section="WAFW00F"
                ;;
            "cd ufw")
                current_section="UFW"
                manage_firewall
                current_section="WAFW00F"
                ;;
        esac

        case $cmd in
            "ls")
                echo -e "\033[1;33m\n       WAFW00F COMMANDS:\033[0m"
                echo -e "\033[1;32m"
                echo "     >>>  scan [url]                    - Detect WAF"
                echo "     >>>  proxy [url] [proxy:port]      - Scan using proxy"
                echo "     >>>  verbose [url]                 - Verbose output"
                echo "     >>>  agent [url] [user-agent]      - Custom User-Agent"
                echo "     >>>  output [url] [file.txt]       - Save scan result"
                echo "     >>>  fromlist [file.txt]           - Bulk scan from URL list"
                echo "     >>>  quiet [url]                   - No output, just status"
                echo "     >>>  retry [url]                   - Aggressive retry mode"
                echo -e "\033[0m"
                ;;
            "scan")
                [[ -z "$args" ]] && echo -e "\033[1;31mUsage: scan [url]\033[0m" && continue
                log_message "INFO" "Scanning $args with wafw00f"
                wafw00f "$args"
                ;;
            "proxy")
                url=$(echo "$args" | awk '{print $1}')
                proxy=$(echo "$args" | cut -d' ' -f2-)
                [[ -z "$url" || -z "$proxy" ]] && echo -e "\033[1;31mUsage: proxy [url] [proxy:port]\033[0m" && continue
                log_message "INFO" "Using proxy $proxy for $url"
                wafw00f -p "$proxy" "$url"
                ;;
            "verbose")
                [[ -z "$args" ]] && echo -e "\033[1;31mUsage: verbose [url]\033[0m" && continue
                log_message "INFO" "Verbose mode on $args"
                wafw00f -v "$args"
                ;;
            "agent")
                url=$(echo "$args" | awk '{print $1}')
                ua=$(echo "$args" | cut -d' ' -f2-)
                [[ -z "$url" || -z "$ua" ]] && echo -e "\033[1;31mUsage: agent [url] [user-agent]\033[0m" && continue
                log_message "INFO" "Using UA '$ua' on $url"
                wafw00f -a "$ua" "$url"
                ;;
            "output")
                url=$(echo "$args" | awk '{print $1}')
                file=$(echo "$args" | cut -d' ' -f2-)
                [[ -z "$url" || -z "$file" ]] && echo -e "\033[1;31mUsage: output [url] [output.txt]\033[0m" && continue
                log_message "INFO" "Saving output of $url to $file"
                wafw00f "$url" | tee "$file"
                ;;
            "fromlist")
                [[ ! -f "$args" ]] && echo -e "\033[1;31mFile '$args' not found\033[0m" && continue
                log_message "INFO" "Scanning URLs from file: $args"
                while IFS= read -r line; do
                    echo -e "\n\033[1;34m>>> Scanning: $line\033[0m"
                    wafw00f "$line"
                done < "$args"
                ;;
            "quiet")
                [[ -z "$args" ]] && echo -e "\033[1;31mUsage: quiet [url]\033[0m" && continue
                wafw00f "$args" > /dev/null && echo -e "\033[1;32m$args - Scan completed\033[0m"
                ;;
            "retry")
                [[ -z "$args" ]] && echo -e "\033[1;31mUsage: retry [url]\033[0m" && continue
                log_message "INFO" "Retrying scan on $args with verbose fallback"
                wafw00f "$args" || wafw00f -v "$args"
                ;;
            "clear") 
                clear 
                ;;
            "help")
                echo -e "\033[1;33m" "\n        GLOBAL HELP (GH): \033[0m"
                echo -e "\033[1;32m"
                echo "     >>>   1. ls        - List avaliable security tools in this framework"
                echo "     >>>   2. cd        - To enter New Choosen Section (cd ffuf)"
                echo "     >>>   3. cd ..     - To get back from one section to HOME menu (If 'cd ..' is not working then use 'exit' command)"
                echo "     >>>   4. clear     - Clear the terminal"
                echo "     >>>   5. exit      - Exit the command interface"
                echo "     >>>   6. banner    - To show the banner"
                echo "     >>>   7. dstyle    - Just enjoy Indian hackers (Fun purpose)"
                echo "     >>>   8. bjob      - Just enjoy Indian Hackers (Fun purpose)"
                echo "     >>>   9. mip       - Show your public IP address (JUST USE 'mip' DON'T USE 'cd mip')"
                echo -e "\033[1;31m"  # Red color
                echo ">> By pressing CTRL+C the whole script stops (BE CAREFULL)"
                echo ">> If you see any warning while useing 'cd ..' then check your section name or execute 'exit' command to exit from the section."
                echo -e "\033[0m"  # Reset color
                ;;
            *)
                echo -e "\033[1;31m-->> Invalid Command. Please use 'help/ls' to see the commands.\033[0m"
                ;;
        esac

        history -a "$HISTORY_FILE"
    done
}

manage_dnsrecon_commands() {
    local current_section="DNSRECON"
    local wordlist_path="/usr/share/wordlists/dnsmap.txt"

    [[ -f "$HISTORY_FILE" ]] && history -r "$HISTORY_FILE"

    while true; do
        read -e -p "$(echo -e "\033[1;31m($(date +"%I:%M:%S %p"))\033[1;34m-(MAHAKAL)\033[0m-(${current_section})> ")" input
        [[ "$input" == "exit" ]] && break
        [[ -z "$input" ]] && continue
        history -s "$input"

        local cmd=$(echo "$input" | awk '{print $1}')
        local args=$(echo "$input" | cut -d' ' -f2-)

        case $input in 
            "cd ..")
                return
                ;;
            "mip")
                echo -e "\033[1;32m"  # Green color
                echo "Your IP address is: $(curl -s ifconfig.me)"
                echo -e "\033[0m"  # Reset color
                log_message "INFO" "User checked IP address"
                ;;
            "cd nmap")
                current_section="NMAP"
                manage_nmap_commands
                current_section="DNSRECON"
                ;;
            "cd curl")
                current_section="CURL"
                manage_curl_commands
                current_section="DNSRECON"
                ;;
            "cd whatweb")
                current_section="WHATWEB"
                manage_whatweb_commands
                current_section="DNSRECON"
                ;;
            "cd wpscan")
                current_section="WPSCAN"
                manage_wpscan_commands
                current_section="DNSRECON"
                ;;
            "cd ai")
                current_section="AI"
                chat_ai
                current_section="DNSRECON"
                ;;
            "cd css")
                current_section="CSS"
                check_sys_status
                current_section="DNSRECON"
                ;;
            "cd anony")
                current_section="ANONY"
                traffic_anony
                current_section="DNSRECON"
                ;;
            "cd subfinder")
                current_section="SUBFINDER"
                manage_subfinder_commands
                current_section="DNSRECON"
                ;;
            "cd waf")
                current_section="WAFW00F"
                manage_dnsrecon_commands
                current_section="DNSRECON"
                ;;
            "cd dnsenum")
                current_section="DNSENUM"
                manage_dnsenum_commands
                current_section="DNSRECON"
                ;;
            "cd httprobe")
                current_section="HTTPROBE"
                manage_httprobe_commands
                current_section="DNSRECON"
                ;;
            "cd whois")
                current_section="WHOIS"
                manage_whois_commands
                current_section="DNSRECON"
                ;;
            "cd amass")
                current_section="AMASS"
                manage_amass_commands
                current_section="DNSRECON"
                ;;
            "cd hydra")
                current_section="HYDRA"
                manage_hydra_commands
                current_section="DNSRECON"
                ;;
            "cd medusa")
                current_section="MEDUSA"
                manage_medusa_commands
                current_section="DNSRECON"
                ;;
            "cd john")
                current_section="JOHN"
                manage_john_commands
                current_section="DNSRECON"
                ;;
            "cd hashcat")
                current_section="HASHCAT"
                manage_hashcat_commands
                current_section="DNSRECON"
                ;;
            "cd gobuster")
                current_section="GOBUSTER"
                manage_gobuster_commands
                current_section="DNSRECON"
                ;;
            "cd ffuf")
                current_section="FFUF"
                manage_ffuf_commands
                current_section="DNSRECON"
                ;;
            "cd nikto")
                current_section="NIKTO"
                manage_nikto_commands
                current_section="DNSRECON"
                ;;
            "cd masscan")
                current_section="MASSCAN"
                manage_masscan_commands
                current_section="DNSRECON"
                ;;
            "cd unic")
                current_section="UNICORNSCAN"
                manage_unicornscan_commands
                current_section="DNSRECON"
                ;;
            "cd enumli")
                current_section="ENUM4LINUX"
                manage_enum4linux_commands
                current_section="DNSRECON"
                ;;
            "cd sqlmap")
                current_section="SQLMAP"
                manage_sqlmap_commands
                current_section="DNSRECON"
                ;;
            "cd ufw")
                current_section="UFW"
                manage_firewall
                current_section="DNSRECON"
                ;;
        esac

        case $cmd in
            ls)
                echo -e "\033[1;33m\n       DNSRECON COMMANDS:\033[0m"
                echo -e "\033[1;32m"
                echo "     >>>  scan [domain]             - Basic DNS recon"
                echo "     >>>  brute [domain]            - Brute-force subdomains"
                echo "     >>>  axfr [domain]             - Zone transfer test"
                echo "     >>>  enum [domain]             - Full DNS enumeration"
                echo "     >>>  type [domain] [record]    - Query specific record type (A, NS, MX, TXT)"
                echo "     >>>  rev [ip/cidr]             - Reverse lookup"
                echo "     >>>  export [domain]           - Save results to XML/CSV/JSON"
                echo "     >>>  custom [args]             - Run custom dnsrecon arguments"
                echo "     >>>  set wordlist [path]       - Set wordlist for brute"
                echo "     >>>  show wordlist             - Show current wordlist path"
                echo -e "\033[0m"
                ;;
            scan)
                [[ -z "$args" ]] && echo -e "\033[1;31mUsage: scan [domain]\033[0m" && continue
                log_message "INFO" "Basic DNS scan on $args"
                dnsrecon -d "$args"
                ;;
            brute)
                [[ -z "$args" ]] && echo -e "\033[1;31mUsage: brute [domain]\033[0m" && continue
                log_message "INFO" "Brute-forcing subdomains for $args"
                dnsrecon -d "$args" -D "$wordlist_path" -t brt
                ;;
            axfr)
                [[ -z "$args" ]] && echo -e "\033[1;31mUsage: axfr [domain]\033[0m" && continue
                log_message "INFO" "Zone transfer attempt on $args"
                dnsrecon -d "$args" -t axfr
                ;;
            enum)
                [[ -z "$args" ]] && echo -e "\033[1;31mUsage: enum [domain]\033[0m" && continue
                log_message "INFO" "Full enumeration on $args"
                dnsrecon -d "$args" -a
                ;;
            type)
                local domain=$(echo "$args" | awk '{print $1}')
                local record=$(echo "$args" | awk '{print $2}')
                [[ -z "$domain" || -z "$record" ]] && echo -e "\033[1;31mUsage: type [domain] [record_type]\033[0m" && continue
                log_message "INFO" "Querying $record records for $domain"
                dnsrecon -d "$domain" -t "$record"
                ;;
            rev)
                [[ -z "$args" ]] && echo -e "\033[1;31mUsage: rev [ip/cidr]\033[0m" && continue
                log_message "INFO" "Reverse lookup for $args"
                dnsrecon -r "$args"
                ;;
            export)
                [[ -z "$args" ]] && echo -e "\033[1;31mUsage: export [domain]\033[0m" && continue
                log_message "INFO" "Saving DNS info for $args"
                dnsrecon -d "$args" -a -x "dnsrecon_${args}.xml" -j "dnsrecon_${args}.json" -c "dnsrecon_${args}.csv"
                echo -e "\033[1;34mSaved: XML, JSON, CSV in current directory.\033[0m"
                ;;
            custom)
                [[ -z "$args" ]] && echo -e "\033[1;31mUsage: custom [dnsrecon-arguments]\033[0m" && continue
                log_message "INFO" "Running custom dnsrecon command: $args"
                dnsrecon $args
                ;;
            set)
                if [[ "$args" =~ ^wordlist[[:space:]]+(.+)$ ]]; then
                    wordlist_path="${BASH_REMATCH[1]}"
                    echo -e "\033[1;32mWordlist path set to: $wordlist_path\033[0m"
                else
                    echo -e "\033[1;31mUsage: set wordlist [path]\033[0m"
                fi
                ;;
            show)
                if [[ "$args" == "wordlist" ]]; then
                    echo -e "\033[1;34mCurrent wordlist: $wordlist_path\033[0m"
                else
                    echo -e "\033[1;31mUsage: show wordlist\033[0m"
                fi
                ;;
            clear)
                clear
                ;;
            "help")
                echo -e "\033[1;33m" "\n        GLOBAL HELP (GH): \033[0m"
                echo -e "\033[1;32m"
                echo "     >>>   1. ls        - List avaliable security tools in this framework"
                echo "     >>>   2. cd        - To enter New Choosen Section (cd ffuf)"
                echo "     >>>   3. cd ..     - To get back from one section to HOME menu (If 'cd ..' is not working then use 'exit' command)"
                echo "     >>>   4. clear     - Clear the terminal"
                echo "     >>>   5. exit      - Exit the command interface"
                echo "     >>>   6. banner    - To show the banner"
                echo "     >>>   7. dstyle    - Just enjoy Indian hackers (Fun purpose)"
                echo "     >>>   8. bjob      - Just enjoy Indian Hackers (Fun purpose)"
                echo "     >>>   9. mip       - Show your public IP address (JUST USE 'mip' DON'T USE 'cd mip')"
                echo -e "\033[1;31m"  # Red color
                echo ">> By pressing CTRL+C the whole script stops (BE CAREFULL)"
                echo ">> If you see any warning while useing 'cd ..' then check your section name or execute 'exit' command to exit from the section."
                echo -e "\033[0m"  # Reset color
                ;;
            *)
                echo -e "\033[1;31m-->> Invalid Command. Please use 'help/ls' to see the commands.\033[0m"
                ;;
        esac

        history -a "$HISTORY_FILE"
    done
}

manage_dnsenum_commands() {
    local current_section="DNSENUM"
    local wordlist_path="/usr/share/wordlists/dnsmap.txt"
    [[ -f "$HISTORY_FILE" ]] && history -r "$HISTORY_FILE"

    while true; do
        read -e -p "$(echo -e "\033[1;31m($(date +"%I:%M:%S %p"))\033[1;34m-(MAHAKAL)\033[0m-(${current_section})> ")" input
        [[ "$input" == "exit" ]] && break
        [[ -z "$input" ]] && continue
        history -s "$input"

        local cmd=$(echo "$input" | awk '{print $1}')
        local args=$(echo "$input" | cut -d' ' -f2-)

        case $input in
            "cd ..")
                return
                ;;
            "mip")
                echo -e "\033[1;32m"  # Green color
                echo "Your IP address is: $(curl -s ifconfig.me)"
                echo -e "\033[0m"  # Reset color
                log_message "INFO" "User checked IP address"
                ;;
            "cd nmap")
                current_section="NMAP"
                manage_nmap_commands
                current_section="DNSENUM"
                ;;
            "cd curl")
                current_section="CURL"
                manage_curl_commands
                current_section="DNSENUM"
                ;;
            "cd whatweb")
                current_section="WHATWEB"
                manage_whatweb_commands
                current_section="DNSENUM"
                ;;
            "cd wpscan")
                current_section="WPSCAN"
                manage_wpscan_commands
                current_section="DNSENUM"
                ;;
            "cd waf")
                current_section="WAFW00F"
                traffic_anony
                current_section="DNSENUM"
                ;;
            "cd subfinder")
                current_section="SUBFINDER"
                manage_subfinder_commands
                current_section="DNSENUM"
                ;;
            "cd dnsrecon")
                current_section="DNSRECON"
                manage_dnsrecon_commands
                current_section="DNSENUM"
                ;;
            "cd httprobe")
                current_section="HTTPROBE"
                manage_httprobe_commands
                current_section="DNSENUM"
                ;;
            "cd ai")
                current_section="AI"
                chat_ai
                current_section="DNSENUM"
                ;;
            "cd css")
                current_section="CSS"
                check_sys_status
                current_section="DNSENUM"
                ;;
            "cd anony")
                current_section="ANONY"
                traffic_anony
                current_section="DNSENUM"
                ;;
            "cd whois")
                current_section="WHOIS"
                manage_whois_commands
                current_section="DNSENUM"
                ;;
            "cd amass")
                current_section="AMASS"
                manage_amass_commands
                current_section="DNSENUM"
                ;;
            "cd hydra")
                current_section="HYDRA"
                manage_hydra_commands
                current_section="DNSENUM"
                ;;
            "cd medusa")
                current_section="MEDUSA"
                manage_medusa_commands
                current_section="DNSENUM"
                ;;
            "cd john")
                current_section="JOHN"
                manage_john_commands
                current_section="DNSENUM"
                ;;
            "cd hashcat")
                current_section="HASHCAT"
                manage_hashcat_commands
                current_section="DNSENUM"
                ;;
            "cd gobuster")
                current_section="GOBUSTER"
                manage_gobuster_commands
                current_section="DNSENUM"
                ;;
            "cd ffuf")
                current_section="FFUF"
                manage_ffuf_commands
                current_section="DNSENUM"
                ;;
            "cd nikto")
                current_section="NIKTO"
                manage_nikto_commands
                current_section="DNSENUM"
                ;;
            "cd masscan")
                current_section="MASSCAN"
                manage_masscan_commands
                current_section="DNSENUM"
                ;;
            "cd unic")
                current_section="UNICORNSCAN"
                manage_unicornscan_commands
                current_section="DNSENUM"
                ;;
            "cd enumli")
                current_section="ENUM4LINUX"
                manage_enum4linux_commands
                current_section="DNSENUM"
                ;;
            "cd sqlmap")
                current_section="SQLMAP"
                manage_sqlmap_commands
                current_section="DNSENUM"
                ;;
            "cd ufw")
                current_section="UFW"
                manage_firewall
                current_section="DNSENUM"
                ;;
        esac 

        case $cmd in
            ls)
                echo -e "\033[1;33m\n       DNSENUM COMMANDS:\033[0m"
                echo -e "\033[1;32m"
                echo "     >>>  scan [domain]          - Basic DNS enumeration"
                echo "     >>>  enumall [domain]       - Full enumeration (--enum)"
                echo "     >>>  dns [domain]           - Only A/NS/MX info"
                echo "     >>>  mx [domain]            - MX records only"
                echo "     >>>  whois [domain]         - Whois info only"
                echo "     >>>  rev [ip/cidr]          - Reverse IP lookup"
                echo "     >>>  brute [domain]         - Brute-force subdomains"
                echo "     >>>  export [domain]        - Save output as HTML"
                echo "     >>>  custom [args]          - Run custom dnsenum command"
                echo "     >>>  set wordlist [path]    - Set brute wordlist"
                echo "     >>>  show wordlist          - Show current wordlist"
                echo "     >>>  clear                  - Clear terminal"
                echo -e "\033[0m"
                ;;
            scan)
                [[ -z "$args" ]] && echo -e "\033[1;31mUsage: scan [domain]\033[0m" && continue
                log_message "INFO" "DNS enum scan on $args"
                dnsenum "$args"
                ;;
            enumall)
                [[ -z "$args" ]] && echo -e "\033[1;31mUsage: enumall [domain]\033[0m" && continue
                log_message "INFO" "Full enumeration on $args"
                dnsenum --enum "$args"
                ;;
            dns)
                [[ -z "$args" ]] && echo -e "\033[1;31mUsage: dns [domain]\033[0m" && continue
                log_message "INFO" "Basic DNS (A, NS, MX) on $args"
                dnsenum --dnsserver 8.8.8.8 "$args"
                ;;
            mx)
                [[ -z "$args" ]] && echo -e "\033[1;31mUsage: mx [domain]\033[0m" && continue
                log_message "INFO" "MX record lookup on $args"
                dnsenum --mx "$args"
                ;;
            whois)
                [[ -z "$args" ]] && echo -e "\033[1;31mUsage: whois [domain]\033[0m" && continue
                log_message "INFO" "Whois on $args"
                dnsenum --whois "$args"
                ;;
            rev)
                [[ -z "$args" ]] && echo -e "\033[1;31mUsage: rev [ip/cidr]\033[0m" && continue
                log_message "INFO" "Reverse DNS lookup on $args"
                dnsenum --noreverse "$args"
                ;;
            brute)
                [[ -z "$args" ]] && echo -e "\033[1;31mUsage: brute [domain]\033[0m" && continue
                log_message "INFO" "Brute-forcing subdomains for $args"
                dnsenum --enum -f "$wordlist_path" "$args"
                ;;
            export)
                [[ -z "$args" ]] && echo -e "\033[1;31mUsage: export [domain]\033[0m" && continue
                log_message "INFO" "Exporting results for $args"
                dnsenum --enum "$args" -o "dnsenum_${args}.html"
                echo -e "\033[1;34mSaved as: dnsenum_${args}.html\033[0m"
                ;;
            custom)
                [[ -z "$args" ]] && echo -e "\033[1;31mUsage: custom [dnsenum-args]\033[0m" && continue
                log_message "INFO" "Running custom dnsenum: $args"
                dnsenum $args
                ;;
            set)
                if [[ "$args" =~ ^wordlist[[:space:]]+(.+)$ ]]; then
                    wordlist_path="${BASH_REMATCH[1]}"
                    echo -e "\033[1;32mWordlist set to: $wordlist_path\033[0m"
                else
                    echo -e "\033[1;31mUsage: set wordlist [path]\033[0m"
                fi
                ;;
            show)
                if [[ "$args" == "wordlist" ]]; then
                    echo -e "\033[1;34mCurrent wordlist: $wordlist_path\033[0m"
                else
                    echo -e "\033[1;31mUsage: show wordlist\033[0m"
                fi
                ;;
            clear) 
                clear 
                ;;
            "banner")
                display_banner
                ;;
            "dstyle")
                display_fuck_banner1
                ;;
            "bjob")
                display_blowjob_banner
                ;;
            "help")
                echo -e "\033[1;33m" "\n        GLOBAL HELP (GH): \033[0m"
                echo -e "\033[1;32m"
                echo "     >>>   1. ls        - List avaliable security tools in this framework"
                echo "     >>>   2. cd        - To enter New Choosen Section (cd ffuf)"
                echo "     >>>   3. cd ..     - To get back from one section to HOME menu (If 'cd ..' is not working then use 'exit' command)"
                echo "     >>>   4. clear     - Clear the terminal"
                echo "     >>>   5. exit      - Exit the command interface"
                echo "     >>>   6. banner    - To show the banner"
                echo "     >>>   7. dstyle    - Just enjoy Indian hackers (Fun purpose)"
                echo "     >>>   8. bjob      - Just enjoy Indian Hackers (Fun purpose)"
                echo "     >>>   9. mip       - Show your public IP address (JUST USE 'mip' DON'T USE 'cd mip')"
                echo -e "\033[1;31m"  # Red color
                echo ">> By pressing CTRL+C the whole script stops (BE CAREFULL)"
                echo ">> If you see any warning while useing 'cd ..' then check your section name or execute 'exit' command to exit from the section."
                echo -e "\033[0m"  # Reset color
                ;;
            *)
                echo -e "\033[1;31m-->> Invalid Command. Use 'help/ls' to view commands.\033[0m"
                ;;
        esac

        history -a "$HISTORY_FILE"
    done
}

# Function to manage subfinder commands
manage_subfinder_commands() {
    local current_section="SUBFINDER"
    local config_path="$HOME/.config/subfinder/config.yaml"
    [[ -f "$HISTORY_FILE" ]] && history -r "$HISTORY_FILE"

    while true; do
        read -e -p "$(echo -e "\033[1;31m($(date +"%I:%M:%S %p"))\033[1;34m-(MAHAKAL)\033[0m-(${current_section})> ")" input
        [[ "$input" == "exit" ]] && break
        [[ -z "$input" ]] && continue
        history -s "$input"

        local cmd=$(echo "$input" | awk '{print $1}')
        local args=$(echo "$input" | cut -d' ' -f2-)

        case $input in
            "mip")
                echo -e "\033[1;32m"  # Green color
                echo "Your IP address is: $(curl -s ifconfig.me)"
                echo -e "\033[0m"  # Reset color
                log_message "INFO" "User checked IP address"
                ;;
            "cd ..")
                return
                ;;
            "cd nmap")
                current_section="NMAP"
                manage_nmap_commands
                current_section="SUBFINDER"
                ;;
            "cd curl")
                current_section="CURL"
                manage_curl_commands
                current_section="SUBFINDER"
                ;;
            "cd whatweb")
                current_section="WHATWEB"
                manage_whatweb_commands
                current_section="SUBFINDER"
                ;;
            "cd wpscan")
                current_section="WPSCAN"
                manage_wpscan_commands
                current_section="SUBFINDER"
                ;;
            "cd waf")
                current_section="WAFW00F"
                traffic_anony
                current_section="SUBFINDER"
                ;;
            "cd dnsrecon")
                current_section="DNSRECON"
                manage_dnsrecon_commands
                current_section="SUBFINDER"
                ;;
            "cd dnsenum")
                current_section="DNSENUM"
                manage_dnsenum_commands
                current_section="SUBFINDER"
                ;;
            "cd httprobe")
                current_section="HTTPROBE"
                manage_httprobe_commands
                current_section="SUBFINDER"
                ;;
            "cd whois")
                current_section="WHOIS"
                manage_whois_commands
                current_section="SUBFINDER"
                ;;
            "cd amass")
                current_section="AMASS"
                manage_amass_commands
                current_section="SUBFINDER"
                ;;
            "cd hydra")
                current_section="HYDRA"
                manage_hydra_commands
                current_section="SUBFINDER"
                ;;
            "cd medusa")
                current_section="MEDUSA"
                manage_medusa_commands
                current_section="SUBFINDER"
                ;;
            "cd john")
                current_section="JOHN"
                manage_john_commands
                current_section="SUBFINDER"
                ;;
            "cd hashcat")
                current_section="HASHCAT"
                manage_hashcat_commands
                current_section="SUBFINDER"
                ;;
            "cd gobuster")
                current_section="GOBUSTER"
                manage_gobuster_commands
                current_section="SUBFINDER"
                ;;
            "cd ffuf")
                current_section="FFUF"
                manage_ffuf_commands
                current_section="SUBFINDER"
                ;;
            "cd nikto")
                current_section="NIKTO"
                manage_nikto_commands
                current_section="SUBFINDER"
                ;;
            "cd masscan")
                current_section="MASSCAN"
                manage_masscan_commands
                current_section="SUBFINDER"
                ;;
            "cd unic")
                current_section="UNICORNSCAN"
                manage_unicornscan_commands
                current_section="SUBFINDER"
                ;;
            "cd enumli")
                current_section="ENUM4LINUX"
                manage_enum4linux_commands
                current_section="SUBFINDER"
                ;;
            "cd sqlmap")
                current_section="SQLMAP"
                manage_sqlmap_commands
                current_section="SUBFINDER"
                ;;
            "cd ai")
                current_section="AI"
                chat_ai
                current_section="SUBFINDER"
                ;;
            "cd css")
                current_section="CSS"
                check_sys_status
                current_section="SUBFINDER"
                ;;
            "cd anony")
                current_section="ANONY"
                traffic_anony
                current_section="SUBFINDER"
                ;;
            "cd ufw")
                current_section="UFW"
                manage_firewall
                current_section="SUBFINDER"
                ;;
        esac

        case $cmd in
            ls)
                echo -e "\033[1;33m\n       SUBFINDER COMMANDS:\033[0m"
                echo -e "\033[1;32m"
                echo "     >>>  scan [domain]         - Run subfinder (to terminal)"
                echo "     >>>  save [domain]         - Save subdomains to [domain]_subs.txt"
                echo "     >>>  json [domain]         - Output in JSON to [domain].json"
                echo "     >>>  silent [domain]       - Subdomains only, no banners"
                echo "     >>>  all [domain]          - Use all sources"
                echo "     >>>  custom [args]         - Run custom subfinder options"
                echo "     >>>  set config [path]     - Set config.yaml path"
                echo "     >>>  show config           - Display current config path"
                echo "     >>>  clear                 - Clear screen"
                echo -e "\033[0m"
                ;;
            scan)
                [[ -z "$args" ]] && echo -e "\033[1;31mUsage: scan [domain]\033[0m" && continue
                log_message "INFO" "Running subfinder on $args"
                subfinder -d "$args" -pc "$config_path"
                ;;
            save)
                [[ -z "$args" ]] && echo -e "\033[1;31mUsage: save [domain]\033[0m" && continue
                local outfile="${args}_subs.txt"
                log_message "INFO" "Saving subdomains of $args to $outfile"
                subfinder -d "$args" -pc "$config_path" -o "$outfile"
                echo -e "\033[1;34mSaved to $outfile\033[0m"
                ;;
            json)
                [[ -z "$args" ]] && echo -e "\033[1;31mUsage: json [domain]\033[0m" && continue
                log_message "INFO" "Saving JSON output for $args"
                subfinder -d "$args" -o "$args.json" -oJ -pc "$config_path"
                echo -e "\033[1;34mSaved to $args.json\033[0m"
                ;;
            silent)
                [[ -z "$args" ]] && echo -e "\033[1;31mUsage: silent [domain]\033[0m" && continue
                log_message "INFO" "Running silent mode on $args"
                subfinder -d "$args" -silent -pc "$config_path"
                ;;
            all)
                [[ -z "$args" ]] && echo -e "\033[1;31mUsage: all [domain]\033[0m" && continue
                log_message "INFO" "Using all sources for $args"
                subfinder -d "$args" -all -pc "$config_path"
                ;;
            custom)
                [[ -z "$args" ]] && echo -e "\033[1;31mUsage: custom [subfinder args]\033[0m" && continue
                log_message "INFO" "Running custom: subfinder $args"
                subfinder $args
                ;;
            set)
                if [[ "$args" =~ ^config[[:space:]]+(.+)$ ]]; then
                    config_path="${BASH_REMATCH[1]}"
                    echo -e "\033[1;32mSubfinder config path set to: $config_path\033[0m"
                else
                    echo -e "\033[1;31mUsage: set config [path]\033[0m"
                fi
                ;;
            show)
                if [[ "$args" == "config" ]]; then
                    echo -e "\033[1;34mCurrent config path: $config_path\033[0m"
                else
                    echo -e "\033[1;31mUsage: show config\033[0m"
                fi
                ;;
            clear)
                clear
                ;;
            "banner")
                display_banner
                ;;
            "dstyle")
                display_fuck_banner1
                ;;
            "bjob")
                display_blowjob_banner
                ;;
            "help")
                echo -e "\033[1;33m" "\n        GLOBAL HELP (GH): \033[0m"
                echo -e "\033[1;32m"
                echo "     >>>   1. ls        - List avaliable security tools in this framework"
                echo "     >>>   2. cd        - To enter New Choosen Section (cd ffuf)"
                echo "     >>>   3. cd ..     - To get back from one section to HOME menu (If 'cd ..' is not working then use 'exit' command)"
                echo "     >>>   4. clear     - Clear the terminal"
                echo "     >>>   5. exit      - Exit the command interface"
                echo "     >>>   6. banner    - To show the banner"
                echo "     >>>   7. dstyle    - Just enjoy Indian hackers (Fun purpose)"
                echo "     >>>   8. bjob      - Just enjoy Indian Hackers (Fun purpose)"
                echo "     >>>   9. mip       - Show your public IP address (JUST USE 'mip' DON'T USE 'cd mip')"
                echo -e "\033[1;31m"  # Red color
                echo ">> By pressing CTRL+C the whole script stops (BE CAREFULL)"
                echo ">> If you see any warning while useing 'cd ..' then check your section name or execute 'exit' command to exit from the section."
                echo -e "\033[0m"  # Reset color
                ;;
            *)
                echo -e "\033[1;31m-->> Invalid Command. Please use 'help/ls' to see the commands.\033[0m"
                ;;
        esac

        history -a "$HISTORY_FILE"
    done
}

manage_httprobe_commands() {
    local current_section="HTTPROBE"
    local timeout=5  # default timeout in seconds
    [[ -f "$HISTORY_FILE" ]] && history -r "$HISTORY_FILE"

    while true; do
        read -e -p "$(echo -e "\033[1;31m($(date +"%I:%M:%S %p"))\033[1;34m-(MAHAKAL)\033[0m-(${current_section})> ")" input
        [[ "$input" == "exit" ]] && break
        [[ -z "$input" ]] && continue
        history -s "$input"

        local cmd=$(echo "$input" | awk '{print $1}')
        local args=$(echo "$input" | cut -d' ' -f2-)

        case $input in
            "mip")
                echo -e "\033[1;32m"  # Green color
                echo "Your IP address is: $(curl -s ifconfig.me)"
                echo -e "\033[0m"  # Reset color
                log_message "INFO" "User checked IP address"
                ;;
            "cd ..")
                return
                ;;
            "cd nmap")
                current_section="NMAP"
                manage_nmap_commands
                current_section="HTTPROBE"
                ;;
            "cd curl")
                current_section="CURL"
                manage_curl_commands
                current_section="HTTPROBE"
                ;;
            "cd whatweb")
                current_section="WHATWEB"
                manage_whatweb_commands
                current_section="HTTPROBE"
                ;;
            "cd wpscan")
                current_section="WPSCAN"
                manage_wpscan_commands
                current_section="HTTPROBE"
                ;;
            "cd waf")
                current_section="WAFW00F"
                traffic_anony
                current_section="HTTPROBE"
                ;;
            "cd subfinder")
                current_section="SUBFINDER"
                manage_subfinder_commands
                current_section="HTTPROBE"
                ;;
            "cd dnsrecon")
                current_section="DNSRECON"
                manage_dnsrecon_commands
                current_section="HTTPROBE"
                ;;
            "cd dnsenum")
                current_section="DNSENUM"
                manage_dnsenum_commands
                current_section="HTTPROBE"
                ;;
            "cd whois")
                current_section="WHOIS"
                manage_whois_commands
                current_section="HTTPROBE"
                ;;
            "cd amass")
                current_section="AMASS"
                manage_amass_commands
                current_section="HTTPROBE"
                ;;
            "cd hydra")
                current_section="HYDRA"
                manage_hydra_commands
                current_section="HTTPROBE"
                ;;
            "cd medusa")
                current_section="MEDUSA"
                manage_medusa_commands
                current_section="HTTPROBE"
                ;;
            "cd john")
                current_section="JOHN"
                manage_john_commands
                current_section="HTTPROBE"
                ;;
            "cd hashcat")
                current_section="HASHCAT"
                manage_hashcat_commands
                current_section="HTTPROBE"
                ;;
            "cd gobuster")
                current_section="GOBUSTER"
                manage_gobuster_commands
                current_section="HTTPROBE"
                ;;
            "cd ffuf")
                current_section="FFUF"
                manage_ffuf_commands
                current_section="HTTPROBE"
                ;;
            "cd nikto")
                current_section="NIKTO"
                manage_nikto_commands
                current_section="HTTPROBE"
                ;;
            "cd masscan")
                current_section="MASSCAN"
                manage_masscan_commands
                current_section="HTTPROBE"
                ;;
            "cd unic")
                current_section="UNICORNSCAN"
                manage_unicornscan_commands
                current_section="HTTPORBE"
                ;;
            "cd enumli")
                current_section="ENUM4LINUX"
                manage_enum4linux_commands
                current_section="HTTPOROBE"
                ;;
            "cd sqlmap")
                current_section="SQLMAP"
                manage_sqlmap_commands
                current_section="HTTPROBE"
                ;;
            "cd ai")
                current_section="AI"
                chat_ai
                current_section="HTTPROBE"
                ;;
            "cd css")
                current_section="CSS"
                check_sys_status
                current_section="HTTPROBE"
                ;;
            "cd anony")
                current_section="ANONY"
                traffic_anony
                current_section="HTTPROBE"
                ;;
            "cd ufw")
                current_section="UFW"
                manage_firewall
                current_section="HTTPROBE"
                ;;
        esac

        case $cmd in
            ls)
                echo -e "\033[1;33m\n       HTTPROBE COMMANDS:\033[0m"
                echo -e "\033[1;32m"
                echo "     >>>  probe [file]                   - Run default probe"
                echo "     >>>  https [file]                   - HTTPS only"
                echo "     >>>  ports [file] [port,port]       - Custom port probe"
                echo "     >>>  delay [file] [ms]              - Set delay in milliseconds"
                echo "     >>>  timeout [file] [sec]           - Set timeout per host"
                echo "     >>>  follow-redirects [file]        - Follow 30x redirects"
                echo "     >>>  prefer-https [file]            - Prefer HTTPS scheme"
                echo "     >>>  prefer-http [file]             - Prefer HTTP scheme"
                echo "     >>>  silent [file]                  - Strip http/https from result"
                echo "     >>>  output [file] [out.txt]        - Save output to file"
                echo "     >>>  load [file]                    - Save live hosts to filtered-subdomains.txt"
                echo "     >>>  custom [args]                  - Run custom httprobe options"
                echo "     >>>  set timeout [sec]              - Set default timeout"
                echo "     >>>  show timeout                   - Display current timeout"
                echo "     >>>  clear                          - Clear screen"
                echo -e "\033[0m"
                ;;
            probe)
                [[ -z "$args" ]] && echo -e "\033[1;31mUsage: probe [file]\033[0m" && continue
                log_message "INFO" "Running default probe on $args"
                cat "$args" | httprobe -t "$timeout"
                ;;
            https)
                [[ -z "$args" ]] && echo -e "\033[1;31mUsage: https [file]\033[0m" && continue
                log_message "INFO" "HTTPS only mode for $args"
                cat "$args" | httprobe -s -t "$timeout"
                ;;
            ports)
                file=$(echo "$args" | awk '{print $1}')
                ports=$(echo "$args" | cut -d' ' -f2-)
                [[ -z "$file" || -z "$ports" ]] && echo -e "\033[1;31mUsage: ports [file] [ports_comma_separated]\033[0m" && continue
                log_message "INFO" "Probing $file with ports $ports"
                cat "$file" | httprobe -p "$ports" -t "$timeout"
                ;;
            delay)
                file=$(echo "$args" | awk '{print $1}')
                delay=$(echo "$args" | awk '{print $2}')
                [[ -z "$file" || -z "$delay" ]] && echo -e "\033[1;31mUsage: delay [file] [ms]\033[0m" && continue
                log_message "INFO" "Delaying probe on $file by $delay ms"
                cat "$file" | httprobe -d "$delay" -t "$timeout"
                ;;
            timeout)
                file=$(echo "$args" | awk '{print $1}')
                tval=$(echo "$args" | awk '{print $2}')
                [[ -z "$file" || -z "$tval" ]] && echo -e "\033[1;31mUsage: timeout [file] [seconds]\033[0m" && continue
                log_message "INFO" "Setting timeout $tval for $file"
                cat "$file" | httprobe -t "$tval"
                ;;
            follow-redirects)
                [[ -z "$args" ]] && echo -e "\033[1;31mUsage: follow-redirects [file]\033[0m" && continue
                log_message "INFO" "Following redirects for $args"
                cat "$args" | httprobe -follow-redirects -t "$timeout"
                ;;
            prefer-https)
                [[ -z "$args" ]] && echo -e "\033[1;31mUsage: prefer-https [file]\033[0m" && continue
                log_message "INFO" "Preferring HTTPS for $args"
                cat "$args" | httprobe -prefer-https -t "$timeout"
                ;;
            prefer-http)
                [[ -z "$args" ]] && echo -e "\033[1;31mUsage: prefer-http [file]\033[0m" && continue
                log_message "INFO" "Preferring HTTP for $args"
                cat "$args" | httprobe -prefer-http -t "$timeout"
                ;;
            silent)
                [[ -z "$args" ]] && echo -e "\033[1;31mUsage: silent [file]\033[0m" && continue
                log_message "INFO" "Silent mode for $args"
                cat "$args" | httprobe -silent -t "$timeout"
                ;;
            output)
                file=$(echo "$args" | awk '{print $1}')
                out=$(echo "$args" | awk '{print $2}')
                [[ -z "$file" || -z "$out" ]] && echo -e "\033[1;31mUsage: output [file] [out.txt]\033[0m" && continue
                log_message "INFO" "Saving output from $file to $out"
                cat "$file" | httprobe -t "$timeout" > "$out"
                echo -e "\033[1;34mSaved to: $out\033[0m"
                ;;
            load)
                [[ -z "$args" ]] && echo -e "\033[1;31mUsage: load [file]\033[0m" && continue
                log_message "INFO" "Saving live domains to filtered-subdomains.txt"
                cat "$args" | httprobe -t "$timeout" > filtered-subdomains.txt
                echo -e "\033[1;34mSaved to: filtered-subdomains.txt\033[0m"
                ;;
            custom)
                [[ -z "$args" ]] && echo -e "\033[1;31mUsage: custom [httprobe options]\033[0m" && continue
                log_message "INFO" "Running custom command: $args"
                httprobe $args
                ;;
            set)
                if [[ "$args" =~ ^timeout[[:space:]]+([0-9]+)$ ]]; then
                    timeout="${BASH_REMATCH[1]}"
                    echo -e "\033[1;32mTimeout set to $timeout seconds\033[0m"
                else
                    echo -e "\033[1;31mUsage: set timeout [seconds]\033[0m"
                fi
                ;;
            show)
                if [[ "$args" == "timeout" ]]; then
                    echo -e "\033[1;34mCurrent timeout: $timeout seconds\033[0m"
                else
                    echo -e "\033[1;31mUsage: show timeout\033[0m"
                fi
                ;;
            clear)
                clear
                ;;
            "banner")
                display_banner
                ;;
            "dstyle")
                display_fuck_banner1
                ;;
            "bjob")
                display_blowjob_banner
                ;;
            "help")
                echo -e "\033[1;33m" "\n        GLOBAL HELP (GH): \033[0m"
                echo -e "\033[1;32m"
                echo "     >>>   1. ls        - List avaliable security tools in this framework"
                echo "     >>>   2. cd        - To enter New Choosen Section (cd ffuf)"
                echo "     >>>   3. cd ..     - To get back from one section to HOME menu (If 'cd ..' is not working then use 'exit' command)"
                echo "     >>>   4. clear     - Clear the terminal"
                echo "     >>>   5. exit      - Exit the command interface"
                echo "     >>>   6. banner    - To show the banner"
                echo "     >>>   7. dstyle    - Just enjoy Indian hackers (Fun purpose)"
                echo "     >>>   8. bjob      - Just enjoy Indian Hackers (Fun purpose)"
                echo "     >>>   9. mip       - Show your public IP address (JUST USE 'mip' DON'T USE 'cd mip')"
                echo -e "\033[1;31m"  # Red color
                echo ">> By pressing CTRL+C the whole script stops (BE CAREFULL)"
                echo ">> If you see any warning while useing 'cd ..' then check your section name or execute 'exit' command to exit from the section."
                echo -e "\033[0m"  # Reset color
                ;;
            *)
                echo -e "\033[1;31m-->> Invalid Command. Use 'help' or 'ls' to list commands.\033[0m"
                ;;
        esac

        history -a "$HISTORY_FILE"
    done
}

manage_whois_commands() {
    local current_section="WHOIS"
    [[ -f "$HISTORY_FILE" ]] && history -r "$HISTORY_FILE"

    while true; do
        read -e -p "$(echo -e "\033[1;31m($(date +"%I:%M:%S %p"))\033[1;34m-(MAHAKAL)\033[0m-(${current_section})> ")" input
        [[ "$input" == "exit" ]] && break
        [[ -z "$input" ]] && continue
        history -s "$input"

        local cmd=$(echo "$input" | awk '{print $1}')
        local args=$(echo "$input" | cut -d' ' -f2-)

        case $input in
            "mip")
                echo -e "\033[1;32m"  # Green color
                echo "Your IP address is: $(curl -s ifconfig.me)"
                echo -e "\033[0m"  # Reset color
                log_message "INFO" "User checked IP address"
                ;;
            "cd ..")
                return
                ;;
            "cd nmap")
                current_section="NMAP"
                manage_nmap_commands
                current_section="WHOIS"
                ;;
            "cd curl")
                current_section="CURL"
                manage_curl_commands
                current_section="WHOIS"
                ;;
            "cd whatweb")
                current_section="WHATWEB"
                manage_whatweb_commands
                current_section="WHOIS"
                ;;
            "cd wpscan")
                current_section="WPSCAN"
                manage_wpscan_commands
                current_section="WHOIS"
                ;;
            "cd waf")
                current_section="WAFW00F"
                traffic_anony
                current_section="WHOIS"
                ;;
            "cd subfinder")
                current_section="SUBFINDER"
                manage_subfinder_commands
                current_section="WHOIS"
                ;;
            "cd dnsrecon")
                current_section="DNSRECON"
                manage_dnsrecon_commands
                current_section="WHOIS"
                ;;
            "cd dnsenum")
                current_section="DNSENUM"
                manage_dnsenum_commands
                current_section="WHOIS"
                ;;
            "cd httprobe")
                current_section="HTTPROBE"
                manage_httprobe_commands
                current_section="WHOIS"
                ;;
            "cd amass")
                current_section="AMASS"
                manage_amass_commands
                current_section="WHOIS"
                ;;
            "cd hydra")
                current_section="HYDRA"
                manage_hydra_commands
                current_section="WHOIS"
                ;;
            "cd medusa")
                current_section="MEDUSA"
                manage_medusa_commands
                current_section="WHOIS"
                ;;
            "cd john")
                current_section="JOHN"
                manage_john_commands
                current_section="WHOIS"
                ;;
            "cd hashcat")
                current_section="HASHCAT"
                manage_hashcat_commands
                current_section="WHOIS"
                ;;
            "cd gobuster")
                current_section="GOBUSTER"
                manage_gobuster_commands
                current_section="WHOIS"
                ;;
            "cd ffuf")
                current_section="FFUF"
                manage_ffuf_commands
                current_section="WHOIS"
                ;;
            "cd nikto")
                current_section="NIKTO"
                manage_nikto_commands
                current_section="WHOIS"
                ;;
            "cd masscan")
                current_section="MASSCAN"
                manage_masscan_commands
                current_section="WHOIS"
                ;;
            "cd unic")
                current_section="UNICORNSCAN"
                manage_unicornscan_commands
                current_section="WHOIS"
                ;;
            "cd enumli")
                current_section="ENUM4LINUX"
                manage_enum4linux_commands
                current_section="WHOIS"
                ;;
            "cd sqlmap")
                current_section="SQLMAP"
                manage_sqlmap_commands
                current_section="WHOIS"
                ;;
            "cd ai")
                current_section="AI"
                chat_ai
                current_section="WHOIS"
                ;;
            "cd css")
                current_section="CSS"
                check_sys_status
                current_section="WHOIS"
                ;;
            "cd anony")
                current_section="ANONY"
                traffic_anony
                current_section="WHOIS"
                ;;
            "cd ufw")
                current_section="UFW"
                manage_firewall
                current_section="WHOIS"
                ;;
        esac

        case $cmd in
            ls)
                echo -e "\033[1;33m\n       WHOIS COMMANDS:\033[0m"
                echo -e "\033[1;32m"
                echo "     >>>  lookup [domain]         - Basic whois lookup"
                echo "     >>>  save [domain] [file]    - Save output to file"
                echo "     >>>  ip [IP]                 - Whois for IP"
                echo "     >>>  custom [args]           - Custom whois query"
                echo -e "\033[0m"
                ;;
            lookup)
                whois "$args" ;;
            save)
                domain=$(echo "$args" | awk '{print $1}')
                file=$(echo "$args" | awk '{print $2}')
                whois "$domain" > "$file" ;;
            ip)
                whois "$args" ;;
            custom)
                whois $args ;;
            "help")
                echo -e "\033[1;33m" "\n        GLOBAL HELP (GH): \033[0m"
                echo -e "\033[1;32m"
                echo "     >>>   1. ls        - List avaliable security tools in this framework"
                echo "     >>>   2. cd        - To enter New Choosen Section (cd ffuf)"
                echo "     >>>   3. cd ..     - To get back from one section to HOME menu (If 'cd ..' is not working then use 'exit' command)"
                echo "     >>>   4. clear     - Clear the terminal"
                echo "     >>>   5. exit      - Exit the command interface"
                echo "     >>>   6. banner    - To show the banner"
                echo "     >>>   7. dstyle    - Just enjoy Indian hackers (Fun purpose)"
                echo "     >>>   8. bjob      - Just enjoy Indian Hackers (Fun purpose)"
                echo "     >>>   9. mip       - Show your public IP address (JUST USE 'mip' DON'T USE 'cd mip')"
                echo -e "\033[1;31m"  # Red color
                echo ">> By pressing CTRL+C the whole script stops (BE CAREFULL)"
                echo ">> If you see any warning while useing 'cd ..' then check your section name or execute 'exit' command to exit from the section."
                echo -e "\033[0m"  # Reset color
                ;;
            clear) 
                clear 
                ;;
            "banner")
                display_banner
                ;;
            "dstyle")
                display_fuck_banner1
                ;;
            "bjob")
                display_blowjob_banner
                ;;
            *) echo -e "\033[1;31m-->> Invalid command\033[0m" ;;
        esac
        history -a "$HISTORY_FILE"
    done
}

manage_amass_commands() {
    local current_section="AMASS"
    [[ -f "$HISTORY_FILE" ]] && history -r "$HISTORY_FILE"

    while true; do
        read -e -p "$(echo -e "\033[1;31m($(date +"%I:%M:%S %p"))\033[1;34m-(MAHAKAL)\033[0m-(${current_section})> ")" input
        [[ "$input" == "exit" ]] && break
        [[ -z "$input" ]] && continue
        history -s "$input"

        local cmd=$(echo "$input" | awk '{print $1}')
        local args=$(echo "$input" | cut -d' ' -f2-)

        case $input in
            "mip")
                echo -e "\033[1;32m"  # Green color
                echo "Your IP address is: $(curl -s ifconfig.me)"
                echo -e "\033[0m"  # Reset color
                log_message "INFO" "User checked IP address"
                ;;
            "cd ..")
                return
                ;;
            "cd nmap")
                current_section="NMAP"
                manage_nmap_commands
                current_section="AMASS"
                ;;
            "cd curl")
                current_section="CURL"
                manage_curl_commands
                current_section="AMASS"
                ;;
            "cd whatweb")
                current_section="WHATWEB"
                manage_whatweb_commands
                current_section="AMASS"
                ;;
            "cd wpscan")
                current_section="WPSCAN"
                manage_wpscan_commands
                current_section="AMASS"
                ;;
            "cd waf")
                current_section="WAFW00F"
                traffic_anony
                current_section="AMASS"
                ;;
            "cd subfinder")
                current_section="SUBFINDER"
                manage_subfinder_commands
                current_section="AMASS"
                ;;
            "cd dnsrecon")
                current_section="DNSRECON"
                manage_dnsrecon_commands
                current_section="AMASS"
                ;;
            "cd dnsenum")
                current_section="DNSENUM"
                manage_dnsenum_commands
                current_section="AMASS"
                ;;
            "cd httprobe")
                current_section="HTTPROBE"
                manage_httprobe_commands
                current_section="AMASS"
                ;;
            "cd whois")
                current_section="WHOIS"
                manage_whois_commands
                current_section="AMASS"
                ;;
            "cd hydra")
                current_section="HYDRA"
                manage_hydra_commands
                current_section="AMASS"
                ;;
            "cd medusa")
                current_section="MEDUSA"
                manage_medusa_commands
                current_section="AMASS"
                ;;
            "cd john")
                current_section="JOHN"
                manage_john_commands
                current_section="AMASS"
                ;;
            "cd hashcat")
                current_section="HASHCAT"
                manage_hashcat_commands
                current_section="AMASS"
                ;;
            "cd gobuster")
                current_section="GOBUSTER"
                manage_gobuster_commands
                current_section="AMASS"
                ;;
            "cd ffuf")
                current_section="FFUF"
                manage_ffuf_commands
                current_section="AMASS"
                ;;
            "cd nikto")
                current_section="NIKTO"
                manage_nikto_commands
                current_section="AMASS"
                ;;
            "cd masscan")
                current_section="MASSCAN"
                manage_masscan_commands
                current_section="AMASS"
                ;;
            "cd unic")
                current_section="UNICORNSCAN"
                manage_unicornscan_commands
                current_section="AMASS"
                ;;
            "cd enumli")
                current_section="ENUM4LINUX"
                manage_enum4linux_commands
                current_section="AMASS"
                ;;
            "cd sqlmap")
                current_section="SQLMAP"
                manage_sqlmap_commands
                current_section="AMASS"
                ;;
            "cd ai")
                current_section="AI"
                chat_ai
                current_section="AMASS"
                ;;
            "cd css")
                current_section="CSS"
                check_sys_status
                current_section="AMASS"
                ;;
            "cd anony")
                current_section="ANONY"
                traffic_anony
                current_section="AMASS"
                ;;
            "cd ufw")
                current_section="UFW"
                manage_firewall
                current_section="AMASS"
                ;;
        esac

        case $cmd in
            ls)
                echo -e "\033[1;33m\n       AMASS COMMANDS:\033[0m"
                echo -e "\033[1;32m"
                echo "     >>>  enum [domain]               - Passive + active enum"
                echo "     >>>  passive [domain]            - Passive only"
                echo "     >>>  output [domain] [file]      - Save to file"
                echo "     >>>  intel [domain]              - ASNs, CIDRs, etc."
                echo "     >>>  brute [domain]              - Brute-force subdomains"
                echo "     >>>  custom [args]               - Run custom amass"
                echo -e "\033[0m"
                ;;
            enum)
                amass enum -d "$args" ;;
            passive)
                amass enum -passive -d "$args" ;;
            output)
                domain=$(echo "$args" | awk '{print $1}')
                file=$(echo "$args" | awk '{print $2}')
                amass enum -d "$domain" -o "$file" ;;
            intel)
                amass intel -d "$args" ;;
            brute)
                amass enum -brute -d "$args" ;;
            custom)
                amass $args ;;
            "help")
                echo -e "\033[1;33m" "\n        GLOBAL HELP (GH): \033[0m"
                echo -e "\033[1;32m"
                echo "     >>>   1. ls        - List avaliable security tools in this framework"
                echo "     >>>   2. cd        - To enter New Choosen Section (cd ffuf)"
                echo "     >>>   3. cd ..     - To get back from one section to HOME menu (If 'cd ..' is not working then use 'exit' command)"
                echo "     >>>   4. clear     - Clear the terminal"
                echo "     >>>   5. exit      - Exit the command interface"
                echo "     >>>   6. banner    - To show the banner"
                echo "     >>>   7. dstyle    - Just enjoy Indian hackers (Fun purpose)"
                echo "     >>>   8. bjob      - Just enjoy Indian Hackers (Fun purpose)"
                echo "     >>>   9. mip       - Show your public IP address (JUST USE 'mip' DON'T USE 'cd mip')"
                echo -e "\033[1;31m"  # Red color
                echo ">> By pressing CTRL+C the whole script stops (BE CAREFULL)"
                echo ">> If you see any warning while useing 'cd ..' then check your section name or execute 'exit' command to exit from the section."
                echo -e "\033[0m"  # Reset color
                ;;
            clear) 
                clear 
                ;;
            "banner")
                display_banner
                ;;
            "dstyle")
                display_fuck_banner1
                ;;
            "bjob")
                display_blowjob_banner
                ;;
            *) echo -e "\033[1;31m-->> Invalid command\033[0m" ;;
        esac
        history -a "$HISTORY_FILE"
    done
}

manage_hydra_commands() {
    local current_section="HYDRA"
    [[ -f "$HISTORY_FILE" ]] && history -r "$HISTORY_FILE"

    while true; do
        read -e -p "$(echo -e "\033[1;31m($(date +"%I:%M:%S %p"))\033[1;34m-(MAHAKAL)\033[0m-(${current_section})> ")" input
        [[ "$input" == "exit" ]] && break
        [[ -z "$input" ]] && continue
        history -s "$input"

        local cmd=$(echo "$input" | awk '{print $1}')
        local args=$(echo "$input" | cut -d' ' -f2-)

        case $input in
            "mip")
                echo -e "\033[1;32m"  # Green color
                echo "Your IP address is: $(curl -s ifconfig.me)"
                echo -e "\033[0m"  # Reset color
                log_message "INFO" "User checked IP address"
                ;;
            "cd ..")
                return
                ;;
            "cd nmap")
                current_section="NMAP"
                manage_nmap_commands
                current_section="HYDRA"
                ;;
            "cd curl")
                current_section="CURL"
                manage_curl_commands
                current_section="HYDRA"
                ;;
            "cd whatweb")
                current_section="WHATWEB"
                manage_whatweb_commands
                current_section="HYDRA"
                ;;
            "cd wpscan")
                current_section="WPSCAN"
                manage_wpscan_commands
                current_section="HYDRA"
                ;;
            "cd waf")
                current_section="WAFW00F"
                traffic_anony
                current_section="HYDRA"
                ;;
            "cd subfinder")
                current_section="SUBFINDER"
                manage_subfinder_commands
                current_section="HYDRA"
                ;;
            "cd dnsrecon")
                current_section="DNSRECON"
                manage_dnsrecon_commands
                current_section="HYDRA"
                ;;
            "cd dnsenum")
                current_section="DNSENUM"
                manage_dnsenum_commands
                current_section="HYDRA"
                ;;
            "cd httprobe")
                current_section="HTTPROBE"
                manage_httprobe_commands
                current_section="HYDRA"
                ;;
            "cd whois")
                current_section="WHOIS"
                manage_whois_commands
                current_section="HYDRA"
                ;;
            "cd amass")
                current_section="AMASS"
                manage_amass_commands
                current_section="HYDRA"
                ;;
            "cd medusa")
                current_section="MEDUSA"
                manage_medusa_commands
                current_section="HYDRA"
                ;;
            "cd john")
                current_section="JOHN"
                manage_john_commands
                current_section="HYDRA"
                ;;
            "cd hashcat")
                current_section="HASHCAT"
                manage_hashcat_commands
                current_section="HYDRA"
                ;;
            "cd gobuster")
                current_section="GOBUSTER"
                manage_gobuster_commands
                current_section="HYDRA"
                ;;
            "cd ffuf")
                current_section="FFUF"
                manage_ffuf_commands
                current_section="HYDRA"
                ;;
            "cd nikto")
                current_section="NIKTO"
                manage_nikto_commands
                current_section="HYDRA"
                ;;
            "cd masscan")
                current_section="MASSCAN"
                manage_masscan_commands
                current_section="HYDRA"
                ;;
            "cd unic")
                current_section="UNICORNSCAN"
                manage_unicornscan_commands
                current_section="HYDRA"
                ;;
            "cd enumli")
                current_section="ENUM4LINUX"
                manage_enum4linux_commands
                current_section="HYDRA"
                ;;
            "cd sqlmap")
                current_section="SQLMAP"
                manage_sqlmap_commands
                current_section="HYDRA"
                ;;
            "cd ai")
                current_section="AI"
                chat_ai
                current_section="HYDRA"
                ;;
            "cd css")
                current_section="CSS"
                check_sys_status
                current_section="HYDRA"
                ;;
            "cd anony")
                current_section="ANONY"
                traffic_anony
                current_section="HYDRA"
                ;;
            "cd ufw")
                current_section="UFW"
                manage_firewall
                current_section="HYDRA"
                ;;
        esac

        case $cmd in
            ls)
                echo -e "\033[1;33m\n       HYDRA COMMANDS:\033[0m"
                echo -e "\033[1;32m"
                echo "     >>>  ftp [ip] [user.txt] [pass.txt]"
                echo "     >>>  ssh [ip] [user.txt] [pass.txt]"
                echo "     >>>  http [ip] [user.txt] [pass.txt]"
                echo "     >>>  rdp [ip] [user.txt] [pass.txt]"
                echo "     >>>  smtp [ip] [user.txt] [pass.txt]"
                echo "     >>>  custom [args]             - Custom hydra command"
                echo -e "\033[0m"
                ;;
            ftp|ssh|http|rdp|smtp)
                read -r ip userlist passlist <<< "$args"
                hydra -L "$userlist" -P "$passlist" "$ip" $cmd ;;
            custom)
                hydra $args ;;
            "help")
                echo -e "\033[1;33m" "\n        GLOBAL HELP (GH): \033[0m"
                echo -e "\033[1;32m"
                echo "     >>>   1. ls        - List avaliable security tools in this framework"
                echo "     >>>   2. cd        - To enter New Choosen Section (cd ffuf)"
                echo "     >>>   3. cd ..     - To get back from one section to HOME menu (If 'cd ..' is not working then use 'exit' command)"
                echo "     >>>   4. clear     - Clear the terminal"
                echo "     >>>   5. exit      - Exit the command interface"
                echo "     >>>   6. banner    - To show the banner"
                echo "     >>>   7. dstyle    - Just enjoy Indian hackers (Fun purpose)"
                echo "     >>>   8. bjob      - Just enjoy Indian Hackers (Fun purpose)"
                echo "     >>>   9. mip       - Show your public IP address (JUST USE 'mip' DON'T USE 'cd mip')"
                echo -e "\033[1;31m"  # Red color
                echo ">> By pressing CTRL+C the whole script stops (BE CAREFULL)"
                echo ">> If you see any warning while useing 'cd ..' then check your section name or execute 'exit' command to exit from the section."
                echo -e "\033[0m"  # Reset color
                ;;
            clear) 
                clear 
                ;;
            "banner")
                display_banner
                ;;
            "dstyle")
                display_fuck_banner1
                ;;
            "bjob")
                display_blowjob_banner
                ;;
            *) echo -e "\033[1;31m-->> Invalid command\033[0m" ;;
        esac
        history -a "$HISTORY_FILE"
    done
}

manage_medusa_commands() {
    local current_section="MEDUSA"
    [[ -f "$HISTORY_FILE" ]] && history -r "$HISTORY_FILE"

    while true; do
        read -e -p "$(echo -e "\033[1;31m($(date +"%I:%M:%S %p"))\033[1;34m-(MAHAKAL)\033[0m-(${current_section})> ")" input
        [[ "$input" == "exit" ]] && break
        [[ -z "$input" ]] && continue
        history -s "$input"

        local cmd=$(echo "$input" | awk '{print $1}')
        local args=$(echo "$input" | cut -d' ' -f2-)

        case $input in
            "mip")
                echo -e "\033[1;32m"  # Green color
                echo "Your IP address is: $(curl -s ifconfig.me)"
                echo -e "\033[0m"  # Reset color
                log_message "INFO" "User checked IP address"
                ;;
            "cd ..")
                return
                ;;
            "cd nmap")
                current_section="NMAP"
                manage_nmap_commands
                current_section="MEDUSA"
                ;;
            "cd curl")
                current_section="CURL"
                manage_curl_commands
                current_section="MEDUSA"
                ;;
            "cd whatweb")
                current_section="WHATWEB"
                manage_whatweb_commands
                current_section="MEDUSA"
                ;;
            "cd wpscan")
                current_section="WPSCAN"
                manage_wpscan_commands
                current_section="MEDUSA"
                ;;
            "cd waf")
                current_section="WAFW00F"
                traffic_anony
                current_section="MEDUSA"
                ;;
            "cd subfinder")
                current_section="SUBFINDER"
                manage_subfinder_commands
                current_section="MEDUSA"
                ;;
            "cd dnsrecon")
                current_section="DNSRECON"
                manage_dnsrecon_commands
                current_section="MEDUSA"
                ;;
            "cd dnsenum")
                current_section="DNSENUM"
                manage_dnsenum_commands
                current_section="MEDUSA"
                ;;
            "cd httprobe")
                current_section="HTTPROBE"
                manage_httprobe_commands
                current_section="MEDUSA"
                ;;
            "cd whois")
                current_section="WHOIS"
                manage_whois_commands
                current_section="MEDUSA"
                ;;
            "cd amass")
                current_section="AMASS"
                manage_amass_commands
                current_section="MEDUSA"
                ;;
            "cd hydra")
                current_section="HYDRA"
                manage_hydra_commands
                current_section="MEDUSA"
                ;;
            "cd john")
                current_section="JOHN"
                manage_john_commands
                current_section="MEDUSA"
                ;;
            "cd hashcat")
                current_section="HASHCAT"
                manage_hashcat_commands
                current_section="MEDUSA"
                ;;
            "cd gobuster")
                current_section="GOBUSTER"
                manage_gobuster_commands
                current_section="MEDUSA"
                ;;
            "cd ffuf")
                current_section="FFUF"
                manage_ffuf_commands
                current_section="MEDUSA"
                ;;
            "cd nikto")
                current_section="NIKTO"
                manage_nikto_commands
                current_section="MEDUSA"
                ;;
            "cd masscan")
                current_section="MASSCAN"
                manage_masscan_commands
                current_section="MEDUSA"
                ;;
            "cd unic")
                current_section="UNICORNSCAN"
                manage_unicornscan_commands
                current_section="MEDUSA"
                ;;
            "cd enumli")
                current_section="ENUM4LINUX"
                manage_enum4linux_commands
                current_section="MEDUSA"
                ;;
            "cd sqlmap")
                current_section="SQLMAP"
                manage_sqlmap_commands
                current_section="MEDUSA"
                ;;
            "cd ai")
                current_section="AI"
                chat_ai
                current_section="MEDUSA"
                ;;
            "cd css")
                current_section="CSS"
                check_sys_status
                current_section="MEDUSA"
                ;;
            "cd anony")
                current_section="ANONY"
                traffic_anony
                current_section="MEDUSA"
                ;;
            "cd ufw")
                current_section="UFW"
                manage_firewall
                current_section="MEDUSA"
                ;;
        esac

        case $cmd in
            ls)
                echo -e "\033[1;33m\n       MEDUSA COMMANDS:\033[0m"
                echo -e "\033[1;32m"
                echo "     >>>  ftp [ip] [user.txt] [pass.txt]"
                echo "     >>>  ssh [ip] [user.txt] [pass.txt]"
                echo "     >>>  http [ip] [user.txt] [pass.txt]"
                echo "     >>>  smb [ip] [user.txt] [pass.txt]"
                echo "     >>>  custom [args]               - Custom medusa command"
                echo -e "\033[0m"
                ;;
            ftp|ssh|http|smb)
                read -r ip userlist passlist <<< "$args"
                medusa -h "$ip" -U "$userlist" -P "$passlist" -M $cmd ;;
            custom)
                medusa $args ;;
            "help")
                echo -e "\033[1;33m" "\n        GLOBAL HELP (GH): \033[0m"
                echo -e "\033[1;32m"
                echo "     >>>   1. ls        - List avaliable security tools in this framework"
                echo "     >>>   2. cd        - To enter New Choosen Section (cd ffuf)"
                echo "     >>>   3. cd ..     - To get back from one section to HOME menu (If 'cd ..' is not working then use 'exit' command)"
                echo "     >>>   4. clear     - Clear the terminal"
                echo "     >>>   5. exit      - Exit the command interface"
                echo "     >>>   6. banner    - To show the banner"
                echo "     >>>   7. dstyle    - Just enjoy Indian hackers (Fun purpose)"
                echo "     >>>   8. bjob      - Just enjoy Indian Hackers (Fun purpose)"
                echo "     >>>   9. mip       - Show your public IP address (JUST USE 'mip' DON'T USE 'cd mip')"
                echo -e "\033[1;31m"  # Red color
                echo ">> By pressing CTRL+C the whole script stops (BE CAREFULL)"
                echo ">> If you see any warning while useing 'cd ..' then check your section name or execute 'exit' command to exit from the section."
                echo -e "\033[0m"  # Reset color
                ;;
            clear) 
                clear 
                ;;
            "banner")
                display_banner
                ;;
            "dstyle")
                display_fuck_banner1
                ;;
            "bjob")
                display_blowjob_banner
                ;;
            *) echo -e "\033[1;31m-->> Invalid command\033[0m" ;;
        esac
        history -a "$HISTORY_FILE"
    done
}

manage_john_commands() {
    local current_section="JOHN"
    [[ -f "$HISTORY_FILE" ]] && history -r "$HISTORY_FILE"

    while true; do
        read -e -p "$(echo -e "\033[1;31m($(date +"%I:%M:%S %p"))\033[1;34m-(MAHAKAL)\033[0m-(${current_section})> ")" input
        [[ "$input" == "exit" ]] && break
        [[ -z "$input" ]] && continue
        history -s "$input"

        local cmd=$(echo "$input" | awk '{print $1}')
        local args=$(echo "$input" | cut -d' ' -f2-)

        case $input in
            "mip")
                echo -e "\033[1;32m"  # Green color
                echo "Your IP address is: $(curl -s ifconfig.me)"
                echo -e "\033[0m"  # Reset color
                log_message "INFO" "User checked IP address"
                ;;
            "cd ..")
                return
                ;;
            "cd nmap")
                current_section="NMAP"
                manage_nmap_commands
                current_section="JOHN"
                ;;
            "cd curl")
                current_section="CURL"
                manage_curl_commands
                current_section="JOHN"
                ;;
            "cd whatweb")
                current_section="WHATWEB"
                manage_whatweb_commands
                current_section="JOHN"
                ;;
            "cd wpscan")
                current_section="WPSCAN"
                manage_wpscan_commands
                current_section="JOHN"
                ;;
            "cd waf")
                current_section="WAFW00F"
                traffic_anony
                current_section="JOHN"
                ;;
            "cd subfinder")
                current_section="SUBFINDER"
                manage_subfinder_commands
                current_section="JOHN"
                ;;
            "cd dnsrecon")
                current_section="DNSRECON"
                manage_dnsrecon_commands
                current_section="JOHN"
                ;;
            "cd dnsenum")
                current_section="DNSENUM"
                manage_dnsenum_commands
                current_section="JOHN"
                ;;
            "cd httprobe")
                current_section="HTTPROBE"
                manage_httprobe_commands
                current_section="JOHN"
                ;;
            "cd whois")
                current_section="WHOIS"
                manage_whois_commands
                current_section="JOHN"
                ;;
            "cd amass")
                current_section="AMASS"
                manage_amass_commands
                current_section="JOHN"
                ;;
            "cd hydra")
                current_section="HYDRA"
                manage_hydra_commands
                current_section="JOHN"
                ;;
            "cd medusa")
                current_section="MEDUSA"
                manage_medusa_commands
                current_section="JOHN"
                ;;
            "cd hashcat")
                current_section="HASHCAT"
                manage_hashcat_commands
                current_section="JOHN"
                ;;
            "cd gobuster")
                current_section="GOBUSTER"
                manage_gobuster_commands
                current_section="JOHN"
                ;;
            "cd ffuf")
                current_section="FFUF"
                manage_ffuf_commands
                current_section="JOHN"
                ;;
            "cd nikto")
                current_section="NIKTO"
                manage_nikto_commands
                current_section="JOHN"
                ;;
            "cd masscan")
                current_section="MASSCAN"
                manage_masscan_commands
                current_section="JOHN"
                ;;
            "cd unic")
                current_section="UNICORNSCAN"
                manage_unicornscan_commands
                current_section="JOHN"
                ;;
            "cd enumli")
                current_section="ENUM4LINUX"
                manage_enum4linux_commands
                current_section="JOHN"
                ;;
            "cd sqlmap")
                current_section="SQLMAP"
                manage_sqlmap_commands
                current_section="JOHN"
                ;;
            "cd ai")
                current_section="AI"
                chat_ai
                current_section="JOHN"
                ;;
            "cd css")
                current_section="CSS"
                check_sys_status
                current_section="JOHN"
                ;;
            "cd anony")
                current_section="ANONY"
                traffic_anony
                current_section="JOHN"
                ;;
            "cd ufw")
                current_section="UFW"
                manage_firewall
                current_section="JOHN"
                ;;
        esac

        case $cmd in
            ls)
                echo -e "\033[1;33m\n       JOHN COMMANDS:\033[0m"
                echo -e "\033[1;32m"
                echo "     >>>  crack [hash.txt] [wordlist]         - Basic cracking"
                echo "     >>>  show [hash.txt]                     - Show cracked passwords"
                echo "     >>>  format [format]                     - Supported hash format"
                echo "     >>>  rules [hash.txt] [wordlist]         - Use rules"
                echo "     >>>  resume                              - Resume last session"
                echo "     >>>  restore [session]                   - Restore named session"
                echo "     >>>  benchmark                           - Performance test"
                echo "     >>>  unshadow [passwd] [shadow] [out]    - Extract hashes from Linux"
                echo "     >>>  zip2john [file.zip] > out.txt       - Extract hashes from ZIP"
                echo "     >>>  pdf2john [file.pdf] > out.txt       - Extract PDF hashes"
                echo "     >>>  office2john [file.docx] > out.txt   - Extract MS Office hashes"
                echo "     >>>  rar2john [file.rar] > out.txt       - Extract RAR hashes"
                echo "     >>>  custom [args]                       - Custom john command"
                echo -e "\033[0m"
                ;;
            crack)
                file=$(echo "$args" | awk '{print $1}')
                wordlist=$(echo "$args" | awk '{print $2}')
                [[ ! -f "$file" || ! -f "$wordlist" ]] && echo -e "\033[1;31mFile not found.\033[0m" && continue
                john --wordlist="$wordlist" "$file"
                ;;
            show)
                [[ ! -f "$args" ]] && echo -e "\033[1;31mFile not found.\033[0m" && continue
                john --show "$args"
                ;;
            format)
                john --list=formats | grep -i "$args"
                ;;
            resume)
                john --restore
                ;;
            restore)
                john --restore="$args"
                ;;
            rules)
                file=$(echo "$args" | awk '{print $1}')
                wordlist=$(echo "$args" | awk '{print $2}')
                john --wordlist="$wordlist" --rules "$file"
                ;;
            benchmark)
                john --test
                ;;
            unshadow)
                pfile=$(echo "$args" | awk '{print $1}')
                sfile=$(echo "$args" | awk '{print $2}')
                outfile=$(echo "$args" | awk '{print $3}')
                unshadow "$pfile" "$sfile" > "$outfile"
                ;;
            zip2john|pdf2john|office2john|rar2john)
                file=$(echo "$args" | awk '{print $1}')
                [[ ! -f "$file" ]] && echo -e "\033[1;31mFile not found.\033[0m" && continue
                $cmd "$file"
                ;;
            custom)
                john $args
                ;;
            "help")
                echo -e "\033[1;33m" "\n        GLOBAL HELP (GH): \033[0m"
                echo -e "\033[1;32m"
                echo "     >>>   1. ls        - List avaliable security tools in this framework"
                echo "     >>>   2. cd        - To enter New Choosen Section (cd ffuf)"
                echo "     >>>   3. cd ..     - To get back from one section to HOME menu (If 'cd ..' is not working then use 'exit' command)"
                echo "     >>>   4. clear     - Clear the terminal"
                echo "     >>>   5. exit      - Exit the command interface"
                echo "     >>>   6. banner    - To show the banner"
                echo "     >>>   7. dstyle    - Just enjoy Indian hackers (Fun purpose)"
                echo "     >>>   8. bjob      - Just enjoy Indian Hackers (Fun purpose)"
                echo "     >>>   9. mip       - Show your public IP address (JUST USE 'mip' DON'T USE 'cd mip')"
                echo -e "\033[1;31m"  # Red color
                echo ">> By pressing CTRL+C the whole script stops (BE CAREFULL)"
                echo ">> If you see any warning while useing 'cd ..' then check your section name or execute 'exit' command to exit from the section."
                echo -e "\033[0m"  # Reset color
                ;;
            clear) 
                clear 
                ;;
            "banner")
                display_banner
                ;;
            "dstyle")
                display_fuck_banner1
                ;;
            "bjob")
                display_blowjob_banner
                ;;
            *) echo -e "\033[1;31m-->> Invalid command. Use 'help' or 'ls'.\033[0m" ;;
        esac

        history -a "$HISTORY_FILE"
    done
}

manage_hashcat_commands() {
    local current_section="HASHCAT"
    [[ -f "$HISTORY_FILE" ]] && history -r "$HISTORY_FILE"

    while true; do
        read -e -p "$(echo -e "\033[1;31m($(date +"%I:%M:%S %p"))\033[1;34m-(MAHAKAL)\033[0m-(${current_section})> ")" input
        [[ "$input" == "exit" ]] && break
        [[ -z "$input" ]] && continue
        history -s "$input"

        local cmd=$(echo "$input" | awk '{print $1}')
        local args=$(echo "$input" | cut -d' ' -f2-)
        
        case $input in
            "mip")
                echo -e "\033[1;32m"  # Green color
                echo "Your IP address is: $(curl -s ifconfig.me)"
                echo -e "\033[0m"  # Reset color
                log_message "INFO" "User checked IP address"
                ;;
            "cd ..")
                return
                ;;
            "cd nmap")
                current_section="NMAP"
                manage_nmap_commands
                current_section="HASHCAT"
                ;;
            "cd curl")
                current_section="CURL"
                manage_curl_commands
                current_section="HASHCAT"
                ;;
            "cd whatweb")
                current_section="WHATWEB"
                manage_whatweb_commands
                current_section="HASHCAT"
                ;;
            "cd wpscan")
                current_section="WPSCAN"
                manage_wpscan_commands
                current_section="HASHCAT"
                ;;
            "cd waf")
                current_section="WAFW00F"
                traffic_anony
                current_section="HASHCAT"
                ;;
            "cd subfinder")
                current_section="SUBFINDER"
                manage_subfinder_commands
                current_section="HASHCAT"
                ;;
            "cd dnsrecon")
                current_section="DNSRECON"
                manage_dnsrecon_commands
                current_section="HASHCAT"
                ;;
            "cd dnsenum")
                current_section="DNSENUM"
                manage_dnsenum_commands
                current_section="HASHCAT"
                ;;
            "cd httprobe")
                current_section="HTTPROBE"
                manage_httprobe_commands
                current_section="HASHCAT"
                ;;
            "cd whois")
                current_section="WHOIS"
                manage_whois_commands
                current_section="HASHCAT"
                ;;
            "cd amass")
                current_section="AMASS"
                manage_amass_commands
                current_section="HASHCAT"
                ;;
            "cd hydra")
                current_section="HYDRA"
                manage_hydra_commands
                current_section="HASHCAT"
                ;;
            "cd medusa")
                current_section="MEDUSA"
                manage_medusa_commands
                current_section="HASHCAT"
                ;;
            "cd john")
                current_section="JOHN"
                manage_john_commands
                current_section="HASHCAT"
                ;;
            "cd gobuster")
                current_section="GOBUSTER"
                manage_gobuster_commands
                current_section="HASHCAT"
                ;;
            "cd ffuf")
                current_section="FFUF"
                manage_ffuf_commands
                current_section="HASHCAT"
                ;;
            "cd nikto")
                current_section="NIKTO"
                manage_nikto_commands
                current_section="HASHCAT"
                ;;
            "cd masscan")
                current_section="MASSCAN"
                manage_masscan_commands
                current_section="HASHCAT"
                ;;
            "cd unic")
                current_section="UNICORNSCAN"
                manage_unicornscan_commands
                current_section="HASHCAT"
                ;;
            "cd enumli")
                current_section="ENUM4LINUX"
                manage_enum4linux_commands
                current_section="HASHCAT"
                ;;
            "cd sqlmap")
                current_section="SQLMAP"
                manage_sqlmap_commands
                current_section="HASHCAT"
                ;;
            "cd ai")
                current_section="AI"
                chat_ai
                current_section="HASHCAT"
                ;;
            "cd css")
                current_section="CSS"
                check_sys_status
                current_section="HASHCAT"
                ;;
            "cd anony")
                current_section="ANONY"
                traffic_anony
                current_section="HASHCAT"
                ;;
            "cd ufw")
                current_section="UFW"
                manage_firewall
                current_section="HASHCAT"
                ;;
        esac

        case $cmd in
            ls)
                echo -e "\033[1;33m\n       HASHCAT COMMANDS:\033[0m"
                echo -e "\033[1;32m"
                echo "     >>>  crack [mode] [hash.txt] [wordlist]             - Dictionary attack"
                echo "     >>>  brute [mode] [hash.txt] [mask]                 - Brute force attack"
                echo "     >>>  rules [mode] [hash.txt] [wordlist]             - Apply rules"
                echo "     >>>  combinator [mode] [hash.txt] [file1] [file2]   - Combo attack"
                echo "     >>>  devices                                        - Show available devices"
                echo "     >>>  formats                                        - List supported hash types"
                echo "     >>>  session [session]                              - Name session for resume"
                echo "     >>>  resume                                         - Resume previous session"
                echo "     >>>  status                                         - Check running status"
                echo "     >>>  custom [args]                                  - Custom command"
                echo -e "\033[0m"
                ;;
            crack)
                mode=$(echo "$args" | awk '{print $1}')
                file=$(echo "$args" | awk '{print $2}')
                wordlist=$(echo "$args" | awk '{print $3}')
                hashcat -m "$mode" "$file" "$wordlist"
                ;;
            brute)
                mode=$(echo "$args" | awk '{print $1}')
                file=$(echo "$args" | awk '{print $2}')
                mask=$(echo "$args" | awk '{print $3}')
                hashcat -m "$mode" "$file" -a 3 "$mask"
                ;;
            rules)
                mode=$(echo "$args" | awk '{print $1}')
                file=$(echo "$args" | awk '{print $2}')
                wordlist=$(echo "$args" | awk '{print $3}')
                hashcat -m "$mode" "$file" "$wordlist" -r /usr/share/hashcat/rules/best64.rule
                ;;
            combinator)
                mode=$(echo "$args" | awk '{print $1}')
                file=$(echo "$args" | awk '{print $2}')
                word1=$(echo "$args" | awk '{print $3}')
                word2=$(echo "$args" | awk '{print $4}')
                hashcat -m "$mode" "$file" -a 1 "$word1" "$word2"
                ;;
            formats)
                hashcat --help | grep -A100 "Hash modes" | less
                ;;
            devices)
                hashcat -I
                ;;
            session)
                hashcat --session="$args"
                ;;
            resume)
                hashcat --restore
                ;;
            status)
                hashcat --status
                ;;
            custom)
                hashcat $args
                ;;
            "help")
                echo -e "\033[1;33m" "\n        GLOBAL HELP (GH): \033[0m"
                echo -e "\033[1;32m"
                echo "     >>>   1. ls        - List avaliable security tools in this framework"
                echo "     >>>   2. cd        - To enter New Choosen Section (cd ffuf)"
                echo "     >>>   3. cd ..     - To get back from one section to HOME menu (If 'cd ..' is not working then use 'exit' command)"
                echo "     >>>   4. clear     - Clear the terminal"
                echo "     >>>   5. exit      - Exit the command interface"
                echo "     >>>   6. banner    - To show the banner"
                echo "     >>>   7. dstyle    - Just enjoy Indian hackers (Fun purpose)"
                echo "     >>>   8. bjob      - Just enjoy Indian Hackers (Fun purpose)"
                echo "     >>>   9. mip       - Show your public IP address (JUST USE 'mip' DON'T USE 'cd mip')"
                echo -e "\033[1;31m"  # Red color
                echo ">> By pressing CTRL+C the whole script stops (BE CAREFULL)"
                echo ">> If you see any warning while useing 'cd ..' then check your section name or execute 'exit' command to exit from the section."
                echo -e "\033[0m"  # Reset color
                ;;
            clear) 
                clear 
                ;;
            "banner")
                display_banner
                ;;
            "dstyle")
                display_fuck_banner1
                ;;
            "bjob")
                display_blowjob_banner
                ;;
            *) echo -e "\033[1;31m-->> Invalid command. Use 'help' or 'ls'.\033[0m" ;;
        esac

        history -a "$HISTORY_FILE"
    done
}

manage_gobuster_commands() {
    local current_section="GOBUSTER"
    [[ -f "$HISTORY_FILE" ]] && history -r "$HISTORY_FILE"

    while true; do
        read -e -p "$(echo -e "\033[1;31m($(date +"%I:%M:%S %p"))\033[1;34m-(MAHAKAL)\033[0m-(${current_section})> ")" input
        [[ "$input" == "exit" ]] && break
        [[ -z "$input" ]] && continue
        history -s "$input"

        local cmd=$(echo "$input" | awk '{print $1}')
        local args=$(echo "$input" | cut -d' ' -f2-)

        case $input in
            "mip")
                echo -e "\033[1;32m"  # Green color
                echo "Your IP address is: $(curl -s ifconfig.me)"
                echo -e "\033[0m"  # Reset color
                log_message "INFO" "User checked IP address"
                ;;
            "cd ..")
                return
                ;;
            "cd nmap")
                current_section="NMAP"
                manage_nmap_commands
                current_section="GOBUSTER"
                ;;
            "cd curl")
                current_section="CURL"
                manage_curl_commands
                current_section="GOBUSTER"
                ;;
            "cd whatweb")
                current_section="WHATWEB"
                manage_whatweb_commands
                current_section="GOBUSTER"
                ;;
            "cd wpscan")
                current_section="WPSCAN"
                manage_wpscan_commands
                current_section="GOBUSTER"
                ;;
            "cd waf")
                current_section="WAFW00F"
                traffic_anony
                current_section="GOBUSTER"
                ;;
            "cd subfinder")
                current_section="SUBFINDER"
                manage_subfinder_commands
                current_section="GOBUSTER"
                ;;
            "cd dnsrecon")
                current_section="DNSRECON"
                manage_dnsrecon_commands
                current_section="GOBUSTER"
                ;;
            "cd dnsenum")
                current_section="DNSENUM"
                manage_dnsenum_commands
                current_section="GOBUSTER"
                ;;
            "cd httprobe")
                current_section="HTTPROBE"
                manage_httprobe_commands
                current_section="GOBUSTER"
                ;;
            "cd whois")
                current_section="WHOIS"
                manage_whois_commands
                current_section="GOBUSTER"
                ;;
            "cd amass")
                current_section="AMASS"
                manage_amass_commands
                current_section="GOBUSTER"
                ;;
            "cd hydra")
                current_section="HYDRA"
                manage_hydra_commands
                current_section="GOBUSTER"
                ;;
            "cd medusa")
                current_section="MEDUSA"
                manage_medusa_commands
                current_section="GOBUSTER"
                ;;
            "cd john")
                current_section="JOHN"
                manage_john_commands
                current_section="GOBUSTER"
                ;;
            "cd hashcat")
                current_section="HASHCAT"
                manage_hashcat_commands
                current_section="GOBUSTER"
                ;;
            "cd ffuf")
                current_section="FFUF"
                manage_ffuf_commands
                current_section="GOBUSTER"
                ;;
            "cd nikto")
                current_section="NIKTO"
                manage_nikto_commands
                current_section="GOBUSTER"
                ;;
            "cd masscan")
                current_section="MASSCAN"
                manage_masscan_commands
                current_section="GOBUSTER"
                ;;
            "cd unic")
                current_section="UNICORNSCAN"
                manage_unicornscan_commands
                current_section="GOBUSTER"
                ;;
            "cd enumli")
                current_section="ENUM4LINUX"
                manage_enum4linux_commands
                current_section="GOBUSTER"
                ;;
            "cd sqlmap")
                current_section="SQLMAP"
                manage_sqlmap_commands
                current_section="GOBUSTER"
                ;;
            "cd ai")
                current_section="AI"
                chat_ai
                current_section="GOBUSTER"
                ;;
            "cd css")
                current_section="CSS"
                check_sys_status
                current_section="GOBUSTER"
                ;;
            "cd anony")
                current_section="ANONY"
                traffic_anony
                current_section="GOBUSTER"
                ;;
            "cd ufw")
                current_section="UFW"
                manage_firewall
                current_section="GOBUSTER"
                ;;
        esac

        case $cmd in
            ls)
                echo -e "\033[1;33m\n       GOBUSTER COMMANDS:\033[0m"
                echo -e "\033[1;32m"
                echo "     >>>  dir [url] [wordlist]        - Directory brute force"
                echo "     >>>  dns [domain] [wordlist]     - DNS subdomain brute force"
                echo "     >>>  vhost [domain] [wordlist]   - VHost brute force"
                echo "     >>>  s3 [bucket] [wordlist]      - S3 bucket brute force"
                echo "     >>>  custom [args]               - Run custom gobuster command"
                echo -e "\033[0m"
                ;;
            dir)
                url=$(echo "$args" | awk '{print $1}')
                wordlist=$(echo "$args" | awk '{print $2}')
                gobuster dir -u "$url" -w "$wordlist"
                ;;
            dns)
                domain=$(echo "$args" | awk '{print $1}')
                wordlist=$(echo "$args" | awk '{print $2}')
                gobuster dns -d "$domain" -w "$wordlist"
                ;;
            vhost)
                domain=$(echo "$args" | awk '{print $1}')
                wordlist=$(echo "$args" | awk '{print $2}')
                gobuster vhost -u "$domain" -w "$wordlist"
                ;;
            s3)
                bucket=$(echo "$args" | awk '{print $1}')
                wordlist=$(echo "$args" | awk '{print $2}')
                gobuster s3 -b "$bucket" -w "$wordlist"
                ;;
            custom)
                gobuster $args
                ;;
            "help")
                echo -e "\033[1;33m" "\n        GLOBAL HELP (GH): \033[0m"
                echo -e "\033[1;32m"
                echo "     >>>   1. ls        - List avaliable security tools in this framework"
                echo "     >>>   2. cd        - To enter New Choosen Section (cd ffuf)"
                echo "     >>>   3. cd ..     - To get back from one section to HOME menu (If 'cd ..' is not working then use 'exit' command)"
                echo "     >>>   4. clear     - Clear the terminal"
                echo "     >>>   5. exit      - Exit the command interface"
                echo "     >>>   6. banner    - To show the banner"
                echo "     >>>   7. dstyle    - Just enjoy Indian hackers (Fun purpose)"
                echo "     >>>   8. bjob      - Just enjoy Indian Hackers (Fun purpose)"
                echo "     >>>   9. mip       - Show your public IP address (JUST USE 'mip' DON'T USE 'cd mip')"
                echo -e "\033[1;31m"  # Red color
                echo ">> By pressing CTRL+C the whole script stops (BE CAREFULL)"
                echo ">> If you see any warning while useing 'cd ..' then check your section name or execute 'exit' command to exit from the section."
                echo -e "\033[0m"  # Reset color
                ;;
            clear) 
                clear 
                ;;
            "banner")
                display_banner
                ;;
            "dstyle")
                display_fuck_banner1
                ;;
            "bjob")
                display_blowjob_banner
                ;;
            *) echo -e "\033[1;31m-->> Invalid command. Use 'help' or 'ls'.\033[0m" ;;
        esac

        history -a "$HISTORY_FILE"
    done
}

manage_ffuf_commands() {
    local current_section="FFUF"
    [[ -f "$HISTORY_FILE" ]] && history -r "$HISTORY_FILE"

    while true; do
        read -e -p "$(echo -e "\033[1;31m($(date +"%I:%M:%S %p"))\033[1;34m-(MAHAKAL)\033[0m-(${current_section})> ")" input
        [[ "$input" == "exit" ]] && break
        [[ -z "$input" ]] && continue
        history -s "$input"

        local cmd=$(echo "$input" | awk '{print $1}')
        local args=$(echo "$input" | cut -d' ' -f2-)

        case $input in
            "mip")
                echo -e "\033[1;32m"  # Green color
                echo "Your IP address is: $(curl -s ifconfig.me)"
                echo -e "\033[0m"  # Reset color
                log_message "INFO" "User checked IP address"
                ;;
            "cd ..")
                return
                ;;
            "cd nmap")
                current_section="NMAP"
                manage_nmap_commands
                current_section="FFUF"
                ;;
            "cd curl")
                current_section="CURL"
                manage_curl_commands
                current_section="FFUF"
                ;;
            "cd whatweb")
                current_section="WHATWEB"
                manage_whatweb_commands
                current_section="FFUF"
                ;;
            "cd wpscan")
                current_section="WPSCAN"
                manage_wpscan_commands
                current_section="FFUF"
                ;;
            "cd waf")
                current_section="WAFW00F"
                traffic_anony
                current_section="FFUF"
                ;;
            "cd subfinder")
                current_section="SUBFINDER"
                manage_subfinder_commands
                current_section="FFUF"
                ;;
            "cd dnsrecon")
                current_section="DNSRECON"
                manage_dnsrecon_commands
                current_section="FFUF"
                ;;
            "cd dnsenum")
                current_section="DNSENUM"
                manage_dnsenum_commands
                current_section="FFUF"
                ;;
            "cd httprobe")
                current_section="HTTPROBE"
                manage_httprobe_commands
                current_section="FFUF"
                ;;
            "cd whois")
                current_section="WHOIS"
                manage_whois_commands
                current_section="FFUF"
                ;;
            "cd amass")
                current_section="AMASS"
                manage_amass_commands
                current_section="FFUF"
                ;;
            "cd hydra")
                current_section="HYDRA"
                manage_hydra_commands
                current_section="FFUF"
                ;;
            "cd medusa")
                current_section="MEDUSA"
                manage_medusa_commands
                current_section="FFUF"
                ;;
            "cd john")
                current_section="JOHN"
                manage_john_commands
                current_section="FFUF"
                ;;
            "cd hashcat")
                current_section="HASHCAT"
                manage_hashcat_commands
                current_section="FFUF"
                ;;
            "cd gobuster")
                current_section="GOBUSTER"
                manage_gobuster_commands
                current_section="FFUF"
                ;;
            "cd nikto")
                current_section="NIKTO"
                manage_nikto_commands
                current_section="FFUF"
                ;;
            "cd masscan")
                current_section="MASSCAN"
                manage_masscan_commands
                current_section="FFUF"
                ;;
            "cd unic")
                current_section="UNICORNSCAN"
                manage_unicornscan_commands
                current_section="FFUF"
                ;;
            "cd enumli")
                current_section="ENUM4LINUX"
                manage_enum4linux_commands
                current_section="FFUF"
                ;;
            "cd sqlmap")
                current_section="SQLMAP"
                manage_sqlmap_commands
                current_section="FFUF"
                ;;
            "cd ai")
                current_section="AI"
                chat_ai
                current_section="FFUF"
                ;;
            "cd css")
                current_section="CSS"
                check_sys_status
                current_section="FFUF"
                ;;
            "cd anony")
                current_section="ANONY"
                traffic_anony
                current_section="FFUF"
                ;;
            "cd ufw")
                current_section="UFW"
                manage_firewall
                current_section="FFUF"
                ;;
        esac

        case $cmd in
            ls)
                echo -e "\033[1;33m\n       FFUF COMMANDS:\033[0m"
                echo -e "\033[1;32m"
                echo "     >>>  dir [url] [wordlist]        - Directory fuzz"
                echo "     >>>  sub [domain] [wordlist]     - Subdomain fuzz"
                echo "     >>>  custom [args]               - Custom ffuf command"
                echo -e "\033[0m"
                ;;
            dir)
                url=$(echo "$args" | awk '{print $1}')
                wordlist=$(echo "$args" | awk '{print $2}')
                ffuf -u "$url/FUZZ" -w "$wordlist"
                ;;
            sub)
                domain=$(echo "$args" | awk '{print $1}')
                wordlist=$(echo "$args" | awk '{print $2}')
                ffuf -u "https://FUZZ.$domain" -w "$wordlist" -H "Host: FUZZ.$domain"
                ;;
            custom)
                ffuf $args
                ;;
            "help")
                echo -e "\033[1;33m" "\n        GLOBAL HELP (GH): \033[0m"
                echo -e "\033[1;32m"
                echo "     >>>   1. ls        - List avaliable security tools in this framework"
                echo "     >>>   2. cd        - To enter New Choosen Section (cd ffuf)"
                echo "     >>>   3. cd ..     - To get back from one section to HOME menu (If 'cd ..' is not working then use 'exit' command)"
                echo "     >>>   4. clear     - Clear the terminal"
                echo "     >>>   5. exit      - Exit the command interface"
                echo "     >>>   6. banner    - To show the banner"
                echo "     >>>   7. dstyle    - Just enjoy Indian hackers (Fun purpose)"
                echo "     >>>   8. bjob      - Just enjoy Indian Hackers (Fun purpose)"
                echo "     >>>   9. mip       - Show your public IP address (JUST USE 'mip' DON'T USE 'cd mip')"
                echo -e "\033[1;31m"  # Red color
                echo ">> By pressing CTRL+C the whole script stops (BE CAREFULL)"
                echo ">> If you see any warning while useing 'cd ..' then check your section name or execute 'exit' command to exit from the section."
                echo -e "\033[0m"  # Reset color
                ;;
            clear) 
                clear 
                ;;
            "banner")
                display_banner
                ;;
            "dstyle")
                display_fuck_banner1
                ;;
            "bjob")
                display_blowjob_banner
                ;;
            *) echo -e "\033[1;31m-->> Invalid command. Use 'help' or 'ls'.\033[0m" ;;
        esac

        history -a "$HISTORY_FILE"
    done
}

manage_nikto_commands() {
    local current_section="NIKTO"
    [[ -f "$HISTORY_FILE" ]] && history -r "$HISTORY_FILE"

    while true; do
        read -e -p "$(echo -e "\033[1;31m($(date +"%I:%M:%S %p"))\033[1;34m-(MAHAKAL)\033[0m-(${current_section})> ")" input
        [[ "$input" == "exit" ]] && break
        [[ -z "$input" ]] && continue
        history -s "$input"

        local cmd=$(echo "$input" | awk '{print $1}')
        local args=$(echo "$input" | cut -d' ' -f2-)

        case $input in
            "mip")
                echo -e "\033[1;32m"  # Green color
                echo "Your IP address is: $(curl -s ifconfig.me)"
                echo -e "\033[0m"  # Reset color
                log_message "INFO" "User checked IP address"
                ;;
            "cd ..")
                return
                ;;
            "cd nmap")
                current_section="NMAP"
                manage_nmap_commands
                current_section="NIKTO"
                ;;
            "cd curl")
                current_section="CURL"
                manage_curl_commands
                current_section="NIKTO"
                ;;
            "cd whatweb")
                current_section="WHATWEB"
                manage_whatweb_commands
                current_section="NIKTO"
                ;;
            "cd wpscan")
                current_section="WPSCAN"
                manage_wpscan_commands
                current_section="NIKTO"
                ;;
            "cd waf")
                current_section="WAFW00F"
                traffic_anony
                current_section="NIKTO"
                ;;
            "cd subfinder")
                current_section="SUBFINDER"
                manage_subfinder_commands
                current_section="NIKTO"
                ;;
            "cd dnsrecon")
                current_section="DNSRECON"
                manage_dnsrecon_commands
                current_section="NIKTO"
                ;;
            "cd dnsenum")
                current_section="DNSENUM"
                manage_dnsenum_commands
                current_section="NIKTO"
                ;;
            "cd httprobe")
                current_section="HTTPROBE"
                manage_httprobe_commands
                current_section="NIKTO"
                ;;
            "cd whois")
                current_section="WHOIS"
                manage_whois_commands
                current_section="NIKTO"
                ;;
            "cd amass")
                current_section="AMASS"
                manage_amass_commands
                current_section="NIKTO"
                ;;
            "cd hydra")
                current_section="HYDRA"
                manage_hydra_commands
                current_section="NIKTO"
                ;;
            "cd medusa")
                current_section="MEDUSA"
                manage_medusa_commands
                current_section="NIKTO"
                ;;
            "cd john")
                current_section="JOHN"
                manage_john_commands
                current_section="NIKTO"
                ;;
            "cd hashcat")
                current_section="HASHCAT"
                manage_hashcat_commands
                current_section="NIKTO"
                ;;
            "cd gobuster")
                current_section="GOBUSTER"
                manage_gobuster_commands
                current_section="NIKTO"
                ;;
            "cd ffuf")
                current_section="FFUF"
                manage_ffuf_commands
                current_section="NIKTO"
                ;;
            "cd masscan")
                current_section="MASSCAN"
                manage_masscan_commands
                current_section="NIKTO"
                ;;
            "cd unic")
                current_section="UNICORNSCAN"
                manage_unicornscan_commands
                current_section="NIKTO"
                ;;
            "cd enumli")
                current_section="ENUM4LINUX"
                manage_enum4linux_commands
                current_section="NIKTO"
                ;;
            "cd sqlmap")
                current_section="SQLMAP"
                manage_sqlmap_commands
                current_section="NIKTO"
                ;;
            "cd ai")
                current_section="AI"
                chat_ai
                current_section="NIKTO"
                ;;
            "cd css")
                current_section="CSS"
                check_sys_status
                current_section="NIKTO"
                ;;
            "cd anony")
                current_section="ANONY"
                traffic_anony
                current_section="NIKTO"
                ;;
            "cd ufw")
                current_section="UFW"
                manage_firewall
                current_section="NIKTO"
                ;;
        esac

        case $cmd in
            ls)
                echo -e "\033[1;33m\n       NIKTO COMMANDS:\033[0m"
                echo -e "\033[1;32m"
                echo "     >>>  scan [url]                         - Basic scan"
                echo "     >>>  ssl [url]                          - Force SSL scan"
                echo "     >>>  port [url] [port]                  - Scan specific port"
                echo "     >>>  output [url] [file] [format]       - Output to file (formats: txt/html/xml/csv)"
                echo "     >>>  hostfile [file]                    - Scan multiple hosts from file"
                echo "     >>>  timeout [url] [seconds]            - Set scan timeout"
                echo "     >>>  throttle [url] [delay-ms]          - Delay between requests"
                echo "     >>>  banner [url]                       - Enable banner grabbing"
                echo "     >>>  guessos [url]                      - Attempt OS guess"
                echo "     >>>  useragent [url] [agent-string]     - Set custom User-Agent"
                echo "     >>>  custom [args]                      - Custom Nikto command"
                echo -e "\033[0m"
                ;;
            scan)
                [[ -z "$args" ]] && echo -e "\033[1;31mUsage: scan [url]\033[0m" && continue
                log_message "INFO" "Nikto scanning $args"
                nikto -h "$args"
                ;;
            ssl)
                [[ -z "$args" ]] && echo -e "\033[1;31mUsage: ssl [url]\033[0m" && continue
                log_message "INFO" "Nikto SSL scan $args"
                nikto -h "$args" -ssl
                ;;
            port)
                url=$(echo "$args" | awk '{print $1}')
                port=$(echo "$args" | awk '{print $2}')
                [[ -z "$url" || -z "$port" ]] && echo -e "\033[1;31mUsage: port [url] [port]\033[0m" && continue
                nikto -h "$url" -p "$port"
                ;;
            output)
                url=$(echo "$args" | awk '{print $1}')
                file=$(echo "$args" | awk '{print $2}')
                format=$(echo "$args" | awk '{print $3}')
                [[ -z "$url" || -z "$file" || -z "$format" ]] && echo -e "\033[1;31mUsage: output [url] [file] [txt/html/xml/csv]\033[0m" && continue
                nikto -h "$url" -o "$file" -Format "$format"
                ;;
            hostfile)
                [[ ! -f "$args" ]] && echo -e "\033[1;31mFile not found: $args\033[0m" && continue
                log_message "INFO" "Scanning hosts from file: $args"
                while IFS= read -r line; do
                    echo -e "\033[1;34m--> Scanning $line...\033[0m"
                    nikto -h "$line"
                done < "$args"
                ;;
            timeout)
                url=$(echo "$args" | awk '{print $1}')
                sec=$(echo "$args" | awk '{print $2}')
                [[ -z "$url" || -z "$sec" ]] && echo -e "\033[1;31mUsage: timeout [url] [seconds]\033[0m" && continue
                nikto -h "$url" -timeout "$sec"
                ;;
            throttle)
                url=$(echo "$args" | awk '{print $1}')
                delay=$(echo "$args" | awk '{print $2}')
                [[ -z "$url" || -z "$delay" ]] && echo -e "\033[1;31mUsage: throttle [url] [delay-ms]\033[0m" && continue
                nikto -h "$url" -delay "$delay"
                ;;
            banner)
                [[ -z "$args" ]] && echo -e "\033[1;31mUsage: banner [url]\033[0m" && continue
                nikto -h "$args" -Display V
                ;;
            guessos)
                [[ -z "$args" ]] && echo -e "\033[1;31mUsage: guessos [url]\033[0m" && continue
                nikto -h "$args" -guess
                ;;
            useragent)
                url=$(echo "$args" | awk '{print $1}')
                agent=$(echo "$args" | cut -d' ' -f2-)
                [[ -z "$url" || -z "$agent" ]] && echo -e "\033[1;31mUsage: useragent [url] [agent-string]\033[0m" && continue
                nikto -h "$url" -useragent "$agent"
                ;;
            custom)
                log_message "INFO" "Running custom command: nikto $args"
                nikto $args
                ;;
            clear) 
                clear 
                ;;
            "banner")
                display_banner
                ;;
            "dstyle")
                display_fuck_banner1
                ;;
            "bjob")
                display_blowjob_banner
                ;;
            "help")
                echo -e "\033[1;33m" "\n        GLOBAL HELP (GH): \033[0m"
                echo -e "\033[1;32m"
                echo "     >>>   1. ls        - List avaliable security tools in this framework"
                echo "     >>>   2. cd        - To enter New Choosen Section (cd ffuf)"
                echo "     >>>   3. cd ..     - To get back from one section to HOME menu (If 'cd ..' is not working then use 'exit' command)"
                echo "     >>>   4. clear     - Clear the terminal"
                echo "     >>>   5. exit      - Exit the command interface"
                echo "     >>>   6. banner    - To show the banner"
                echo "     >>>   7. dstyle    - Just enjoy Indian hackers (Fun purpose)"
                echo "     >>>   8. bjob      - Just enjoy Indian Hackers (Fun purpose)"
                echo "     >>>   9. mip       - Show your public IP address (JUST USE 'mip' DON'T USE 'cd mip')"
                echo -e "\033[1;31m"  # Red color
                echo ">> By pressing CTRL+C the whole script stops (BE CAREFULL)"
                echo ">> If you see any warning while useing 'cd ..' then check your section name or execute 'exit' command to exit from the section."
                echo -e "\033[0m"  # Reset color
                ;;
            *)
                echo -e "\033[1;31m-->> Invalid Command. Use 'help' or 'ls'.\033[0m"
                ;;
        esac

        history -a "$HISTORY_FILE"
    done
}

manage_masscan_commands() {
    local current_section="MASSCAN"
    [[ -f "$HISTORY_FILE" ]] && history -r "$HISTORY_FILE"

    while true; do
        read -e -p "$(echo -e "\033[1;31m($(date +"%I:%M:%S %p"))\033[1;34m-(MAHAKAL)\033[0m-(${current_section})> ")" input
        [[ "$input" == "exit" ]] && break
        [[ -z "$input" ]] && continue
        history -s "$input"
        local cmd=$(echo "$input" | awk '{print $1}')
        local args=$(echo "$input" | cut -d' ' -f2-)

        case $input in
            "mip")
                echo -e "\033[1;32m"  # Green color
                echo "Your IP address is: $(curl -s ifconfig.me)"
                echo -e "\033[0m"  # Reset color
                log_message "INFO" "User checked IP address"
                ;;
            "cd ..")
                return
                ;;
            "cd nmap")
                current_section="NMAP"
                manage_nmap_commands
                current_section="MASSCAN"
                ;;
            "cd curl")
                current_section="CURL"
                manage_curl_commands
                current_section="MASSCAN"
                ;;
            "cd whatweb")
                current_section="WHATWEB"
                manage_whatweb_commands
                current_section="MASSCAN"
                ;;
            "cd wpscan")
                current_section="WPSCAN"
                manage_wpscan_commands
                current_section="MASSCAN"
                ;;
            "cd waf")
                current_section="WAFW00F"
                traffic_anony
                current_section="MASSCAN"
                ;;
            "cd subfinder")
                current_section="SUBFINDER"
                manage_subfinder_commands
                current_section="MASSCAN"
                ;;
            "cd dnsrecon")
                current_section="DNSRECON"
                manage_dnsrecon_commands
                current_section="MASSCAN"
                ;;
            "cd dnsenum")
                current_section="DNSENUM"
                manage_dnsenum_commands
                current_section="MASSCAN"
                ;;
            "cd httprobe")
                current_section="HTTPROBE"
                manage_httprobe_commands
                current_section="MASSCAN"
                ;;
            "cd whois")
                current_section="WHOIS"
                manage_whois_commands
                current_section="MASSCAN"
                ;;
            "cd amass")
                current_section="AMASS"
                manage_amass_commands
                current_section="MASSCAN"
                ;;
            "cd hydra")
                current_section="HYDRA"
                manage_hydra_commands
                current_section="MASSCAN"
                ;;
            "cd medusa")
                current_section="MEDUSA"
                manage_medusa_commands
                current_section="MASSCAN"
                ;;
            "cd john")
                current_section="JOHN"
                manage_john_commands
                current_section="MASSCAN"
                ;;
            "cd hashcat")
                current_section="HASHCAT"
                manage_hashcat_commands
                current_section="MASSCAN"
                ;;
            "cd gobuster")
                current_section="GOBUSTER"
                manage_gobuster_commands
                current_section="MASSCAN"
                ;;
            "cd ffuf")
                current_section="FFUF"
                manage_ffuf_commands
                current_section="MASSCAN"
                ;;
            "cd nikto")
                current_section="NIKTO"
                manage_nikto_commands
                current_section="MASSCAN"
                ;;
            "cd unic")
                current_section="UNICORNSCAN"
                manage_unicornscan_commands
                current_section="MASSCAN"
                ;;
            "cd enumli")
                current_section="ENUM4LINUX"
                manage_enum4linux_commands
                current_section="MASSCAN"
                ;;
            "cd sqlmap")
                current_section="SQLMAP"
                manage_sqlmap_commands
                current_section="MASSCAN"
                ;;
            "cd ai")
                current_section="AI"
                chat_ai
                current_section="MASSCAN"
                ;;
            "cd css")
                current_section="CSS"
                check_sys_status
                current_section="MASSCAN"
                ;;
            "cd anony")
                current_section="ANONY"
                traffic_anony
                current_section="MASSCAN"
                ;;
            "cd ufw")
                current_section="UFW"
                manage_firewall
                current_section="MASSCAN"
                ;;
        esac

        case $cmd in
            ls)
                echo -e "\033[1;33m\n       MASSCAN COMMANDS:\033[0m"
                echo -e "\033[1;32m"
                echo "     >>>  scan [ip] [ports]              - Fast port scan"
                echo "     >>>  iface [ip] [port] [iface]      - Scan with interface"
                echo "     >>>  rate [ip] [ports] [rate]       - Custom rate scan"
                echo "     >>>  output [ip] [ports] [file]     - Save output"
                echo "     >>>  custom [args]                  - Custom masscan args"
                echo -e "\033[0m"
                ;;
            scan)
                ip=$(echo "$args" | awk '{print $1}')
                ports=$(echo "$args" | awk '{print $2}')
                masscan -p"$ports" "$ip"
                ;;
            iface)
                ip=$(echo "$args" | awk '{print $1}')
                port=$(echo "$args" | awk '{print $2}')
                iface=$(echo "$args" | awk '{print $3}')
                masscan -p"$port" "$ip" --interface "$iface"
                ;;
            rate)
                ip=$(echo "$args" | awk '{print $1}')
                port=$(echo "$args" | awk '{print $2}')
                rate=$(echo "$args" | awk '{print $3}')
                masscan -p"$port" "$ip" --rate="$rate"
                ;;
            output)
                ip=$(echo "$args" | awk '{print $1}')
                port=$(echo "$args" | awk '{print $2}')
                out=$(echo "$args" | awk '{print $3}')
                masscan -p"$port" "$ip" -oG "$out"
                ;;
            custom)
                masscan $args
                ;;
            clear) 
                clear 
                ;;
            "banner")
                display_banner
                ;;
            "dstyle")
                display_fuck_banner1
                ;;
            "bjob")
                display_blowjob_banner
                ;;
            "help")
                echo -e "\033[1;33m" "\n        GLOBAL HELP (GH): \033[0m"
                echo -e "\033[1;32m"
                echo "     >>>   1. ls        - List avaliable security tools in this framework"
                echo "     >>>   2. cd        - To enter New Choosen Section (cd ffuf)"
                echo "     >>>   3. cd ..     - To get back from one section to HOME menu (If 'cd ..' is not working then use 'exit' command)"
                echo "     >>>   4. clear     - Clear the terminal"
                echo "     >>>   5. exit      - Exit the command interface"
                echo "     >>>   6. banner    - To show the banner"
                echo "     >>>   7. dstyle    - Just enjoy Indian hackers (Fun purpose)"
                echo "     >>>   8. bjob      - Just enjoy Indian Hackers (Fun purpose)"
                echo "     >>>   9. mip       - Show your public IP address (JUST USE 'mip' DON'T USE 'cd mip')"
                echo -e "\033[1;31m"  # Red color
                echo ">> By pressing CTRL+C the whole script stops (BE CAREFULL)"
                echo ">> If you see any warning while useing 'cd ..' then check your section name or execute 'exit' command to exit from the section."
                echo -e "\033[0m"  # Reset color
                ;;
            *) echo -e "\033[1;31m-->> Invalid Command. Use 'ls' or 'help'.\033[0m" ;;
        esac

        history -a "$HISTORY_FILE"
    done
}

manage_unicornscan_commands() {
    local current_section="UNICORNSCAN"
    [[ -f "$HISTORY_FILE" ]] && history -r "$HISTORY_FILE"

    while true; do
        read -e -p "$(echo -e "\033[1;31m($(date +"%I:%M:%S %p"))\033[1;34m-(MAHAKAL)\033[0m-(${current_section})> ")" input
        [[ "$input" == "exit" ]] && break
        [[ -z "$input" ]] && continue
        history -s "$input"
        local cmd=$(echo "$input" | awk '{print $1}')
        local args=$(echo "$input" | cut -d' ' -f2-)

        case $input in
            "mip")
                echo -e "\033[1;32m"  # Green color
                echo "Your IP address is: $(curl -s ifconfig.me)"
                echo -e "\033[0m"  # Reset color
                log_message "INFO" "User checked IP address"
                ;;
            "cd ..")
                return
                ;;
            "cd nmap")
                current_section="NMAP"
                manage_nmap_commands
                current_section="UNICORNSCAN"
                ;;
            "cd curl")
                current_section="CURL"
                manage_curl_commands
                current_section="UNICORNSCAN"
                ;;
            "cd whatweb")
                current_section="WHATWEB"
                manage_whatweb_commands
                current_section="UNICORNSCAN"
                ;;
            "cd wpscan")
                current_section="WPSCAN"
                manage_wpscan_commands
                current_section="UNICORNSCAN"
                ;;
            "cd waf")
                current_section="WAFW00F"
                traffic_anony
                current_section="UNICORNSCAN"
                ;;
            "cd subfinder")
                current_section="SUBFINDER"
                manage_subfinder_commands
                current_section="UNICORNSCAN"
                ;;
            "cd dnsrecon")
                current_section="DNSRECON"
                manage_dnsrecon_commands
                current_section="UNICORNSCAN"
                ;;
            "cd dnsenum")
                current_section="DNSENUM"
                manage_dnsenum_commands
                current_section="UNICORNSCAN"
                ;;
            "cd httprobe")
                current_section="HTTPROBE"
                manage_httprobe_commands
                current_section="UNICORNSCAN"
                ;;
            "cd whois")
                current_section="WHOIS"
                manage_whois_commands
                current_section="UNICORNSCAN"
                ;;
            "cd amass")
                current_section="AMASS"
                manage_amass_commands
                current_section="UNICORNSCAN"
                ;;
            "cd hydra")
                current_section="HYDRA"
                manage_hydra_commands
                current_section="UNICORNSCAN"
                ;;
            "cd medusa")
                current_section="MEDUSA"
                manage_medusa_commands
                current_section="UNICORNSCAN"
                ;;
            "cd john")
                current_section="JOHN"
                manage_john_commands
                current_section="UNICORNSCAN"
                ;;
            "cd hashcat")
                current_section="HASHCAT"
                manage_hashcat_commands
                current_section="UNICORNSCAN"
                ;;
            "cd gobuster")
                current_section="GOBUSTER"
                manage_gobuster_commands
                current_section="UNICORNSCAN"
                ;;
            "cd ffuf")
                current_section="FFUF"
                manage_ffuf_commands
                current_section="UNICORNSCAN"
                ;;
            "cd nikto")
                current_section="NIKTO"
                manage_nikto_commands
                current_section="UNICORNSCAN"
                ;;
            "cd masscan")
                current_section="MASSCAN"
                manage_masscan_commands
                current_section="UNICORNSCAN"
                ;;
            "cd enumli")
                current_section="ENUM4LINUX"
                manage_enum4linux_commands
                current_section="UNICORNSCAN"
                ;;
            "cd sqlmap")
                current_section="SQLMAP"
                manage_sqlmap_commands
                current_section="UNICORNSCAN"
                ;;
            "cd ai")
                current_section="AI"
                chat_ai
                current_section="UNICORNSCAN"
                ;;
            "cd css")
                current_section="CSS"
                check_sys_status
                current_section="UNICORNSCAN"
                ;;
            "cd anony")
                current_section="ANONY"
                traffic_anony
                current_section="UNICORNSCAN"
                ;;
            "cd ufw")
                current_section="UFW"
                manage_firewall
                current_section="UNICORNSCAN"
                ;;
        esac

        case $cmd in
            ls)
                echo -e "\033[1;33m\n       UNICORNSCAN COMMANDS:\033[0m"
                echo -e "\033[1;32m"
                echo "     >>>  tcp [target]                  - TCP SYN scan"
                echo "     >>>  udp [target]                  - UDP scan"
                echo "     >>>  full [target]                 - Full scan"
                echo "     >>>  custom [args]                 - Custom scan"
                echo -e "\033[0m"
                ;;
            tcp) unicornscan -Iv "$args":a ;;
            udp) unicornscan -mU "$args":a ;;
            full) unicornscan -Iv -mT -r 10000 "$args":a ;;
            custom) unicornscan $args ;;
            clear) 
                clear 
                ;;
            "banner")
                display_banner
                ;;
            "dstyle")
                display_fuck_banner1
                ;;
            "bjob")
                display_blowjob_banner
                ;;
            "help")
                echo -e "\033[1;33m" "\n        GLOBAL HELP (GH): \033[0m"
                echo -e "\033[1;32m"
                echo "     >>>   1. ls        - List avaliable security tools in this framework"
                echo "     >>>   2. cd        - To enter New Choosen Section (cd ffuf)"
                echo "     >>>   3. cd ..     - To get back from one section to HOME menu (If 'cd ..' is not working then use 'exit' command)"
                echo "     >>>   4. clear     - Clear the terminal"
                echo "     >>>   5. exit      - Exit the command interface"
                echo "     >>>   6. banner    - To show the banner"
                echo "     >>>   7. dstyle    - Just enjoy Indian hackers (Fun purpose)"
                echo "     >>>   8. bjob      - Just enjoy Indian Hackers (Fun purpose)"
                echo "     >>>   9. mip       - Show your public IP address (JUST USE 'mip' DON'T USE 'cd mip')"
                echo -e "\033[1;31m"  # Red color
                echo ">> By pressing CTRL+C the whole script stops (BE CAREFULL)"
                echo ">> If you see any warning while useing 'cd ..' then check your section name or execute 'exit' command to exit from the section."
                echo -e "\033[0m"  # Reset color
                ;;
            *) echo -e "\033[1;31m-->> Invalid Command. Use 'ls' or 'help'.\033[0m" ;;
        esac

        history -a "$HISTORY_FILE"
    done
}

manage_enum4linux_commands() {
    local current_section="ENUM4LINUX-NG"
    [[ -f "$HISTORY_FILE" ]] && history -r "$HISTORY_FILE"

    while true; do
        read -e -p "$(echo -e "\033[1;31m($(date +"%I:%M:%S %p"))\033[1;34m-(MAHAKAL)\033[0m-(${current_section})> ")" input
        [[ "$input" == "exit" ]] && break
        [[ -z "$input" ]] && continue
        history -s "$input"
        local cmd=$(echo "$input" | awk '{print $1}')
        local args=$(echo "$input" | cut -d' ' -f2-)

        case $input in
            "mip")
                echo -e "\033[1;32m"  # Green color
                echo "Your IP address is: $(curl -s ifconfig.me)"
                echo -e "\033[0m"  # Reset color
                log_message "INFO" "User checked IP address"
                ;;
            "cd ..")
                return
                ;;
            "cd nmap")
                current_section="NMAP"
                manage_nmap_commands
                current_section="ENUM4LINUX-NG"
                ;;
            "cd curl")
                current_section="CURL"
                manage_curl_commands
                current_section="ENUM4LINUX-NG"
                ;;
            "cd whatweb")
                current_section="WHATWEB"
                manage_whatweb_commands
                current_section="ENUM4LINUX-NG"
                ;;
            "cd wpscan")
                current_section="WPSCAN"
                manage_wpscan_commands
                current_section="ENUM4LINUX-NG"
                ;;
            "cd waf")
                current_section="WAFW00F"
                traffic_anony
                current_section="ENUM4LINUX-NG"
                ;;
            "cd subfinder")
                current_section="SUBFINDER"
                manage_subfinder_commands
                current_section="ENUM4LINUX-NG"
                ;;
            "cd dnsrecon")
                current_section="DNSRECON"
                manage_dnsrecon_commands
                current_section="ENUM4LINUX-NG"
                ;;
            "cd dnsenum")
                current_section="DNSENUM"
                manage_dnsenum_commands
                current_section="ENUM4LINUX-NG"
                ;;
            "cd httprobe")
                current_section="HTTPROBE"
                manage_httprobe_commands
                current_section="ENUM4LINUX-NG"
                ;;
            "cd whois")
                current_section="WHOIS"
                manage_whois_commands
                current_section="ENUM4LINUX-NG"
                ;;
            "cd amass")
                current_section="AMASS"
                manage_amass_commands
                current_section="ENUM4LINUX-NG"
                ;;
            "cd hydra")
                current_section="HYDRA"
                manage_hydra_commands
                current_section="ENUM4LINUX-NG"
                ;;
            "cd medusa")
                current_section="MEDUSA"
                manage_medusa_commands
                current_section="ENUM4LINUX-NG"
                ;;
            "cd john")
                current_section="JOHN"
                manage_john_commands
                current_section="ENUM4LINUX-NG"
                ;;
            "cd hashcat")
                current_section="HASHCAT"
                manage_hashcat_commands
                current_section="ENUM4LINUX-NG"
                ;;
            "cd gobuster")
                current_section="GOBUSTER"
                manage_gobuster_commands
                current_section="ENUM4LINUX-NG"
                ;;
            "cd ffuf")
                current_section="FFUF"
                manage_ffuf_commands
                current_section="ENUM4LINUX-NG"
                ;;
            "cd nikto")
                current_section="NIKTO"
                manage_nikto_commands
                current_section="ENUM4LINUX-NG"
                ;;
            "cd masscan")
                current_section="MASSCAN"
                manage_masscan_commands
                current_section="ENUM4LINUX-NG"
                ;;
            "cd unic")
                current_section="UNICORNSCAN"
                manage_unicornscan_commands
                current_section="ENUM4LINUX-NG"
                ;;
            "cd sqlmap")
                current_section="SQLMAP"
                manage_sqlmap_commands
                current_section="ENUM4LINUX-NG"
                ;;
            "cd ai")
                current_section="AI"
                chat_ai
                current_section="ENUM4LINUX-NG"
                ;;
            "cd css")
                current_section="CSS"
                check_sys_status
                current_section="ENUM4LINUX-NG"
                ;;
            "cd anony")
                current_section="ANONY"
                traffic_anony
                current_section="ENUM4LINUX-NG"
                ;;
            "cd ufw")
                current_section="UFW"
                manage_firewall
                current_section="ENUM4LINUX-NG"
                ;;
        esac

        case $cmd in
            ls)
                echo -e "\033[1;33m\n       ENUM4LINUX-NG COMMANDS:\033[0m"
                echo -e "\033[1;32m"
                echo "     >>>  basic [ip]                    - Basic SMB enum"
                echo "     >>>  full [ip]                     - Full enumeration"
                echo "     >>>  user [ip] [user]              - Enum single user"
                echo "     >>>  creds [ip] [user] [pass]      - Authenticated enum"
                echo "     >>>  custom [args]                 - Custom command"
                echo -e "\033[0m"
                ;;
            basic)
                enum4linux-ng "$args"
                ;;
            full)
                enum4linux-ng -A "$args"
                ;;
            user)
                ip=$(echo "$args" | awk '{print $1}')
                user=$(echo "$args" | awk '{print $2}')
                enum4linux-ng -u "$user" "$ip"
                ;;
            creds)
                ip=$(echo "$args" | awk '{print $1}')
                user=$(echo "$args" | awk '{print $2}')
                pass=$(echo "$args" | awk '{print $3}')
                enum4linux-ng -u "$user" -p "$pass" "$ip"
                ;;
            custom)
                enum4linux-ng $args
                ;;
            clear) 
                clear 
                ;;
            "banner")
                display_banner
                ;;
            "dstyle")
                display_fuck_banner1
                ;;
            "bjob")
                display_blowjob_banner
                ;;
            "help")
                echo -e "\033[1;33m" "\n        GLOBAL HELP (GH): \033[0m"
                echo -e "\033[1;32m"
                echo "     >>>   1. ls        - List avaliable security tools in this framework"
                echo "     >>>   2. cd        - To enter New Choosen Section (cd ffuf)"
                echo "     >>>   3. cd ..     - To get back from one section to HOME menu (If 'cd ..' is not working then use 'exit' command)"
                echo "     >>>   4. clear     - Clear the terminal"
                echo "     >>>   5. exit      - Exit the command interface"
                echo "     >>>   6. banner    - To show the banner"
                echo "     >>>   7. dstyle    - Just enjoy Indian hackers (Fun purpose)"
                echo "     >>>   8. bjob      - Just enjoy Indian Hackers (Fun purpose)"
                echo "     >>>   9. mip       - Show your public IP address (JUST USE 'mip' DON'T USE 'cd mip')"
                echo -e "\033[1;31m"  # Red color
                echo ">> By pressing CTRL+C the whole script stops (BE CAREFULL)"
                echo ">> If you see any warning while useing 'cd ..' then check your section name or execute 'exit' command to exit from the section."
                echo -e "\033[0m"  # Reset color
                ;;
            *) echo -e "\033[1;31m-->> Invalid Command. Use 'ls' or 'help'.\033[0m" ;;
        esac

        history -a "$HISTORY_FILE"
    done
}

manage_sqlmap_commands() {
    local current_section="SQLMAP"
    [[ -f "$HISTORY_FILE" ]] && history -r "$HISTORY_FILE"

    while true; do
        read -e -p "$(echo -e "\033[1;31m($(date +"%I:%M:%S %p"))\033[1;34m-(MAHAKAL)\033[0m-(${current_section})> ")" input
        [[ "$input" == "exit" ]] && break
        [[ -z "$input" ]] && continue
        history -s "$input"

        local cmd=$(echo "$input" | awk '{print $1}')
        local args=$(echo "$input" | cut -d' ' -f2-)

        case $input in
            "mip")
                echo -e "\033[1;32m"  # Green color
                echo "Your IP address is: $(curl -s ifconfig.me)"
                echo -e "\033[0m"  # Reset color
                log_message "INFO" "User checked IP address"
                ;;
            "cd ..")
                return
                ;;
            "cd nmap")
                current_section="NMAP"
                manage_nmap_commands
                current_section="SQLMAP"
                ;;
            "cd curl")
                current_section="CURL"
                manage_curl_commands
                current_section="SQLMAP"
                ;;
            "cd whatweb")
                current_section="WHATWEB"
                manage_whatweb_commands
                current_section="SQLMAP"
                ;;
            "cd wpscan")
                current_section="WPSCAN"
                manage_wpscan_commands
                current_section="SQLMAP"
                ;;
            "cd waf")
                current_section="WAFW00F"
                traffic_anony
                current_section="SQLMAP"
                ;;
            "cd subfinder")
                current_section="SUBFINDER"
                manage_subfinder_commands
                current_section="SQLMAP"
                ;;
            "cd dnsrecon")
                current_section="DNSRECON"
                manage_dnsrecon_commands
                current_section="SQLMAP"
                ;;
            "cd dnsenum")
                current_section="DNSENUM"
                manage_dnsenum_commands
                current_section="SQLMAP"
                ;;
            "cd httprobe")
                current_section="HTTPROBE"
                manage_httprobe_commands
                current_section="SQLMAP"
                ;;
            "cd whois")
                current_section="WHOIS"
                manage_whois_commands
                current_section="SQLMAP"
                ;;
            "cd amass")
                current_section="AMASS"
                manage_amass_commands
                current_section="SQLMAP"
                ;;
            "cd hydra")
                current_section="HYDRA"
                manage_hydra_commands
                current_section="SQLMAP"
                ;;
            "cd medusa")
                current_section="MEDUSA"
                manage_medusa_commands
                current_section="SQLMAP"
                ;;
            "cd john")
                current_section="JOHN"
                manage_john_commands
                current_section="SQLMAP"
                ;;
            "cd hashcat")
                current_section="HASHCAT"
                manage_hashcat_commands
                current_section="SQLMAP"
                ;;
            "cd gobuster")
                current_section="GOBUSTER"
                manage_gobuster_commands
                current_section="SQLMAP"
                ;;
            "cd ffuf")
                current_section="FFUF"
                manage_ffuf_commands
                current_section="SQLMAP"
                ;;
            "cd nikto")
                current_section="NIKTO"
                manage_nikto_commands
                current_section="SQLMAP"
                ;;
            "cd masscan")
                current_section="MASSCAN"
                manage_masscan_commands
                current_section="SQLMAP"
                ;;
            "cd unic")
                current_section="UNICORNSCAN"
                manage_unicornscan_commands
                current_section="SQLMAP"
                ;;
            "cd enumli")
                current_section="ENUM4LINUX"
                manage_enum4linux_commands
                current_section="SQLMAP"
                ;;
            "cd ai")
                current_section="AI"
                chat_ai
                current_section="SQLMAP"
                ;;
            "cd css")
                current_section="CSS"
                check_sys_status
                current_section="SQLMAP"
                ;;
            "cd anony")
                current_section="ANONY"
                traffic_anony
                current_section="SQLMAP"
                ;;
            "cd ufw")
                current_section="UFW"
                manage_firewall
                current_section="SQLMAP"
                ;;
        esac

        case $cmd in
            ls)
                echo -e "\033[1;33m\n       SQLMAP COMMANDS:\033[0m"
                echo -e "\033[1;32m"
                echo "     >>>  basic [url]                             - Basic SQLi test"
                echo "     >>>  dbs [url]                               - List databases"
                echo "     >>>  tables [url] [db]                       - List tables"
                echo "     >>>  columns [url] [db] [table]              - List columns"
                echo "     >>>  dump [url] [db] [table]                 - Dump data"
                echo "     >>>  os-shell [url]                          - Get OS shell"
                echo "     >>>  os-cmd [url] [command]                  - Run OS command"
                echo "     >>>  file-read [url] [path]                  - Read remote file"
                echo "     >>>  file-write [url] [lfile] [rfile]        - Upload file"
                echo "     >>>  auth-cookie [url] [cookie]              - Auth via cookie"
                echo "     >>>  auth-user [url] [user] [pass]           - Basic auth"
                echo "     >>>  auth-header [url] [header]              - Auth via header"
                echo "     >>>  tor [url]                               - Use Tor"
                echo "     >>>  proxy [url] [proxy:port]                - Use HTTP proxy"
                echo "     >>>  level [url] [1-5]                       - Risk + level"
                echo "     >>>  threads [url] [num]                     - Multi-thread"
                echo "     >>>  delay [url] [secs]                      - Delay between req"
                echo "     >>>  timeout [url] [secs]                    - Request timeout"
                echo "     >>>  random-agent [url]                      - Use random UA"
                echo "     >>>  referer [url] [ref]                     - Custom referer"
                echo "     >>>  user-agent [url] [agent]                - Custom UA"
                echo "     >>>  tamper [url] [script]                   - Tamper script"
                echo "     >>>  dump-all [url]                          - Dump entire DB"
                echo "     >>>  search [url] [keyword]                  - Search DB"
                echo "     >>>  banner-dbms [url]                       - Detect DBMS"
                echo "     >>>  technique [url] [tech]                  - Choose injection"
                echo "     >>>  output [url] [dir]                      - Save to dir"
                echo "     >>>  flush [url]                             - Flush previous data"
                echo "     >>>  custom [args]                           - Custom sqlmap args"
                echo -e "\033[0m"
                ;;
            basic) sqlmap -u "$args" --batch ;;
            dbs) sqlmap -u "$args" --dbs --batch ;;
            tables)
                url=$(awk '{print $1}' <<< "$args")
                db=$(awk '{print $2}' <<< "$args")
                sqlmap -u "$url" -D "$db" --tables --batch ;;
            columns)
                url=$(awk '{print $1}' <<< "$args")
                db=$(awk '{print $2}' <<< "$args")
                tbl=$(awk '{print $3}' <<< "$args")
                sqlmap -u "$url" -D "$db" -T "$tbl" --columns --batch ;;
            dump)
                url=$(awk '{print $1}' <<< "$args")
                db=$(awk '{print $2}' <<< "$args")
                tbl=$(awk '{print $3}' <<< "$args")
                sqlmap -u "$url" -D "$db" -T "$tbl" --dump --batch ;;
            os-shell) sqlmap -u "$args" --os-shell --batch ;;
            os-cmd)
                url=$(awk '{print $1}' <<< "$args")
                cmd=$(cut -d' ' -f2- <<< "$args")
                sqlmap -u "$url" --os-cmd="$cmd" --batch ;;
            file-read)
                url=$(awk '{print $1}' <<< "$args")
                path=$(awk '{print $2}' <<< "$args")
                sqlmap -u "$url" --file-read="$path" --batch ;;
            file-write)
                url=$(awk '{print $1}' <<< "$args")
                lfile=$(awk '{print $2}' <<< "$args")
                rfile=$(awk '{print $3}' <<< "$args")
                sqlmap -u "$url" --file-write="$lfile" --file-dest="$rfile" --batch ;;
            auth-cookie)
                url=$(awk '{print $1}' <<< "$args")
                cookie=$(cut -d' ' -f2- <<< "$args")
                sqlmap -u "$url" --cookie="$cookie" --batch ;;
            auth-user)
                url=$(awk '{print $1}' <<< "$args")
                user=$(awk '{print $2}' <<< "$args")
                pass=$(awk '{print $3}' <<< "$args")
                sqlmap -u "$url" --auth-type=Basic --auth-cred="$user:$pass" --batch ;;
            auth-header)
                url=$(awk '{print $1}' <<< "$args")
                header=$(cut -d' ' -f2- <<< "$args")
                sqlmap -u "$url" --headers="$header" --batch ;;
            tor) sqlmap -u "$args" --tor --tor-type=SOCKS5 --check-tor --batch ;;
            proxy)
                url=$(awk '{print $1}' <<< "$args")
                proxy=$(awk '{print $2}' <<< "$args")
                sqlmap -u "$url" --proxy="http://$proxy" --batch ;;
            level)
                url=$(awk '{print $1}' <<< "$args")
                lvl=$(awk '{print $2}' <<< "$args")
                sqlmap -u "$url" --level="$lvl" --risk="$lvl" --batch ;;
            threads)
                url=$(awk '{print $1}' <<< "$args")
                th=$(awk '{print $2}' <<< "$args")
                sqlmap -u "$url" --threads="$th" --batch ;;
            delay)
                url=$(awk '{print $1}' <<< "$args")
                dly=$(awk '{print $2}' <<< "$args")
                sqlmap -u "$url" --delay="$dly" --batch ;;
            timeout)
                url=$(awk '{print $1}' <<< "$args")
                to=$(awk '{print $2}' <<< "$args")
                sqlmap -u "$url" --timeout="$to" --batch ;;
            random-agent) sqlmap -u "$args" --random-agent --batch ;;
            referer)
                url=$(awk '{print $1}' <<< "$args")
                ref=$(cut -d' ' -f2- <<< "$args")
                sqlmap -u "$url" --referer="$ref" --batch ;;
            user-agent)
                url=$(awk '{print $1}' <<< "$args")
                ua=$(cut -d' ' -f2- <<< "$args")
                sqlmap -u "$url" --user-agent="$ua" --batch ;;
            tamper)
                url=$(awk '{print $1}' <<< "$args")
                script=$(awk '{print $2}' <<< "$args")
                sqlmap -u "$url" --tamper="$script" --batch ;;
            dump-all) sqlmap -u "$args" --dump-all --batch ;;
            search)
                url=$(awk '{print $1}' <<< "$args")
                keyword=$(awk '{print $2}' <<< "$args")
                sqlmap -u "$url" --search -C "$keyword" --batch ;;
            banner-dbms) sqlmap -u "$args" --banner --batch ;;
            technique)
                url=$(awk '{print $1}' <<< "$args")
                tech=$(awk '{print $2}' <<< "$args")
                sqlmap -u "$url" --technique="$tech" --batch ;;
            output)
                url=$(awk '{print $1}' <<< "$args")
                dir=$(awk '{print $2}' <<< "$args")
                sqlmap -u "$url" --output-dir="$dir" --batch ;;
            flush) sqlmap -u "$args" --flush-session --batch ;;
            custom) sqlmap $args ;;
            "help")
                echo -e "\033[1;33m" "\n        GLOBAL HELP (GH): \033[0m"
                echo -e "\033[1;32m"
                echo "     >>>   1. ls        - List avaliable security tools in this framework"
                echo "     >>>   2. cd        - To enter New Choosen Section (cd ffuf)"
                echo "     >>>   3. cd ..     - To get back from one section to HOME menu (If 'cd ..' is not working then use 'exit' command)"
                echo "     >>>   4. clear     - Clear the terminal"
                echo "     >>>   5. exit      - Exit the command interface"
                echo "     >>>   6. banner    - To show the banner"
                echo "     >>>   7. dstyle    - Just enjoy Indian hackers (Fun purpose)"
                echo "     >>>   8. bjob      - Just enjoy Indian Hackers (Fun purpose)"
                echo "     >>>   9. mip       - Show your public IP address (JUST USE 'mip' DON'T USE 'cd mip')"
                echo -e "\033[1;31m"  # Red color
                echo ">> By pressing CTRL+C the whole script stops (BE CAREFULL)"
                echo ">> If you see any warning while useing 'cd ..' then check your section name or execute 'exit' command to exit from the section."
                echo -e "\033[0m"  # Reset color
                ;;
            clear) 
                clear 
                ;;
            banner) 
                display_banner 
                ;;
            dstyle) 
                display_fuck_banner1 
                ;;
            bjob) 
                display_blowjob_banner 
                ;;
            *) echo -e "\033[1;31m-->> Invalid command\033[0m" ;;
        esac
        history -a "$HISTORY_FILE"
    done
}

# Function to chat or work with ai
chat_ai() {
    local current_section="AI"

    # Load history from file if it exists
    if [[ -f "$HISTORY_FILE" ]]; then
        history -r "$HISTORY_FILE"
    fi

    while true; do
        read -e -p "$(echo -e "\033[1;31m($(date +"%I:%M:%S %p"))\033[1;34m-(MAHAKAL)\033[0m-(${current_section})> ")" option

        # Exit the loop if the user types 'exit'
        if [[ "$option" == "exit" ]]; then
            break
        fi

        # If the input is empty, continue to the next iteration
        if [[ -z "$option" ]]; then
            continue
        fi

        # Add the command to history
        history -s "$option"

        case $option in
            "cd ..")
                return
                ;;
            "mip")
                echo -e "\033[1;32m"  # Green color
                echo "Your IP address is: $(curl -s ifconfig.me)"
                echo -e "\033[0m"  # Reset color
                log_message "INFO" "User checked IP address"
                ;;
            "cd nmap")
                current_section="NMAP"
                manage_nmap_commands
                current_section="AI"
                ;;
            "cd curl")
                current_section="CURL"
                manage_curl_commands
                current_section="AI"
                ;;
            "cd whatweb")
                current_section="WHATWEB"
                manage_whatweb_commands
                current_section="AI"
                ;;
            "cd wpscan")
                current_section="WPSCAN"
                manage_wpscan_commands
                current_section="AI"
                ;;
            "cd waf")
                current_section="WAFW00F"
                traffic_anony
                current_section="AI"
                ;;
            "cd subfinder")
                current_section="SUBFINDER"
                manage_subfinder_commands
                current_section="AI"
                ;;
            "cd dnsrecon")
                current_section="DNSRECON"
                manage_dnsrecon_commands
                current_section="AI"
                ;;
            "cd dnsenum")
                current_section="DNSENUM"
                manage_dnsenum_commands
                current_section="AI"
                ;;
            "cd httprobe")
                current_section="HTTPROBE"
                manage_httprobe_commands
                current_section="AI"
                ;;
            "cd whois")
                current_section="WHOIS"
                manage_whois_commands
                current_section="AI"
                ;;
            "cd amass")
                current_section="AMASS"
                manage_amass_commands
                current_section="AI"
                ;;
            "cd hydra")
                current_section="HYDRA"
                manage_hydra_commands
                current_section="AI"
                ;;
            "cd medusa")
                current_section="MEDUSA"
                manage_medusa_commands
                current_section="AI"
                ;;
            "cd john")
                current_section="JOHN"
                manage_john_commands
                current_section="AI"
                ;;
            "cd hashcat")
                current_section="HASHCAT"
                manage_hashcat_commands
                current_section="AI"
                ;;
            "cd gobuster")
                current_section="GOBUSTER"
                manage_gobuster_commands
                current_section="AI"
                ;;
            "cd ffuf")
                current_section="FFUF"
                manage_ffuf_commands
                current_section="AI"
                ;;
            "cd nikto")
                current_section="NIKTO"
                manage_nikto_commands
                current_section="AI"
                ;;
            "cd masscan")
                current_section="MASSCAN"
                manage_masscan_commands
                current_section="AI"
                ;;
            "cd unic")
                current_section="UNICORNSCAN"
                manage_unicornscan_commands
                current_section="AI"
                ;;
            "cd enumli")
                current_section="ENUM4LINUX"
                manage_enum4linux_commands
                current_section="AI"
                ;;
            "cd sqlmap")
                current_section="SQLMAP"
                manage_sqlmap_commands
                current_section="AI"
                ;;
            "cd css")
                current_section="CSS"
                check_sys_status
                current_section="AI"
                ;;
            "cd anony")
                current_section="ANONY"
                traffic_anony
                current_section="AI"
                ;;
            "cd ufw")
                current_section="UFW"
                manage_firewall
                current_section="AI"
                ;;
        esac

        case $option in
            "intarch")
                echo -e "\033[1;32m"
                echo "    <<==={INSTALLING-TGPT}===>>"
                echo -e "\033[0m"  # Reset color
                sudo pacman -S tgpt --noconfirm
                log_message "INFO" "TGPT installing for arch."
                send_alert "TGPT INSTALLING FOR ARCH."
                ;;
            "intdeb")
                echo -e "\033[1;32m"
                echo "    <<==={INSTALLING-TGPT}===>>"
                echo -e "\033[0m"  # Reset color
                sudo curl -sSL https://raw.githubusercontent.com/aandrew-me/tgpt/main/install | bash -s /usr/local/bin
                log_message "INFO" "TGPT installing for debian based distro."
                send_alert "TGPT INSTALLING FOR DEBIAN."
                ;;
            "aiup")
                echo -e "\033[1;32m"
                echo "    <<==={UPDATING-TGPT}===>>"
                echo -e "\033[0m"  # Reset color
                sudo tgpt -u
                log_message "INFO" "TGPT updating."
                send_alert "TGPT UPDATING."
                ;;
            "aint")
                echo -e "\033[1;32m"
                echo "    <<==={INTERACTIVE-TGPT}===>>"
                echo -e "\033[0m"  # Reset color
                tgpt -i
                log_message "INFO" "TGPT in interactive mode."
                send_alert "TGPT INTERACTIVE MODE."
                ;;
            "aindev")
                echo -e "\033[1;32m"
                echo "    <<==={INTERACTIVE-DEVLOOPER-TGPT}===>>"
                echo -e "\033[0m"  # Reset color
                tgpt --provider phind -i
                log_message "INFO" "TGPT in interactive devloper mode."
                send_alert "TGPT INTERACTIVE DEVLOPER MODE."
                ;;
            "aichat")
                echo -e "\033[1;32m"
                echo "    <<==={CHAT-WITH-TGPT}===>>"
                echo -e "\033[0m"  # Reset color
                tgpt -m
                log_message "INFO" "TGPT in normal chat mode."
                send_alert "TGPT CHAT MODE."
                ;;
            "aidev")
                echo -e "\033[1;32m"
                echo "    <<==={DEVLOPER-TGPT}===>>"
                echo -e "\033[0m"  # Reset color
                
                # Prompt for user input
                echo -e "\033[1;31m"
                read -p "  (YOUR-IDEA) ->> " user_prompt
                echo -e "\033[0m"
                
                # Execute tgpt with user input
                tgpt --provider phind "$user_prompt"
                
                log_message "INFO" "TGPT in interactive mode with user prompt."
                send_alert "TGPT INTERACTIVE MODE WITH PROMPT."
                ;;
            "aishell")
                echo -e "\033[1;32m"
                echo "    <<==={DEVLOPER-TGPT}===>>"
                echo -e "\033[0m"  # Reset color
                
                # Prompt for user input
                echo -e "\033[1;31m"
                read -p "  (YOUR-QUERRY) ->> " user_prompt
                echo -e "\033[0m"
                
                # Execute tgpt with user input
                tgpt -s "$user_prompt"
                
                log_message "INFO" "TGPT in shell mode with user prompt."
                send_alert "TGPT SHELL MODE WITH PROMPT."
                ;;
            "aisim")
                echo -e "\033[1;32m"
                echo "    <<==={SIMPLE-TGPT}===>>"
                echo -e "\033[0m"  # Reset color
                
                # Prompt for user input
                echo -e "\033[1;31m"
                read -p "  (YOUR-QUERRY) ->> " user_prompt
                echo -e "\033[0m"
                
                # Execute tgpt with user input
                tgpt "$user_prompt"
                
                log_message "INFO" "TGPT in SIMPLE mode with user prompt."
                send_alert "TGPT SIMPLE MODE WITH PROMPT."
                ;;
            "aimg")
                echo -e "\033[1;32m"
                echo "    <<==={IMAGE-TGPT}===>>"
                echo -e "\033[0m"  # Reset color
                
                # Prompt for user input
                echo -e "\033[1;31m"
                read -p "  (YOUR-IMAGE-IDEA) ->> " user_prompt
                echo -e "\033[0m"
                
                # Execute tgpt with user input
                tgpt --img "$user_prompt"
                
                log_message "INFO" "TGPT in image generator mode with user prompt."
                send_alert "TGPT IMAGE GENERATOR MODE WITH PROMPT."
                ;;
            "aiasc")
                echo -e "\033[1;32m"
                echo "    <<==={ASCII-TGPT}===>>"
                echo -e "\033[0m"  # Reset color
                
                # Prompt for user input
                echo -e "\033[1;31m"
                read -p "  (YOUR-ASCII-IDEA) ->> " user_prompt
                echo -e "\033[0m" 
                
                # Execute tgpt with user input
                tgpt --provider pollinations "$user_prompt"
                
                log_message "INFO" "TGPT in ascii image generator mode with user prompt."
                send_alert "TGPT ASCII IMAGE GENERATOR MODE WITH PROMPT."
                ;;
            "help")
                echo -e "\033[1;33m" "\n        GLOBAL HELP (GH): \033[0m"
                echo -e "\033[1;32m"
                echo "     >>>   1. ls        - List avaliable security tools in this framework"
                echo "     >>>   2. cd        - To enter New Choosen Section (cd ffuf)"
                echo "     >>>   3. cd ..     - To get back from one section to HOME menu (If 'cd ..' is not working then use 'exit' command)"
                echo "     >>>   4. clear     - Clear the terminal"
                echo "     >>>   5. exit      - Exit the command interface"
                echo "     >>>   6. banner    - To show the banner"
                echo "     >>>   7. dstyle    - Just enjoy Indian hackers (Fun purpose)"
                echo "     >>>   8. bjob      - Just enjoy Indian Hackers (Fun purpose)"
                echo "     >>>   9. mip       - Show your public IP address (JUST USE 'mip' DON'T USE 'cd mip')"
                echo -e "\033[1;31m"  # Red color
                echo ">> By pressing CTRL+C the whole script stops (BE CAREFULL)"
                echo ">> If you see any warning while useing 'cd ..' then check your section name or execute 'exit' command to exit from the section."
                echo -e "\033[0m"  # Reset color
                ;;
            "ls")
                echo -e "\033[1;33m" "\n        AI COMMANDS (AIC):\033[0m"
                echo -e "\033[1;32m"
                echo "     >>>  aint     - TGPT in interactive mode."
                echo "     >>>  aiup     - Update TGPT (specally for debian)."
                echo "     >>>  aimg     - TGPT in image generator mode."
                echo "     >>>  aiasc    - TGPT in ascii image generator mode."
                echo "     >>>  aisim    - TGPT in simple mode."
                echo "     >>>  aidev    - TGPT in Devloper mode."
                echo "     >>>  aichat   - TGPT in normal chat mode."
                echo "     >>>  aindeb   - TGPT in interactive devloper mode."
                echo "     >>>  aishell  - TGPT for ask command or execute command mode."
                echo "   "
                echo "> INSTALL TGPT"
                echo " 1. intdeb   - Install TGPT for debian based distro (including kali, ubuntu, parrot)."
                echo " 2. intarch  - Install TGPT for arch linux."
                echo -e "\033[0m"  # Reset color
                ;;
            "clear")
                clear  # Clear the terminal
                ;;
            "banner")
                display_banner
                ;;
            "dstyle")
                display_fuck_banner1
                ;;
            "bjob")
                display_blowjob_banner
                ;;
            *)
                echo -e "\033[1;31m"
                echo "-->> Invalid Command. Please use 'help/ls' to see the commands."
                echo -e "\033[0m"  # Reset color
                ;;
        esac

        # Save history to file
        history -a "$HISTORY_FILE"
    done
}

# Function to check system status
check_sys_status() {
    local current_section="CSS"

    # Load history from file if it exists
    if [[ -f "$HISTORY_FILE" ]]; then
        history -r "$HISTORY_FILE"
    fi

    while true; do
        read -e -p "$(echo -e "\033[1;31m($(date +"%I:%M:%S %p"))\033[1;34m-(MAHAKAL)\033[0m-(${current_section})> ")" option

        # Exit the loop if the user types 'exit'
        if [[ "$option" == "exit" ]]; then
            break
        fi

        # If the input is empty, continue to the next iteration
        if [[ -z "$option" ]]; then
            continue
        fi

        # Add the command to history
        history -s "$option"

        case $option in
            "cd ..")
                return
                ;;
            "mip")
                echo -e "\033[1;32m"  # Green color
                echo "Your IP address is: $(curl -s ifconfig.me)"
                echo -e "\033[0m"  # Reset color
                log_message "INFO" "User checked IP address"
                ;;
            "cd nmap")
                current_section="NMAP"
                manage_nmap_commands
                current_section="CSS"
                ;;
            "cd curl")
                current_section="CURL"
                manage_curl_commands
                current_section="CSS"
                ;;
            "cd whatweb")
                current_section="WHATWEB"
                manage_whatweb_commands
                current_section="CSS"
                ;;
            "cd wpscan")
                current_section="WPSCAN"
                manage_wpscan_commands
                current_section="CSS"
                ;;
            "cd waf")
                current_section="WAFW00F"
                traffic_anony
                current_section="CSS"
                ;;
            "cd subfinder")
                current_section="SUBFINDER"
                manage_subfinder_commands
                current_section="CSS"
                ;;
            "cd dnsrecon")
                current_section="DNSRECON"
                manage_dnsrecon_commands
                current_section="CSS"
                ;;
            "cd dnsenum")
                current_section="DNSENUM"
                manage_dnsenum_commands
                current_section="CSS"
                ;;
            "cd httprobe")
                current_section="HTTPROBE"
                manage_httprobe_commands
                current_section="CSS"
                ;;
            "cd whois")
                current_section="WHOIS"
                manage_whois_commands
                current_section="CSS"
                ;;
            "cd amass")
                current_section="AMASS"
                manage_amass_commands
                current_section="CSS"
                ;;
            "cd hydra")
                current_section="HYDRA"
                manage_hydra_commands
                current_section="CSS"
                ;;
            "cd medusa")
                current_section="MEDUSA"
                manage_medusa_commands
                current_section="CSS"
                ;;
            "cd john")
                current_section="JOHN"
                manage_john_commands
                current_section="CSS"
                ;;
            "cd hashcat")
                current_section="HASHCAT"
                manage_hashcat_commands
                current_section="CSS"
                ;;
            "cd gobuster")
                current_section="GOBUSTER"
                manage_gobuster_commands
                current_section="CSS"
                ;;
            "cd ffuf")
                current_section="FFUF"
                manage_ffuf_commands
                current_section="CSS"
                ;;
            "cd nikto")
                current_section="NIKTO"
                manage_nikto_commands
                current_section="CSS"
                ;;
            "cd masscan")
                current_section="MASSCAN"
                manage_masscan_commands
                current_section="CSS"
                ;;
            "cd unic")
                current_section="UNICORNSCAN"
                manage_unicornscan_commands
                current_section="CSS"
                ;;
            "cd enumli")
                current_section="ENUM4LINUX"
                manage_enum4linux_commands
                current_section="CSS"
                ;;
            "cd sqlmap")
                current_section="SQLMAP"
                manage_sqlmap_commands
                current_section="CSS"
                ;;
            "cd ai")
                current_section="AI"
                chat_ai
                current_section="CSS"
                ;;
            "cd anony")
                current_section="ANONY"
                traffic_anony
                current_section="CSS"
                ;;
            "cd ufw")
                current_section="UFW"
                manage_firewall
                current_section="CSS"
                ;;
        esac

        case $option in
            "ufws")
                echo -e "\033[1;32m"
                echo "<<==={UFW-STATUS}===>:"
                echo -e "\033[0m"  # Reset color
                sudo ufw status verbose
                log_message "INFO" "UFW status checked."
                send_alert "UFW STATUS IS SHOWN."
                ;;
            "disks")
                echo -e "\033[1;32m"
                echo "<<==={DISK-USAGE-STATUS}===>>"
                echo -e "\033[0m"  # Reset color
                df -h
                log_message "INFO" "Disk status checked"
                send_alert "DISK USAGE STATUS IS SHOWN."
                ;;
            "rams")
                echo -e "\033[1;32m"
                echo "<<==={MEMORY-USAGE-STATUS}===>>"
                echo -e "\033[0m"  # Reset color
                free -h
                log_message "INFO" "Memory/Ram usage status checked."
                send_alert "MEMORY/RAM STATUS IS SHOWN."
                ;;
            "rsers")
                echo -e "\033[1;32m"
                echo "<<==={RUNNING-SERVICES-STATUS}===>>"
                echo -e "\033[0m"  # Reset color
                systemctl list-units --type=service --state=running
                log_message "INFO" "Running services status checked."
                send_alert "RUNNING SERVICE STATUS SHOWN."
                ;;
            "fails")
                echo -e "\033[1;32m"
                echo "<<==={FAIL2BAN-STATUS}===>>"
                echo -e "\033[0m"  # Reset color
                sudo fail2ban-client status
                log_message "INFO" "Fail2ban status checked."
                send_alert "FAIL2BAN STATUS SHOWN."
                ;;
            "cpu")
                echo -e "\033[1;32m"
                echo "<<==={CPU-INFO}===>>"
                echo -e "\033[0m"  # Reset color
                lscpu
                log_message "INFO" "CPU information ."
                send_alert "CPU INFO SHOWN."
                ;;
            "short")
                echo -e "\033[1;32m"
                echo "<<==={SHROT-INFO}===>>"
                echo -e "\033[0m"  # Reset color
                inxi
                log_message "INFO" "INXI information ."
                send_alert "SHORT INFO SHOWN."
                ;;
            "pci")
                echo  -e "\033[1;32m"
                echo "<<==={PCI-INFO}===>>"
                echo -e "\033[0m"
                lspci
                log_message "INFO" "PCI information ."
                send_alert "PCI INFO SHOWN."
                ;; 
            "all")
                echo -e "\033[1;32m"
                echo "<<=========================>>"
                echo "  <<--ALL-SYSTEM-STATUS-->>"
                echo "<<=========================>>"
                echo -e "\033[0m"  # Reset color
                echo ""
                echo -e "\033[1;32m"
                echo "<<==={UFW-STATUS}===>>"
                echo -e "\033[0m"  # Reset color
                sudo ufw status verbose
                echo ""
                echo -e "\033[1;32m"
                echo "<<==={DISK-STATUS}===>>"
                echo -e "\033[0m"  # Reset color
                df -h
                echo ""
                echo -e "\033[1;32m"
                echo "<<==={RAM-STATUS}===>>"
                echo -e "\033[0m"  # Reset color
                free -h
                echo ""
                echo -e "\033[1;32m"
                echo "<<==={CPU-STATUS}===>>"
                echo -e "\033[0m"  # Reset color
                lscpu
                inxi
                echo ""
                echo -e "\033[1;32m"
                echo "<<==={UPTIME-STATUS}===>>"
                echo -e "\033[0m"  # Reset color
                uptime
                echo ""
                echo  -e "\033[1;32m"
                echo "<<==={PCI-INFO}===>>"
                echo -e "\033[0m"
                lspci
                echo ""
                echo -e "\033[1;32m"
                echo "<<==={SERVICES-STATUS}===>>"
                echo -e "\033[0m"  # Reset color
                systemctl list-units --type=service --state=running
                echo ""
                echo -e "\033[1;32m"
                echo "<<==={FAIL2BAN-STATUS}===>>"
                echo -e "\033[0m"  # Reset color
                sudo fail2ban-client status
                echo ""
                log_message "INFO" "ALL status is checked in once"
                send_alert "ALL SYS-STATUS IS SHOWN"
                ;;
            "help")
                echo -e "\033[1;33m" "\n        GLOBAL HELP (GH): \033[0m"
                echo -e "\033[1;32m"
                echo "     >>>   1. ls        - List avaliable security tools in this framework"
                echo "     >>>   2. cd        - To enter New Choosen Section (cd ffuf)"
                echo "     >>>   3. cd ..     - To get back from one section to HOME menu (If 'cd ..' is not working then use 'exit' command)"
                echo "     >>>   4. clear     - Clear the terminal"
                echo "     >>>   5. exit      - Exit the command interface"
                echo "     >>>   6. banner    - To show the banner"
                echo "     >>>   7. dstyle    - Just enjoy Indian hackers (Fun purpose)"
                echo "     >>>   8. bjob      - Just enjoy Indian Hackers (Fun purpose)"
                echo "     >>>   9. mip       - Show your public IP address (JUST USE 'mip' DON'T USE 'cd mip')"
                echo -e "\033[1;31m"  # Red color
                echo ">> By pressing CTRL+C the whole script stops (BE CAREFULL)"
                echo ">> If you see any warning while useing 'cd ..' then check your section name or execute 'exit' command to exit from the section."
                echo -e "\033[0m"  # Reset color
                ;;
            "ls")
                echo -e "\033[1;33m" "\n         CSS COMMANDS (CSSC):\033[0m"
                echo -e "\033[1;32m"
                echo "     >>>  all   - Show all of above in once."
                echo "     >>>  cpu   - Show the cpu information."
                echo "     >>>  pci   - Show all hardware information in detail."
                echo "     >>>  ufws  - Show the ufw status in verbose."
                echo "     >>>  rams  - Show the ram/memory usage status."
                echo "     >>>  rsers - Show the running services."
                echo "     >>>  fails - Show the fail2ban status."
                echo "     >>>  disks - Show the disk spaces in humab readable format."
                echo "     >>>  short - Show CPU, SPEED, KERNEL, UPTIME, MEMORY, STORAGE, etc. lot information. (RECOMMANDED)"
                echo -e "\033[0m"  # Reset color
                ;;
            "clear")
                clear  # Clear the terminal
                ;;
            "banner")
                display_banner
                ;;
            "dstyle")
                display_fuck_banner1
                ;;
            "bjob")
                display_blowjob_banner
                ;;
            *)
                echo -e "\033[1;31m"
                echo "-->> Invalid Command. Please use 'help/ls' to see the commands."
                echo -e "\033[0m"  # Reset color
                ;;
        esac

        # Save history to file
        history -a "$HISTORY_FILE"
    done
}

# Function to go through Tor circuit
traffic_anony() {
    local current_section="ANONY"

    # Load history from file if it exists
    if [[ -f "$HISTORY_FILE" ]]; then
        history -r "$HISTORY_FILE"
    fi

    while true; do
        read -e -p "$(echo -e "\033[1;31m($(date +"%I:%M:%S %p"))\033[1;34m-(MAHAKAL)\033[0m-(${current_section})> ")" option

        # Exit the loop if the user types 'exit'
        if [[ "$option" == "exit" ]]; then
            break
        fi

        # If the input is empty, continue to the next iteration
        if [[ -z "$option" ]]; then
            continue
        fi

        # Add the command to history
        history -s "$option"

        case $option in
            "cd ..")
                return
                ;;
            "mip")
                echo -e "\033[1;32m"  # Green color
                echo "Your IP address is: $(curl -s ifconfig.me)"
                echo -e "\033[0m"  # Reset color
                log_message "INFO" "User checked IP address"
                ;;
            "cd nmap")
                current_section="NMAP"
                manage_nmap_commands
                current_section="ANONY"
                ;;
            "cd curl")
                current_section="CURL"
                manage_curl_commands
                current_section="ANONY"
                ;;
            "cd whatweb")
                current_section="WHATWEB"
                manage_whatweb_commands
                current_section="ANONY"
                ;;
            "cd wpscan")
                current_section="WPSCAN"
                manage_wpscan_commands
                current_section="ANONY"
                ;;
            "cd waf")
                current_section="WAFW00F"
                traffic_anony
                current_section="ANONY"
                ;;
            "cd subfinder")
                current_section="SUBFINDER"
                manage_subfinder_commands
                current_section="ANONY"
                ;;
            "cd dnsrecon")
                current_section="DNSRECON"
                manage_dnsrecon_commands
                current_section="ANONY"
                ;;
            "cd dnsenum")
                current_section="DNSENUM"
                manage_dnsenum_commands
                current_section="ANONY"
                ;;
            "cd httprobe")
                current_section="HTTPROBE"
                manage_httprobe_commands
                current_section="ANONY"
                ;;
            "cd whois")
                current_section="WHOIS"
                manage_whois_commands
                current_section="ANONY"
                ;;
            "cd amass")
                current_section="AMASS"
                manage_amass_commands
                current_section="ANONY"
                ;;
            "cd hydra")
                current_section="HYDRA"
                manage_hydra_commands
                current_section="ANONY"
                ;;
            "cd medusa")
                current_section="MEDUSA"
                manage_medusa_commands
                current_section="ANONY"
                ;;
            "cd john")
                current_section="JOHN"
                manage_john_commands
                current_section="ANONY"
                ;;
            "cd hashcat")
                current_section="HASHCAT"
                manage_hashcat_commands
                current_section="ANONY"
                ;;
            "cd gobuster")
                current_section="GOBUSTER"
                manage_gobuster_commands
                current_section="ANONY"
                ;;
            "cd ffuf")
                current_section="FFUF"
                manage_ffuf_commands
                current_section="ANONY"
                ;;
            "cd nikto")
                current_section="NIKTO"
                manage_nikto_commands
                current_section="ANONY"
                ;;
            "cd masscan")
                current_section="MASSCAN"
                manage_masscan_commands
                current_section="ANONY"
                ;;
            "cd unic")
                current_section="UNICORNSCAN"
                manage_unicornscan_commands
                current_section="ANONY"
                ;;
            "cd enumli")
                current_section="ENUM4LINUX"
                manage_enum4linux_commands
                current_section="ANONY"
                ;;
            "cd sqlmap")
                current_section="SQLMAP"
                manage_sqlmap_commands
                current_section="ANONY"
                ;;
            "cd ai")
                current_section="AI"
                chat_ai
                current_section="ANONY"
                ;;
            "cd css")
                current_section="CSS"
                check_sys_status
                current_section="ANONY"
                ;;
            "cd ufw")
                current_section="UFW"
                manage_firewall
                current_section="ANONY"
                ;;
        esac

        case $option in
            "dstart")
                echo -e "\033[1;32m"
                echo "<<==={TOR-MODE-ON}===>>"
                echo -e "\033[0m"  # Reset color
                sudo anonsurf start
                log_message "INFO" "All network traffic is routing through Tor."
                send_alert "Tor network traffic is running now."
                ;;
            "dchnid")
                echo -e "\033[1;32m"
                echo "<<==={TOR-CHANGED-IP}===>>"
                echo -e "\033[0m"  # Reset color
                sudo anonsurf changeid
                log_message "INFO" "TOR changed Ip address for debain"
                send_alert "Your IP address changed now."
                ;;
            "dstop")
                echo -e "\033[1;32m"
                echo "<<==={TOR-MODE-OFF}===>>"
                echo -e "\033[0m"  # Reset color
                sudo anonsurf stop
                log_message "INFO" "All network traffic is routing Normally."
                send_alert "Tor network traffic is stop."
                ;;
            "kstart")
                echo -e "\033[1;32m"
                echo "<<==={TOR-MODE-ON}===>>"
                echo -e "\033[0m"  # Reset color
                sudo anonsurf start
                log_message "INFO" "All network traffic is routing through Tor (KALI)."
                send_alert "Tor network traffic is running now."
                ;;
            "kchnid")
                echo -e "\033[1;32m"
                echo "<<==={TOR-CHANGED-IP}===>>"
                echo -e "\033[0m"  # Reset color
                sudo anonsurf change
                log_message "INFO" "TOR changed Ip address for Kali"
                send_alert "Your IP address changed now."
                ;;
            "kstop")
                echo -e "\033[1;32m"
                echo "<<==={TOR-MODE-OFF}===>>"
                echo -e "\033[0m"  # Reset color
                sudo anonsurf stop
                log_message "INFO" "All network traffic is routing kali."
                send_alert "Tor network traffic is stop."
                ;;
            "astart")
                echo -e "\033[1;32m"
                echo "<<==={TOR-MODE-ON}===>>"
                echo -e "\033[0m"  # Reset color
                sudo torctl start 
                log_message "INFO" "All network traffic is routing through Tor."
                send_alert "Tor network is started now."
                ;;
            "achnid")
                echo -e "\033[1;32m"
                echo "<<==={TOR-CHANGED-IP}===>>"
                echo -e "\033[0m"  # Reset color
                sudo torctl chngid
                log_message "INFO" "TOR changed IP address for ARCH."
                send_alert "Your IP address changed now."
                ;;
            "achnmc")
                echo -e "\033[1;32m"
                echo "<<==={TOR-CHANGED-MAC}===>>"
                echo -e "\033[0m"  # Reset color
                sudo torctl chngmac
                log_message "INFO" "TOR changed MAC address for ARCH."
                send_alert "Your MAC address changed now."
                ;;
            "astop")
                echo -e "\033[1;32m"
                echo "<<==={TOR-MODE-OFF}===>>"
                echo -e "\033[0m"  # Reset color
                sudo torctl stop 
                log_message "INFO" "All network traffic is routing Normally."
                send_alert "Tor network is stop"
                ;;
            "help")
                echo -e "\033[1;33m" "\n        GLOBAL HELP (GH): \033[0m"
                echo -e "\033[1;32m"
                echo "     >>>   1. ls        - List avaliable security tools in this framework"
                echo "     >>>   2. cd        - To enter New Choosen Section (cd ffuf)"
                echo "     >>>   3. cd ..     - To get back from one section to HOME menu (If 'cd ..' is not working then use 'exit' command)"
                echo "     >>>   4. clear     - Clear the terminal"
                echo "     >>>   5. exit      - Exit the command interface"
                echo "     >>>   6. banner    - To show the banner"
                echo "     >>>   7. dstyle    - Just enjoy Indian hackers (Fun purpose)"
                echo "     >>>   8. bjob      - Just enjoy Indian Hackers (Fun purpose)"
                echo "     >>>   9. mip       - Show your public IP address (JUST USE 'mip' DON'T USE 'cd mip')"
                echo -e "\033[1;31m"  # Red color
                echo ">> By pressing CTRL+C the whole script stops (BE CAREFULL)"
                echo ">> If you see any warning while useing 'cd ..' then check your section name or execute 'exit' command to exit from the section."
                echo -e "\033[0m"  # Reset color
                ;;
            "ls")
                echo -e "\033[1;33m" "\nANONY COMMANDS (ANONYC):\033[0m"
                echo -e "\033[1;32m"
                echo "--> WARNING: FOR KALI LINUX PLEASE INSTALL KALI-ANONSURF FORM GITHUB."
                echo "--> INFO: My research is still going to resolv other distro tor tool."
                echo "                                                " 
                echo "> DEBIAN-TOR:"
                echo "     >>>  dstart  - For parrot os, to start Tor tunnel."
                echo "     >>>  dchnid  - For parrot os, to change Tor IP Address."
                echo "     >>>  dstop   - For parrot os, to stop Tor tunnel."
                echo "                                                      "
                echo "> KALI-TOR:"
                echo "     >>>  kstart  - For kali, to start Tor tunnel."
                echo "     >>>  kchnid  - For kali, to change Tor IP Address."
                echo "     >>>  kstop   - For kali, to stop Tor tunnel."
                echo "                                          "
                echo "> ARCH-TOR:"
                echo "     >>>  astart  - For Arch, to start Tor tunnel."
                echo "     >>>  achnid  - For Arch, to change IP address of TOR."
                echo "     >>>  achnmc  - For Arch, to change MAC address of TOR."
                echo "     >>>  astop   - For Arch, to stop TOR tunnel."
                echo -e "\033[0m"  # Reset color
                ;;
            "clear")
                clear  # Clear the terminal
                ;;
            "cd ..")
                return  # Exit the scan management section and go back to the main menu
                ;;
            "banner")
                display_banner
                ;;
            "dstyle")
                display_fuck_banner1
                ;;
            "bjob")
                display_blowjob_banner
                ;;
            *)
                echo -e "\033[1;31m"
                echo "-->> Invalid Command. Please use 'help/ls' to see the commands."
                echo -e "\033[0m"  # Reset color
                ;;
        esac

        # Save history to file
        history -a "$HISTORY_FILE"
    done
}

# Function to manage UFW firewall rules
manage_firewall() {
    local current_section="UFW"

    # Load history from file if it exists
    if [[ -f "$HISTORY_FILE" ]]; then
        history -r "$HISTORY_FILE"
    fi

    while true; do
        # Read input with readline support
        read -e -p "$(echo -e "\033[1;31m($(date +"%I:%M:%S %p"))\033[1;34m-(MAHAKAL)\033[0m-(${current_section})> ")" option

        # Exit the loop if the user types 'exit'
        if [[ "$option" == "exit" ]]; then
            break
        fi

        # If the input is empty, continue to the next iteration
        if [[ -z "$option" ]]; then
            continue
        fi

        # Add the command to history
        history -s "$option"

        case $option in
            "cd ..")
                return  # Exit the firewall management section and go back to the main menu
                ;;
            "mip")
                echo -e "\033[1;32m"  # Green color
                echo "Your IP address is: $(curl -s ifconfig.me)"
                echo -e "\033[0m"  # Reset color
                log_message "INFO" "User checked IP address"
                ;;
            "cd nmap")
                current_section="NMAP"
                manage_nmap_commands
                current_section="UFW"
                ;;
            "cd curl")
                current_section="CURL"
                manage_curl_commands
                current_section="UFW"
                ;;
            "cd whatweb")
                current_section="WHATWEB"
                manage_whatweb_commands
                current_section="UFW"
                ;;
            "cd wpscan")
                current_section="WPSCAN"
                manage_wpscan_commands
                current_section="UFW"
                ;;
            "cd waf")
                current_section="WAFW00F"
                manage_wafw00f_commands
                current_section="UFW"
                ;;
            "cd subfinder")
                current_section="SUBFINDER"
                manage_subfinder_commands
                current_section="UFW"
                ;;
            "cd dnsrecon")
                current_section="DNSRECON"
                manage_dnsrecon_commands
                current_section="UFW"
                ;;
            "cd dnsenum")
                current_section="DNSENUM"
                manage_dnsenum_commands
                current_section="UFW"
                ;;
            "cd httprobe")
                current_section="HTTPROBE"
                manage_httprobe_commands
                current_section="UFW"
                ;;
            "cd whois")
                current_section="WHOIS"
                manage_whois_commands
                current_section="UFW"
                ;;
            "cd amass")
                current_section="AMASS"
                manage_amass_commands
                current_section="UFW"
                ;;
            "cd hydra")
                current_section="HYDRA"
                manage_hydra_commands
                current_section="UFW"
                ;;
            "cd medusa")
                current_section="MEDUSA"
                manage_medusa_commands
                current_section="UFW"
                ;;
            "cd john")
                current_section="JOHN"
                manage_john_commands
                current_section="UFW"
                ;;
            "cd hashcat")
                current_section="HASHCAT"
                manage_hashcat_commands
                current_section="UFW"
                ;;
            "cd gobuster")
                current_section="GOBUSTER"
                manage_gobuster_commands
                current_section="UFW"
                ;;
            "cd ffuf")
                current_section="FFUF"
                manage_ffuf_commands
                current_section="UFW"
                ;;
            "cd nikto")
                current_section="NIKTO"
                manage_nikto_commands
                current_section="UFW"
                ;;
            "cd masscan")
                current_section="MASSCAN"
                manage_masscan_commands
                current_section="UFW"
                ;;
            "cd unic")
                current_section="UNICORNSCAN"
                manage_unicornscan_commands
                current_section="UFW"
                ;;
            "cd enumli")
                current_section="ENUM4LINUX"
                manage_enum4linux_commands
                current_section="UFW"
                ;;
            "cd sqlmap")
                current_section="SQLMAP"
                manage_sqlmap_commands
                current_section="UFW"
                ;;
            "cd ai")
                current_section="AI"
                chat_ai
                current_section="UFW"
                ;;
            "cd css")
                current_section="CSS"
                check_sys_status
                current_section="UFW"
                ;;
            "cd anony")
                current_section="ANONY"
                traffic_anony
                current_section="UFW"
                ;;
        esac

        case $option in
            "enable")
                echo -e "\033[1;32m"
                echo "<<==={UFW-ON}===>>"
                echo -e "\033[0m"  # Reset color
                sudo ufw enable
                log_message "INFO" "UFW enabled."
                send_alert "UFW has been enabled."
                ;;
            "disable")
                echo -e "\033[1;32m"
                echo "<<==={UFW-OFF}===>>"
                echo -e "\033[0m"  # Reset color
                sudo ufw disable
                log_message "INFO" "UFW disabled."
                send_alert "UFW has been disabled."
                ;;
            "assh")
                echo -e "\033[1;32m"
                echo "<<==={UFW-ALLOW-SSH}===>>"
                echo -e "\033[0m"  # Reset color
                sudo ufw allow ssh
                log_message "INFO" "SSH allowed through UFW."
                send_alert "SSH has been allowed through UFW."
                ;;
            "dssh")
                echo -e "\033[1;32m"
                echo "<<==={UFW-DENY-SSH}===>>"
                echo -e "\033[0m"  # Reset color
                sudo ufw deny ssh
                log_message "INFO" "SSH denied through UFW."
                send_alert "SSH has been denied through UFW."
                ;;
            "ahttp")
                echo -e "\033[1;32m"
                echo "<<==={UFW-ALLOW-HTTP}===>>"
                echo -e "\033[0m"  # Reset color
                sudo ufw allow http
                log_message "INFO" "HTTP allowed through UFW."
                send_alert "HTTP has been allowed through UFW."
                ;;
            "dhttp")
                echo -e "\033[1;32m"
                echo "<<==={UFW-DENY-HTTP}===>>"
                echo -e "\033[0m"  # Reset color
                sudo ufw deny http
                log_message "INFO" "HTTP denied through UFW."
                send_alert "HTTP has been denied through UFW."
                ;;
            "ahttps")
                echo -e "\033[1;32m"
                echo "<<==={UFW-ALLOW-HTTPS}===>>"
                echo -e "\033[0m"  # Reset color
                sudo ufw allow https
                log_message "INFO" "HTTPS allowed through UFW."
                send_alert "HTTPS has been allowed through UFW."
                ;;
            "dhttps")
                echo -e "\033[1;32m"
                echo "<<==={UFW-DENY-HTTPS}===>>"
                echo -e "\033[0m"  # Reset color
                sudo ufw deny https
                log_message "INFO" "HTTPS denied through UFW."
                send_alert "HTTPS has been denied through UFW."
                ;;
            "statv")
                echo -e "\033[1;32m"
                echo "<<==={UFW-STATUS-VERBOSE}===>>"
                echo -e "\033[0m"  # Reset color
                sudo ufw status verbose
                ;;
            "statn")
                echo -e "\033[1;32m"
                echo "<<==={UFW-STATUS-NUMBERED}===>>"
                echo -e "\033[0m"  # Reset color
                sudo ufw status numbered
                ;;
            "urest")
                echo -e "\033[1;32m"
                echo "<<==={UFW-RESETER}===>>"
                echo -e "\033[0m"  # Reset color
                sudo ufw reset
                ;;
            "uload")
                echo -e "\033[1;32m"
                echo "<<==={UFW-STATUS-NUMBERED}===>>"
                echo -e "\033[0m"  # Reset color
                sudo ufw reload
                ;;
            "aftp")
                echo -e "\033[1;32m"
                echo "<<==={UFW-ALLOW-FTP}===>>"
                echo -e "\033[0m"  # Reset color
                sudo ufw allow ftp
                log_message "INFO" "FTP allowed through UFW."
                send_alert "FTP has been allowed through UFW."
                ;;
            "dftp")
                echo -e "\033[1;32m"
                echo "<<==={UFW-DENY-FTP}===>>"
                echo -e "\033[0m"  # Reset color
                sudo ufw allow ftp
                log_message "INFO" "FTP denied through UFW."
                send_alert "FTP has been denied through UFW."
                ;;
            "deny-all")
                echo -e "\033[1;32m"
                echo "<<==={UFW-DENY-ALL}===>>"
                echo -e "\033[0m"  # Reset color
                sudo ufw default deny
                log_message "INFO" "All traffic denied by default."
                send_alert "All traffic is now denied by default."
                ;;
            "den-in")
                echo -e "\033[1;32m"
                echo "<<==={UFW-DENY-INCOMING}===>>"
                echo -e "\033[0m"  # Reset color
                sudo ufw default deny incoming
                log_message "INFO" "All incoming traffic denied by default."
                send_alert "All incoming traffic is now denied by default."
                ;;
            "alw-out")
                echo -e "\033[1;32m"
                echo "<<==={UFW-ALLOW-OUTGOING}===>>"
                echo -e "\033[0m"  # Reset color
                sudo ufw default allow outgoing
                log_message "INFO" "Outgoing traffic allowed by default."
                send_alert "Outgoing traffic is now allowed by default."
                ;;
            "den-out")
                echo -e "\033[1;32m"
                echo "<<==={UFW-DENY-OUTGOING}===>>"
                echo -e "\033[0m"  # Reset color
                sudo ufw deny outgoing
                log_message "INFO" "Outgoing traffic denied."
                send_alert "Outgoing traffic has been denied."
                ;;
            "aping")
                echo -e "\033[1;32m"
                echo "<<==={UFW-ALLOW-PING}===>>"
                echo -e "\033[0m"  # Reset color
                sudo ufw allow proto icmp
                log_message "INFO" "Ping (ICMP) allowed through UFW."
                send_alert "Ping has been allowed through UFW."
                ;;
            "dping")
                echo -e "\033[1;32m"
                echo "<<==={UFW-DENY-PING}===>>"
                echo -e "\033[0m"  # Reset color
                sudo ufw deny proto icmp
                log_message "INFO" "Ping (ICMP) denied through UFW."
                send_alert "Ping has been denied through UFW."
                ;;
            "adns")
                echo -e "\033[1;32m"
                echo "<<==={UFW-ALLOW-DNS}===>>"
                echo -e "\033[0m"  # Reset color
                sudo ufw allow dns
                log_message "INFO" "DNS allowed through UFW."
                send_alert "DNS has been allowed through UFW."
                ;;
            "ddns")
                echo -e "\033[1;32m"
                echo "<<==={UFW-DENY-DNS}===>>"
                echo -e "\033[0m"  # Reset color
                sudo ufw allow dns
                log_message "INFO" "DNS Denied through UFW."
                send_alert "DNS has been Denied through UFW."
                ;;
            "asmtp")
                echo -e "\033[1;32m"
                echo "<<==={UFW-ALLOW-SMTP}===>>"
                echo -e "\033[0m"  # Reset color
                sudo ufw allow smtp
                log_message "INFO" "SMTP allowed through UFW."
                send_alert "SMTP has been allowed through UFW."
                ;;
            "dsmtp")
                echo -e "\033[1;32m"
                echo "<<==={UFW-DENY-SMTP}===>>"
                echo -e "\033[0m"  # Reset color
                sudo ufw deny smtp
                log_message "INFO" "SMTP denied through UFW."
                send_alert "SMTP has been denied through UFW."
                ;;
            "apop3")
                echo -e "\033[1;32m"
                echo "<<==={UFW-ALLOW-POP3}===>>"
                echo -e "\033[0m"  # Reset color
                sudo ufw allow pop3
                log_message "INFO" "POP3 allowed through UFW."
                send_alert "POP3 has been allowed through UFW."
                ;;
            "dpop3")
                echo -e "\033[1;32m"
                echo "<<==={UFW-DENY-POP3}===>>"
                echo -e "\033[0m"  # Reset color
                sudo ufw Deny pop3
                log_message "INFO" "POP3 denied through UFW."
                send_alert "POP3 has been denied through UFW."
                ;;
            "aimap")
                echo -e "\033[1;32m"
                echo "<<==={UFW-ALLOW-IMAP}===>>"
                echo -e "\033[0m"  # Reset color
                sudo ufw allow imap
                log_message "INFO" "IMAP allowed through UFW."
                send_alert "IMAP has been allowed through UFW."
                ;;
            "dimap")
                echo -e "\033[1;32m"
                echo "<<==={UFW-DENY-IMAP}===>>"
                echo -e "\033[0m"  # Reset color
                sudo ufw deny imap
                log_message "INFO" "IMAP denied through UFW."
                send_alert "IMAP has been denied through UFW."
                ;;
            "clear")
                clear
                ;;
            "banner")
                display_banner
                ;;
            "dstyle")
                display_fuck_banner1
                ;;
            "bjob")
                display_blowjob_banner
                ;;
            "help")
                echo -e "\033[1;33m" "\n        GLOBAL HELP (GH): \033[0m"
                echo -e "\033[1;32m"
                echo "     >>>   1. ls        - List avaliable security tools in this framework"
                echo "     >>>   2. cd        - To enter New Choosen Section (cd ffuf)"
                echo "     >>>   3. cd ..     - To get back from one section to HOME menu (If 'cd ..' is not working then use 'exit' command)"
                echo "     >>>   4. clear     - Clear the terminal"
                echo "     >>>   5. exit      - Exit the command interface"
                echo "     >>>   6. banner    - To show the banner"
                echo "     >>>   7. dstyle    - Just enjoy Indian hackers (Fun purpose)"
                echo "     >>>   8. bjob      - Just enjoy Indian Hackers (Fun purpose)"
                echo "     >>>   9. mip       - Show your public IP address (JUST USE 'mip' DON'T USE 'cd mip')"
                echo -e "\033[1;31m"  # Red color
                echo ">> By pressing CTRL+C the whole script stops (BE CAREFULL)"
                echo ">> If you see any warning while useing 'cd ..' then check your section name or execute 'exit' command to exit from the section."
                echo -e "\033[0m"  # Reset color
                ;;
            "ls")
                echo -e "\033[1;32m" "Available Options (AO):"
                echo "     >>>   1.  enable    - Enable UFW"
                echo "     >>>   2.  disable   - Disable UFW"
                echo "     >>>   3.  assh      - Allow SSH"
                echo "     >>>   4.  dssh      - Deny SSH"
                echo "     >>>   5.  ahttp     - Allow HTTP"
                echo "     >>>   6.  dhttp     - Deny HTTP"
                echo "     >>>   7.  ahttps    - Allow HTTPS"
                echo "     >>>   8.  dhttps    - Deny HTTPS"
                echo "     >>>   9.  aftp      - Allow FTP "
                echo "     >>>  10.  dftp      - Deny FTP "
                echo "     >>>  11.  aping     - Allow Ping (ICMP)"
                echo "     >>>  12.  dping     - Deny Ping (ICMP)"
                echo "     >>>  13.  adns      - Allow DNS "
                echo "     >>>  14.  ddns      - Deny DNS "
                echo "     >>>  15.  asmtp     - Allow SMTP"
                echo "     >>>  16.  dsmtp     - Deny SMTP"
                echo "     >>>  17.  apop3     - Allow POP3"
                echo "     >>>  18.  dpop3     - Deny P0P3"
                echo "     >>>  19.  aimap     - Allow IMAP"
                echo "     >>>  20.  dimap     - Deny IAMP"
                echo "     >>>  21.  deny-all  - Deny all Internet Traffic"
                echo "     >>>  22.  den-in    - Deny all incoming Traffic"
                echo "     >>>  23.  alw-out   - Allow Outgoing Traffic"
                echo "     >>>  24.  den-out   - Deny Outgoing Traffic"
                echo "     >>>  25.  urest     - Reset the UFW and take it to normal"
                echo "     >>>  26.  uload     - Reload the UFW "
                echo "     >>>  27.  statv     - Show UFW status in verbose."
                echo "     >>>  28.  statn     - Show UFW status in numbered."
                echo -e "\033[0m"  # Reset color
                ;;
            "cd ..")
                return
                ;;
            *)
                echo -e "\033[1;31m"
                echo "-->> Invalid Command. Please use 'help/ls' to see the commands."
                echo -e "\033[0m"  # Reset color
                ;;
        esac

        # Save history to file
        history -a "$HISTORY_FILE"
    done
}

# Main function
main() {
    check_root
    display_banner
    run_user_commands
}

# Run the main function
main "$@"
