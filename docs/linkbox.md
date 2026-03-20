# Linkbox

Linkbox is described as "a private cloud drive" integrated with rclone for cloud storage management.

## Configuration Process

To set up Linkbox with rclone, users execute `rclone config` and follow an interactive setup. The configuration requires a token obtained from the Linkbox admin account page at https://www.linkbox.to/admin/account.

## Key Configuration Options

**Standard Option:**
- `--linkbox-token`: Authentication credential required to connect to the service

**Advanced Option:**
- `--linkbox-description`: Optional field for documenting the remote configuration

## Technical Limitation

The documentation notes that "Invalid UTF-8 bytes will also be replaced, as they can't be used in JSON strings." This affects how certain file names and metadata are handled during operations.

## Support Status

Linkbox is classified as Tier 5, indicating it is "Deprecated: No longer maintained or supported" within rclone's support structure.

The integration allows users to manage files on Linkbox using rclone's standard commands for copying, syncing, and organizing cloud storage data alongside other supported storage systems.
