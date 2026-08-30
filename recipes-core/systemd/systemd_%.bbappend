# Remove/Enabling standard systemd services

FILESEXTRAPATHS:prepend := "${THISDIR}/systemd-serialgetty:"

SRC_URI:append = "\
    file://serial-getty.service \
    "

# Disable the login console (getty@tty1)
do_install:append() {
    rm ${D}${systemd_unitdir}/system/getty@.service
    rm ${D}${systemd_unitdir}/system/getty-pre.target

    install -m 0644 ${UNPACKDIR}/serial-getty.service \
        ${D}${systemd_system_unitdir}/serial-getty@.service
}
