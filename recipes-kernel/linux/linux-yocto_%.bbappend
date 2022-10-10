FILESEXTRAPATHS:prepend := "${THISDIR}/kernel-configs:"

SRC_URI:append = "\
  file://fix-linux-yocto-5.15-warning.cfg \
  "
