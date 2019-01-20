################################################################################
#
# libax25
#
#################################################################################

LIBAX25_VERSION = 0.0.12-rc4
LIBAX25_SOURCE = libax25-$(LIBAX25_VERSION).tar.gz
LIBAX25_SITE = http://www.linux-ax25.org/pub/libax25
LIBAX25_LICENSE = GPL-2
LIBAX25_LICENSE_FILES = COPYING
LIBAX25_CONF_OPTS = ac_cv_func_setpgrp_void=yes
LIBAX25_INSTALL_STAGING = YES
LIBAX25_INSTALL_TARGET = YES

define LIBAX25_INSTALL_CONFIG
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) installconf
endef

LIBAX25_POST_INSTALL_TARGET_HOOKS += LIBAX25_INSTALL_CONFIG

$(eval $(autotools-package))
