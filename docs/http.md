# HTTP Remote Documentation

## Overview

The HTTP remote is a read-only solution that accesses files from web servers by parsing directory listings. It's compatible with popular servers like Apache, Nginx, and Caddy.

## Key Configuration Details

**Basic Setup:** Configure via `rclone config` with a required URL parameter (e.g., "https://example.com").

**Path Resolution:** Paths follow standard URL conventions—relative paths extend from the base URL, while absolute paths (starting with `/`) resolve from the domain root.

**Directory Detection:** Paths ending with `/` are treated as directories. Without the trailing slash, rclone sends a HEAD request to determine type, unless `--http-no-head` is enabled.

## Usage Examples

List top-level directories:
```
rclone lsd remote:
```

Display directory contents:
```
rclone ls remote:directory
```

Sync remote folder locally (with deletion):
```
rclone sync --interactive remote:directory /home/local/directory
```

## Configuration Options

**Standard Options:**
- `--http-url`: The HTTP endpoint (required)
- `--http-no-escape`: Prevents URL metacharacter encoding

**Advanced Options:**
- `--http-headers`: Inject custom HTTP headers
- `--http-no-slash`: Treats HTML files as directories when sites don't use trailing slashes
- `--http-no-head`: Disables HEAD requests for faster listings but loses file metadata

## Important Limitations

- **Read-only access only**—no uploads supported
- "Timestamps typically accurate to 1 second"
- No checksum support available
- `rclone about` is unsupported, preventing free-space detection for mount operations

## Metadata Support

The backend provides access to HTTP headers as metadata (case-insensitive, lowercase output), including Content-Type, Content-Disposition, and Cache-Control.
