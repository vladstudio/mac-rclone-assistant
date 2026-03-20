# Quatrix Integration with Rclone

Quatrix by Maytech is a secure file-sharing platform integrated with rclone as a Tier 3 supported storage system.

## Setup Requirements

To configure Quatrix, you need an API key obtainable from your account profile at `https://<account>/profile/api-keys` or through the Maytech API documentation.

## Key Configuration Parameters

**Standard options:**
- `--quatrix-api-key`: Required authentication credential
- `--quatrix-host`: Required account hostname

**Advanced options include:**
- Chunk size management (minimal: 9.537Mi, maximal summary: 95.367Mi)
- Upload timing preferences (`effective_upload_time`)
- Hard delete capability to bypass trash
- Project folder filtering
- Custom encoding settings

## Notable Capabilities

**File handling:**
- Modification times accurate to microsecond precision
- No hash support (cannot use `--checksum`)
- Filenames support 1-255 characters, excluding `/`, `\`, and non-printable ASCII
- Deleted files remain in trash for 30 days unless hard-deleted

**Upload behavior:**
- Files exceeding 50 MiB use chunked transfers
- Memory scales with transfer count and minimal chunk size
- Dynamic chunk sizing adapts to upload speed

**Server operations:**
- Supports server-side copy and move functions
- File conflicts result in overwriting during operations

## Storage Limitations

The platform enforces account-level storage quotas, with optional per-user restrictions. Uploads fail once quota is reached.
