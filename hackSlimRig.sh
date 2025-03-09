#!/bin/bash

# Script to convert Ubuntu VM to a minimal CLI-only server with dev tools
# Usage: Run as root or with sudo

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "[!] -Error: This script must be run with sudo."
    exit 1
fi

# Check if on Ubuntu
if ! grep -q "Ubuntu" /etc/os-release; then
    echo "[!] -Error: This script is designed for Ubuntu only."
    exit 1
fi

# Function to log actions
logAction() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] - $1"
}

# Update package lists
logAction "Updating package lists..."
apt update || {
    logAction "[!] -Error: Failed to update package lists."
    exit 1
}

# Remove unnecessary GUI applications and desktop environment
logAction "Removing GUI applications and desktop environment..."
apt remove --purge -y libreoffice* totem rhythmbox shotwell thunderbird simple-scan gnome-games aisleriot \
    gnome-calculator gnome-calendar gnome-contacts gnome-weather ubuntu-desktop gnome-shell gdm3 || {
    logAction "[!] -Error: Failed to remove GUI components."
    exit 1
}

# Remove unnecessary services
logAction "Removing unnecessary services..."
apt remove --purge -y bluez cups modemmanager || {
    logAction "[!] -Error: Failed to remove services."
    exit 1
}

# Install minimal server-like system
logAction "Installing minimal CLI-only system..."
apt install --no-install-recommends -y ubuntu-minimal || {
    logAction "[!] -Error: Failed to install minimal system."
    exit 1
}

# C++ Development Tools
logAction "Installing C++ development tools..."
apt install -y build-essential g++ gdb cmake lldb || {
    logAction "[!] -Error: Failed to install C++ tools."
    exit 1
}

# Networking Tools
logAction "Installing networking tools..."
apt install -y nmap wireshark net-tools iputils-ping traceroute || {
    logAction "[!] -Error: Failed to install networking tools."
    exit 1
}

# Reverse Engineering Tools (no Ghidra)
logAction "Installing reverse engineering tools..."
apt install -y radare2 binwalk || {
    logAction "[!] -Error: Failed to install reverse engineering tools."
    exit 1
}

# Additional Utilities
logAction "Installing additional utilities..."
apt install -y python3 htop git openssh-server openssh-client || {
    logAction "[!] -Error: Failed to install utilities."
    exit 1
}

# Clean up unused dependencies and cache
logAction "Cleaning up system..."
apt autoremove --purge -y
apt clean
apt autoclean

# Disable swap (optional, assumes sufficient RAM)
logAction "Disabling swap..."
swapoff -a
sed -i '/swap/d' /etc/fstab

# Ensure CLI-only setup
logAction "Ensuring CLI-only server setup..."
systemctl set-default multi-user.target || {
    logAction "[!] -Error: Failed to set CLI as default."
    exit 1
}

# Enable vim keybindings in bash
logAction "Enabling vim keybindings in bash..."
echo "set -o vi" >> /etc/bash.bashrc

# Verify disk space and packages
logAction "Post-cleanup stats:"
logAction "Disk usage: $(df -h / | tail -n 1)"
logAction "Installed packages: $(dpkg --list | wc -l)"

logAction "Minimal CLI-only server setup with dev tools complete. Rebooting in 5 seconds..."
sleep 5
reboot