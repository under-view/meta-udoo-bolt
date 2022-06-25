require conf/machine/v1000.conf

# We only support IMAGE_FSTYPES "wic" and "iso"
IMAGE_FSTYPES = "wic wic.gz wic.bmap iso"

# Contents of IMAGE_BOOT_FILES are deployed into "$WKS_FILES" wic image
IMAGE_BOOT_FILES = "\
  ${EFIIMGDIR}${EFIDIR}/*;EFI/BOOT/ \
  ${EFIIMGDIR}/startup.nsh;startup.nsh \
  ${KERNEL_IMAGETYPE} \
"

# This makes sure that boot files are deployed before do_image_wic starts execution
do_image_wic[depends] += "${IMAGE_BASENAME}:do_bootimg"
