# Shade Backend for Rclone - Complete Documentation

## Overview

Shade is a Tier 1 backend integrated with rclone, supporting the "Shade platform" - described as an "AI-powered cloud NAS that makes your cloud files behave like a local drive, optimized for media and creative workflows."

## Account Setup

Users must create a free account at Shade to access this backend, which includes "20GB of storage for free."

## Configuration Requirements

Two essential credentials are needed:
- **API Key**: Retrieved from account settings
- **Drive ID**: Obtained from drive settings

The configuration process involves running `rclone config` and selecting the Shade storage type, then entering these credentials.

## Key Technical Features

**Upload Handling**: The backend uses multipart uploads by default with configurable concurrency. The default chunk size is 64MB (minimum 5MB, maximum 5GB).

**Token Management**: JWT tokens are automatically managed by rclone and should not be manually configured.

**Encoding Support**: Uses slash, backslash, delete, control character, invalid UTF-8, and dot encoding by default.

## Important Limitations

- Case-insensitive filesystem (cannot distinguish "Hello.doc" from "hello.doc")
- Maximum filename length: 255 characters
- Does not support modification times or hash verification
- File deletion is permanent (no trash recovery)
- `rclone about` command unsupported, preventing free space determination

## Standard Configuration Options

| Option | Type | Required |
|--------|------|----------|
| drive_id | string | Yes |
| api_key | string | Yes |
| endpoint | string | No |
