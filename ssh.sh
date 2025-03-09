#!/usr/bin/env bash

set -o xtrace
set -o pipefail
set -o errexit

# Read chat ID from env. 
CHAT_ID="$TELEGRAM_CHAT_ID"
LOG_FILE="${LOG_FILE:-/var/log/auth.log}"
TELEGRAM_SCRIPT="${HOME}/Code/Github/dotfiles/bin/sendtelegram.sh"

# Ensure CHAT_ID is set
if [ -z "$CHAT_ID" ]; then
    echo "Error: TELEGRAM_CHAT_ID is not set." >&2
    exit 1
fi

# Ensure the Telegram script exists
if [ ! -f "$TELEGRAM_SCRIPT" ]; then
    echo "Error: sendtelegram.sh not found at $TELEGRAM_SCRIPT" >&2
    exit 1
fi

# Source the Telegram script
source "$TELEGRAM_SCRIPT"


# Trap signals for clean exit
trap 'exit 0' SIGINT SIGTERM

# Monitor SSH logins
tail -Fn0 "$LOG_FILE" | \
while read -r line; do
    if echo "$line" | grep -q "sshd.*Accepted"; then
        sendTelegramMessage "$CHAT_ID" "✅ SSH Login: $line"
    fi
done
