#!/bin/bash

# Set your Telegram Bot Token and Chat ID
telegramBotToken="your_telegram_bot_token_here"
telegramChatId="your_chat_id_here"

# Define the API for sending messages via Telegram
telegramApiUrl="https://api.telegram.org/bot${telegramBotToken}/sendMessage"

# Function to check for required dependencies
checkDependencies() {
    # Check if Python3 is installed
    if ! command -v python3 &> /dev/null; then
        echo "Python3 not found! Please install Python3."
        exit 1
    fi

    # Check if jq is installed (for JSON processing)
    if ! command -v jq &> /dev/null; then
        echo "jq not found! Installing jq..."
        if [[ "$OSTYPE" == "linux-gnu"* ]]; then
            sudo apt-get update && sudo apt-get install -y jq
        elif [[ "$OSTYPE" == "darwin"* ]]; then
            brew install jq
        else
            echo "Unsupported OS for automatic jq installation. Please install jq manually."
            exit 1
        fi
    fi

    # Check if pytrends (Python package) is installed
    if ! python3 -c "import pytrends" &> /dev/null; then
        echo "pytrends not found! Installing pytrends..."
        python3 -m pip install pytrends --user
    fi
}

# Function to fetch trending words using Python
getTrendingWords() {
    python3 << END
import json
from pytrends.request import TrendReq

# Create an instance of Google Trends API
pytrends = TrendReq(hl='en-US', tz=360)

# Get trending searches in real-time for a specific region (United States in this example)
trendingSearchesDf = pytrends.trending_searches(pn='united_states')

# Fetch top 15 trending search terms
trendingSearches = trendingSearchesDf.head(15).values.flatten().tolist()

# Output the result as JSON
print(json.dumps(trendingSearches))
END
}

# Ensure dependencies are installed
checkDependencies

# Fetch the trending words using the Python script
trendingWords=$(getTrendingWords)

# Check if the trending words were successfully retrieved
if [[ -z "$trendingWords" ]]; then
    echo "Failed to fetch trending words"
    exit 1
fi

# Convert JSON output to a readable format
trendingMessage=$(echo "$trendingWords" | jq -r '. | join(", ")')

# Send the message via Telegram
curl -s -X POST $telegramApiUrl \
     -d chat_id="$telegramChatId" \
     -d text="Today's top 15 trending words on Google: $trendingMessage"
