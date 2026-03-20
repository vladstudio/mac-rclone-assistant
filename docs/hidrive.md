# HiDrive Documentation

## Overview
This page documents rclone's HiDrive integration, a Tier 1 (production-grade) storage backend. HiDrive is configured via OAuth authentication and accessed using paths like `remote:path`.

## Key Configuration Points

**Initial Setup**: Users run `rclone config` to authenticate through a browser-based OAuth flow. The system launches a local webserver on `http://127.0.0.1:53682/` temporarily to collect authentication tokens.

**Token Security**: "OAuth-tokens can be used to access your account and hence should not be shared with other persons." The documentation recommends encrypting configuration files to protect refresh tokens.

**Token Refresh**: Refresh tokens expire after 60 days of non-use. Users can reconnect using `rclone config reconnect remote:` if tokens become invalid.

## Technical Features

- **Modification Times & Hashes**: Supports 1-second accuracy for timestamps and HiDrive's native hash type
- **File Transfers**: Implements chunked uploads for files exceeding 96 MiB, with configurable concurrency
- **Filename Restrictions**: Cannot store files/folders containing `/`, null bytes, or named `.` or `..`; max 255 character names

## Configuration Options

Standard options include OAuth credentials and access scopes (read/write or read-only). Advanced options allow customization of chunk size (default 48Mi), upload cutoff (default 96Mi), and concurrency (default 4 concurrent uploads).

## Limitations

- **Symbolic Links**: Native symlinks are ignored; rclone cannot manage them directly
- **Sparse Files**: Copying sparse files converts holes to null-byte regions, consuming additional disk space
