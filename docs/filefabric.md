# Enterprise File Fabric Backend for rclone

## Overview

The Enterprise File Fabric backend enables integration with "Storage Made Easy's Enterprise File Fabric™, which provides a software solution to integrate and unify File and Object Storage accessible through a global file system."

## Configuration Process

Setup requires obtaining a token through your browser using `rclone config`. The configuration needs three main parameters:

1. **URL**: The Enterprise File Fabric endpoint (e.g., https://storagemadeeasy.com, https://eu.storagemadeeasy.com, or your custom instance)
2. **Permanent Token**: Created in your dashboard under Security → My Authentication Tokens
3. **Root Folder ID** (optional): Restricts rclone to a specific folder hierarchy

## Key Features & Limitations

**Modification Times**: The system supports modification times accurate to one second for sync detection.

**Hashing**: "The Enterprise File Fabric does not support any data hashes at this time."

**Empty Files**: The backend cannot store truly empty files. Instead, "rclone will upload an empty file as a single space with a mime type of `application/vnd.rclone.empty.file`"

**Filename Restrictions**: Uses default restricted character set replacement and handles invalid UTF-8 bytes.

## Common Commands

- `rclone lsd remote:` — lists directories
- `rclone ls remote:` — lists all files
- `rclone copy /home/source remote:backup` — copies local directory

## Configuration Options

Standard options include URL, root folder ID, and permanent token. Advanced options manage session tokens, token expiry, version info, encoding, and descriptions.
