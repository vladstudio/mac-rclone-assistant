# Local Filesystem Documentation

The page documents rclone's local filesystem backend, a Tier 1 storage system for managing files on local disk.

## Key Features

**Basic Usage**: Local paths use standard filesystem notation (e.g., `/path/to/wherever`), allowing direct syncing between directories.

**Configuration**: While users can configure a local remote in the config file, direct path specification is typically simpler and more practical.

## Important Technical Details

**Modification Times**: Rclone preserves file timestamps with OS-dependent accuracy—1 nanosecond on Linux, 10 nanoseconds on Windows, and 1 second on macOS.

**Filename Encoding**: Files should use UTF-8 encoding. "If an invalid (non-UTF8) filename is read, the invalid characters will be replaced with a quoted representation of the invalid bytes."

**Character Restrictions**: Different operating systems restrict different characters in filenames. Windows restricts control characters, slashes, asterisks, colons, and other special characters, while non-Windows platforms mainly restrict null bytes and forward slashes.

## Advanced Features

**Symlink Handling**: Users can employ `--copy-links` to follow symlinks or `--local-links` to convert symlinks to `.rclonelink` text files.

**Long Path Support**: Windows paths automatically convert to extended-length format (supporting ~32,767 characters) with the `\\?\` prefix.

**Filesystem Restrictions**: The `--one-file-system` flag prevents crossing filesystem boundaries during operations.

## Metadata Support

The backend supports system metadata (access time, birth time, permissions, ownership) on all operating systems, though extended user metadata requires Unix-like systems.
