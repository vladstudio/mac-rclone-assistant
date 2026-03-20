#!/bin/bash
set -e
cd "$(dirname "$0")"

swift build -c release

APP=/tmp/RcloneAssistant.app
rm -rf "$APP"
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources"
cp Info.plist "$APP/Contents/"
cp .build/release/rclone-assistant "$APP/Contents/MacOS/"

pkill -x rclone-assistant 2>/dev/null || true
rm -rf "/Applications/Rclone Assistant.app"
mv "$APP" "/Applications/Rclone Assistant.app"
touch "/Applications/Rclone Assistant.app"
open "/Applications/Rclone Assistant.app"
echo "==> Installed Rclone Assistant.app"
