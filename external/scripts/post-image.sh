#!/bin/bash

set -e

if [ ! -f "$2" ]; then
	echo "genimage configuration file not found on given path: $2"
	exit 1
fi

GENIMAGE_CFG="$2"
GENIMAGE_TMP="${BUILD_DIR}/genimage.tmp"
CONF_PARTITION_SIZE="$3"
DATA_PARTITION_SIZE="$4"
CMDLINE_FILE="${BINARIES_DIR}/rpi-firmware/cmdline.txt"

makeimg() {
	outpath="$1"
	size="$2"
	dd if=/dev/zero of="$outpath" bs=1M count=$size
	mkfs.ext4 $outpath
}

getkernelcfg() {
	buildroot_cfg_file="$1"
	grep "^BR2_LINUX_KERNEL_CUSTOM_CONFIG_FILE=" "$buildroot_cfg_file" | cut -d \" -f2 | sed -e "s/^\$(BR2_EXTERNAL_CUSTOM_PATH)\///"
}

getcmdline() {
	path="$1"
	grep "^CONFIG_CMDLINE=" "$path" | cut -d \" -f2
}

# Enable audio on rpi
AUDIO_ON="dtparam=audio=on"
CONFIG_TXT="${BINARIES_DIR}/rpi-firmware/config.txt"
if ! grep -qF "$AUDIO_ON" "$CONFIG_TXT"; then
	echo "$AUDIO_ON" >> "$CONFIG_TXT"
fi

rm -rf "${GENIMAGE_TMP}"

kernelcfg="${BR2_EXTERNAL_CUSTOM_PATH}/$(getkernelcfg "${BR2_CONFIG}")"
cmdline="$(getcmdline "$kernelcfg")"
echo "$cmdline" > "${CMDLINE_FILE}"

makeimg "${BINARIES_DIR}/conf.ext4" $CONF_PARTITION_SIZE || exit 1
makeimg "${BINARIES_DIR}/data.ext4" $DATA_PARTITION_SIZE || exit 1
genimage                           \
	--rootpath "${TARGET_DIR}"     \
	--tmppath "${GENIMAGE_TMP}"    \
	--inputpath "${BINARIES_DIR}"  \
	--outputpath "${BINARIES_DIR}" \
	--config "${GENIMAGE_CFG}"

exit $?
