require recipes-kernel/linux/amd-linux-tiny.inc

LINUX_VERSION = "6.12.101"

SRCREV_amdmeta = "b7539a5af405f114402610ad36cb3277584953f8"

INITRAMFS_IMAGE_BUNDLE = "1"

INITRAMFS_IMAGE = "liveusb-initramfs-console"
INITRAMFS_IMAGE_NAME = "liveusb-initramfs-console-${MACHINE}"

AMD_KERNEL_FEATURES:append = "\
    virtio.scc \
    "
