# WebDAV Remote Configuration for Rclone

Rclone supports WebDAV as a storage backend with configuration for multiple vendors. Here's a concise overview:

## Key Configuration Steps

To set up a WebDAV remote, users run `rclone config` and specify:
- **URL**: The WebDAV endpoint (e.g., `https://example.com/remote.php/webdav/`)
- **Vendor type**: Options include Fastmail, Nextcloud, Owncloud, Sharepoint, and others
- **Authentication**: Username/password or bearer token

## Supported Vendors

The documentation lists several WebDAV providers with specific implementation notes:

- **Nextcloud/Owncloud**: Both support modified times via `X-OC-Mtime` header
- **Fastmail Files**: Requires app passwords with WebDAV file access
- **Sharepoint Online**: Uses Microsoft account authentication
- **Sharepoint with NTLM**: For self-hosted or on-premises systems
- **dCache**: Supports Macaroon tokens and OpenID-Connect authentication

## Notable Limitations

"Plain WebDAV does not support modified times" except when configured with specific vendors that include extended metadata support.

## Special Considerations

Sharepoint uploads require specific flags (`--ignore-size --ignore-checksum --update`) since the platform handles document sizing and hashing differently than standard WebDAV.

The remote is rated as Tier 1, indicating production-grade support.
