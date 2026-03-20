# Gofile Configuration Guide for rclone

## Overview

According to the documentation, "Gofile is a content storage and distribution platform" with services offered "for free or at a very low price." To use rclone with Gofile, you need a premium account and an API token from your account's "My Profile" section.

## Setup Process

The configuration requires running `rclone config` and selecting Gofile as the storage type. You'll need to provide your "API Access token" obtained from the web control panel.

## Key Features

**File Support:**
- Modification times with 1-second resolution
- MD5 hash support for checksum verification
- Maximum filename length: 255 unicode characters

**Public Sharing:**
The service supports creating public links to files or directories via `rclone link`, with optional expiration settings.

**Folder Restrictions:**
You can set a `root_folder_id` to restrict rclone to a specific folder hierarchy.

## Important Limitations

- Total item limit: 100,000 files maximum
- Directory cache shouldn't exceed 24 hours to ensure file availability
- Supports duplicate filenames, though rclone cannot sync these to standard filesystems (use `rclone dedupe` to resolve)
- Special characters like `!`, `"`, `*`, `:`, and others are replaced with full-width alternatives
