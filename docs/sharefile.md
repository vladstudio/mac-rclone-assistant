# Citrix ShareFile with rclone

Citrix ShareFile is integrated with rclone as a cloud storage backend. Here's the essential information:

## Overview

"Citrix ShareFile is a secure file sharing and transfer service aimed as business." The service operates at Tier 5 status, indicating it is deprecated and no longer actively maintained.

## Configuration

Users configure ShareFile through `rclone config`, which guides them through OAuth authentication. The process involves:

- Setting a remote name
- Selecting the root folder (Personal Folders, Favorites, shared folders, connectors, or top-level access)
- Authenticating via web browser
- Storing OAuth tokens securely

## Key Features

**File Operations:**
- Supports modification times accurate to 1 second
- MD5 hash verification available
- Chunked transfers for files over 128 MiB
- Maximum filename length: 256 characters

**Character Restrictions:**
The backend replaces several special characters (backslash, asterisk, angle brackets, question mark, colon, pipe, quotes) with full-width Unicode equivalents to comply with ShareFile's limitations.

## Limitations

- Case-insensitive filesystem (cannot distinguish "Hello.doc" from "hello.doc")
- `rclone about` is unsupported, preventing free space detection
- Cannot be used with union remotes requiring space-based policies

## Configuration Options

Standard options include client credentials, root folder selection, and upload parameters. Advanced options allow customization of chunk size (64 MiB default), upload cutoff (128 MiB), and API endpoints.
