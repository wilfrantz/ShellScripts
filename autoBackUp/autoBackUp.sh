 #! /usr/bin/env bash

# Configuration Variables
export rcloneRemote="gdrive_backup:"
export rcloneCryptRemote="gdrive_encrypted:"
export dataToBackup="/etc /home /var /opt /srv /root "

 # Log file location
 logFile="/var/log/backup.log"

 # Log function
 log() {
     echo "$(date '+%Y-%m-%d %H:%M:%S') $1" >> "$logFile"
 }

 # Validation
 if [[ -z "$backupDir" || -z "$rcloneRemote" || -z "$dataToBackup" || -z "$rcloneCryptRemote" ]]; then
     log "ERROR: Configuration missing. Check backupConfig.sh."
     exit 1
 fi

 # Create Temporary Directory
 tmpDir=$(mktemp -d /tmp/backup.XXXXXX)
 if [[ -z "$tmpDir" ]]; then
     log "ERROR: Failed to create temporary directory."
     exit 1
 fi

 dateStamp=$(date +%Y%m%d%H%M)
 fileName="serverBackup_$dateStamp.tar.gz"
 backupFile="$tmpDir/$fileName"
 encryptedFile="$tmpDir/$fileName.enc"

 # Check if data exists
 for dir in $dataToBackup; do
     if [[ ! -e "$dir" ]]; then
         log "ERROR: Directory/File '$dir' does not exist."
         rm -rf "$tmpDir"
         exit 1
     fi
 done

 # Compress Data
 log "INFO: Starting compression."
 tar -czvf "$backupFile" $dataToBackup
 if [[ $? -ne 0 ]]; then
     log "ERROR: Compression failed."
     rm -rf "$tmpDir"
     exit 1
 fi
 log "INFO: Compression complete."


 # Encrypt the file
log "INFO: Starting encryption."
rclone cryptcheck "$backupFile" "$rcloneCryptRemote" # Check if rclone crypt is set up correctly
if [[ $? -ne 0 ]]; then
    log "ERROR: Encryption check failed. Ensure rclone crypt is configured."
    rm -rf "$tmpDir"
    exit 1
fi

rclone copy "$backupFile" "$rcloneCryptRemote" --progress
if [[ $? -ne 0 ]]; then
    log "ERROR: Encryption failed."
    rm -rf "$tmpDir"
    exit 1
fi

log "INFO: Encryption complete."

 # Cleanup
 rm -rf "$tmpDir"
 log "INFO: Backup complete."

 exit 0