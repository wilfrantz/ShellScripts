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
TOKEN="$TELEGRAM_BOT_TOKEN"
CHAT_ID="$TELEGRAM_CHAT_ID"

DEVICE=$(hostname -f)

# Prepare message
message="$DEVICE Internet Speed:
$speedtestResult"

# Send message via Telegram
curl -s -X POST "https://api.telegram.org/bot$TOKEN/sendMessage" -d "chat_id=$CHAT_ID&text=$message" > /dev/null

