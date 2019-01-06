SUPPORTED_BOARDS := rpi rpi0 rpi2 rpi3

ifeq ($(filter $(BOARD),$(SUPPORTED_BOARDS)),)
$(error $(BOARD) is not a supported BOARD. Choose one of the available ones: $(SUPPORTED_BOARDS). E.g.: BOARD=rpi)
endif

BUILDROOT_DIR = ./buildroot
EXTERNAL_DIR = ../external
OUTPUT_PATH := build/$(BOARD)
OUTPUT_DIR := ../$(OUTPUT_PATH)
# Auto-generated config file based on defconfig
CONFIG := $(OUTPUT_PATH)/.config
# Buildroot configuration file specific to the chosen board
DEFCONFIG := $(BOARD)_defconfig

export BR2_EXTERNAL=$(EXTERNAL_DIR)

.PHONY: menuconfig linux-menuconfig savedefconfig savekernelconfig clean build

.DEFAULT_GOAL := build

build: $(CONFIG)
	@make -C $(BUILDROOT_DIR) O=$(OUTPUT_DIR)

menuconfig: $(CONFIG)
	@make -C $(BUILDROOT_DIR) O=$(OUTPUT_DIR) menuconfig

linux-menuconfig: $(CONFIG)
	@make -C $(BUILDROOT_DIR) O=$(OUTPUT_DIR) linux-menuconfig

savedefconfig: $(CONFIG)
	@make -C $(BUILDROOT_DIR) O=$(OUTPUT_DIR) savedefconfig

savekernelconfig: $(CONFIG)
	@make -C $(BUILDROOT_DIR) O=$(OUTPUT_DIR) linux-update-defconfig

clean:
	-rm -rf $(OUTPUT_PATH)

$(CONFIG):
	@make -C $(BUILDROOT_DIR) O=$(OUTPUT_DIR) $(DEFCONFIG)

