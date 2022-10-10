FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI:append = " file://0001-meson-libdrm-only-enable-amdgpu-radeon.patch"

GALLIUM_DRIVERS = "swrast,radeonsi,r300,r600"
PACKAGECONFIG[gallium] = "-Dgallium-drivers=${@strip_comma('${GALLIUM_DRIVERS}')}, -Dgallium-drivers='', libdrm"
PACKAGECONFIG[vulkan] = "-Dvulkan-drivers=amd,-Dvulkan-drivers='',"

PACKAGECONFIG:append = "\
  ${@bb.utils.contains('DISTRO_FEATURES', 'vulkan', 'gallium-llvm vulkan', '', d)} \
  "

# meson configure fails due to llvm-config --shared-mode failing to find libs in ${STAGING_LIBDIR}
# function copies files from recipe-sysroot/usr/lib64 to recipe-sysroot/usr/lib where llvm-config
# command can find libraries
do_configure:prepend() {
  install -d "${STAGING_LIBDIR}/../lib"
  cp -ra ${STAGING_LIBDIR}/* ${STAGING_LIBDIR}/../lib
}
