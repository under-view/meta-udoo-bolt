inherit amd-image-wic

AMD_IMAGE_DEPENDS = "\
    liveub-initramfs-console \
    liveub-initramfs-install \
    "

COPY_DIRECT_ENTRIES = "\
    ${EMMC_DEPLOY_IMAGE_DIR}/emmc-wic-udoo-bolt-emmc.wic.gz; \
    ${EMMC_DEPLOY_IMAGE_DIR}/emmc-wic-udoo-bolt-emmc.wic.bmap; \
    "

WICVARS:append = "\
    COPY_DIRECT_ENTRIES \
    "

do_image_wic[mcdepends] += "\
    mc::emmc:emmc-wic:do_image_complete \
    "

do_image_wic[depends] += "dosfstools-native:do_populate_sysroot \
                          mtools-native:do_populate_sysroot \
                          cdrtools-native:do_populate_sysroot \
                          syslinux-native:do_populate_sysroot \
                          ${MLPREFIX}syslinux:do_populate_sysroot \
                          liveusb-boot:do_deploy \
                          virtual/kernel:do_deploy \
                          "
