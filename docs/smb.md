# SMB / CIFS Remote Storage Configuration Guide

## Overview

SMB (Server Message Block) is a network file-sharing protocol that rclone supports through the go-smb2 library. The documentation describes how to configure and use SMB/CIFS shares as a remote storage backend.

## Key Configuration Points

**Path Format:** Remote shares are accessed as `remote:sharename` or `remote:sharename/path/to/directory`.

**Authentication Requirements:** The system requires either a named user account or the special "guest" user with an empty password; anonymous access is not supported.

## Standard Connection Options

The configuration requires:
- **Host:** The SMB server hostname (e.g., "example.com")
- **User:** Username for authentication (defaults to current system user)
- **Port:** Connection port, typically 445
- **Password:** Encrypted credential (must be obscured via rclone tools)
- **Domain:** NTLM authentication domain (defaults to "WORKGROUP")

## Additional Features

The backend supports advanced authentication methods including Kerberos, configurable connection pooling with idle timeouts, and character encoding specifications. Special shares and printer access are filtered by default for security purposes.

## Important Limitations

"You can't access the shared printers from rclone, obviously" and the system avoids 8.3 filename formats during uploads by encoding trailing spaces and periods.
