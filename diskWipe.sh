#!/usr/bin/env bash

set -euo pipefail

# Directory to monitor for USB devices
# WATCH_DIR="/dev/disk/by-id/"

# Sound to play when wiping is complete
SOUND="/usr/share/sounds/ubuntu/stereo/complete.ogg"

# Function to wipe a disk using shred
wipe_disk() {
	local disk=$1
	echo "Wiping disk $disk..."
	shred -v -n 3 "$disk"
	echo "Wiping completed for $disk"
	paplay $SOUND
}

# Function to handle new USB device connections
handle_device() {
	local device=$1

	# Ensure it's a USB disk
	if [[ -b $device && $(lsblk -no FSTYPE "$device") == "" ]]; then
		wipe_disk "$device"
	fi
}

# Main loop to monitor for new USB disks
while true; do
	udevadm monitor --udev --subsystem-match=block | while read -r line; do
	if [[ "$line" =~ "add" ]]; then
		# Extract device path from the udev event
		device=$(echo "$line" | grep -oP '(?<=DEVNAME=)[^\s]*')
		if [[ -n $device && -e $device ]]; then
			handle_device "$device"
		fi
	fi
done
done

