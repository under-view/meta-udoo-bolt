SUMMARY = "Final liveusb wic image"

LICENSE = "MIT"

inherit core-image image-artifact-names

IMAGE_FSTYPES = "ext4 wic wic.gz wic.bmap"

ROOTFS ?= "${IMGDEPLOYDIR}/${IMAGE_LINK_NAME}.ext4"
INITRD ?= "${MLPREFIX}udoo-minimal-initramfs"

WICVARS:append = "\
    ROOTFS \
    "

do_image_wic[depends] += "dosfstools-native:do_populate_sysroot \
                          mtools-native:do_populate_sysroot \
                          cdrtools-native:do_populate_sysroot \
                          util-linux-native:do_populate_sysroot \
                          syslinux-native:do_populate_sysroot \
                          ${MLPREFIX}syslinux:do_populate_sysroot \
                          bootloader-extra:do_deploy \
                          virtual/kernel:do_deploy \
                          ${@'%s:do_image_%s' % (d.getVar('INITRD'), 'cpio') if d.getVar('INITRD') else ''} \
                          "
