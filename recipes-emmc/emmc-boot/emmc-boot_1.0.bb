SUMMARY = "Recipe to place extra files that will be used \
after install and resides on the boot partition \
(i.e grub configs, etc...)"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SECTION = "bootloaders"

DEPENDS = ""

inherit deploy

do_deploy() {
    install -d ${DEPLOYDIR}/image-boot-files

    install -m 0644 ${THISDIR}/files/grub.cfg ${DEPLOYDIR}/image-boot-files

    sed -i -e "s#@KERNEL_IMAGETYPE@#${KERNEL_IMAGETYPE}#g" \
           -e "s#@KERNEL_ARGS@#${KERNEL_ARGS}#g" \
              ${DEPLOYDIR}/image-boot-files/grub.cfg
}

addtask do_deploy
do_deploy[vardeps] += "KERNEL_ARGS KERNEL_IMAGETYPE"
do_deploy[nostamp] = "1"
