#!/bin/bash

set -e

# Configuration
PROJECT_NAME="FileBrowserClient"
if [ -z "$DEVICE_ID" ]; then
    echo "Error: DEVICE_ID is not set. Please set it to the device's UDID."
    # List run destinations
    # xcrun xctrace list devices
    # xcrun simctl list devices (only for simulators)
    exit 1
fi

cd "$PROJECT_NAME" || { echo "Project directory not found!"; exit 1; }

# Build the project
xcodebuild \
  -project "$PROJECT_NAME.xcodeproj" \
  -scheme "$PROJECT_NAME" \
  -configuration Debug \
  -derivedDataPath build \
  -allowProvisioningUpdates

# Find the app bundle
APP_PATH=$(find build -name "*.app" | head -n 1)

# Check if build succeeded
if [ -z "$APP_PATH" ]; then
    echo "Build failed!"
    exit 1
fi

# List available signing identities
# security find-identity -p codesigning -v

# Deploy to device
# TODO: Device needs to be physically connected and trusted
ios-deploy \
  --bundle "$APP_PATH" \
  --id "$DEVICE_ID" \
  --timeout 120

echo "Deployment completed at $(date)"
