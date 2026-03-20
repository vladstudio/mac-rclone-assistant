# Swift (OpenStack Object Storage)

## Overview

This page documents rclone's support for Swift, which refers to OpenStack Object Storage. The documentation covers configuration, usage, options, and troubleshooting for this cloud storage backend.

## Supported Commercial Implementations

The page lists several providers offering Swift services:
- Rackspace Cloud Files
- Memset Memstore
- OVH Object Storage
- Oracle Cloud Storage
- Blomp Cloud Storage
- IBM Bluemix Cloud ObjectStorage Swift

## Basic Configuration

Path format follows the pattern `remote:container` or `remote:` for listing commands, with optional subdirectories like `remote:container/path/to/dir`.

Users configure Swift through the `rclone config` command, which provides an interactive setup process. The configuration supports multiple authentication methods including environment variables and alternate authentication tokens.

## Key Features

**Modification Times and Hashes**: The backend stores modification times as metadata (`X-Object-Meta-Mtime`) and supports MD5 hash verification.

**Large File Handling**: Files above a configurable threshold (default 5 GiB) are chunked using dynamic large objects (DLO).

**Fast Listing Support**: The remote supports the `--fast-list` flag for reduced transactions.

## Configuration Options

Standard options include authentication credentials (user, key, auth URL) and tenant/region specifications. Advanced options control chunking behavior, pagination handling, and segment storage location.

## Important Limitations

The Swift API doesn't return correct MD5 checksums for segmented files, preventing checksum verification for these objects.

## OVH Cloud Archive

The documentation includes specific guidance for using rclone with OVH's archive storage service, noting that frozen objects require unfreezing before retrieval, which triggers automatic retry handling.
