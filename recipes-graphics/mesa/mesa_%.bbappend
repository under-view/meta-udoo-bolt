FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI:append = "\
  file://0001-meson-libdrm-only-enable-amdgpu-radeon.patch \
  "

GALLIUM_DRIVERS = "radeonsi,r300,r600"
PACKAGECONFIG[gallium] = "-Dgallium-drivers=${@strip_comma('${GALLIUM_DRIVERS}')}, -Dgallium-drivers='', libdrm"
PACKAGECONFIG[vulkan] = "-Dvulkan-drivers=amd,-Dvulkan-drivers='',glslang-native vulkan-loader vulkan-headers"

PACKAGECONFIG:append = "\
  ${@bb.utils.contains('DISTRO_FEATURES', 'opengl x11', 'glvnd', '', d)} \
  ${@bb.utils.contains('DISTRO_FEATURES', 'vulkan', 'vulkan', '', d)} \
  gallium-llvm \
  "