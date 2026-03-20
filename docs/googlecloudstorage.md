# Google Cloud Storage Configuration with Rclone

## Overview
Rclone provides integration with Google Cloud Storage, allowing users to manage cloud storage through command-line operations. The documentation specifies that "Paths are specified as `remote:bucket` (or `remote:` for the `lsd` command.)"

## Initial Setup Process

Configuration begins with the `rclone config` command, which guides users through an interactive setup. Key configuration options include:

- **Project number**: Required for bucket management operations
- **Object ACL settings**: Controls access permissions for uploaded objects
- **Bucket ACL settings**: Manages bucket-level access policies
- **Location selection**: Specifies geographic regions for bucket creation
- **Storage class**: Determines the storage tier (Standard, Nearline, Coldline, Archive, etc.)

## Authentication Methods

### OAuth2 Browser Authentication
The standard approach uses browser-based authentication where "rclone runs a webserver on your local machine to collect the token as returned from Google."

### Service Account Authentication
For unattended operations, users can employ Service Account credentials via JSON key files. This method suits "machines that don't have actively logged-in users, for example build machines."

An alternative approach uses temporary access tokens obtained through `gcloud impersonate-service-account`, which "protect[s] security by avoiding the use of the JSON key file."

### Application Default Credentials
Rclone supports automatic fallback to Application Default Credentials when no explicit authentication is configured.

## Key Features

- **Fast-list support** for reduced transaction overhead
- **Custom upload headers** including Cache-Control, Content-Disposition, and custom metadata
- **Modification time storage** using RFC3339 format for nanosecond precision
- **Bucket Policy Only support** for IAM-based access control

## Notable Limitations

"rclone about is not supported by the Google Cloud Storage backend," preventing free space determination for mounts and certain union remote policies.
