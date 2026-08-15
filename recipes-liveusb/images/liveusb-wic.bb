inherit amd-image-wic

COPY_DIRECT_ENTRIES = "\
    ${EMMC_DEPLOY_IMAGE_DIR}/emmc-wic-udoo-bolt-emmc.wic.gz; \
    ${EMMC_DEPLOY_IMAGE_DIR}/emmc-wic-udoo-bolt-emmc.wic.bmap; \
    "

WICVARS:append = "\
    COPY_DIRECT_ENTRIES \
    "

do_image_wic[mcdepends] += "\
    mc:::virtual/kernel:do_deploy \
    mc::liveusb-install:virtual/kernel:do_deploy \
    mc::emmc:emmc-wic:do_image_complete \
    "

do_image_wic[depends] += "dosfstools-native:do_populate_sysroot \
                          mtools-native:do_populate_sysroot \
                          cdrtools-native:do_populate_sysroot \
                          syslinux-native:do_populate_sysroot \
                          ${MLPREFIX}syslinux:do_populate_sysroot \
                          liveusb-boot:do_deploy \
                          "
