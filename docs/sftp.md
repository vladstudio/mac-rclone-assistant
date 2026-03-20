# SFTP Backend for Rclone

## Overview

SFTP (Secure File Transfer Protocol) operates over SSH v2 and is available as standard with most modern SSH installations. Rclone's SFTP backend supports various providers including Hetzner Storage Box and rsync.net.

## Path Specification

Paths follow the format `remote:path`. Important distinctions:
- Paths without a leading `/` are relative to the user's home directory
- Empty path `remote:` refers to the user's home directory
- `remote:/` accesses the server's root directory

**Provider-specific requirements:** Some servers like Synology require leading slashes, while rsync.net and Hetzner require omitting them.

## Authentication Methods

The backend supports three approaches:

1. **Password authentication** - Direct password entry
2. **Key file authentication** - PEM-encoded private keys (unencrypted OpenSSH or PEM encrypted formats)
3. **SSH-agent** - The default fallback when other methods aren't specified

Key files can be specified via `key_file` (external file) or `key_pem` (inline configuration).

## Host Key Validation

By default, rclone skips host key validation, creating potential security vulnerabilities. Enable validation using the `known_hosts_file` option pointing to an OpenSSH known_hosts file or custom equivalent.

## Shell Access Considerations

"By default rclone will try to execute shell commands on the server," which enables checksum calculations and disk usage queries. The backend auto-detects shell type (Unix, PowerShell, CMD, or none) on first access and stores this in configuration.

Setting `shell_type = none` disables all shell command execution. This prevents potential command injection vulnerabilities when shell type is uncertain.

## Checksum Support

SFTP lacks native checksum support, but rclone can calculate them via remote shell commands. Supported algorithms include MD5, SHA-1, CRC32, SHA-256, BLAKE3, XXH3, and XXH128. PowerShell servers receive built-in checksum calculation scripts.

## Key Configuration Options

| Option | Purpose |
|--------|---------|
| `host` | SSH server address (required) |
| `user` | SSH username |
| `port` | SSH port (default: 22) |
| `known_hosts_file` | Enable host key validation |
| `shell_type` | Specify or disable shell access |
| `disable_hashcheck` | Disable remote checksum execution |
| `set_modtime` | Control modification time updates |

## Advanced Features

**Concurrent operations:** Configurable concurrent reads/writes (disabled individually if server limitations exist)

**Chunk size:** Default 32KB; can increase to 255KB on high-latency links if server supports it

**Connection pooling:** Idle timeout of 1 minute by default; set to 0 for indefinite connections

**Proxy support:** Both SOCKS5 and HTTP CONNECT proxies available

## Known Limitations

- Synology and similar servers require path overrides due to SSH/SFTP path differences
- Windows supports only Putty's pageant as SSH agent
- AES128-CBC cipher disabled by default for security; can be re-enabled if needed
- Not supported on Plan9 systems
- HTTP-based debugging flags incompatible with protocol

## Provider-Specific Notes

**rsync.net:** Full support documented with detailed configuration examples available on their site

**Hetzner Storage Box:** Accessible via SFTP on port 23 with official setup documentation provided
