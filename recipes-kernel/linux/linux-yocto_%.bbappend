FILESEXTRAPATHS:prepend := "${THISDIR}/kernel-configs:"

# Handle all graphics cfg setting ourselves
# Seems to load in better as modules
SRC_URI:append = "\
  file://fix-linux-yocto-5.15-warning.cfg \
  file://udoo-bolt-amdx86.cfg \
  ${@bb.utils.contains('MACHINE_FEATURES', 'screen', 'file://enable-graphics-extras.cfg', 'file://disable-graphics-extras.cfg', d)} \
  "

SRC_URI:remove = "\
  file://amdx86.cfg \
  file://enable-graphics.cfg \
  "
