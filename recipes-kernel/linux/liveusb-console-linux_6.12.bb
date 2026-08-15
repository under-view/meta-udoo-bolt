require recipes-kernel/linux/amd-linux-tiny.inc

LINUX_VERSION = "6.12.101"

INITRAMFS_IMAGE_BUNDLE = "1"

INITRAMFS_IMAGE = "liveub-initramfs-console"
INITRAMFS_IMAGE_NAME = "liveub-initramfs-console-${MACHINE}"
