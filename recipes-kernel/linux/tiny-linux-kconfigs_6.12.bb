SUMMARY = "Clones and copies repo that stores all kernel Kconfig symbols"
HOMEPAGE = "https://github.com/under-view/tiny-linux-kconfigs"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=e3bf24f6d9404087a466a27410dc3b66"

SRC_URI = "git://git@github.com/under-view/tiny-linux-kconfigs.git;protocol=https;branch=master"
SRCREV ?= "4277405c0e15a66468ae9776459c90297104347c"

S = "${UNPACKDIR}/${BPN}-${PV}"

do_install() {
    install -d ${D}${datadir}/tiny-linux-kconfigs
    cp -r ${S}/* ${D}${datadir}/tiny-linux-kconfigs
}

BBCLASSEXTENDS += "native"
