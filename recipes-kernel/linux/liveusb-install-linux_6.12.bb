require recipes-kernel/linux/amd-linux-tiny.inc

LINUX_VERSION = "6.12.101"

SRCREV_amdmeta = "adefda3dcc704c943baca24e3bbda7674d35b6ae"

INITRAMFS_IMAGE_BUNDLE = "1"

INITRAMFS_IMAGE = "liveusb-initramfs-install"
INITRAMFS_IMAGE_NAME = "liveusb-initramfs-install-${MACHINE}"

AMD_KERNEL_FEATURES:append = "\
    virtio.scc \
    "
