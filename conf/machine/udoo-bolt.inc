require conf/machine/v1000.conf

# We only support IMAGE_FSTYPES "wic" and "iso"
IMAGE_FSTYPES = "wic wic.gz wic.bmap iso"

# Contents of IMAGE_BOOT_FILES are deployed into "$WKS_FILES" wic image
IMAGE_BOOT_FILES = "\
  ${EFIIMGDIR}${EFIDIR}/*;EFI/BOOT/ \
  ${EFIIMGDIR}/startup.nsh;startup.nsh \
  ${KERNEL_IMAGETYPE} \
"

# At the moment OE-core variables in grub-efi-cfg.bbclass
# (i.e GRUB_SERIAL, GRUB_TIMEOUT, GRUB_OPTS)
# aren't being overridin in the layer
GRUB_SERIAL ?= "console=ttyS0,115200n8"
GRUB_TIMEOUT ?= "1"
GRUB_OPTS ?= "serial --unit=0 --speed=115200 --word=8 --parity=no --stop=1"

KERNEL_SERIAL_CONSOLE ?= "console=tty1 console=ttyS0,115200n8"
SERIAL_CONSOLES ?= "115200;ttyS0"

# This makes sure that boot files are deployed before do_image_wic starts execution
do_image_wic[depends] += "${IMAGE_BASENAME}:do_bootimg"
