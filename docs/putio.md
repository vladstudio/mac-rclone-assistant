# put.io Backend for rclone

## Overview

put.io is a cloud storage service integrated with rclone, enabling file synchronization and management through the command-line interface.

## Path Format

Files are accessed using the format `remote:path`, with support for nested directories like `remote:directory/subdirectory`.

## Configuration Process

Users initiate setup by running `rclone config`, which guides them through an interactive authentication flow. The system opens a browser at `http://127.0.0.1:53682/` to collect OAuth tokens securely. This webserver operates only during the authentication window.

### Configuration Example

The setup creates a remote named "putio" storing OAuth credentials in JSON format:
```
[putio]
type = putio
token = {"access_token":"XXXXXXXX","expiry":"0001-01-01T00:00:00Z"}
```

## Basic Usage Commands

- **List directories**: `rclone lsd remote:`
- **List files**: `rclone ls remote:`
- **Copy local directory**: `rclone copy /home/source remote:backup`

## Character Restrictions

Beyond standard restricted characters, the backslash character (0x5C) is replaced with ＼. Invalid UTF-8 bytes are also replaced since they cannot appear in JSON strings.

## Configuration Options

**Standard options** include `--putio-client-id` and `--putio-client-secret` (typically left blank).

**Advanced options** encompass OAuth token configuration, auth/token server URLs, client credentials flow support, encoding preferences, and remote descriptions.

## Rate Limiting

put.io enforces rate limits; rclone automatically retries with server-specified delays. The `--tpslimit` flag can prevent hitting these limits.
