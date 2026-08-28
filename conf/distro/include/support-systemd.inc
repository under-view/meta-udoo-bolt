# Replaces sysvinit init system with systemd init system
VIRTUAL-RUNTIME_initscripts = ""
VIRTUAL-RUNTIME_init_manager = "systemd"
VIRTUAL-RUNTIME_dev_manager = "systemd"
VIRTUAL-RUNTIME_login_manager = "shadow-base"

PREFERRED_PROVIDER_udev = "systemd"
PREFERRED_PROVIDER_udev-utils = "systemd"

DISTRO_FEATURES_OPTED_OUT:append = " sysvinit"
DISTRO_FEATURES += "usrmerge systemd"

ROOT_HOME = "/root"
