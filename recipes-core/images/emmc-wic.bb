inherit amd-image-wic

AMD_IMAGE_DEPENDS = "\
    emmc-rootfs \
    "

EMMC_ROOTFS = "emmc-rootfs-${MACHINE}.ext4"

WICVARS:append = "\
    EMMC_ROOTFS \
    "
