# Seafile Backend Documentation for rclone

## Overview
The Seafile backend enables rclone to work with the Seafile storage service, supporting both community and professional editions across versions 6.x through 9.x. The system accommodates encrypted libraries and accounts with two-factor authentication enabled.

## Configuration Modes

Two distinct setup approaches exist:

**Root Mode**: Points to the server's root without specifying a library during configuration. Paths follow the format `remote:library` or `remote:library/path/to/dir`.

**Library Mode**: Points to a specific library during setup. Paths are specified as `remote:path/to/dir`. This approach is recommended for encrypted libraries and offers potentially faster performance.

## Key Features

- Support for encrypted libraries
- Two-factor authentication compatibility
- Library API Token usage is **not** supported
- `--fast-list` available for Seafile 7+ (reduces transactions, increases memory usage)
- Share link generation for non-encrypted libraries only

## Restricted Characters

Beyond default restrictions, rclone replaces forward slashes (／), double quotes (＂), and backslashes (＼). Invalid UTF-8 bytes are also replaced since they cannot be used in JSON strings.

## Tested Compatibility

Active development testing has verified functionality with:
- Version 6.3.4 community edition
- Version 7.0.5, 7.1.3 community editions
- Version 9.0.10 community edition

Versions below 6.0 lack support; versions 6.0-6.3 remain untested.

## Configuration Options

**Standard options** include URL, username, password, 2FA setting, library name, and library password for encrypted libraries.

**Advanced options** cover library creation, encoding preferences, and remote descriptions.
