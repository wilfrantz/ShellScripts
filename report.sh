#!/bin/bash

# Simple report script for SysAdmin.
# Update: November 2020

 set -x # Debug mode.
# set -n # Run w/o execution.

# NOTE  alias upsys='apt-get update && apt-get upgrade -y' in ~/.zshrc

write_to_file(){
	local Ram_eater
	Ram_eater=$(ps aux | awk '{print $6 "\t" $11}' | sort -rn | head -25 | \
	awk '{print $1/1024 " MB\t\t" $2}') # >> "$OutPutFile"

	local OutPutFile
	OutPutFile="$HOME"/reports/report_$(date | sed s/" "/_/g).txt

	# printf "\nReport for %s: \n\n" "$(hostname)" > "$OutPutFile"
	echo "Report for '$(hostname)" 
	upsys | grep -i "upgraded" | sed s/", "/\\n/g  

	printf "\n\n Ram eater Aplications: \n" 
	"$Ram_eater" >> "$OutPutFile"

	printf "\nRootkit check... \n" 
	sudo chkrootkit | grep -i "infected" 

} 

write_to_file >> "$OutPutFile"

telegram-send --file "$OutPutFile" --caption "Report $(date)"

