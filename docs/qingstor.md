# QingStor Remote Storage Configuration Guide

## Overview
QingStor is a cloud object storage service accessible through rclone using the format `remote:bucket` for paths, with optional subdirectories like `remote:bucket/path/to/dir`.

## Key Configuration Steps

To set up QingStor, run `rclone config` and select the QingStor storage type. Essential parameters include:

- **Access credentials**: Access Key ID and Secret Access Key (can be left blank for anonymous or runtime access)
- **Endpoint**: Defaults to "https://qingstor.com:443"
- **Zone selection**: Options include "pek3a" (Beijing), "sh1a" (Shanghai), and "gd2a" (Guangdong)

## Authentication Methods

Two credential approaches exist in order of precedence:
1. Direct configuration via `rclone config` using `access_key_id` and `secret_access_key`
2. Runtime configuration with environment variables: `QS_ACCESS_KEY_ID`/`QS_ACCESS_KEY` and `QS_SECRET_ACCESS_KEY`/`QS_SECRET_KEY`

## Important Features

**Multipart uploads** support files larger than 5 GiB, though MD5SUM checksums are unavailable for such uploads. Incomplete uploads older than 24 hours can be removed using `rclone cleanup`.

**Zone limitations** restrict bucket access to the zone where it was created—attempting access from another zone produces an error.

The `--fast-list` option reduces transaction counts at the cost of increased memory usage.

## Notable Limitation

"The `rclone about` command is unsupported, preventing free space determination for mount operations or union remote policies."
