# Storj Integration with Rclone

## Overview

Rclone provides integration with Storj, described as "encrypted, secure, and cost-effective object storage" enabling decentralized data storage and backup.

## Backend Options

Two approaches are available:

**Native Storj Backend**
Provides "client-side encryption" and direct node connections. Suitable for servers and desktops with sufficient resources, though uploads experience "network amplification" (~2.7x data overhead due to erasure coding).

**S3 Compatible Gateway**
Uses HTTP REST API via shared gateways, reducing network amplification to normal levels but requiring encryption key sharing with the gateway service.

## Configuration Methods

Users can authenticate via:
- Existing access grants shared by others
- API Keys from Storj projects with a custom passphrase

The setup process involves running `rclone config` and selecting either "existing" or "new" provider options.

## Key Operational Commands

Common usage patterns include:
- Creating buckets: `rclone mkdir remote:bucket`
- Uploading: `rclone copy /local/path remote:bucket/`
- Downloading: `rclone copy remote:bucket/path /local/directory/`
- Syncing: `rclone sync --interactive --progress source destination`

## Notable Limitations

The documentation notes that "rclone about is not supported" and checksums cannot be verified without downloading files, as metadata isn't calculated during upload.

## System Requirements

The native backend requires elevated file descriptor limits due to extensive TCP connections—potentially 110 per upload stream and 35 per download stream per 64MB segment.
