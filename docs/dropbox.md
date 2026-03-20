# Dropbox - rclone Documentation

## Overview
Rclone is a tool for syncing and managing files across cloud storage systems, including Dropbox. The documentation provides comprehensive guidance on configuring and using Dropbox with rclone.

## Key Configuration Points

**Initial Setup:**
Users begin with `rclone config` command, which guides them through obtaining an OAuth token from Dropbox. The process involves visiting a Dropbox authorization URL and entering a code to complete authentication.

**Path Format:**
Paths use the format `remote:path`, allowing nested directories like `remote:directory/subdirectory`.

## Important Features

**Dropbox for Business:**
- Personal folders accessed via `remote:` or `remote:path/to/file`
- Team folders require a leading slash: `remote:/TeamFolder`
- Root access uses `remote:/`

**Batch Mode Uploads:**
Three modes are available:
- **Off**: No batching (legacy, slower)
- **Sync**: Batches uploads with integrity checking (default)
- **Async**: Batches without confirmation (fastest but requires verification)

**File Handling:**
- Dropbox-specific hash type checked for all transfers
- Modification times supported but require file re-upload
- Exportable files (Paper documents) converted during download
- Default export formats: HTML and Markdown

## Notable Limitations

- Case-insensitive filesystem (cannot have "Hello.doc" and "hello.doc")
- Certain filenames disallowed (e.g., "thumbs.db")
- Copyright-protected files may fail with restricted_content errors
- Directories exceeding 10,000 files require workaround for purge operations
- Paper document modification times may be imprecise

## Configuration Options

Standard options include `--dropbox-client-id` and `--dropbox-client-secret`. Advanced options cover OAuth tokens, chunk sizes, shared files/folders, batch settings, and export preferences.

Users can create custom Dropbox App IDs for dedicated API credentials and enhanced permissions management.
