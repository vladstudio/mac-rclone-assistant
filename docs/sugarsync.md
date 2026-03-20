# SugarSync Backend Documentation for rclone

## Overview

This page documents rclone's SugarSync integration, which enables users to synchronize files with SugarSync's cloud service. The backend is classified as "Tier 3" with support for many uses but known limitations.

## Configuration Process

Users configure SugarSync through interactive setup via `rclone config`. The process requests:
- A remote name (e.g., "remote")
- Storage type selection (sugarsync)
- Optional custom credentials or use of rclone defaults
- Hard delete preference
- Email and password for initial token generation

The system notes that credentials are temporary and only used to obtain the initial authorization token.

## Key Features and Limitations

**Supported Operations:**
- Listing sync folders and files
- Copying files to SugarSync folders
- Moving and syncing data

**Important Constraints:**
- Modification times and hash checking unsupported; syncs default to size-only verification
- File creation limited to subfolders; top-level folder creation unavailable
- Special characters in filenames are restricted per the platform's defaults
- Invalid UTF-8 bytes are automatically replaced

## File Deletion Behavior

By default, deleted files move to a "Deleted items" folder. Users can enable permanent deletion using the `--sugarsync-hard-delete` flag or configuration parameter.

## Configuration Options

Standard options include app credentials and hard delete settings. Advanced options manage refresh tokens, authorization details, and internal folder identifiers that are typically configured automatically.

## Notable Limitation

The backend does not support `rclone about`, preventing free space determination for mount operations.
