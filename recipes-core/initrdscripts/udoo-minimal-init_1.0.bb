DESCRIPTION = "Minimal initramfs init script"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "\
    file://init-boot.sh \
    file://flash.sh \
    "

S = "${WORKDIR}/sources"
UNPACKDIR = "${S}"

RDEPENDS:${PN} += "\
    bmaptool \
    parted \
    efibootmgr \
    "

do_install() {
    install -m 0555 -d ${D}/proc ${D}/sys
    install -m 0755 -d ${D}/dev ${D}/mnt ${D}/run ${D}/usr
    install -m 1777 -d ${D}/tmp
    install -m 0644 -d ${D}/usr/local/bin
    install -m 0755 ${UNPACKDIR}/init-boot.sh ${D}/init
    install -m 0755 ${UNPACKDIR}/flash.sh ${D}/usr/local/bin
    mknod -m 622 ${D}/dev/console c 5 1
}

FILES:${PN} = "/"

PACKAGE_ARCH = "${MACHINE_ARCH}"
