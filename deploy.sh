#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"
WORKSPACE_PATH="${PROJECT_DIR}/FileBrowserClient/FileBrowserClient.xcodeproj/project.xcworkspace"
TARGET_DEVICE="Vignesh's iPhone"
SCRIPT_PATH="${PROJECT_DIR}/deploy.scpt"
LOG_FILE="${PROJECT_DIR}/deploy.log"

log() { echo "[ $(date '+%Y-%m-%d %H:%M:%S') ] $1" >> "$LOG_FILE"; }

echo "***************************************[ START ]***************************************" >> "$LOG_FILE"
git pull origin main

log "Starting wireless deployment"
osascript "$SCRIPT_PATH" "$WORKSPACE_PATH" "$TARGET_DEVICE"

if [[ $? -eq 0 ]]; then
    log "Deployment completed successfully"
else
    log "Deployment failed"
fi
echo "****************************************[ END ]****************************************" >> "$LOG_FILE"
