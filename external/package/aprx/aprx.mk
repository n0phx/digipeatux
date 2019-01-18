################################################################################
#
# aprx
#
#################################################################################

APRX_VERSION = v2.9.0
APRX_SITE = $(call github,PhirePhly,aprx,$(APRX_VERSION))
APRX_LICENSE = BSD-3c
APRX_LICENSE_FILES = LICENSE
APRX_INSTALL_STAGING = NO
APRX_INSTALL_TARGET = YES

define APRX_INSTALL_INIT_SYSV
	$(INSTALL) -m 0755 -D $(APRX_PKGDIR)/S60aprx \
				$(TARGET_DIR)/etc/init.d/S60aprx
endef

$(eval $(autotools-package))
