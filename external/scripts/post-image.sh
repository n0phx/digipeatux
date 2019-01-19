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

for arg in "$@"
do
	case "${arg}" in
		--add-pi3-miniuart-bt-overlay)
		if ! grep -qE '^dtoverlay=' "${BINARIES_DIR}/rpi-firmware/config.txt"; then
			echo "Adding 'dtoverlay=pi3-miniuart-bt' to config.txt (fixes ttyAMA0 serial console)."
			cat << __EOF__ >> "${BINARIES_DIR}/rpi-firmware/config.txt"

# fixes rpi3 ttyAMA0 serial console
dtoverlay=pi3-miniuart-bt
__EOF__
		fi
		;;
		--aarch64)
		# Run a 64bits kernel (armv8)
		sed -e '/^kernel=/s,=.*,=Image,' -i "${BINARIES_DIR}/rpi-firmware/config.txt"
		if ! grep -qE '^arm_control=0x200' "${BINARIES_DIR}/rpi-firmware/config.txt"; then
			cat << __EOF__ >> "${BINARIES_DIR}/rpi-firmware/config.txt"

# enable 64bits support
arm_control=0x200
__EOF__
		fi

		# Enable uart console
		if ! grep -qE '^enable_uart=1' "${BINARIES_DIR}/rpi-firmware/config.txt"; then
			cat << __EOF__ >> "${BINARIES_DIR}/rpi-firmware/config.txt"

# enable rpi3 ttyS0 serial console
enable_uart=1
__EOF__
		fi
		;;
		--gpu_mem_256=*|--gpu_mem_512=*|--gpu_mem_1024=*)
		# Set GPU memory
		gpu_mem="${arg:2}"
		sed -e "/^${gpu_mem%=*}=/s,=.*,=${gpu_mem##*=}," -i "${BINARIES_DIR}/rpi-firmware/config.txt"
		;;
	esac

done

rm -rf "${GENIMAGE_TMP}"

makeimg "${BINARIES_DIR}/conf.ext4" $CONF_PARTITION_SIZE || exit 1
makeimg "${BINARIES_DIR}/data.ext4" $DATA_PARTITION_SIZE || exit 1

kernelcfg="${BR2_EXTERNAL_CUSTOM_PATH}/$(getkernelcfg "${BR2_CONFIG}")"
cmdline="$(getcmdline "$kernelcfg")"
echo "$cmdline" > "${CMDLINE_FILE}"

genimage                           \
	--rootpath "${TARGET_DIR}"     \
	--tmppath "${GENIMAGE_TMP}"    \
	--inputpath "${BINARIES_DIR}"  \
	--outputpath "${BINARIES_DIR}" \
	--config "${GENIMAGE_CFG}"

exit $?
