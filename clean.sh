#!/bin/bash

# Clean up caches and temporary files
echo "Cleaning caches and temporary files..."
sudo rm -rf /Library/Caches/*
rm -rf ~/Library/Caches/*
rm -rf ~/Library/Application\ Support/Code/Cache/*
rm -rf ~/Library/Application\ Support/Code/CachedData/*

# Remove old log files
echo "Removing old log files..."
sudo rm -rf /private/var/log/*
sudo rm -rf /Library/Logs/*
rm -rf ~/Library/Logs/*

# Delete unneeded files and folders
echo "Deleting unneeded files and folders..."
rm -rf ~/Downloads/*.iso
rm -rf ~/Downloads/*.dmg
rm -rf ~/Desktop/.DS_Store

# Empty the Trash
echo "Emptying the Trash..."
rm -rf ~/.Trash/*

# Uninstall Homebrew packages (if Homebrew is installed)
if command -v brew &>/dev/null; then
	echo "Uninstalling Homebrew packages..."
	brew list | xargs brew uninstall
	brew cleanup
fi

# Uninstall applications (you can add more as needed)
echo "Uninstalling applications..."
sudo rm -rf /Applications/SomeApp.app

# Display disk space usage after cleaning
echo "Disk space usage after cleaning:"
df -h

echo "Cleanup complete!"

