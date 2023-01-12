PREFERRED_PROVIDER_virtual/kernel ?= "${@bb.utils.contains('RT_KERNEL_AMD', 'yes', "linux-yocto-rt", "linux-yocto", d)}"
PREFERRED_VERSION_linux-yocto ?= "5.15%"
PREFERRED_VERSION_linux-yocto-rt ?= "5.15%"
PREFERRED_PROVIDER_virtual/libglx ?= "mesa"

IMAGE_CLASSES += "efi-boot-populate"

# We only support IMAGE_FSTYPES "wic"
IMAGE_FSTYPES = "ext4 wic wic.gz wic.bmap"

KERNEL_IMAGETYPE = "bzImage"

# Contents of IMAGE_BOOT_FILES are deployed into "$WKS_FILES" wic image
IMAGE_BOOT_FILES = "\
  ${EFIIMGDIR}${EFIDIR}/*;EFI/BOOT/ \
  ${EFIIMGDIR}/startup.nsh;startup.nsh \
  ${KERNEL_IMAGETYPE} \
  "

# This makes sure that boot files are deployed before do_image_wic starts execution
do_image_wic[depends] += "${IMAGE_BASENAME}:do_bootimg"
do_image_wic[vardeps] += "BOLT_ROOT_DEVICE KERNEL_IMAGETYPE"

UDOO_BOLT_ESSENTIAL_EXTRA_RDEPENDS ?= ""
MACHINE_ESSENTIAL_EXTRA_RDEPENDS = "linux-firmware-amdgpu ${UDOO_BOLT_ESSENTIAL_EXTRA_RDEPENDS}"

XSERVER ?= "\
  xserver-xorg \
  xf86-input-evdev \
  xf86-video-amdgpu \
  ${@bb.utils.contains('DISTRO_FEATURES', 'opengl', 'xserver-xorg-extension-glx', '', d)} \
  "

OPENGLX_FEATURE_ENABLED ?= "${@bb.utils.contains('DISTRO_FEATURES', 'opengl x11', 'true', 'false', d)}"
