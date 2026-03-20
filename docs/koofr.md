# Koofr - rclone Documentation

## Overview

Koofr is a cloud storage service supported by rclone at version 1.47 with Tier 2 stability status. The documentation covers configuration, usage, and integration with Koofr-compatible storage providers.

## Key Configuration Points

To set up Koofr with rclone, users must first generate an application password through the web interface. The setup process involves running `rclone config` and selecting Koofr as the storage type. Users are prompted to enter their username and the application password created beforehand.

## Storage Providers

The system supports three provider options:

1. **Koofr** - The original provider at https://app.koofr.net/
2. **Digi Storage** - A Romanian cloud service at https://storage.rcs-rds.ro/
3. **Other** - Custom Koofr API-compatible services requiring endpoint specification

## Technical Configuration

Standard options include specifying the provider, user credentials, and password. Advanced options allow selecting alternative mounts via Mount ID and controlling modification time support. The encoding defaults to handling slash, backslash, delete, control characters, and invalid UTF-8 sequences.

## Limitations and Filename Restrictions

The platform is case-insensitive, preventing simultaneous storage of files differing only in capitalization. The backslash character (0x5C) is replaced with a full-width variant (＼), and invalid UTF-8 bytes are replaced per standard rclone protocols.

## Practical Usage Examples

Common operations include listing directories with `rclone lsd koofr:` and copying local directories with `rclone copy /home/source koofr:backup`.
