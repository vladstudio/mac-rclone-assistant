# Rclone: Overview of Cloud Storage Systems

Source: https://rclone.org/overview/

Rclone is a command-line tool that provides a unified interface for managing files across numerous cloud storage providers. The overview page documents the capabilities and limitations of 70+ supported storage systems, detailing features like hash support, modification time handling, case sensitivity, and optional operations.

## Key Features

### Hash Support
Various algorithms (MD5, SHA1, SHA256, BLAKE3, etc.) enable integrity checking during transfers via the `--checksum` flag.

### Modification Time (ModTime)
Categorized as unsupported (`-`), read-only (`R`), or read/write (`R/W`), with directory variants (`DR/W`). Storage systems with a `-` in the ModTime column means modification read on objects is not the modification time of the file when uploaded.

### Case Sensitivity
Identifies which backends treat filenames as case-insensitive, causing sync complications between systems. Windows typically operates case-insensitive though case is preserved; OSX usually case-insensitive; Linux typically case-sensitive.

### MIME Type Support
Some providers allow reading or writing MIME type metadata for proper HTTP serving.

### Filename Encoding
Rclone transparently replaces restricted characters with similar-looking Unicode characters to preserve compatibility across systems.

### Metadata
Support levels range from read-only system metadata to full read/write access for both system and user metadata.

## Optional Features

Advanced capabilities documented in the overview:
- Server-side copy and move operations
- Directory movement
- Recursive listing for faster operations
- Stream uploads without pre-calculating file size
- Multi-threaded uploads
- Link sharing functionality
- Quota information retrieval
- Empty directory support

## Storage Providers

| Provider | Docs Path |
|----------|-----------|
| 1Fichier | /fichier/ |
| Akamai NetStorage | /netstorage/ |
| Amazon S3 | /s3/ |
| Azure Blob | /azureblob/ |
| Azure Files | /azurefiles/ |
| Backblaze B2 | /b2/ |
| Box | /box/ |
| Cloudinary | /cloudinary/ |
| Citrix ShareFile | /sharefile/ |
| Digi Storage | /koofr/#digi-storage |
| Drime | /drime/ |
| Dropbox | /dropbox/ |
| Enterprise File Fabric | /filefabric/ |
| FileLu Cloud Storage | /filelu/ |
| FileLu S5 | /s3/#filelu-s5 |
| Filen | /filen/ |
| Files.com | /filescom/ |
| FTP | /ftp/ |
| Gofile | /gofile/ |
| Google Cloud Storage | /googlecloudstorage/ |
| Google Drive | /drive/ |
| Google Photos | /googlephotos/ |
| HDFS | /hdfs/ |
| HiDrive | /hidrive/ |
| HTTP | /http/ |
| iCloud Drive | /iclouddrive/ |
| ImageKit | /imagekit/ |
| Internet Archive | /internetarchive/ |
| Internxt | /internxt/ |
| Jottacloud | /jottacloud/ |
| Koofr | /koofr/ |
| Linkbox | /linkbox/ |
| Mail.ru Cloud | /mailru/ |
| Mega | /mega/ |
| Mega S4 | /s3/#mega |
| Microsoft OneDrive | /onedrive/ |
| OpenDrive | /opendrive/ |
| OpenStack Swift | /swift/ |
| Oracle Object Storage | /oracleobjectstorage/ |
| pCloud | /pcloud/ |
| PikPak | /pikpak/ |
| Pixeldrain | /pixeldrain/ |
| premiumize.me | /premiumizeme/ |
| Proton Drive | /protondrive/ |
| put.io | /putio/ |
| Quatrix | /quatrix/ |
| QingStor | /qingstor/ |
| Seafile | /seafile/ |
| SFTP | /sftp/ |
| Sia | /sia/ |
| Shade | /shade/ |
| SMB/CIFS | /smb/ |
| Storj | /storj/ |
| SugarSync | /sugarsync/ |
| Uloz.to | /ulozto/ |
| WebDAV | /webdav/ |
| Yandex Disk | /yandex/ |
| Zoho WorkDrive | /zoho/ |
| Local Filesystem | /local/ |
