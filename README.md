# Rclone Assistant

A native macOS app that provides a graphical interface for configuring [rclone](https://rclone.org/) remotes. Built for users who prefer GUI over the command line.

![macOS 15+](https://img.shields.io/badge/macOS-15%2B-blue)
![Swift](https://img.shields.io/badge/Swift-6-orange)
![License](https://img.shields.io/badge/license-MIT-green)

## Features

- **List, add, edit, rename, and delete** rclone remotes
- **Dynamic configuration forms** generated from rclone's own provider schema — automatically supports all 60+ cloud storage providers
- **OAuth authorization** for providers like Google Drive, Dropbox, OneDrive (opens browser via `rclone authorize`)
- **Auto-installs rclone** via Homebrew or direct download if not found
- **Operation log** for debugging

## Install

### From release

```bash
bash <(curl -sL https://raw.githubusercontent.com/vladstudio/mac-rclone-assistant/main/install.sh)
```

### Build from source

Requires Swift 6+ (Xcode 16+).

```bash
git clone https://github.com/vladstudio/mac-rclone-assistant.git
cd mac-rclone-assistant
./build.sh
```

This builds a release binary, assembles `Rclone Assistant.app`, and installs it to `/Applications`.

## How it works

The app is a thin GUI layer over the `rclone` CLI. It does not reimplement any rclone logic:

- `rclone config providers` — provides the schema for all provider options (types, defaults, help text, examples)
- `rclone config dump` — reads existing remotes
- `rclone config create / update / delete` — modifies remotes
- `rclone authorize` — handles OAuth flows

This means the app automatically supports new providers and options when rclone is updated.

## Requirements

- macOS 15 (Sequoia) or later
- [rclone](https://rclone.org/) (the app will offer to install it if not found)

## License

MIT
