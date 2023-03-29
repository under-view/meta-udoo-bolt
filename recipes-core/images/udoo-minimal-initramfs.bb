DESCRIPTION = "Minimal initramfs/initrd image for UDOO bolt"
LICENSE = "MIT"

UDOO_INITRD_INSTALL ??= ""

UDOO_INITRD_BASEUTILS ?= "busybox udev base-passwd"

INITRAMFS_SCRIPTS ?= "\
    initramfs-framework-base \
    initramfs-module-setup-live \
    initramfs-module-udev \
    initramfs-module-install \
    initramfs-module-install-efi \
    "

PACKAGE_INSTALL = "\
    ${INITRAMFS_SCRIPTS} \
    ${UDOO_INITRD_BASEUTILS} \
    ${ROOTFS_BOOTSTRAP_INSTALL} \
    ${UDOO_INITRD_INSTALL} \
    "

IMAGE_FEATURES = ""
IMAGE_LINGUAS = ""

COPY_LIC_MANIFEST = "0"
COPY_LIC_DIRS = "0"

KERNELDEPMODDEPEND = ""

IMAGE_ROOTFS_SIZE = "32768"
IMAGE_ROOTFS_EXTRA_SPACE = "0"

FORCE_RO_REMOVE ?= "1"

inherit core-image

IMAGE_FSTYPES = "${INITRAMFS_FSTYPES}"

IMAGE_POSTPROCESS_COMMAND = ""

# inherited class efi-boot-populate will cause udoo-minimal-initramfs to execute
# do_bootimg which depends on do_image_ext4. The ext4 fs extension isn't in IMAGE_FSTYPES.
deltask do_bootimg
