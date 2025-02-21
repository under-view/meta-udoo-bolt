PREFERRED_PROVIDER_virtual/kernel ?= "linux-yocto"
PREFERRED_VERSION_linux-yocto ?= "6.12%"
PREFERRED_VERSION_linux-yocto-rt ?= "6.12%"
PREFERRED_PROVIDER_jpeg ?= "jpeg"
PREFERRED_PROVIDER_jpeg-native ?= "jpeg-native"

ACPI_DEBUG ?= "0"
ACPI_DEBUG_KERNEL_ARGS ?= "log_buf_len=16M acpi.debug_layer=0x00000002 acpi.debug_level=0x00000004"

KERNEL_IMAGETYPE = "bzImage"

BOLT_BLOCK_DEVICE ?= "/dev/mmcblk0"

UDOO_BOLT_ESSENTIAL_EXTRA_RDEPENDS ?= ""

# QEMU does not support some of the enhanced instructions available
# on the AMD chips which causes some build time failures.
MACHINE_FEATURES:remove = "qemu-usermode"
MACHINE_FEATURES += "wifi efi"
MACHINE_EXTRA_RRECOMMENDS += "kernel-modules alsa-utils"
MACHINE_EXTRA_RRECOMMENDS += "grub parted util-linux-blkid"
MACHINE_ESSENTIAL_EXTRA_RDEPENDS = "linux-firmware-amdgpu ${UDOO_BOLT_ESSENTIAL_EXTRA_RDEPENDS}"

XSERVER ?= "\
    xserver-xorg \
    xf86-input-evdev \
    xf86-video-amdgpu \
    ${@bb.utils.contains('DISTRO_FEATURES', 'opengl', 'xserver-xorg-extension-glx', '', d)} \
    "

OPENGLX_FEATURE_ENABLED ?= "${@bb.utils.contains('DISTRO_FEATURES', 'opengl x11', 'true', 'false', d)}"
