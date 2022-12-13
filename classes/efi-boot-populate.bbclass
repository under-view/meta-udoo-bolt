inherit image-artifact-names
require conf/image-uefi.conf

GRUB_CFG ??= ""
EFIIMGDIR = "${S}/efi_img"

ROOTFS ?= "${IMGDEPLOYDIR}/${IMAGE_LINK_NAME}.ext4"

# Taken from: https://github.com/openembedded/openembedded-core/blob/kirkstone/meta/classes/live-vm-common.bbclass#L67
populate_kernel() {
  dest=$1
  install -d $dest

  # Install bzImage, initrd, and rootfs.img in DEST for all loaders to use.
  bbnote "Trying to install ${DEPLOY_DIR_IMAGE}/${KERNEL_IMAGETYPE} as $dest/${KERNEL_IMAGETYPE}"
  if [ -e ${DEPLOY_DIR_IMAGE}/${KERNEL_IMAGETYPE} ]; then
    install -m 0644 ${DEPLOY_DIR_IMAGE}/${KERNEL_IMAGETYPE} $dest/${KERNEL_IMAGETYPE}
  else
    bbwarn "${DEPLOY_DIR_IMAGE}/${KERNEL_IMAGETYPE} doesn't exist"
  fi

  # initrd is made of concatenation of multiple filesystem images
  if [ -n "${INITRD}" ]; then
    rm -f $dest/initrd
    for fs in ${INITRD}
    do
      if [ -s "$fs" ]; then
        cat $fs >> $dest/initrd
      else
        bbfatal "$fs is invalid. initrd image creation failed."
      fi
    done
    chmod 0644 $dest/initrd
  fi
}

# Taken from: https://github.com/openembedded/openembedded-core/blob/kirkstone/meta/classes/image-live.bbclass
populate_live() {
  populate_kernel $1
  if [ -s "${ROOTFS}" ]; then
    install -m 0644 ${ROOTFS} $1/rootfs.img
  fi
}

# Taken from: https://github.com/openembedded/openembedded-core/blob/kirkstone/meta/classes/live-vm-common.bbclass#L32
efi_populate() {
  # DEST must be the root of the image so that EFIDIR is not
  # nested under a top level directory.
  DEST="${S}/efi_img"

  install -d ${DEST}${EFIDIR}

  populate_live ${S}

  EFIPATH=$(echo "${EFIDIR}" | sed 's/\//\\/g')
  printf 'fs0:%s\%s\n' "${EFIPATH}" "${EFI_BOOT_IMAGE}" > ${DEST}/startup.nsh
  echo -e "${GRUB_CFG}" > ${DEST}${EFIDIR}/grub.cfg

  install -m 0644 ${DEPLOY_DIR_IMAGE}/grub-efi-${EFI_BOOT_IMAGE} ${DEST}${EFIDIR}/${EFI_BOOT_IMAGE}
}

python do_bootimg() {
  bb.build.exec_func('efi_populate', d)
  bb.build.exec_func('create_symlinks', d)
}

addtask bootimg before do_image_complete after do_rootfs

do_bootimg[imgsuffix] = "."
do_bootimg[depends] += "dosfstools-native:do_populate_sysroot \
                        mtools-native:do_populate_sysroot \
                        cdrtools-native:do_populate_sysroot \
                        virtual/kernel:do_deploy \
                        ${MLPREFIX}syslinux:do_populate_sysroot \
                        syslinux-native:do_populate_sysroot \
                        ${@'%s:do_image_%s' % (d.getVar('PN'), 'ext4') if d.getVar('ROOTFS') else ''} \
                        "
