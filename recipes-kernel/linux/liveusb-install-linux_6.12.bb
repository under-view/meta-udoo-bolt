require recipes-kernel/linux/amd-linux-tiny.inc

LINUX_VERSION = "6.12.101"

INITRAMFS_IMAGE_BUNDLE = "1"

INITRAMFS_IMAGE = "liveusb-initramfs-install"
INITRAMFS_IMAGE_NAME = "liveusb-initramfs-install-${MACHINE}"
