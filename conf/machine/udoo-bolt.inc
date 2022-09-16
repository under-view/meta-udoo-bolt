require conf/machine/v1000.conf

IMAGE_CLASSES += "efi-boot-populate"

# We only support IMAGE_FSTYPES "wic"
IMAGE_FSTYPES = "ext4 wic wic.gz wic.bmap"

# Contents of IMAGE_BOOT_FILES are deployed into "$WKS_FILES" wic image
IMAGE_BOOT_FILES = "\
  ${EFIIMGDIR}${EFIDIR}/*;EFI/BOOT/ \
  ${EFIIMGDIR}/startup.nsh;startup.nsh \
  ${KERNEL_IMAGETYPE} \
"

# This makes sure that boot files are deployed before do_image_wic starts execution
do_image_wic[depends] += "${IMAGE_BASENAME}:do_bootimg"
do_image_wic[vardeps] += "BOLT_ROOT_DEVICE KERNEL_IMAGETYPE"

PREFERRED_PROVIDER_virtual/kernel ?= "linux-yocto"
PREFERRED_VERSION_linux-yocto ?= "5.15%"
PREFERRED_VERSION_linux-yocto-rt ?= "5.15%"
