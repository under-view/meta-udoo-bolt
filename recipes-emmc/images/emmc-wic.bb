inherit amd-image-wic

AMD_IMAGE_DEPENDS = "\
    emmc-rootfs \
    "

EMMC_ROOTFS = "emmc-rootfs-${MACHINE}.ext4"

WICVARS:append = "\
    GRUB_CONFIG_FILE \
    EMMC_ROOTFS \
    "

do_image_wic[depends] += "\
        emmc-boot:do_deploy \
        "
