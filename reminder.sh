#!/bin/bash

# Path to your CSV file
CSV_FILE=$1

# Function to convert date to seconds
date_to_seconds() {
	date -j -f "%m/%d/%y %H:%M" "$1" +"%s"
}

# Today's date in seconds
today=$(date +"%s")

# Loop through each line in the CSV file
while IFS=',' read -r domain status auto_renew expiration_date date_purchased category locked whois_privacy num_nameservers forward_url nameserver1 nameserver2 tld upgraded; do

	# Skip the header row
	if [[ $domain == "Domain" ]]; then
		continue
	fi

	# Check if the domain is active and auto-renew is on
	if [[ "$status" == "Active" && "$auto_renew" == "On" ]]; then

		# Convert the expiration date to seconds
		exp_in_seconds=$(date_to_seconds "$expiration_date")

		# Calculate the reminder date (7 days before expiration)
		reminder_date=$((exp_in_seconds - 7 * 24 * 60 * 60))

		# If the reminder date is in the future, schedule a reminder in Reminders app
		if [[ $reminder_date -gt $today ]]; then
			reminder_date_human=$(date -r $reminder_date "+%Y-%m-%d %H:%M")

			# Create a reminder in the Reminders app using osascript
			osascript <<EOF
tell application "Reminders"
	set newReminder to make new reminder with properties {name:"Domain $domain expires soon", due date:date "$reminder_date_human"}
	tell list "Reminders" -- Change "Reminders" to a specific list if you want
		move newReminder to end
	end tell
end tell
EOF

echo "Reminder added for domain: $domain, due on $reminder_date_human"
	fi
		fi

	done < "$CSV_FILE"

