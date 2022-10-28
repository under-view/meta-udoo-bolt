FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI:append = "\
  file://0001-meson-libdrm-only-enable-amdgpu-radeon.patch \
  file://0002-meson-bug-install-eglplatform.h.patch \
  "

GALLIUM_DRIVERS = "radeonsi,r300,r600"
PACKAGECONFIG[gallium] = "-Dgallium-drivers=${@strip_comma('${GALLIUM_DRIVERS}')}, -Dgallium-drivers='', libdrm"
PACKAGECONFIG[vulkan] = "-Dvulkan-drivers=amd,-Dvulkan-drivers='',glslang-native vulkan-loader vulkan-headers"
PACKAGECONFIG[openglx] = "-Dglvnd=true,-Dglvnd=false,libglvnd"

PACKAGECONFIG:append = "\
  ${@bb.utils.contains('DISTRO_FEATURES', 'opengl x11', 'openglx', '', d)} \
  ${@bb.utils.contains('DISTRO_FEATURES', 'vulkan', 'gallium-llvm vulkan', '', d)} \
  x11 \
  "

# meson configure fails. This is due to llvm-config --shared-mode failing to find libs in ${STAGING_LIBDIR}
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
  if ${@bb.utils.contains('PACKAGECONFIG', 'openglx', 'true', 'false', d)}; then
    rm ${D}${includedir}/EGL/eglplatform.h
  fi
}

PACKAGES =+ "libglx-mesa libglx-mesa-dev"
PROVIDES =+ "${@bb.utils.contains('DISTRO_FEATURES', 'opengl x11', 'virtual/libglx', '', d)}"

FULLP = "${MLPREFIX}libglx-mesa"

DEBIAN_NOAUTONAME:${FULLP} = "1"
RREPLACES:${FULLP} = "libglx"
RPROVIDES:${FULLP} = "libglx"
RCONFLICTS:${FULLP} = "libglx"
RRECOMMENDS:${FULLP} = "${MLPREFIX}mesa-megadriver"

DEBIAN_NOAUTONAME:${FULLP}-native = "1"
RREPLACES:${FULLP}-native = "libglx"
RPROVIDES:${FULLP}-native = "libglx"
RCONFLICTS:${FULLP}-native = "libglx"
RRECOMMENDS:${FULLP}-native = "${MLPREFIX}mesa-megadriver"

DEBIAN_NOAUTONAME:${FULLP}-dev = "1"
RREPLACES:${FULLP}-dev = "libglx-dev"
RPROVIDES:${FULLP}-dev = "libglx-dev"
RCONFLICTS:${FULLP}-dev = "libglx-dev"
RRECOMMENDS:${FULLP}-dev = "${MLPREFIX}mesa-megadriver"

DEBIAN_NOAUTONAME:${FULLP}-dev-native = "1"
RREPLACES:${FULLP}-dev-native = "libglx-dev"
RPROVIDES:${FULLP}-dev-native = "libglx-dev"
RCONFLICTS:${FULLP}-dev-native = "libglx-dev"
RRECOMMENDS:${FULLP}-dev-native = "${MLPREFIX}mesa-megadriver"

FILES:libglx-mesa = "${libdir}/libGLX_mesa.so.* ${datadir}/glvnd"
FILES:libegl-mesa += "${libdir}/libEGL_mesa.so.*"

FILES:libglx-mesa-dev = "${libdir}/libGLX_mesa.*"
FILES:libegl-mesa-dev += "${libdir}/libEGL_mesa.*"
