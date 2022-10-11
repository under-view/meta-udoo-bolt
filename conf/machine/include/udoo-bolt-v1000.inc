# The amdx86.inc file removes MACHINE_FEATURES = "screen",
# Which unadds kernel config symbols CONFIG_DRM & CONFIG_AGP
# for us. Unfortunately, setting MACHINE_FEATURES here just
# gets overriden by the remove. So, we can't add DRM support.
# Avoid usage of amdx86.inc by implemented v1000.conf &
# amdx86.inc here.
require conf/machine/include/tune-zen1.inc
# require conf/machine/include/amdx86.inc
require conf/machine/include/amd-common-configurations.inc
include conf/machine/include/amd-customer-configurations.inc

# Add machine specific AMD features and feature pkgs here
EXTRA_IMAGE_FEATURES += "amd-feature-networking"

MACHINEOVERRIDES =. "amd:amdx86:"

MACHINE_FEATURES += "screen screen-console"

MACHINE_EXTRA_RRECOMMENDS:remove = " rtc-test"

# Mask out recipes for packages we do not support for
# amdx86 but may be required by others. Use '|' sign
# between the patterns.
BBMASK .= "\
.*/meta-amd/common/recipes-support/libtinyxml\
"
