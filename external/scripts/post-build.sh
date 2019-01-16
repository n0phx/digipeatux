#!/bin/sh

set -e

CONF_PATH="/mnt/conf"
CONF_DIR="${TARGET_DIR}/${CONF_PATH}"

DATA_PATH="/mnt/data"
DATA_DIR="${TARGET_DIR}/${DATA_PATH}"

FSTAB="${TARGET_DIR}/etc/fstab"

# Make sure directories exist where the non-volatile partitions are mounted
mkdir -p "$CONF_DIR"
mkdir -p "$DATA_DIR"

# Update fstab to mount the non-volatile partitions during boot
echo "/dev/mmcblk0p3	${CONF_PATH}	ext4	defaults	0	1" >> $FSTAB
echo "/dev/mmcblk0p4	${DATA_PATH}	ext4	defaults	0	1" >> $FSTAB

# Disable tty0 serial console
sed -i '/console 0/d' ${TARGET_DIR}/etc/inittab
