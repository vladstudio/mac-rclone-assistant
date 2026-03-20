# pCloud Remote Storage Configuration for rclone

## Overview
The pCloud documentation describes how to configure and use pCloud as a remote storage backend with rclone, a command-line synchronization tool.

## Key Configuration Points

**Initial Setup**: Users must authenticate through a browser-based OAuth flow. The setup process guides users through obtaining necessary tokens via `rclone config`.

**Authentication Method**: The system runs a temporary local webserver at `http://127.0.0.1:53682/` to collect authentication credentials during the OAuth process. This server operates only during the authentication window.

## Important Features

**Hash and Modification Support**: pCloud supports MD5 and SHA1 hashes in US regions, while EU regions support SHA1 and SHA256, allowing users to employ the `--checksum` flag.

**File Deletion**: Files deleted through rclone move to trash rather than permanent deletion. The subscription level determines retention duration.

**Root Folder Configuration**: Users can restrict rclone access to specific folder hierarchies using the `root_folder_id` parameter, which can be identified through the `rclone lsf` command.

**Real-Time Change Notifications**: The backend supports automatic directory refresh detection when using `rclone mount`, enabling near real-time visibility of file changes without manual intervention.

## Regional Considerations

For EU region users, the hostname must be manually set to `eapi.pcloud.com` during remote configuration to avoid token errors.
