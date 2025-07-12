SUMMARY = "Final emmc wic image"

LICENSE = "MIT"

inherit core-image image-artifact-names

IMAGE_FSTYPES = "ext4 wic wic.gz wic.bmap"

ROOTFS ?= "${IMGDEPLOYDIR}/${IMAGE_LINK_NAME}.ext4"

WICVARS:append = "\
    ROOTFS \
    "

do_image_wic[depends] += "\
    grub-native:do_populate_sysroot \
    grub:do_populate_sysroot \
    grub-efi:do_populate_sysroot \
    "
