# Drime Cloud Storage Configuration Guide

## Overview

Drime is a cloud storage platform emphasizing rapid file transfers and sharing capabilities, available in both complimentary and premium versions.

## Setup Process

To configure Drime with rclone, users must:

1. Access the Drime web interface
2. Navigate to Settings → Developer section
3. Generate an API token for authentication
4. Use this token during rclone configuration

## Key Configuration Steps

Run `rclone config` and select Drime as the storage type. The essential parameter required is the "API Access token" obtained from your control panel.

## Important Limitations

**Modification Times & Hashes:** "Drime does not support modification times or hashes." This means synchronization relies on file size by default, though the `--update` flag can utilize upload timestamps.

**Filename Constraints:** Maximum filename length is 255 bytes in UTF-8 encoding. The backslash character (0x5C) converts to a full-width variant, and spaces at filename boundaries transform into visible space markers.

## Advanced Configuration Options

- `root_folder_id`: Restricts rclone to specific folder hierarchies
- `hard_delete`: Permanently removes files rather than moving to trash
- `upload_cutoff`: Default 200 MiB threshold for chunked uploads
- `chunk_size`: Default 5 MiB for multipart uploads

The maximum uploadable file size via streaming defaults to 48 GiB but increases with larger chunk_size adjustments.
