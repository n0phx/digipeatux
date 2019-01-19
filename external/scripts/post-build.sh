#!/bin/sh

set -e

CONF_PATH="/mnt/conf"
CONF_DIR="${TARGET_DIR}/${CONF_PATH}"

DATA_PATH="/mnt/data"
DATA_DIR="${TARGET_DIR}/${DATA_PATH}"

FSTAB="${TARGET_DIR}/etc/fstab"

append_line() {
  line="$1"
  file="$2"
  grep -qF -- "$line" "$file" || echo "$line" >> "$file"
}

# Make sure directories exist where the non-volatile partitions are mounted
mkdir -p "$CONF_DIR"
mkdir -p "$DATA_DIR"

# Update fstab to mount the non-volatile partitions during boot
CONF_ENTRY="/dev/mmcblk0p3	${CONF_PATH}	ext4	defaults	0	2"
DATA_ENTRY="/dev/mmcblk0p4	${DATA_PATH}	ext4	defaults	0	2"

append_line "$CONF_ENTRY" "$FSTAB"
append_line "$DATA_ENTRY" "$FSTAB"
