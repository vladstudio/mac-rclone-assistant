# Files.com Integration with Rclone

Files.com is a cloud storage service available as a Tier 1 storage option in rclone v1.68. The integration allows users to securely store and share files through authentication via site subdomain, username, and password, or through API keys.

## Authentication Methods

Users can authenticate using either traditional credentials or an API key approach. The `rclone config` command guides users through interactive setup where they specify their site subdomain, username, and password for Files.com account access.

## Key Configuration Features

**Standard Options:**
- Site subdomain or custom domain specification
- Username for authentication
- Password for authentication (requires obscuring via `rclone obscure`)

**Advanced Options:**
- API key authentication alternative
- Encoding configuration with default: "Slash,BackSlash,Del,Ctl,RightSpace,RightCrLfHtVt,InvalidUtf8,Dot"
- Optional remote description field

## Checksum Support

As of December 2024, Files.com supports multiple checksum algorithms. Users must enable checksums through the "File Integrity" section in "Data Governance." Currently, rclone supports CRC32 and MD5, with MD5 recommended for end-to-end integrity verification during synchronization operations.

## Common Operations

Users can perform standard rclone operations including listing files, creating directories, recursive content listing, and synchronizing local directories to remote storage with deletion of excess files.
