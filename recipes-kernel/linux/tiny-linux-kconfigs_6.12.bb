SUMMARY = "Clones and copies repo that stores all kernel Kconfig symbols"
HOMEPAGE = "https://github.com/under-view/tiny-linux-kconfigs"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=e3bf24f6d9404087a466a27410dc3b66"

SRC_URI = "git://git@github.com/under-view/tiny-linux-kconfigs.git;protocol=https;branch=master"
SRCREV ?= "065e2e2eaa2bbfcb66f47e9dddc462b453d94ea4"

S = "${UNPACKDIR}/${BPN}-${PV}"

do_install() {
    install -d ${D}${datadir}/linux-cfgs-${PV}
    cp -r ${S}/linux-${PV}/* ${D}${datadir}/linux-cfgs-${PV}
}

BBCLASSEXTEND += "native"
