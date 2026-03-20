# Mega Storage Backend for Rclone - Complete Documentation

## Overview

Mega is a cloud storage service emphasizing client-side encryption where files are encrypted locally before upload. Rclone provides a backend supporting Mega's file transfer features with the same encryption approach.

> "This is an rclone backend for Mega which supports the file transfer features of Mega using the same client side encryption."

## Configuration Setup

Users configure a Mega remote through interactive setup:

```
rclone config
```

The process requests:
- Remote name
- Storage type selection (mega)
- User credentials (email)
- Password entry
- Optional 2FA code

**Important note:** Encryption keys must already exist from a browser login before using rclone credentials.

## Common Usage Examples

**List top-level directories:**
```
rclone lsd remote:
```

**List all files:**
```
rclone ls remote:
```

**Backup local directory:**
```
rclone copy /home/source remote:backup
```

## Technical Limitations

### Metadata Support
Mega lacks support for modification times and hash values in rclone operations.

### Filename Restrictions

| Character | Value | Replacement |
|-----------|-------|-------------|
| NUL | 0x00 | ␀ |
| Forward slash | 0x2F | ／ |

Invalid UTF-8 bytes are replaced due to JSON string incompatibility.

### Duplicate File Handling

> "Mega can have two files with exactly the same name and path (unlike a normal file system)."

The `rclone dedupe` command resolves duplicates.

## Authentication Issues

### Login Failures ("Object not found")

Using MEGAcmd utility helps diagnose connection problems. The tool distinguishes between credential issues and configuration problems.

### Rate Limiting and Blocking

Mega implements blocking mechanisms against rapid successive commands. Running the same operation repeatedly (example: 90 iterations of `rclone link remote:file`) triggers temporary access rejection lasting approximately one week.

**Mitigation strategies:**
- Space commands with 3-second delays
- Mount remotes using `rclone mount` to reduce login frequency
- Use `rclone rcd` with `rclone rc` for API-based command execution

Passwords containing special characters sometimes cause authentication failures; temporarily using alphanumeric-only passwords may help diagnose issues.

## Configuration Options

### Standard Options

**User name** (`--mega-user`):
- Required field for authentication
- Environment variable: `RCLONE_MEGA_USER`

**Password** (`--mega-pass`):
- Must be obscured using `rclone obscure`
- Environment variable: `RCLONE_MEGA_PASS`

**2FA Code** (`--mega-2fa`):
- Optional two-factor authentication
- Environment variable: `RCLONE_MEGA_2FA`

### Advanced Options

**HTTPS Usage** (`--mega-use-https`):
- Forces encrypted connections
- Mitigates ISP HTTP throttling
- Increases CPU usage
- Default: disabled

**Permanent Deletion** (`--mega-hard-delete`):
- Bypasses trash folder
- Default: disabled (moves to trash)

**Debug Output** (`--mega-debug`):
- Requires `-vv` flag
- Produces extended diagnostic information

**Encoding** (`--mega-encoding`):
- Default: Slash, InvalidUtf8, Dot

**Session and Master Key** (internal use only):
- `--mega-session-id`
- `--mega-master-key`

## Resource Considerations

Large files and extensive operations may significantly increase memory consumption. Cloud deployments require adequate instance specifications with sufficient memory and CPU resources. Monitor resource utilization during list and sync operations.

## Backend Limitations

The implementation relies on the go-mega library, an open-source implementation of the Mega API. Complete protocol documentation lacks availability beyond the official C++ SDK source code, resulting in potential remaining implementation gaps.

Duplicate file support in Mega creates operational confusion incompatible with rclone's filesystem assumptions.
