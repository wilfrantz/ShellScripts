#! /usr/bin/env bash

# Configuration Variables
export backupDir="/path/to/backup" 
export rcloneRemote="gdrive_backup:" # or "gdrive_backup:" if you do not use crypt
export rcloneCryptRemote="gdrive_encrypted:" # rclone encrypted remote
export dataToBackup="/etc /home " # Add data 