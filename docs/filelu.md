# FileLu on Rclone

## Header Navigation
The page contains links to Downloads, Docs (Installation, Usage, Filtering, GUI, Remote Control, Remote Setup, Changelog, Bugs, FAQ, Flags, Licence, Authors, Privacy Policy), Commands (Overview and 70+ individual commands), Storage Systems (Overview, Support Tiers, and 80+ backend options), Contact, and Sponsor sections.

## Main Content

### FileLu Overview
FileLu is described as "a reliable cloud storage provider offering features like secure file uploads, downloads, flexible storage options, and sharing capabilities." The service supports high storage limits and integrates with rclone. A note indicates that FileLu offers a fully featured S3-compatible backend called FileLu S5.

### Configuration Section
Users configure FileLu by running `rclone config` and entering their FileLu Rclone Key (format: RC_xxxxxxxxxxxxxxxxxxxxxxxx).

### Paths
Paths without a leading `/` operate in the Rclone directory. Paths with `/` operate at root level where the Rclone directory is visible.

### Example Commands
The documentation provides 13 example rclone commands including:
- Creating folders: `rclone mkdir filelu:foldername`
- Deleting folders/files: `rclone rmdir` and `rclone delete`
- Listing files: `rclone ls` and `rclone lsd`
- Copying, moving, and syncing files between local and FileLu storage
- Mounting remote storage to local systems
- Getting account storage information: `rclone about filelu:`

### Key Features & Limitations

**FolderID Implementation**: The system uses FolderID instead of folder names to prevent confusion with duplicate folder names, particularly important for systems with hundreds of thousands of folders.

**Supported Features**:
- Modification times and MD5 hashes
- Filenames up to 255 Unicode characters
- Duplicate files in different directories (not in same directory)

**Configuration Issues**: Users experiencing login failures should verify their Rclone Key from My Account, as new keys generate each time Rclone is toggled.

**Memory Concerns**: Large file accounts may consume significant memory during list/sync operations.

### Standard Options
- `--filelu-key`: Required. FileLu Rclone key from My Account

### Advanced Options
- `--filelu-upload-cutoff`: Default 500Mi
- `--filelu-chunk-size`: Default 64Mi
- `--filelu-encoding`: Multiple character encoding options
- `--filelu-description`: Optional remote description

### Limitations
The backend uses a custom library implementing the FileLu API. While file transfers are supported, some advanced features may be unavailable.

## Footer
The page lists Platinum and Gold sponsors (Internxt, IDrive e2, Files.com), social sharing options, and credits to Nick Craig-Wood, Hugo, and hosting providers.
