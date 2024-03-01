#!/usr/bin/env bash
#
# This Bash script automates internet speed testing and sends reporting to a designated system administrator.

# Check if speedtest-cli is installed
if ! command -v speedtest-cli &> /dev/null; then
	echo "speedtest-cli is not installed. Please install it using 'pip install speedtest-cli'."
	exit 1
fi


# Read the content of the file
speedtestResult=$(speedtest-cli --simple 2>&1)

# Read Telegram bot token and chat ID from environment variables
CHAT_ID="$TELEGRAM_CHAT_ID"

DEVICE=$(hostname -f)

# Prepare message
message="$DEVICE Internet Speed:
$speedtestResult"

# Send message via Telegram, using the sendTelegramMessage function.
#source ./sendtelegram.sh
source ~/Code/Github/dotfiles/bin/sendtelegram.sh

sendTelegramMessage "$CHAT_ID", "$message"

