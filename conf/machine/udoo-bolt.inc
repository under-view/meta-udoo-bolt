require conf/machine/v1000.conf

IMAGE_CLASSES += "efi-boot-populate"

INITRAMFS_FSTYPES = "ext4"

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
