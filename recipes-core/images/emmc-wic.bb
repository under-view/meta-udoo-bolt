SUMMARY = "Final emmc wic image"

LICENSE = "MIT"

inherit core-image image-artifact-names

IMAGE_FSTYPES = "ext4 wic wic.gz wic.bmap"

GRUB_CONFIG_PATH = "${DEPLOY_DIR_IMAGE}/image-boot-files/grub.cfg"
ROOTFS ?= "${IMGDEPLOYDIR}/${IMAGE_LINK_NAME}.ext4"

WICVARS:append = "\
    ROOTFS \
    GRUB_CONFIG_PATH \
    "

do_image_wic[depends] += "\
    grub-native:do_populate_sysroot \
    grub:do_populate_sysroot \
    grub-efi:do_populate_sysroot \
    image-boot-files:do_deploy \
    "
