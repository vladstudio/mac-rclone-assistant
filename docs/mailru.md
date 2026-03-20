# Mail.ru Cloud Storage with Rclone

Mail.ru Cloud is a storage service from Mail.Ru Group offering features like deep directory paths, file sharing via public links, and transparent deduplication using a modified SHA1 algorithm.

## Key Configuration Requirements

To use rclone with Mail.ru Cloud, you must create an app-specific password rather than using your regular login credentials. The setup process involves:

1. Accessing your Mail.ru account security settings
2. Navigating to "Пароли для внешних приложений" (app passwords)
3. Creating a new password with appropriate permissions
4. Running `rclone config` to establish the remote connection

As noted in the documentation, "rclone **will not work** with your normal username and password - it will give an error like `oauth2: server response missing access_token`."

## Important Limitations

The service enforces case-insensitive file handling, meaning you cannot have both "Hello.doc" and "hello.doc" in the same location. File size limits vary by account type: free accounts are capped at 2GB per file, while paid accounts have unlimited file sizes.

## Notable Features

The "speedup" or "put by hash" optimization allows rclone to skip full uploads when identical files already exist in storage, checking across all Mail.ru user accounts. This feature is especially useful for commonly available files like books or media content.

Deleted files move to trash by default and don't immediately free storage quota—using `rclone cleanup remote:` permanently removes trashed items.
