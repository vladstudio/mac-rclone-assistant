# HDFS Remote - Complete Documentation

## Overview

HDFS (Hadoop Distributed Filesystem) represents a distributed file system component of the Apache Hadoop framework. Users specify paths using the format `remote:` or `remote:path/to/dir`.

## Configuration Setup

### Initial Configuration Process

Users begin by executing `rclone config`, which launches an interactive setup wizard. The process involves:

1. Creating a new remote named `remote`
2. Selecting HDFS as the storage type
3. Specifying the namenode address and port (example: "namenode.hadoop:8020")
4. Providing the Hadoop username (commonly "root")
5. Confirming the configuration

### Example Configuration Output

The completed configuration creates a remote with these properties:
- type: hdfs
- namenode: namenode.hadoop:8020
- username: root

### Testing with Docker

Two approaches exist for testing:

**Building from source:**
```
git clone https://github.com/rclone/rclone.git
cd rclone/fstest/testserver/images/test-hdfs
docker build --rm -t rclone/test-hdfs .
```

**Using pre-built image:**
```
docker run --rm --name "rclone-hdfs" -p 127.0.0.1:9866:9866 -p 127.0.0.1:8020:8020 --hostname "rclone-hdfs" rclone/test-hdfs
```

The Docker image requires configuration as:
```
[remote]
type = hdfs
namenode = 127.0.0.1:8020
username = root
```

## Common rclone Commands

- **List top-level directories:** `rclone lsd remote:`
- **View directory contents:** `rclone ls remote:directory`
- **Sync remote to local:** `rclone sync --interactive remote:directory /home/local/directory`

## Technical Specifications

### Modification Times
Time precision extends to 1 second accuracy.

### Checksum Support
No checksum functionality is implemented.

### Usage Information
The command `rclone about remote:` displays filesystem size and current usage metrics.

### Restricted Filename Characters

Beyond default restrictions, the colon character (0x3A) converts to "：". Invalid UTF-8 bytes receive replacement according to standard encoding rules.

## Configuration Options

### Standard Options

**--hdfs-namenode**
- Specifies Hadoop name nodes and ports
- Format: "namenode-1:8020,namenode-2:8020,..."
- Config key: namenode
- Environment variable: RCLONE_HDFS_NAMENODE
- Type: CommaSepList

**--hdfs-username**
- Defines the Hadoop user name
- Config key: username
- Environment variable: RCLONE_HDFS_USERNAME
- Type: string

### Advanced Options

**--hdfs-service-principal-name**
- Enables Kerberos authentication
- Format: SERVICE/FQDN (example: "hdfs/namenode.hadoop.docker")
- Config key: service_principal_name
- Environment variable: RCLONE_HDFS_SERVICE_PRINCIPAL_NAME

**--hdfs-data-transfer-protection**
- Kerberos protection level specification
- Acceptable values: authentication, integrity, privacy
- Config key: data_transfer_protection
- Environment variable: RCLONE_HDFS_DATA_TRANSFER_PROTECTION

**--hdfs-encoding**
- Backend encoding specification
- Default: Slash,Colon,Del,Ctl,InvalidUtf8,Dot
- Config key: encoding
- Environment variable: RCLONE_HDFS_ENCODING

**--hdfs-description**
- Remote description field
- Config key: description
- Environment variable: RCLONE_HDFS_DESCRIPTION

## Known Limitations

- Erasure coding remains unsupported (referenced issue #8808)
- Server-side Move and DirMove operations unavailable
- Checksum functionality not implemented

## Support Status

HDFS is classified as Tier 2: "Stable: Well-supported, minor gaps"
