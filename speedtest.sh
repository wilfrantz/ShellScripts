#!/bin/bash
#
# This Bash script automates internet speed testing and send reporting to a designated system administrator.


# Check if speedtest-cli is installed
if ! command -v speedtest-cli &> /dev/null
then
    echo "speedtest-cli is not installed. Please install it using 'pip install speedtest-cli'."
    exit 1
fi


# Read Telegram bot token and chat ID from environment variables
TOKEN="$TELEGRAM_BOT_TOKEN"
CHAT_ID="$TELEGRAM_CHAT_ID"

# Perform speedtest and capture the result
speedtestResult=$(speedtest-cli --simple)

# Extract download and upload speeds
downloadSpeed=$(echo "$speedtestResult" | awk '/Download:/ {print $2}')
uploadSpeed=$(echo "$speedtestResult" | awk '/Upload:/ {print $2}')

# Prepare message
message="Internet Speed Test: 
Download Speed: $downloadSpeed
Upload Speed: $uploadSpeed"

# Email configuration
recipient="contact@dede.dev"
subject="Internet Speed Test: "
body="Download Speed: $downloadSpeed\nUpload Speed: $uploadSpeed"

# Send email
echo -e "$body" | mailx -s "$subject" "$recipient"

# Send message via Telegram
curl -s -X POST "https://api.telegram.org/bot$TOKEN/sendMessage" -d "chat_id=$CHAT_ID&text=$message" > /dev/null
