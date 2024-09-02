SUMMARY = "Final liveusb wic image"

LICENSE = "MIT"

inherit core-image image-artifact-names

IMAGE_FSTYPES = "ext4 wic wic.gz wic.bmap"

INITRD ?= "${MLPREFIX}udoo-minimal-initramfs"

do_image_wic[depends] += "dosfstools-native:do_populate_sysroot \
                          mtools-native:do_populate_sysroot \
                          cdrtools-native:do_populate_sysroot \
                          util-linux-native:do_populate_sysroot \
                          syslinux-native:do_populate_sysroot \
                          ${MLPREFIX}syslinux:do_populate_sysroot \
                          grub-efi:do_deploy \
                          grub:do_deploy \
                          bootloader-extra:do_deploy \
                          virtual/kernel:do_deploy \
                          ${@'%s:do_image_complete' % d.getVar('INITRD') if d.getVar('INITRD') else ''} \
                          "
