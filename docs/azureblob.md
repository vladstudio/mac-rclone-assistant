# Microsoft Azure Blob Storage with rclone

## Overview

Rclone supports Microsoft Azure Blob Storage as a cloud storage backend. The service is classified as **Tier 1** (production-grade, first-class support).

## Key Configuration Methods

Rclone offers multiple authentication approaches for Azure Blob Storage:

1. **Account and Shared Key** - Most straightforward method using account name and key
2. **SAS URL** - Account-level or container-level Shared Access Signatures
3. **Service Principal** - With client secret or certificate
4. **User Credentials** - Username and password authentication
5. **Managed Service Identity** - For Azure-hosted resources
6. **Azure CLI** - Using the `az` tool for authentication
7. **Environment Variables** - Reading credentials from runtime environment

## Basic Usage

After configuration, common operations include:

- List containers: `rclone lsd remote:`
- Create container: `rclone mkdir remote:container`
- List contents: `rclone ls remote:container`
- Sync directory: `rclone sync /home/local/directory remote:container`

## Performance Features

The documentation notes that "increasing the value of `--azureblob-upload-concurrency` will increase performance at the cost of using more memory." The default setting is 16, though values up to 64 or higher may be needed for gigabit-speed connections.

## Key Limitations

- MD5 checksums upload only with chunked files when the source supports them
- `rclone about` is unsupported, preventing free space determination for mounts
- Archive tier blobs cannot be directly updated without deletion first

## Additional Capabilities

Rclone supports metadata mapping, custom upload headers, blob tiering (hot/cool/cold/archive), directory markers, and Azure Storage Emulator integration for local testing.
