#!/usr/bin/bash

# Sourcing the sendtelegram.sh script
source ~/Code/Github/ShellScripts/sendtelegram.sh

CHAT_ID="$TELEGRAM_CHAT_ID"

# Reading the contents of domain.log into the domains variable
domains=$(<"$HOME/log/domain.log")

# Sending a message to Telegram with the domain information
sendTelegramMessage "$CHAT_ID" "$domains"

