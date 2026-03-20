# Filen Configuration Guide for Rclone

## Overview
Filen is a cloud storage system supported by rclone at Tier 1 (production-grade). The integration requires an API key obtained through the Filen CLI tool.

## Setup Process

To configure Filen with rclone, users must:

1. **Obtain API Key**: Download the [Filen CLI](https://github.com/FilenCloudDienste/filen-cli), log in, and run the `export-api-key` command
2. **Run Configuration**: Execute `rclone config` and select Filen as the storage type
3. **Provide Credentials**: Enter email, password, and the API key during setup

## Required Configuration Options

**Standard Options:**
- `--filen-email`: Account email address
- `--filen-password`: Account password (must be obscured via rclone obscure)
- `--filen-api-key`: API key from Filen CLI (must be obscured)

## Key Features

- **Hash Support**: Blake3 hashes are fully supported
- **Modification Times**: Fully supported for files; only creation time matters for directories
- **Filename Restrictions**: Invalid UTF-8 bytes are replaced
- **Upload Concurrency**: Default of 16 concurrent transfers for chunked uploads

## Advanced Options

The configuration supports upload concurrency adjustments, encoding specifications, and internal authentication parameters (master keys, RSA keys, auth version, base folder UUID).
