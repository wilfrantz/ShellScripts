#!/usr/bin/env bash
#
# This Bash script automates internet speed testing and sends reporting to a designated system administrator.

# Define Telegram API URL
TELEGRAM_API_URL="https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage"

# Function to send message via Telegram
sendTelegramMessage() {
	local chatId="$1"
	local message="$2"

	# Send message via Telegram
	local response
	response=$(curl -s -X POST "$TELEGRAM_API_URL" -d "chat_id=$chatId&text=$message")

	# Check if the response contains an error message
	if [[ $response == *"\"ok\":false"* ]]; then
		echo "Failed to send message via Telegram. Response: $response" >&2
		return 1
	fi

	return 0
}

# Example usage:
# sendTelegramMessage "$TELEGRAM_CHAT_ID" "Test message"

