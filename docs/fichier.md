# 1Fichier Backend for Rclone

## Overview
The 1Fichier backend enables rclone to interact with 1fichier.com cloud storage. A Premium subscription is required to access the API.

## Configuration

To set up a 1Fichier remote, run `rclone config` and select the fichier storage type. You'll need to provide an API key obtained from https://1fichier.com/console/params.pl.

Example remote configuration:
```
- type: fichier
- api_key: example_key
```

## Basic Usage

- List top-level directories: `rclone lsd remote:`
- List all files: `rclone ls remote:`
- Copy local directory to backup: `rclone copy /home/source remote:backup`

## Key Features & Limitations

**Supported:** Whirlpool hash algorithm for file verification

**Not Supported:**
- Modification times
- The `rclone about` command (cannot determine free space for mounts)

**Notable Characteristic:** The service permits duplicate files with identical names and paths, which can cause syncing complications.

## Restricted Characters

Beyond standard restrictions, 1Fichier replaces these characters: backslash, less-than, greater-than, quotes, dollar sign, backtick, and apostrophe. Filenames cannot start or end with spaces.

## Advanced Options

- `--fichier-shared-folder`: Access shared folders
- `--fichier-file-password` / `--fichier-folder-password`: Protected content access
- `--fichier-cdn`: Enable CDN download links
