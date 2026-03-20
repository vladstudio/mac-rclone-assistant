# Google Drive - Rclone Documentation

## Overview

Rclone is a command-line tool for syncing files with cloud storage systems. The Google Drive backend enables users to manage their Drive files remotely using paths specified as `drive:path`.

## Key Configuration Features

**Authentication Methods:**
Rclone supports multiple approaches for Google Drive authentication:
- Interactive browser-based OAuth2 flow (default)
- Service Account credentials for unattended operations
- Environment variable-based authentication

**Scope Options:**
Users can restrict permissions through five scope levels, from full access (`drive`) to read-only metadata access (`drive.metadata.readonly`). The documentation notes that "rclone allows you to select which scope you would like for rclone to use."

## Advanced Features

**Shared Drives Support:**
The tool integrates with Google Workspace shared drives, enabling team-based file synchronization across organizational boundaries.

**Shortcut Handling:**
Google Drive shortcuts are treated intelligently—file shortcuts appear as destination files, while folder shortcuts display linked contents transparently.

**Google Docs Integration:**
Native support for exporting Google documents in multiple formats (DOCX, XLSX, PPTX, PDF, ODF variants). Import conversion is also available with configurable format mappings.

**Fast-List Optimization:**
Batch API requests combining up to 50 parent filters reportedly improve performance by "up to 20x faster than the regular method."

## Operational Limitations

**Rate Limiting:**
Rclone documentation warns of Google Drive rate limits constraining transfers to "about 2 files per second." Server-side copying operations have separate rate restrictions.

**File Size Uncertainties:**
Google Docs display size `-1` in listings but `0` in VFS contexts, creating operational complications for mount operations and directory calculations.

**Duplication Issues:**
Google Drive occasionally duplicates uploaded files. The `rclone dedupe` command resolves this problem.

## Security Considerations

Custom OAuth client IDs are recommended over default shared credentials to avoid hitting global query rate limits. Google's verification process requires submitting applications, though users can proceed with test credentials.

## Backend Commands

Specialized operations include:
- File/directory shortcuts creation
- Shared Drive enumeration
- Orphaned file recovery or deletion
- ID-based file copying and moving
- Query-based file searches using Google's search syntax
