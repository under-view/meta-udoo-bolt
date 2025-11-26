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

TINY_LINUX_CFG_BRANCH ?= "branch=master"
TINY_LINUX_CFG_PROTO ?= "protocol=https"
TINY_LINUX_CFG_URL ?= "git://git@github.com/under-view/tiny-linux-kconfigs.git"
TINY_LINUX_EXTRA = "type=kmeta;name=tiny;destsuffix=tiny-linux-kconfigs"

SRCREV_tiny:amd ?= "4277405c0e15a66468ae9776459c90297104347c"

FILESEXTRAPATHS:prepend := "${UNPACKDIR}/tiny-linux-kconfigs/linux-6.12:"

SRC_URI:append:amd = "\
    ${TINY_LINUX_CFG_URL};${TINY_LINUX_CFG_PROTO};${TINY_LINUX_CFG_BRANCH};${TINY_LINUX_EXTRA} \
    ${@bb.utils.contains('ACPI_DEBUG', '1', 'file://acpi-debug.cfg', '', d)} \
    "
