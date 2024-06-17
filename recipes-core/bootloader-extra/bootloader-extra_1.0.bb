SUMMARY = "Recipe to place extra files that can be used by \
bootloader into a specific directory. That the wics plugin \
x64-liveusb-isohybrid may see."

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SECTION = "bootloaders"

DEPENDS = ""

SRC_URI:amd ?= "\
    file://amd.jpg \
    file://grub.cfg \
    file://isolinux.cfg \
    "

inherit deploy

do_deploy() {
    install -d ${DEPLOYDIR}/bootloader-extra

    install -m 0644 "${UNPACKDIR}/amd.jpg" ${DEPLOYDIR}/bootloader-extra
    install -m 0644 "${UNPACKDIR}/grub.cfg" ${DEPLOYDIR}/bootloader-extra/grub.cfg
    install -m 0644 "${UNPACKDIR}/isolinux.cfg" ${DEPLOYDIR}/bootloader-extra/isolinux.cfg

    MENU_ENTRY="${@bb.utils.contains("MACHINE", "udoo-bolt-live-usb", "liveusb", "emmc", d)}"

    sed -i -e "s#@KERNEL_IMAGETYPE@#${KERNEL_IMAGETYPE}#g" \
           -e "s#@KERNEL_ARGS@#${KERNEL_ARGS}#g" \
           -e "s#@MENU_ENTRY@#${MENU_ENTRY}#g" \
              ${DEPLOYDIR}/bootloader-extra/grub.cfg

    sed -i -e "s#@KERNEL_IMAGETYPE@#${KERNEL_IMAGETYPE}#g" \
           -e "s#@KERNEL_ARGS@#${KERNEL_ARGS}#g" \
           -e "s#@MENU_ENTRY@#${MENU_ENTRY}#g" \
              ${DEPLOYDIR}/bootloader-extra/isolinux.cfg
}

addtask do_deploy after do_install
do_deploy[vardeps] += "KERNEL_ARGS KERNEL_IMAGETYPE"
