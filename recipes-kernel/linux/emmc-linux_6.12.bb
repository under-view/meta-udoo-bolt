require recipes-kernel/linux/amd-linux-tiny.inc

LINUX_VERSION = "6.12.101"

SRCREV_amdmeta = "adefda3dcc704c943baca24e3bbda7674d35b6ae"

AMD_KERNEL_FEATURES:append = "\
    virtio.scc \
    "
