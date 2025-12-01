# Mostly just a copy of what's in OE-core

SUMMARY = "Linux kernel"
SECTION = "kernel"
LICENSE = "GPL-2.0-with-Linux-syscall-note"
HOMEPAGE = "https://www.yoctoproject.org/"

LIC_FILES_CHKSUM ?= "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"

UPSTREAM_CHECK_GITTAGREGEX = "(?P<pver>\d+\.\d+(\.\d+)*)"

RECIPE_NO_UPDATE_REASON = "Recipe is updated through a separate process"

# Skip processing of this recipe if it is not explicitly specified as the
# PREFERRED_PROVIDER for virtual/kernel. This avoids network access required
# by the use of AUTOREV SRCREVs, which are the default for this recipe.
python () {
    if d.getVar("KERNEL_PACKAGE_NAME") == "kernel" and d.getVar("PREFERRED_PROVIDER_virtual/kernel") != d.getVar("PN"):
        d.delVar("BB_DONT_CACHE")
        raise bb.parse.SkipRecipe("Set PREFERRED_PROVIDER_virtual/kernel to %s to enable it" % (d.getVar("PN")))
}

KERNEL_DEBUG ?= "False"
# These used to be version specific, but are now common dependencies.  New
# tools / dependencies will continue to be added in version specific recipes.
DEPENDS += '${@bb.utils.contains_any("ARCH", [ "x86", "arm64", "powerpc" ], "elfutils-native", "", d)}'
DEPENDS += "openssl-native util-linux-native"
DEPENDS += "tiny-linux-kconfigs-native"
DEPENDS += "gmp-native libmpc-native"
DEPENDS += "xz-native bc-native"

KMACHINE ?= "common-pc-64"
LINUX_VERSION ?= "6.12.58"
LINUX_VERSION_EXTENSION ?= "-amd-${LINUX_KERNEL_TYPE}"

inherit kernel
inherit kernel-yocto

B = "${WORKDIR}/linux-${PACKAGE_ARCH}-${LINUX_KERNEL_TYPE}-build"

do_install:append(){
	if [ -n "${KMETA}" ]; then
		rm -rf ${STAGING_KERNEL_DIR}/${KMETA}
	fi
}

# Some options depend on CONFIG_PAHOLE_VERSION, so need to make pahole-native available before do_kernel_configme
do_kernel_configme[depends] += '${@bb.utils.contains("KERNEL_DEBUG", "True", "pahole-native:do_populate_sysroot", "", d)}'

EXTRA_OEMAKE += '${@bb.utils.contains("KERNEL_DEBUG", "True", "", "PAHOLE=false", d)}'

COMPATIBLE_MACHINE = "${MACHINE}"

KERNEL_VERSION_SANITY_SKIP ?= "1"

INC_PR := "r0"

PR := "${INC_PR}.1"
PV = "${LINUX_VERSION}+git"

KPROTOCOL ?= "protocol=https"
KBRANCH:amd ?= "tag=v6.12;mindepth=1;nobranch=1"
KSRC ?= "git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git"
SRCREV ?= "adc218676eef25575469234709c2d87185ca223a"
SRC_URI = "${KSRC};${KPROTOCOL};${KBRANCH}"

LINUX_KERNEL_TYPE = "tiny"
KCONFIG_MODE = "--allnoconfig"
KBUILD_DEFCONFIG = "tiny.config"

KCONFIG_SYMBOLS ?= "\
    ${@bb.utils.contains('ACPI_DEBUG', '1', 'acpi-debug.cfg', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'systemd.cfg', '', d)} \
    x86_64/arch.cfg \
    console.cfg \
    disk.cfg \
    efi.cfg \
    filesystem.cfg \
    generic.cfg \
    graphics.cfg \
    input.cfg \
    liveusb.cfg \
    network.cfg \
    pci.cfg \
    "

do_configure:append() {
    for kcfg in ${KCONFIG_SYMBOLS}; do
        cat ${STAGING_DATADIR_NATIVE}/linux-cfgs-6.12/${kcfg} >> ${B}/.config
    done
}

do_devshell:prepend() {
    # setup native pkg-config variables (kconfig scripts call pkg-config directly, cannot generically be overriden to pkg-config-native)
    d.setVar("PKG_CONFIG_DIR", "${STAGING_DIR_NATIVE}${libdir_native}/pkgconfig")
    d.setVar("PKG_CONFIG_PATH", "${PKG_CONFIG_DIR}:${STAGING_DATADIR_NATIVE}/pkgconfig")
    d.setVar("PKG_CONFIG_LIBDIR", "${PKG_CONFIG_DIR}")
    d.setVarFlag("PKG_CONFIG_SYSROOT_DIR", "unexport", "1")
    d.appendVar("OE_TERMINAL_EXPORTS", " PKG_CONFIG_DIR PKG_CONFIG_PATH PKG_CONFIG_LIBDIR PKG_CONFIG_SYSROOT_DIR")
}
