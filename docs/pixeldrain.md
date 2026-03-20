# Pixeldrain Backend for Rclone

## Overview

Pixeldrain is a cloud storage backend supported by rclone (version 1.68, Tier 1 status). It provides access to Pixeldrain's premium filesystem feature, distinct from their free file-sharing service.

## Key Requirements

To use Pixeldrain's personal filesystem, users need:
- A Pixeldrain account
- Either a Prepaid plan or Patreon-based subscription
- An API key generated from the account settings

## Configuration Methods

**With Account Access:**
Users authenticate by generating an API key and running `rclone config`, then selecting Pixeldrain storage type and entering their credentials.

**Without Account (Read-Only):**
"It is possible to gain read-only access to publicly shared directories through rclone" using only the directory ID found in shared directory URLs.

## Standard Configuration Options

- **API Key**: Located at pixeldrain.com/user/api_keys
- **Root Folder ID**: Defaults to 'me' for personal filesystem; can be set to shared directory IDs

## Advanced Features

The backend supports:
- Custom API endpoint configuration
- File modes and creation times
- Remote descriptions
- Metadata including birth time, file mode, and modification time in RFC 3339 format

## Resources

Official documentation, API key management, and filesystem guides are available through Pixeldrain's website and the rclone documentation portal.
