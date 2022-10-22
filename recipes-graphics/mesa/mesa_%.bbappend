FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI:append = "\
  file://0001-meson-libdrm-only-enable-amdgpu-radeon.patch \
  file://0002-meson-bug-install-eglplatform.h.patch \
  "

GALLIUM_DRIVERS = "swrast,radeonsi,r300,r600"
PACKAGECONFIG[gallium] = "-Dgallium-drivers=${@strip_comma('${GALLIUM_DRIVERS}')}, -Dgallium-drivers='', libdrm"
PACKAGECONFIG[vulkan] = "-Dvulkan-drivers=amd,-Dvulkan-drivers='',"
PACKAGECONFIG[glvnd] = "-Dglvnd=true,-Dglvnd=false,libglvnd"

PACKAGECONFIG:append = "\
  ${@bb.utils.contains('DISTRO_FEATURES', 'opengl x11', 'glvnd', '', d)} \
  ${@bb.utils.contains('DISTRO_FEATURES', 'vulkan', 'gallium-llvm vulkan', '', d)} \
  x11 \
  "

# meson configure fails due to llvm-config --shared-mode failing to find libs in ${STAGING_LIBDIR}
# function copies files from recipe-sysroot/usr/lib64 to recipe-sysroot/usr/lib where llvm-config
# command can find libraries
do_configure:prepend() {
  install -d "${STAGING_LIBDIR}/../lib"
  cp -ra ${STAGING_LIBDIR}/* ${STAGING_LIBDIR}/../lib
}

# added patch 0002-meson-bug-install-eglplatform.h.patch to bypass
# mesa sed can't find eglplatform.h as it doesn't get installed
# when glvnd enabled. Command removes file that gets added.
do_install:append() {
  if ${@bb.utils.contains('PACKAGECONFIG', 'glvnd', 'true', 'false', d)}; then
    rm ${D}/usr/include/EGL/eglplatform.h
  fi
}

FILES:${PN} += "\
  ${libdir}/*.so.* \
  ${libdir}/*_mesa.so* \
  ${datadir}/glvnd \
  "

INSANE_SKIP:${PN} = "dev-so"
SOLIBS = ".so"
FILES_SOLIBSDEV = ""
