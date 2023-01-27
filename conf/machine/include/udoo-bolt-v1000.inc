DEFAULTTUNE ?= "zen1"
MULTILIBS ?= ""

require conf/machine/include/x86/arch-x86.inc
require conf/machine/include/x86/x86-base.inc
require conf/multilib.conf

TUNEVALID[zen1] = "Enable AMD x86 (64 bit) Zen 1 Core Architecture specific optimizations"
TUNECONFLICTS[zen1] = "m32 mx32"

TUNE_CCARGS .= "${@bb.utils.contains('TUNE_FEATURES', 'zen1', ' -march=znver1', '', d)}"
MACHINEOVERRIDES =. "${@bb.utils.contains('TUNE_FEATURES', 'zen1', 'zen1:', '', d)}amd:amdx86:"

AVAILTUNES += "zen1"
TUNE_FEATURES:tune-zen1         = "${TUNE_FEATURES:tune-x86-64} zen1"
TUNE_PKGARCH:tune-zen1          = "zen1"
PACKAGE_EXTRA_ARCHS:tune-zen1   = "${PACKAGE_EXTRA_ARCHS:tune-x86-64} zen1"
BASE_LIB:tune-zen1              = "lib64"

