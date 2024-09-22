require ./udoo-minimal-initramfs.inc

INITRAMFS_SCRIPTS:append = "\
    udoo-minimal-init \
    "
