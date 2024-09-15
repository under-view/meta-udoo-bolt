SUMMARY = "Recipe to place extra files that can be used by \
bootloader into a specific directory. That the wics plugin \
x64-liveusb-isohybrid may see."

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SECTION = "bootloaders"

DEPENDS = ""

inherit deploy

do_deploy() {
    install -d ${DEPLOYDIR}/bootloader-extra

    install -m 0644 "${THISDIR}/files/amd.jpg" ${DEPLOYDIR}/bootloader-extra
    install -m 0644 "${THISDIR}/files/grub.cfg" ${DEPLOYDIR}/bootloader-extra/grub.cfg
    install -m 0644 "${THISDIR}/files/isolinux.cfg" ${DEPLOYDIR}/bootloader-extra/isolinux.cfg

    sed -i -e "s#@KERNEL_IMAGETYPE@#${KERNEL_IMAGETYPE}#g" \
           -e "s#@KERNEL_ARGS@#${KERNEL_ARGS}#g" \
              ${DEPLOYDIR}/bootloader-extra/grub.cfg

    sed -i -e "s#@KERNEL_IMAGETYPE@#${KERNEL_IMAGETYPE}#g" \
           -e "s#@KERNEL_ARGS@#${KERNEL_ARGS}#g" \
              ${DEPLOYDIR}/bootloader-extra/isolinux.cfg
}

addtask do_deploy
do_deploy[vardeps] += "KERNEL_ARGS KERNEL_IMAGETYPE"
