################################################################################
#
# direwolf
#
################################################################################

DIREWOLF_VERSION = 1.7-dev-A
DIREWOLF_SITE = $(call github,wb2osz,direwolf,$(DIREWOLF_VERSION))
DIREWOLF_DEPENDENCIES = alsa-lib

ifeq ($(BR2_DIREWOLF_BUILD_WITH_NEON),y)
	DIREWOLF_CONF_OPTS = -DBUILD_WITH_NEON=ON
else
	DIREWOLF_CONF_OPTS = -DBUILD_WITH_NEON=OFF
endif

define DIREWOLF_INSTALL_INIT_SYSV
	$(INSTALL) -m 0755 -D $(DIREWOLF_PKGDIR)/S50direwolf \
				$(TARGET_DIR)/etc/init.d/S50direwolf
endef

define DIREWOLF_INSTALL_CONFIG
	$(INSTALL) -D -m 0644 $(DIREWOLF_PKGDIR)/direwolf.conf \
		$(TARGET_DIR)/etc/direwolf.conf
endef

DIREWOLF_POST_INSTALL_TARGET_HOOKS += DIREWOLF_INSTALL_CONFIG

$(eval $(cmake-package))
