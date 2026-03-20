# Yandex Disk Configuration Guide for Rclone

## Overview

Yandex Disk is a cloud storage platform developed by Yandex. The rclone documentation provides comprehensive setup instructions for integrating it with the rclone CLI tool.

## Setup Process

To configure Yandex Disk with rclone, users initiate the process by running `rclone config`. The interactive setup guides users through selecting the Yandex storage type and configuring OAuth credentials. The system typically uses browser-based authentication, where rclone runs a local webserver on `http://127.0.0.1:53682/` to collect authorization tokens.

## Key Features

**File Operations:** Once configured, users can perform standard operations like listing directories, creating folders, syncing content, and managing file structures at multiple directory levels.

**Modification Times:** The system stores modification times with nanosecond accuracy using custom metadata in RFC3339 format.

**Hash Support:** MD5 hash algorithms are natively supported.

**Trash Management:** The `rclone cleanup` command permanently deletes trashed files.

**Quota Tracking:** Users can check storage usage and limits using the `rclone about` command.

## Configuration Options

Standard options include client ID and client secret fields. Advanced options encompass OAuth token management, authentication URLs, token server URLs, and client credentials flow configuration. Users can also enable hard deletion (permanent removal rather than trash), configure character encoding, spoof user agents for better upload performance, and add remote descriptions.

## Important Limitations

"When uploading very large files (bigger than about 5 GiB) you will need to increase the `--timeout` parameter" due to server-side processing delays. A Yandex Mail account is mandatory for functionality, despite tokens generating without one.
