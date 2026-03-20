# Google Photos - rclone Documentation

## Overview
Rclone provides a specialized backend for transferring photos and videos to and from Google Photos. However, users should carefully review the limitations before use.

## Key Configuration Points

The setup process involves browser-based OAuth authentication. Users run `rclone config` to establish a remote connection, which launches a local webserver at `http://127.0.0.1:53682/` to handle the authentication token exchange.

## Directory Structure

The backend organizes files into distinct sections:

- **upload**: Temporary directory for single-session file uploads
- **media**: Categorized view of photos (by year, month, day, or all)
- **album**: Writable section where users can create and manage albums
- **shared-album**: Albums shared with the user or by the user
- **feature**: Special collections like favorites

## Critical Limitations

**Download Restrictions**: "From March 31, 2025 rclone can only download photos it uploaded. This limitation is due to policy changes at Google."

**Image Quality**: The API does not permit downloading images at original resolution, nor uploading in "high quality" mode. All uploads count toward storage quota at full resolution.

**Video Compression**: Downloaded videos are significantly compressed compared to those retrieved through the Google Photos web interface.

**Storage Operations**: Users cannot permanently delete files (Google Photos API limitation), delete albums, or manage files outside of albums they created.

**No Size Information**: The API doesn't return file sizes, limiting sync verification to existence checks only.

## Advanced Options

Notable configuration parameters include:
- `--gphotos-read-size`: Enables size reading (requires additional transactions)
- `--gphotos-include-archived`: Shows archived media in listings
- `--gphotos-proxy`: Uses gphotosdl for full-resolution downloads via headless browser
- `--gphotos-batch-mode`: Controls upload batching (sync/async/off)

## Custom Client ID

Users experiencing quota issues can create their own OAuth credentials by enabling the Photos Library API and configuring specific scopes for photo operations.
