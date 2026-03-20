# Proton Drive Backend for Rclone

## Overview

The documentation describes rclone's integration with Proton Drive, an end-to-end encrypted file storage service. The backend enables file transfers while maintaining client-side encryption compatibility.

## Key Features

**Status**: Currently in Beta tier (v1.64.0). The implementation relies on reverse-engineering since "Proton Drive doesn't publish its API documentation."

**Supported Operations**:
- File listing and copying
- Directory creation and management
- SHA1 hash verification
- Modification time tracking (with limitations)

## Configuration Requirements

Users must provide:
- Proton account username (email)
- Account password (obscured via rclone)
- Optional 2FA code or OTP secret key
- Optional mailbox password for dual-password accounts

**Critical Note**: "The Proton Drive encryption keys need to have been already generated after a regular login via the browser, otherwise attempting to use the credentials in rclone will fail."

## Technical Limitations

- No modification time updates supported
- Concurrent client access may cause cache staleness issues
- Filename restrictions apply (invalid UTF-8 bytes and leading/trailing spaces removed)
- No duplicate filenames allowed at the same path

## Architecture

The backend uses the Proton-API-Bridge library, which abstracts Proton's undocumented API. The documentation notes that while Proton has open-sourced some components, "there isn't official documentation available," requiring developers to implement encryption/decryption logic independently.
