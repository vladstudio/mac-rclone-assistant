# iCloud Drive - rclone Documentation

## Overview
This page documents rclone's support for iCloud Drive, classified as "Tier 4" (Experimental). The integration enables syncing and managing files on iCloud Drive through rclone's command-line interface.

## Key Configuration Requirements

**Authentication Method:**
- Regular iCloud password with two-factor authentication (2FA) required
- "App specific passwords won't be accepted"
- Trust tokens remain valid for 30 days, requiring re-authentication afterward

**Critical Limitation:**
Advanced Data Protection must be disabled. Users must ensure their iPhone settings have "Access iCloud Data on the Web" enabled and "Advanced Data Protection" turned off.

## Setup Process

Configuration occurs through `rclone config`, which guides users through entering:
- Apple ID credentials
- Password (which gets encrypted in configuration)
- 2FA code when prompted
- Automatic generation of trust tokens and cookies

## Troubleshooting

The main issue documented is missing PCS cookies, which indicates Advanced Data Protection remains enabled. Resolution requires:
- Disabling Advanced Data Protection in iCloud settings
- Clearing cookies and trust_token fields from configuration
- Running `rclone reconnect remote:`
- Note: Settings changes may require several hours or days to take effect

## Standard Configuration Options

Core required parameters include apple_id, password, with optional trust_token and cookies fields for internal use.
