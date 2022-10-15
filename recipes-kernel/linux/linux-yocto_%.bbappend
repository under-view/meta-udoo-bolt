FILESEXTRAPATHS:prepend := "${THISDIR}/kernel-configs:"

# Handle all graphics cfg setting ourselves
# amdgpu driver requires linux-firmware-amdgpu, but can't load it to later in the boot process.
# if CONFIG_DRM_AMDGPU=y run into
# amdgpu 0000:05:00.0: Direct firmware load for amdgpu/raven_gpu_info.bin failed with error -2
# amdgpu 0000:05:00.0: amdgpu: Failed to load gpu_info firmware "amdgpu/raven_gpu_info.bin"
# amdgpu 0000:05:00.0: amdgpu: Fatal error during GPU init
# amdgpu 0000:05:00.0: amdgpu: amdgpu: finishing device.
# Add amdgpu driver as a module so that the driver can properly load the firmware
SRC_URI:append = "\
  file://fix-linux-yocto-5.15-warning.cfg \
  file://udoo-bolt-amdx86.cfg \
  ${@bb.utils.contains('MACHINE_FEATURES', 'screen', 'file://enable-graphics-extras.cfg', 'file://disable-graphics-extras.cfg', d)} \
  "

SRC_URI:remove = "\
  file://amdx86.cfg \
  file://enable-graphics.cfg \
  "
