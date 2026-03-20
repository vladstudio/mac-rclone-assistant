# Internxt Drive Documentation

## Overview
Internxt Drive is described as "a zero-knowledge encrypted cloud storage service." The rclone integration is classified as Tier 2 (Stable: Well-supported, minor gaps).

## Key Configuration Details

Users configure Internxt by running `rclone config` and providing:
- Email address for the Internxt account
- Account password
- Optional two-factor authentication code when prompted

## Important Limitations

The documentation notes that "The Internxt backend may not work with all account types." Users should verify compatibility through Internxt's pricing page or support channels before proceeding.

## Security Recommendations

The guide emphasizes that credentials stored in configuration files should be protected: "It is **strongly recommended** to encrypt your rclone config to protect these sensitive credentials" using `rclone config password`.

## Technical Capabilities

- **Path format**: `remote:path` with unlimited depth
- **Hash support**: Not available
- **Modification times**: Read-only from server
- **File operations**: Supports listing, copying, syncing, mounting, and storage usage checks

## Configuration Options

Standard options include email and password parameters. Advanced options offer hash validation control, encoding specifications, and remote descriptions.
