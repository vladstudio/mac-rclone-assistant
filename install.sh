#!/bin/bash
set -e

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

URL=$(curl -sL https://api.github.com/repos/vladstudio/mac-rclone-assistant/releases/latest \
  | grep browser_download_url | head -1 | cut -d'"' -f4)
curl -sL "$URL" -o "$TMP/RcloneAssistant.zip"
unzip -q "$TMP/RcloneAssistant.zip" -d "$TMP"

pkill -x rclone-assistant 2>/dev/null || true
rm -rf "/Applications/Rclone Assistant.app"
mv "$TMP/Rclone Assistant.app" /Applications/
xattr -dr com.apple.quarantine "/Applications/Rclone Assistant.app" 2>/dev/null || true
open "/Applications/Rclone Assistant.app"
echo "==> Installed Rclone Assistant"
