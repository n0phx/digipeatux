#!/bin/sh

set -e

MDEVCONF="${TARGET_DIR}/etc/mdev.conf"

append_line() {
  line="$1"
  file="$2"
  grep -qF -- "$line" "$file" || echo "$line" >> "$file"
}

# Add mdev.conf entry to restart rtl_fm service every time the rtl-sdr dongle is inserted
RTL_USB_ENTRY="SUBSYSTEM=usb;DEVTYPE=usb_device;.* root:root 660 @/usr/bin/usbdetect"

append_line "$RTL_USB_ENTRY" "$MDEVCONF"

