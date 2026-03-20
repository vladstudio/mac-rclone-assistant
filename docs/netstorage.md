# Akamai NetStorage with Rclone

## Overview

Rclone provides integration with Akamai NetStorage, a cloud storage solution. The service is classified as "Tier 1" (production-grade, first-class support).

## Path Structure

Paths follow the format `remote:` with optional subdirectories. When using CP codes, the structure is typically:
- **With CP code**: `[domain-prefix]-nsu.akamaihd.net/123456/subdirectory/`
- **Without CP code**: `[domain-prefix]-nsu.akamaihd.net`

## Configuration Setup

Users initiate setup via `rclone config`, specifying:
- Remote name
- Storage type (netstorage)
- Protocol (HTTP or HTTPS; HTTPS recommended)
- Host information including domain and CP code
- Account credentials
- Secret/G2O key for authentication

## Key Features

**Directory Handling**: NetStorage distinguishes between explicit directories (physically created) and implicit directories (created during file uploads). Rclone intercepts uploads to ensure explicit directory creation for compatibility with other Akamai services.

**ListR Support**: The remote supports fast recursive listing via the "list" API action. Commands like `lsf -R` use this by default; the `--fast-list` flag enables it for other operations like sync.

**Symlink Support**: Rather than creating `.rclonelink` files, the backend uses NetStorage's symlink API for upload operations.

**Purge Operations**: Uses the quick-delete API when enabled; falls back to standard deletion otherwise.

## Backend Commands

Two specialized commands are available:
- `du`: Returns disk usage for specified directories
- `symlink`: Creates symbolic links on ObjectStore
