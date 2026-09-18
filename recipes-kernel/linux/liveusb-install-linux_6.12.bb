require recipes-kernel/linux/amd-linux-tiny.inc

LINUX_VERSION = "6.12.101"

SRCREV_amdmeta = "3e2041ea094baa4bd374c0bda3bf778ef5b8e71a"

INITRAMFS_IMAGE_BUNDLE = "1"

INITRAMFS_IMAGE = "liveusb-initramfs-install"
INITRAMFS_IMAGE_NAME = "liveusb-initramfs-install-${MACHINE}"
