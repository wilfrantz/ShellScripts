#!/usr/bin/env bash

# Script to convert Ubuntu VM to a minimal CLI-only server with dev tools
# Usage: Run as root or with sudo

set -e # Exit on error

# Function to log actions with color
logAction() {
    local message=$1
    local color=$2

    case $color in
        "green")
            color_code="\033[0;32m"  # Green
            ;;
        "red")
            color_code="\033[0;31m"  # Red
            ;;
        "yellow")
            color_code="\033[0;33m"  # Yellow
            ;;
        "blue")
            color_code="\033[0;34m"  # Blue
            ;;
        *)
            color_code="\033[0m"     # Default (no color)
            ;;
    esac

    echo -e "${color_code}$message\033[0m"
}

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    logAction "[!] - Error: This script must be run with sudo." "red"
    exit 1
fi

# Function to check if a package is installed
isInstalled() {
    dpkg -l | grep -qw "$1"
}


# Check if on Ubuntu
if ! grep -q "Ubuntu" /etc/os-release; then
    logAction "[!] - Error: This script is designed for Ubuntu only." "red"
    exit 1
fi

# Remove unnecessary GUI applications and desktop environment
logAction "Removing GUI applications and desktop environment..." "yellow"
apt remove --purge -y libreoffice* totem rhythmbox shotwell thunderbird simple-scan gnome-games aisleriot \
    gnome-calculator gnome-calendar gnome-contacts gnome-weather ubuntu-desktop gnome-shell gdm3 || {
    logAction "[!] - Error: Failed to remove GUI components." "red"
    exit 1
}

# Remove unnecessary services
logAction "Removing unnecessary services..." "yellow"
apt remove --purge -y bluez cups modemmanager || {
    logAction "[!] - Error: Failed to remove services." "red"
    exit 1
}

# Install minimal server-like system
logAction "Installing minimal CLI-only system..." "yellow"
apt install --no-install-recommends -y ubuntu-minimal || {
    logAction "[!] - Error: Failed to install minimal system." "red"
    exit 1
}

# C++ Development Tools
logAction "Installing C++ development tools..." "yellow"
for pkg in build-essential g++ gdb cmake lldb; do
    isInstalled "$pkg" || apt install -y "$pkg"
done

# Networking Tools
logAction "Installing networking tools..." "yellow"
for pkg in nmap wireshark net-tools iputils-ping traceroute; do
    isInstalled "$pkg" || apt install -y "$pkg"
done

# Reverse Engineering Tools
logAction "Installing reverse engineering tools..." "yellow"
for pkg in radare2 binwalk; do
    isInstalled "$pkg" || apt install -y "$pkg"
done

# Additional Utilities
logAction "Installing additional utilities..." "yellow"
for pkg in python3 htop git openssh-server openssh-client; do
    isInstalled "$pkg" || apt install -y "$pkg"
done

# Clean up unused dependencies and cache
logAction "Cleaning up system..." "blue"
apt autoremove --purge -y
apt clean
apt autoclean

# Disable swap (optional, assumes sufficient RAM)
logAction "Disabling swap..." "yellow"
swapoff -a
sed -i '/swap/d' /etc/fstab

# Ensure CLI-only setup
logAction "Ensuring CLI-only server setup..." "yellow"
systemctl set-default multi-user.target || {
    logAction "[!] - Error: Failed to set CLI as default." "red"
    exit 1
}

# Enable vim keybindings in bash
logAction "Enabling vim keybindings in bash..." "yellow"
if ! grep -q "set -o vi" /etc/bash.bashrc; then
    echo "set -o vi" >> /etc/bash.bashrc
fi

# Verify disk space and packages
logAction "Post-cleanup stats:" "blue"
logAction "Disk usage: $(df -h / | tail -n 1)" "green"
logAction "Installed packages: $(dpkg --list | wc -l)" "green"

logAction "Minimal CLI-only server setup with dev tools complete. Rebooting in 5 seconds..." "green"
sleep 5
reboot