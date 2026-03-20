# Microsoft Azure Files Storage

## Overview
Rclone provides support for Microsoft Azure Files Storage as a Tier 2 storage system. Paths use the format `remote:` with optional subdirectories like `remote:path/to/dir`.

## Configuration Process
Users initiate setup via `rclone config`, selecting Azure Files Storage from the available options. The configuration requires:

- **Account name**: The Azure Storage Account Name
- **Share name**: The required share to access
- **Authentication credentials**: One of several authentication methods

## Authentication Methods

### Primary Options:
1. **Account and Shared Key** - Most straightforward approach
2. **SAS URL** - For container-level access
3. **Connection String** - Storage connection details
4. **Service Principal** - With client secret or certificate
5. **User Credentials** - Username and password authentication
6. **Managed Service Identity** - For Azure-hosted applications
7. **Azure CLI** - Using the `az` tool

### Environment-Based Auth:
"Read credentials from runtime (environment variables, CLI or MSI)" through the `env_auth` parameter, supporting service principals, MSI credentials, and Azure CLI credentials.

## File Handling

**Modified Time**: Stored as Azure's standard `LastModified` time

**MD5 Hashes**: Stored with files, though not all files contain them

**Restricted Characters**: Beyond default restrictions, characters like `"`, `*`, `:`, `<`, `>`, `?`, `\`, and `|` are replaced with full-width alternatives. Files cannot end with periods.

## Performance Considerations

Upload performance improves by increasing `--azurefiles-upload-concurrency` from its conservative default of 16 to values like 64 for higher-bandwidth connections. Memory usage scales with concurrent chunk transfers.

## Key Configuration Options

- **chunk_size**: Default 4Mi for upload chunks
- **upload_concurrency**: Default 16 concurrent uploads
- **max_stream_size**: Default 10Gi for streamed files

## Custom Headers
Supported upload headers include Cache-Control, Content-Disposition, Content-Encoding, Content-Language, and Content-Type.

## Limitations

"MD5 sums are only uploaded with chunked files if the source has an MD5 sum."
