PACKAGES =+ "${PN}-amdgpu-license ${PN}-amdgpu"

# For amdgpu
LICENSE:${PN}-amdgpu = "Firmware-amdgpu"
LICENSE:${PN}-amdgpu-license = "Firmware-amdgpu"

FILES:${PN}-amdgpu-license = "${nonarch_base_libdir}/firmware/LICENSE.amdgpu"
FILES:${PN}-amdgpu = " \
  ${nonarch_base_libdir}/firmware/amdgpu \
"

RDEPENDS:${PN}-amdgpu += "${PN}-amdgpu-license"
