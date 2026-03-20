# Oracle Object Storage with Rclone

## Overview

Rclone provides support for Oracle Cloud Infrastructure (OCI) Object Storage, enabling users to manage cloud storage through a command-line interface. "Object Storage provided by the Oracle Cloud Infrastructure (OCI)" serves as the foundation for this integration.

## Path Specification

Files are accessed using the format `remote:bucket` or `remote:bucket/path/to/dir` for nested directories. The `lsd` command works with just `remote:`.

## Configuration Process

Setting up Oracle Object Storage involves running `rclone config` and selecting the oracleobjectstorage type. Users must specify:
- Namespace (Object storage namespace)
- Compartment OCID (for listing buckets)
- Region
- Optional custom endpoint
- Authentication provider details

## Authentication Methods

Rclone supports six distinct authentication approaches:

**Environment Auth**: "automatically pickup the credentials from runtime(env), first one to provide auth wins"

**User Principal**: Requires OCI config file with credentials, suitable for any server location but involves user management overhead.

**Instance Principal**: Leverages OCI compute instance identity; "you don't need to configure user credentials and transfer/ save it to disk"

**Resource Principal**: For serverless functions and similar resources requiring specific environment variables.

**Workload Identity**: "grant Kubernetes pods policy-driven access to Oracle Cloud Infrastructure" resources through OKE clusters.

**No Authentication**: For accessing public buckets without credentials.

## Key Features

### Multipart Uploads
The system automatically switches to chunked uploads for files exceeding the `--oos-upload-cutoff` threshold (default 200 MiB). Files can reach 5 GiB using multipart transfers with configurable chunk sizes and concurrency.

### Modification Times and Hashes
"The modification time is stored as metadata on the object as `opc-meta-mtime` as floating point since the epoch, accurate to 1 ns." MD5 hash support is provided.

### Storage Tiers
Three tiers are available: Standard, InfrequentAccess, and Archive storage classes.

### Encryption
SSE-C (customer-managed) and KMS encryption options are supported through configuration parameters.

## Backend Commands

Specialized commands include:
- **rename**: Change object names
- **list-multipart-uploads**: View incomplete uploads in JSON format
- **cleanup**: Remove abandoned multipart uploads older than specified duration
- **restore**: Move archived objects back to Standard storage

## Advanced Options

Notable parameters include:
- `--oos-upload-concurrency`: Controls parallel chunk uploads (default 10)
- `--oos-chunk-size`: Default 5 MiB
- `--oos-disable-checksum`: Skip MD5 calculation for faster uploads
- `--oos-attempt-resume-upload`: Resume interrupted transfers
- `--oos-no-check-bucket`: Skip bucket existence checks

## Metadata Support

Objects preserve Unix-style metadata including access times, creation times, ownership (UID/GID), and file mode permissions through `opc-meta-` prefixed keys.
