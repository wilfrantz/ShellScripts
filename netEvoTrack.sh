#!/usr/bin/env bash

# Get the enviroment.
os=$(uname -s | tr '[:upper:]' '[:lower:]')
if [ "$os" != "linux" ]; then
    echo "[!] -This script is only supported on Linux."
    exit 1
fi

# Get the gateway IP address

gateway=$( ip route | grep default | awk '{print $3}' | head -n 1)

nmap -sn "$gateway"/24 | grep -v "Nmap" | grep -v "Host" | awk '{print $5}' | sort -u | while read -r ip; do
    echo "[*] - Found host: $ip"
done

