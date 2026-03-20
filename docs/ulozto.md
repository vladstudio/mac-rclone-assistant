# Uloz.to on Rclone - Complete Documentation

## Overview
Uloz.to is a cloud storage backend supported by rclone at **Tier 3** status, meaning it "works for many uses; known caveats."

## Configuration Setup

To configure Uloz.to with rclone, run `rclone config` and provide:

- **app_token**: Application token from the API documentation at https://uloz.to/upload-resumable-api-beta or customer service
- **username**: Your Uloz.to account username
- **password**: Your account password (optional but recommended)

### Example Commands After Setup

- List root folders: `rclone lsd remote:`
- List all files: `rclone ls remote:`
- Backup local folder: `rclone copy /home/source remote:backup`

## Key Technical Details

**Authentication**: Username and password is the only reliable method. The API key is reserved for Uloz.to's own application and "using it in different circumstances is unreliable."

**File Timestamps & Hashes**: The backend encodes client-provided timestamps and hashes in a free-form API field with microsecond precision. MD5 verification occurs during upload; subsequent operations use client-side calculated hashes.

**Filename Restrictions**: Beyond standard rclone restrictions, the backslash character (`\`, U+5C) is replaced with a fullwidth equivalent (`＼`, U+FF3C). Filenames are limited to 255 characters maximum.

**Upload Method**: Files upload via single HTTP request, requiring stable connections for large files.

**File Deletion**: Files move to recycle bin (permanently deleted after 30 days); folders delete immediately. Trash emptying isn't implemented in rclone.

## Advanced Configuration Options

- **root_folder_slug**: Set a specific folder as root using its URL identifier
- **list_page_size**: Page size for list commands (1-500, default 500)
- **encoding**: Character encoding configuration

## Limitations

- Rate limiting exists but specifics are undisclosed
- "rclone about is not supported by the Uloz.to backend" and cannot determine free space
- Maximum filename length: 255 characters
