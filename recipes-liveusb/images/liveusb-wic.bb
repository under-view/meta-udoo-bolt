inherit amd-liveusb-wic

COPY_DIRECT_ENTRIES = "${AMD_ARTIFACTS_DIR}"

LIVEUSB_INITRAMFS = "1"
# Can be kernel + initramfs or kernel + initrd
LIVEUSB_CONSOLE = "bzImage-initramfs-liveusb-console-${MACHINE}.bin"
LIVEUSB_INSTALL = "bzImage-initramfs-liveusb-install-${MACHINE}.bin"
LIVEUSB_INSTALL_DEPLOY_DIR_IMAGE = "${TMPDIR}-liveusb-install/deploy/images/${MACHINE}"

do_image_wic[mcdepends] += "\
    mc:::virtual/kernel:do_deploy \
    mc::liveusb-install:virtual/kernel:do_deploy \
    mc::emmc:emmc-wic:do_image_complete \
    "

do_image_wic[depends] += "liveusb-boot:do_deploy"

python symlink_liveusb_install() {
    import os

    liveusb_install_src = '%s/%s' % \
        (d.getVar('LIVEUSB_INSTALL_DEPLOY_DIR_IMAGE'), \
         d.getVar('LIVEUSB_INSTALL'))

    liveusb_install_dst = '%s/%s' % \
        (d.getVar('DEPLOY_DIR_IMAGE'), \
         d.getVar('LIVEUSB_INSTALL'))

    if os.path.isfile(liveusb_install_src):
        try:
            os.remove(liveusb_install_dst)
        except FileNotFoundError:
            pass

        os.symlink(liveusb_install_src, liveusb_install_dst)
}

do_image_wic[prefuncs] += "symlink_liveusb_install"
