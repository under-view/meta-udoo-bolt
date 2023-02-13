FILESEXTRAPATHS:prepend := "${THISDIR}/linux-yocto-5.19:"

KMACHINE:amd ?= "common-pc-64"
SRCREV_meta:amd ?= "0cba9aa40445bf59bfa651e1bd43a31c2ca7d524"
LINUX_VERSION:amd ?= "5.19.17"
LINUX_VERSION_EXTENSION:amd ?= "-amd-${LINUX_KERNEL_TYPE}"

COMPATIBLE_MACHINE = "${MACHINE}"

INC_PR := "r0"

SRC_URI:append:amd = " \
      file://afalg.cfg \
      file://amd-xgbe.cfg \
      file://amdx86-extra-config.cfg \
      file://amdx86-standard-only.cfg \
      file://amdx86-user-config.cfg \
      file://amdx86.cfg \
      file://console.cfg \
      file://fragment.cfg \
      file://hid.cfg \
      file://logo.cfg \
      file://sound.cfg \
      file://spi-driver.cfg \
      file://usb-serial.cfg \
      file://wdt-driver.cfg \
      ${@bb.utils.contains('ACPI_DEBUG', '1', 'file://enable-acpi-debug.cfg', '', d)} \
      ${@bb.utils.contains('MACHINE_FEATURES', 'ccp', 'file://amd-ccp.cfg', '', d)} \
      ${@bb.utils.contains('MACHINE_FEATURES', 'screen', 'file://enable-graphics.cfg', 'file://disable-graphics.cfg', d)} \
      ${@bb.utils.contains('DISTRO_FEATURES', 'bluetooth', 'file://enable-bluetooth.cfg', 'file://disable-bluetooth.cfg', d)} \
      "
