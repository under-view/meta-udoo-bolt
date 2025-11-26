KMACHINE:amd ?= "common-pc-64"
LINUX_VERSION:amd ?= "6.12.58"
LINUX_VERSION_EXTENSION:amd ?= "-amd-${LINUX_KERNEL_TYPE}"

COMPATIBLE_MACHINE = "${MACHINE}"

KERNEL_VERSION_SANITY_SKIP:amd ?= "1"

INC_PR := "r0"

PR := "${INC_PR}.1"

KBRANCH:amd ?= "v6.12/standard/tiny/base"

SRCREV_machine:amd ?= "081aa259b8f0252bfc7999b289b79bf129893498"
SRCREV_meta:amd ?= "6a551cd6cf63d4199bc51ef778692f23730dbcca"

DEPENDS += "tiny-linux-kconfigs-native"

KCONFIG_SYMBOLS:amd ?= "\
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
