# Jottacloud - rclone Documentation

## Overview

Jottacloud is a Norwegian cloud storage service with its own datacenters. It supports both the official service (jottacloud.com) and white-label solutions for various companies including Elkjøp, Telia, Tele2, Onlime, and MediaMarkt.

## Authentication Methods

The service offers three authentication approaches:

**Standard Authentication**: Uses OAuth designed for command-line applications. Users generate a single-use personal login token from their service's security settings rather than using browser-based OAuth flows. This creates separate refresh token families for each configuration.

**Traditional Authentication**: A more conventional OAuth variant supported by white-label services. It requires interactive login through a web browser and has strict session management limitations—only a single active authentication per machine is supported.

**Legacy Authentication**: Formerly required username/password but is now deprecated and will be removed in future versions.

## Key Configuration Details

Users access storage via paths like `remote:path` with unlimited nesting depth. The Jottacloud backend uses devices and mountpoints—the built-in Jotta device contains special mountpoints like Archive, Sync, Latest, Links, Shared, and Trash.

## Technical Features

- **Modification Times & Hashes**: Supports MD5 checksums and second-accurate modification times
- **Fast-list Support**: Reduces transaction count but may increase memory usage
- **Versioning**: Creates new file versions on upload; can be disabled with `--jottacloud-no-versions`
- **Quota Tracking**: View usage via `rclone about remote:`

## Important Limitations

Jottacloud exhibits case-insensitivity, restricts filenames to 255 characters, and special characters are mapped to unicode equivalents. The service exhibits "inconsistent behaviours regarding deleted files and folders" which may cause operations to previously deleted paths to fail.

## Restrictions on Characters

The backend replaces quotation marks, asterisks, colons, angle brackets, question marks, and pipes with their full-width unicode equivalents, plus invalid UTF-8 bytes.
