################################################################################
#
# ax25-apps
#
#################################################################################

AX25_APPS_VERSION = 0.0.8-rc4
AX25_APPS_SOURCE = ax25-apps-$(AX25_APPS_VERSION).tar.gz
# AX25_APPS_SITE = http://www.linux-ax25.org/pub/ax25-apps
AX25_APPS_SITE = https://archive.org/download/ax25-apps-$(AX25_APPS_VERSION)
AX25_APPS_LICENSE = GPL-2
AX25_APPS_LICENSE_FILES = COPYING
AX25_APPS_INSTALL_STAGING = NO
AX25_APPS_INSTALL_TARGET = YES
AX25_APPS_DEPENDENCIES = libax25 ncurses
AX25_APPS_MAKE_OPTS = CFLAGS="-fcommon"

define AX25_APPS_INSTALL_CONFIG
# HACK: The following two files are touched / created here, because the Makefile
# attempts to install them but fails as they don't exist actually..
	touch $(@D)/ax25rtd/ax25_route
	touch $(@D)/ax25rtd/ip_route
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) installconf
endef

AX25_APPS_POST_INSTALL_TARGET_HOOKS += AX25_APPS_INSTALL_CONFIG

$(eval $(autotools-package))
