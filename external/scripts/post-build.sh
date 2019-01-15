#!/bin/sh

set -e

CONF_DIR="${TARGET_DIR}/mnt/conf"
DATA_DIR="${TARGET_DIR}/mnt/data"

# Make sure directories exist where the non-volatile partitions are mounted
mkdir -p "$CONF_DIR"
mkdir -p "$DATA_DIR"

