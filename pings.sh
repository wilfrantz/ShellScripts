#!/bin/bash

if [ "$1" == "" ];
then
	echo "Bad usage"
else
	for i in $(seq 1 254); do
		ping "$1"."$i" -c 1 | grep -i "64 bytes" | cut -d" " -f4 | sed 's/.$//' | nl
	done
fi
