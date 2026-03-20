# ImageKit Backend for Rclone

## Overview

Rclone provides integration with ImageKit.io, a platform offering "real-time image and video optimizations, transformations, and CDN delivery." The backend enables users to manage media files stored in ImageKit's Media Library.

## Configuration Requirements

To set up the ImageKit backend, users need:

1. An active ImageKit.io account (free plan available with usage limits)
2. **Three authentication credentials** from the dashboard:
   - Endpoint URL
   - Public key
   - Private key

## Setup Process

The configuration follows rclone's standard interactive setup via `rclone config`. Users specify:
- Remote name (e.g., "imagekit-media-library")
- Storage type as "imagekit"
- Required credentials from the ImageKit developer dashboard

## Key Features & Limitations

**Supported Operations:**
- Directory listing and creation
- File management (copy, move, delete)
- Metadata reading

**Not Supported:**
- Modification times
- Checksums
- Hash verification

## Advanced Configuration Options

Optional settings include:
- **only_signed**: Required when unsigned URLs are restricted
- **versions**: Include historical file versions in listings
- **upload_tags**: Assign tags during file uploads
- **encoding**: Configure character encoding handling

## Metadata Support

The backend reads multiple metadata fields including dimensions, file type, privacy status, and AI-generated tags (AWS Rekognition and Google Cloud Vision).
