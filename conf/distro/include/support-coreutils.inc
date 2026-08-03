# Replaces busybox,uutils-coreutils with coreutils
SKIP_RECIPE[uutils-coreutils] = "Don't build this"
SKIP_RECIPE[busybox] = "Don't build this"
VIRTUAL-RUNTIME_syslog = ""
VIRTUAL-RUNTIME_login_manager = "shadow-base"
VIRTUAL-RUNTIME_base-utils = "packagegroup-core-base-utils"
VIRTUAL-RUNTIME_base-utils-hwclock = "util-linux-hwclock"
VIRTUAL-RUNTIME_base-utils-syslog = ""
VIRTUAL-RUNTIME_vim = "vim"

PREFERRED_PROVIDER_virtual/base-utils = "packagegroup-core-base-utils"
PREFERRED_PROVIDER_coreutils = "coreutils"
PREFERRED_PROVIDER_uutils-coreutils = "coreutils"

RDEPENDS:packagegroup-core-base-utils:remove = " parted"
