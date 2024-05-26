SUMMARY = "Final liveusb wic image"

LICENSE = "MIT"

inherit core-image

IMAGE_FSTYPES = "wic wic.gz wic.bmap"

INITRD ?= "${MLPREFIX}udoo-minimal-initramfs"

do_rootfs() {
    :
}

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
