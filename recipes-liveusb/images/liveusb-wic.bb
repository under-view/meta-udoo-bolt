inherit amd-liveusb-wic

COPY_DIRECT_ENTRIES = "${AMD_ARTIFACTS_DIR}"

LIVEUSB_INITRAMFS = "1"
LIVEUSB_SPLASH = "amd.jpg"
LIVEUSB_GRUB_KERNEL_ARGS = "${KERNEL_ARGS}"
LIVEUSB_SYSLINUX_KERNEL_ARGS = "${KERNEL_ARGS}"
# Can be kernel + initramfs or kernel + initrd
LIVEUSB_CONSOLE = "bzImage-initramfs-liveusb-console-${MACHINE}.bin"
LIVEUSB_INSTALL = "bzImage-initramfs-liveusb-install-${MACHINE}.bin"
LIVEUSB_INSTALL_DEPLOY_DIR_IMAGE = "${TMPDIR}-liveusb-install/deploy/images/${MACHINE}"

IMAGE_POSTPROCESS_COMMAND:remove = "gen_build_artifact_dir;"

WICVARS:append = "\
    COPY_DIRECT_ENTRIES \
    "

do_image_wic[mcdepends] += "\
    mc:::virtual/kernel:do_deploy \
    mc::liveusb-install:virtual/kernel:do_deploy \
    mc::emmc:emmc-wic:do_image_complete \
    "

do_image_wic[depends] += "liveusb-boot:do_deploy"
