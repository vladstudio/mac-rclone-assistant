# Microsoft OneDrive - Rclone Documentation

## Overview
Rclone is a command-line tool for syncing files with cloud storage systems, including Microsoft OneDrive. The documentation covers configuration, usage, limitations, and troubleshooting.

## Key Configuration Points

**Initial Setup**: Users run `rclone config` to create a remote, which guides them through OAuth authentication with Microsoft. The process involves:
- Selecting "onedrive" as the storage type
- Optionally providing custom Client ID and Secret
- Authenticating via web browser
- Selecting the OneDrive account type (Personal, Business, SharePoint, etc.)

**Authentication**: As noted in the docs, "rclone runs a webserver on your local machine to collect the token as returned from Microsoft" on `http://127.0.0.1:53682/`.

## Custom Client ID Setup

Users can create their own OAuth credentials through Azure Portal instead of using rclone's default shared credentials. For OneDrive Personal, the process requires:
- Creating an app registration in Azure AD
- Setting redirect URI to `http://localhost:53682/`
- Configuring permissions including `Files.Read`, `Files.ReadWrite`, `Files.Read.All`, `Files.ReadWrite.All`, `offline_access`, `User.Read`, and `Sites.Read.All`

## Notable Limitations

**File Size**: The maximum file size supported is 250 GiB for both OneDrive Personal and Business.

**Path Length**: "The entire path, including the file name, must contain fewer than 400 characters for OneDrive, OneDrive for Business and SharePoint Online."

**File Count**: OneDrive handles at least 50,000 files per folder but may encounter errors around 100,000 files.

**Naming**: OneDrive is case-insensitive and replaces restricted characters with Unicode equivalents (e.g., `?` becomes `？`).

## Versions and Storage

OneDrive automatically creates new versions when files are modified or metadata is updated. These versions consume quota space. Users can:
- Use `rclone cleanup` to remove old versions
- Enable the `no_versions` parameter to automatically delete versions after operations

However, "Onedrive personal can't currently delete versions."

## Metadata Support

OneDrive supports system metadata for both files and directories, including:
- Creation and modification times
- User information (creator, modifier)
- Permissions (with `--onedrive-metadata-permissions` flag)
- Content type and malware detection status

## OAuth Client Credential Flow

This alternative authentication method allows rclone to use "permissions directly associated with the Azure AD Enterprise application, rather that adopting the context of an Azure AD user account." It's useful for backing up multiple users' data without their individual credentials, though it requires careful handling of Client Secret.

## Common Issues and Workarounds

**Token Expiration**: If unused for 90 days, refresh tokens expire. Solution: Run `rclone config reconnect remote:`.

**SharePoint Throttling**: Can be mitigated by setting user agent explicitly with `--user-agent "ISV|rclone.org|rclone/v1.55.1"`.

**Live Photos**: iOS Live Photos uploaded to OneDrive may show size discrepancies. Workaround: Use `--ignore-size` flag.

**Shared Files**: Files shared "with me" aren't directly supported, but users can create shortcuts in "My files" to access them through rclone.
