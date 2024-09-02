SUMMARY = "Final emmc wic image"

LICENSE = "MIT"

inherit core-image image-artifact-names

IMAGE_FSTYPES = "ext4 wic wic.gz wic.bmap"

ROOTFS ?= "${IMGDEPLOYDIR}/${IMAGE_LINK_NAME}.ext4"

WICVARS:append = "\
    ROOTFS \
    "

do_image_wic[depends] += "dosfstools-native:do_populate_sysroot \
                          mtools-native:do_populate_sysroot \
                          util-linux-native:do_populate_sysroot \
                          gptfdisk-native:do_populate_sysroot \
                          bootloader-extra:do_deploy \
                          virtual/kernel:do_deploy \
                          "
