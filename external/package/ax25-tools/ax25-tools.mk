################################################################################
#
# ax25-tools
#
#################################################################################

AX25_TOOLS_VERSION = 0.0.10-rc4
AX25_TOOLS_SOURCE = ax25-tools-$(AX25_TOOLS_VERSION).tar.gz
AX25_TOOLS_SITE = http://www.linux-ax25.org/pub/ax25-tools
AX25_TOOLS_LICENSE = GPL-2
AX25_TOOLS_LICENSE_FILES = COPYING
AX25_TOOLS_INSTALL_STAGING = NO
AX25_TOOLS_INSTALL_TARGET = YES
AX25_TOOLS_CONF_OPTS = ac_cv_func_setpgrp_void=yes
AX25_TOOLS_DEPENDENCIES = libax25 ncurses zlib

define AX25_TOOLS_INSTALL_CONFIG
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) installconf
endef

AX25_TOOLS_POST_INSTALL_TARGET_HOOKS += AX25_TOOLS_INSTALL_CONFIG

$(eval $(autotools-package))
