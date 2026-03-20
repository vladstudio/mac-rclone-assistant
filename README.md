# Rclone Assistant

Native macOS GUI for managing [rclone](https://rclone.org/) remotes. Add, edit, rename, delete — no terminal needed.

The app calls `rclone` under the hood (`config providers`, `config dump`, `config create/update/delete`, `authorize`), so it supports all 60+ storage providers out of the box and picks up new ones when rclone is updated.

Requires macOS 15+ and rclone (the app will install it for you if missing).

## Install

From release:
```
bash <(curl -sL https://raw.githubusercontent.com/vladstudio/mac-rclone-assistant/main/install.sh)
```

From source (Swift 6+):
```
git clone https://github.com/vladstudio/mac-rclone-assistant.git
cd mac-rclone-assistant
./build.sh
```

## License

MIT
