# FTP Backend Documentation for Rclone

## Overview
Rclone provides FTP support through the `github.com/jlaffaye/ftp` package, classified as "Tier 1" (production-grade). Path syntax follows the pattern `remote:path`, where paths without leading `/` are relative to the user's home directory.

## Configuration

Basic setup requires executing `rclone config` and providing:
- Host (required)
- Username (defaults to $USER)
- Port (defaults to 21)
- Password (must be obscured via `rclone obscure`)

The wizard offers interactive setup with options for implicit/explicit TLS connections.

### Anonymous FTP Access

Anonymous connections use the special "anonymous" username with passwords like "anonymous," "guest," or valid email addresses. Connection strings enable quick access without configuration:

```
rclone lsf :ftp,host=speedtest.tele2.net,user=anonymous,pass=IXs2wc8OJOz7SYLBk47Ji1rHTmxM:
```

### TLS Support

- **Implicit FTPS**: Establishes TLS immediately (port 990)
- **Explicit FTPS**: Upgrades plain connections to encrypted

## Configuration Options

**Standard Options:**
- `--ftp-host`: Server address
- `--ftp-user`: Authentication username
- `--ftp-port`: Connection port
- `--ftp-pass`: Obscured password
- `--ftp-tls`: Enable implicit TLS
- `--ftp-explicit-tls`: Enable explicit TLS

**Advanced Options:**
- `--ftp-concurrency`: Simultaneous connections (default: 0/unlimited)
- `--ftp-idle-timeout`: Connection pool retention (default: 1m)
- `--ftp-no-check-certificate`: Skip TLS verification
- `--ftp-disable-tls13`: Workaround for buggy servers
- `--ftp-socks-proxy`: SOCKS5 proxy support
- `--ftp-http-proxy`: HTTP CONNECT proxy URL

## Key Limitations

- **Passive mode only**: Active mode unsupported due to library constraints and security concerns
- **No checksum support**: Only file size comparison available
- **No `rclone about`**: Cannot determine free space or support "mfs" union policies
- **No server-side move**: Operations require full transfer
- **Modification times**: 1-second resolution for major servers (ProFTPd, PureFTPd, VsFTPd)

## Restricted Characters

Beyond standard restrictions, filenames cannot end with space (0x20), replaced with ␠. Server-specific limitations vary: ProFTPd forbids `*`, PureFTPd restricts `\ [ ]`.

## Usage Examples

```bash
# List remote home directory
rclone lsd remote:

# Create directory
rclone mkdir remote:path/to/directory

# Sync local to remote (with deletions)
rclone sync --interactive /home/local/directory remote:directory
```

The backend requires `EPSV`, `MLSD`, and `MFTM` extensions for optimal modification time precision across connections.
