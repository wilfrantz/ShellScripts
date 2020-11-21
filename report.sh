#!/bin/bash

# Simple report script for SysAdmin.
# Update: November 2020

# set -x # Debug mode.
# set -n # Run w/o execution.

### Variable ###
OutPutFile="$HOME"/reports/report_$(date | sed s/" "/_/g).txt
Ram_eater=$(ps aux | awk '{print $6 "\t" $11}' | sort -rn | head -25 | \
	awk '{print $1/1024 " MB\t\t" $2}') # >> "$OutPutFile"
# alias upsys='apt-get update && apt-get upgrade -y' # NOTE in ~/.zshrc

# printf "\nReport for %s: \n\n" "$(hostname)" > "$OutPutFile"
echo "Report for '$(hostname)" > "$OutPutFile"
upsys | grep -i "upgraded" | sed s/", "/\\n/g >> "$OutPutFile" 

printf "\n\n Ram eater Aplications: \n" >> "$OutPutFile"
"$Ram_eater" >> "$OutPuFile"

#ps aux | awk '{print $6 "\t" $11}' | sort -rn | head -25 | \
	#awk '{print $1/1024 " MB\t\t" $2}' >> "$OutPutFile"

printf "\nRootkit check... \n" >> "$OutPutFile"
sudo chkrootkit | grep -i "infected" >> "$OutPutFile"

telegram-send --file "$OutPutFile" --caption "Report $(date)"

