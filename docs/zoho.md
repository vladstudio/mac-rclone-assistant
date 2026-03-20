# Zoho WorkDrive Configuration Guide for Rclone

## Overview

"Zoho WorkDrive is a cloud storage solution created by Zoho." The rclone tool supports this service at tier 3 support level, meaning it functions for many uses with some known limitations.

## Key Configuration Steps

To set up Zoho WorkDrive with rclone, users run `rclone config` and follow the interactive prompts. The process involves:

1. **OAuth Authentication**: The system launches a local webserver on `http://127.0.0.1:53682/` to collect authorization tokens
2. **Team and Workspace Selection**: Users choose their team and workspace IDs after authentication
3. **Region Selection**: Configuration requires specifying the appropriate Zoho region (com, eu, in, jp, com.cn, or com.au)

## Important Limitations

**Modification times and hashes are not supported** for this backend. Additionally, "only control characters and invalid UTF-8 are replaced," and most Unicode full-width characters are excluded during file uploads.

## Custom Client Setup

For enhanced security, users can configure their own OAuth client credentials through the Zoho API Console by:
- Creating a "Server-based Application" client
- Adding redirect URL `http://localhost:53682/`
- Optionally enabling the client in other regions

## Standard Operations

Once configured, users can perform standard file operations including listing directories, creating folders, syncing content, and checking storage quotas using the `rclone about` command.
