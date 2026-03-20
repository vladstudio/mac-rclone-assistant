# Internet Archive Backend Documentation for Rclone

## Overview

The Internet Archive backend enables rclone to work with items stored on archive.org using the IAS3 API. Path specifications follow the format `remote:bucket` or `remote:item/path/to/dir`.

## Key Features

**Basic Operations:**
- Create items: `rclone mkdir remote:item`
- List contents: `rclone ls remote:item`
- Synchronize data: `rclone sync /home/local/directory remote:item`

## Important Considerations

**Processing Delays:** The Internet Archive queues write operations per item. Changes don't appear immediately; you can monitor queue status at the catalogd URL provided. The optional `wait_archive` parameter allows rclone to wait for server processing completion before proceeding.

**File Uploads:** Avoid uploading numerous small files, as they can create processing bottlenecks in the Item Deriver Queue.

## Metadata Management

The backend supports reading and setting file metadata. Reserved fields that cannot be modified include name, source, size, and various checksums. Rclone reserves keys beginning with "rclone-" for tracking purposes.

Auto-generated metadata files can be excluded from syncs using filters like `--metadata-exclude "source=metadata"`.

## Configuration Requirements

Standard authentication options include:
- `access_key_id`: Optional IAS3 credentials (available at archive.org/account/s3.php)
- `secret_access_key`: Corresponding authentication password
- Anonymous access supported when credentials omitted

Advanced options include endpoint customization, item-level metadata configuration, checksum handling, and encoding specifications.
