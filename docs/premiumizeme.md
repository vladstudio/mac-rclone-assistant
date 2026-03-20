# premiumize.me Configuration Guide for rclone

## Overview
This documentation covers integration between rclone and premiumize.me cloud storage, classified as Tier 3 support.

## Setup Process
Configuration requires obtaining an OAuth token through your browser. The `rclone config` command initiates an interactive setup where users authenticate via a local webserver running on `http://127.0.0.1:53682/`.

## Key Technical Details

### Path Format
Files are accessed using the syntax: `remote:path` or `remote:directory/subdirectory`

### Limitations
- **Case insensitivity**: Cannot simultaneously store "Hello.doc" and "hello.doc"
- **Character restrictions**: Backslash and quotation marks are remapped to Unicode equivalents (＼ and ＂)
- **Filename length**: Maximum 255 characters supported
- **No modification times or hashes**: Syncing defaults to `--size-only` checking

### Configuration Options
Standard options include OAuth client credentials, while advanced options cover token management, authentication URLs, and encoding preferences. The default encoding handles slash, double quotes, backslash, control characters, and invalid UTF-8 bytes.

## Authentication Methods
- Primary: OAuth browser-based authentication
- Alternative: API key authentication (not recommended for standard use)
- Advanced: Client credentials OAuth flow available

The documentation notes that firewall rules may require temporarily unblocking the local webserver port during authentication.
