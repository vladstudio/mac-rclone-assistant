# Cloudinary Backend for rclone

## Overview

This documentation page describes rclone's integration with Cloudinary, an image and video API platform. The service is classified as "Tier 3" support, meaning it "works for many uses; known caveats."

## Key Information

**About the Service:**
Cloudinary is described as "trusted by 1.5 million developers and 10,000 enterprise and hyper-growth companies" for delivering visual content experiences.

**Getting Started:**
Users must create a free Cloudinary account to access the backend, with pricing options scaling based on usage needs.

## Configuration Requirements

Three essential credentials are needed:
- Cloud name
- API Key
- API Secret

All three must be obtained from the Cloudinary developer dashboard before configuring rclone.

## Basic Commands

Once configured, users can perform standard file operations:
- List directories: `rclone lsd cloudinary-media-library:`
- Create folders: `rclone mkdir cloudinary-media-library:directory`
- List contents: `rclone ls cloudinary-media-library:directory`

## Technical Features

**Metadata Handling:**
"Cloudinary stores md5 and timestamps for any successful Put automatically and read-only."

**Notable Setting:**
By default, the backend adjusts media file extensions since Cloudinary treats media formats as file attributes rather than extensions—a departure from standard filesystem behavior.
