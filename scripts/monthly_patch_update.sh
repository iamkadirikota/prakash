#!/bin/bash

# File: monthly_patch_update.sh
# Description: Updates system packages monthly and logs the result
# Author: YourName
# Date: $(date +'%Y-%m-%d')

LOG_DIR="/var/log/patch_updates"
LOG_FILE="$LOG_DIR/update_$(date +'%Y-%m-%d').log"
HOSTNAME=$(hostname)

# Ensure log directory exists
mkdir -p "$LOG_DIR"

# Detect package manager
if command -v apt-get &> /dev/null; then
    PM="apt"
elif command -v dnf &> /dev/null; then
    PM="dnf"
elif command -v yum &> /dev/null; then
    PM="yum"
else
    echo "Unsupported package manager." | tee "$LOG_FILE"
    exit 1
fi

# Start logging
echo "Patch Update Log - $HOSTNAME - $(date)" > "$LOG_FILE"
echo "------------------------------------------" >> "$LOG_FILE"

# Run update based on detected package manager
case "$PM" in
    apt)
        echo "Using apt-get..." >> "$LOG_FILE"
        apt-get update >> "$LOG_FILE" 2>&1
        apt-get upgrade -y >> "$LOG_FILE" 2>&1
        apt-get autoremove -y >> "$LOG_FILE" 2>&1
        ;;
    dnf)
        echo "Using dnf..." >> "$LOG_FILE"
        dnf upgrade -y >> "$LOG_FILE" 2>&1
        ;;
    yum)
        echo "Using yum..." >> "$LOG_FILE"
        yum update -y >> "$LOG_FILE" 2>&1
        ;;
esac

echo "Update completed on $(date)" >> "$LOG_FILE"

