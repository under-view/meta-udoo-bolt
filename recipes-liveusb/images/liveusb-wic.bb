inherit amd-liveusb-wic

COPY_DIRECT_ENTRIES = "\
    ${EMMC_DEPLOY_IMAGE_DIR}/emmc-wic-udoo-bolt-emmc.wic.gz; \
    ${EMMC_DEPLOY_IMAGE_DIR}/emmc-wic-udoo-bolt-emmc.wic.bmap; \
    "

LIVEUSB_INITRAMFS = "1"
# Can be kernel + initramfs or kernel + initrd
LIVEUSB_CONSOLE = "bzImage-initramfs-${MACHINE}.bin"
LIVEUSB_INSTALL = "bzImage-initramfs-install-${MACHINE}.bin"

do_image_wic[mcdepends] += "\
    mc:::virtual/kernel:do_deploy \
    mc::liveusb-install:virtual/kernel:do_deploy \
    mc::emmc:emmc-wic:do_image_complete \
    "

do_image_wic[depends] += "liveusb-boot:do_deploy"
