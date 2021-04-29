#!/bin/bash

#Countdown timer.

countdown(){
	local now=$(date +%s)
	local end=$(( now + $1 ))
	while (( now < end ))
	do
		printf "%s\r" "$(date -u -j -f %s $((end - now)) +%T)"
		sleep 0.25
		now=$(date +%s)
	done
	echo
	say -v Anna "Your time is up"
}

#main
countdown "$@"
