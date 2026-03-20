# Sia Storage Integration with rclone

## Overview

Sia is a blockchain-based decentralized cloud storage platform accessible through rclone. As stated in the documentation, "Sia is a decentralized cloud storage platform based on the blockchain technology" that allows users to "use it like any other remote filesystem or mount Sia folders locally."

## Prerequisites

Before using rclone with Sia, you need either Sia-UI or siad (the Sia daemon) running locally or on your network. The daemon communicates via HTTP API, typically on port 9980.

## Configuration Steps

To set up a Sia remote named "mySia," run `rclone config` and select sia as the storage type. You'll need to provide:

- **API URL**: Default is `http://127.0.0.1:9980` for local daemon
- **API Password**: Found in the apipassword file in `HOME/.sia/` directory

## Key Configuration Options

**Standard Options:**
- `--sia-api-url`: Daemon endpoint address
- `--sia-api-password`: Authentication credential (requires obscuring)

**Advanced Options:**
- `--sia-user-agent`: Defaults to "Sia-Agent"
- `--sia-encoding`: Character encoding handling for special symbols
- `--sia-description`: Remote description field

## Important Limitations

The documentation notes several constraints: "Modification times not supported," "Checksums not supported," and "rclone about not supported." Additionally, Sia doesn't permit control characters or certain symbols in filenames, though rclone handles encoding transparently.

## Remote Access Considerations

For accessing daemons on remote nodes, you must run siad with `--disable-api-security` and enforce an API password via environment variable or configuration file.
