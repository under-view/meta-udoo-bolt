# Replaces sysvinit init system with systemd init system
VIRTUAL-RUNTIME_initscripts = ""
VIRTUAL-RUNTIME_init_manager = "systemd"
VIRTUAL-RUNTIME_dev_manager = "udev"

PREFERRED_PROVIDER_udev = "systemd"
PREFERRED_PROVIDER_udev-utils = "systemd"

DISTRO_FEATURES_OPTED_OUT:append = " sysvinit"
DISTRO_FEATURES += "usrmerge systemd"
