# Box Remote Storage Configuration Guide

## Overview
Rclone supports Box as a cloud storage backend, designated as a Tier 1 (production-grade) service. Users configure Box remotes using OAuth2 authentication or JWT service accounts.

## Setup Process

The configuration begins with `rclone config`, which guides users through authentication. The system offers two authentication pathways:
- **OAuth2 browser-based**: For machines with internet access
- **Config.json JWT method**: For environments without browser access

As stated in the documentation: "rclone runs a webserver on your local machine to collect the token as returned from Box. This only runs from the moment it opens your browser to the moment you get back the verification code."

## Key Configuration Options

**Standard Settings:**
- Client ID and Secret (typically left blank)
- Box config file location
- Primary access tokens
- Account type selection (user vs. enterprise service account)

**Advanced Settings:**
- Custom auth and token server URLs
- OAuth2 client credentials flow
- Root folder ID specification
- Upload cutoff threshold (default: 50 MiB)
- Listing chunk size (1-1000, default: 1000)

## Important Limitations

Box imposes several technical constraints:

- **Case insensitivity**: Cannot distinguish between "Hello.doc" and "hello.doc"
- **Backslash restriction**: Box prohibits `\` characters; rclone maps these to Unicode equivalent `＼`
- **Filename length**: Maximum 255 characters
- **Rate limiting**: API rate limits may impact transfer speeds
- **No `rclone about` support**: Cannot determine free space or use MFS policies

## Refresh Token Management

According to Box documentation, refresh tokens expire after 60 days of inactivity or if used simultaneously across multiple machines. Users encountering "Invalid refresh token" errors must re-authenticate through `rclone config`.

## File Operations

**Modification Times**: Accurate to 1-second precision
**Checksums**: SHA1 hashes supported via `--checksum` flag
**Large Files**: Files exceeding 50 MiB use chunked transfers with configurable concurrent uploads
**Deletion**: Items move to trash or permanently delete based on enterprise settings

## Custom App Creation

Creating a dedicated Box App requires accessing the Developer Console, selecting OAuth 2.0 authentication, configuring redirect URI to `http://127.0.0.1:53682/`, and granting appropriate file read/write scopes.
