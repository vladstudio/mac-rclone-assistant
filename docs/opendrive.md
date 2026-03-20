# OpenDrive - rclone Documentation

## Overview

OpenDrive is a cloud storage backend supported by rclone (v1.42, Tier 1 - Production-grade). Users can manage files through path syntax like `remote:path` with unlimited directory depth.

## Configuration

Setup requires running `rclone config` and providing:
- **Username**: Your OpenDrive account username
- **Password**: Must be obscured using `rclone obscure`

Example basic configuration:
```
Storage> opendrive
Username: [your username]
Password: [encrypted password]
```

## Key Features

**File Operations Support:**
- Modification times accurate to 1-second precision for sync detection
- MD5 hash algorithm support
- Standard rclone commands: copy, sync, move, delete, list operations

**Access Control Options:**
- Private (default) - selective user access
- Public - downloadable by anyone with the link
- Hidden - accessible only with direct URL knowledge

## Advanced Configuration

| Option | Details |
|--------|---------|
| `--opendrive-chunk-size` | Upload chunk size (default: 10Mi, buffered in memory) |
| `--opendrive-access` | Permission level for uploads |
| `--opendrive-encoding` | Character encoding handling |
| `--opendrive-description` | Remote description metadata |

## Filename Restrictions

OpenDrive restricts certain characters, which rclone maps to unicode equivalents:
- Forward slash `/` → `／`
- Asterisk `*` → `＊`
- Question mark `?` → `？`
- Colon `:`, quotes `"`, backslash `\`, pipe `|`, angle brackets also restricted

**Case Sensitivity Note:** "OpenDrive is case insensitive so you can't have a file called 'Hello.doc' and one called 'hello.doc'."

## Limitations

- Case-insensitive filesystem prevents duplicate files with different cases
- `rclone about` unsupported - cannot determine free space for mounts or use "most free space" policy in unions
