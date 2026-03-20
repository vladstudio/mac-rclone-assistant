# PikPak on Rclone - Complete Documentation

## Overview
PikPak represents "a private cloud drive" service integrated with rclone, designated as a Tier 1 (production-grade) storage system.

## Configuration Setup

The initial configuration requires running `rclone config` and providing:
- Remote name
- Storage type selection (PikPak)
- Username credentials
- Password entry
- Optional advanced settings

Upon completion, the system generates a token for authentication.

## Core Features

**Modification Times & Hashes:**
- PikPak maintains modification timestamps on objects
- MD5 hash algorithm support available
- Timestamps update during uploads but cannot be modified independently

## Standard Configuration Options

Two mandatory parameters include:
- `--pikpak-user`: Username requirement
- `--pikpak-pass`: Password (requires obscuration via rclone obscure command)

## Advanced Configuration Parameters

Multiple optional settings control behavior:

| Parameter | Purpose |
|-----------|---------|
| device_id | Authorization device identifier |
| user_agent | HTTP user agent customization |
| root_folder_id | Non-root folder starting point |
| use_trash | Trash vs. permanent deletion (default: true) |
| trashed_only | Display exclusively trashed files |
| no_media_link | Original links instead of media links |
| hash_memory_limit | Disk caching threshold (default: 10Mi) |
| upload_cutoff | Chunked upload threshold (default: 200Mi) |
| chunk_size | Multipart upload chunk size (default: 5Mi) |
| upload_concurrency | Concurrent chunk uploads (default: 4) |

## Backend Commands

**addurl:** "Add offline download task for url" - enables remote downloading to specified directories

**decompress:** "Request decompress of file/files in a folder" - supports password-protected archives with optional source file deletion

## Known Limitations

1. MD5 hashes may return empty values, particularly for user-uploaded content
2. Deleted files remain visible with `--pikpak-trashed-only` flag even after trash emptying for several days
