#!/usr/bin/env bash

set -o xtrace
set -o pipefail
set -o errexit

# Read chat ID from env. 
CHAT_ID="$TELEGRAM_CHAT_ID"
echo "CHAT_ID: $CHAT_ID"

# Monitor SSH logins
tail -Fn0 /var/log/auth.log | \
while read -r line; do
    if [ "$(echo "$line" | grep "sshd.*Accepted" >/dev/null)" = 0 ]; then 
        # Send message via Telegram, using the sendTelegramMessage function.
        source "${HOME}/Code/Github/dotfiles/bin/sendtelegram.sh"
        sendTelegramMessage "$CHAT_ID" "✅ SSH Login: $line"
    fi
done