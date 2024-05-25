#
# Copyright Underview Contributors
#
# SPDX-License-Identifier: GPL-2.0-only
#
# DESCRIPTION
# This implements the 'x64-liveusb-isohybrid' source plugin class for 'wic'
# Searches for most files in deploy directory of a given MACHINE.
#
# AUTHORS
# Vincent Davis Jr <vince (at] underview.tech>
#
# Based on oe-core isoimage-isohybrid

import glob
import logging
import sys
import os
import re
import shutil

from wic import WicError
from wic.engine import get_custom_config
from wic.pluginbase import SourcePlugin
from wic.misc import exec_cmd, exec_native_cmd, get_bitbake_var

logger = logging.getLogger('wic')
handler = logging.StreamHandler(stream=sys.stdout)
logger.addHandler(handler)
#logger.setLevel(logging.DEBUG)
logger.setLevel(logging.INFO)

class LiveusbIsohybrid(SourcePlugin):
    """
    Create a bootable ISO image

    This plugin creates a hybrid, legacy and EFI bootable ISO image. The
    generated image can be used on optical media as well as USB media.

    Legacy boot uses syslinux and EFI boot uses grub or gummiboot (not
    implemented yet) as bootloader. The plugin creates the directories required
    by bootloaders and populates them by creating and configuring the
    bootloader files.

    Example kickstart file:
    part /boot --source liveusb-isohybrid --sourceparams="loaders=grub-efi|syslinux"

    NOT FULLY SUPPORTED YET
    part /boot --source liveusb-isohybrid --sourceparams="loaders=systemd-boot|syslinux"
    """

    name = 'liveusb-isohybrid'

    @staticmethod
    def _install_syslinux(isodir, kernel_dir, bootimg_dir):
        # Prepare files for legacy boot
        # Prefer to utilize wic-tools recipe-sysroot
        isolinux_dir = "%s/isolinux" % isodir
        syslinux_dir = bootimg_dir + "/syslinux"
        bootloader_extra_dir = kernel_dir + "/bootloader-extra"

        if not syslinux_dir:
            raise WicError("Couldn't find STAGING_DATADIR, exiting.")

        if os.path.exists(isolinux_dir):
            shutil.rmtree(isolinux_dir)

        install_cmd = "install -d %s" % isolinux_dir
        exec_cmd(install_cmd)

        install_cmd = "install -m 444 %s/isolinux.cfg " % bootloader_extra_dir
        install_cmd += "%s/isolinux.cfg" % isolinux_dir
        exec_cmd(install_cmd)

        install_cmd = "install -m 444 %s/ldlinux.sys " % syslinux_dir
        install_cmd += "%s/ldlinux.sys" % isolinux_dir
        exec_cmd(install_cmd)

        install_cmd = "install -m 444 %s/isohdpfx.bin " % syslinux_dir
        install_cmd += "%s/isolinux/isohdpfx.bin" % isodir
        exec_cmd(install_cmd)

        install_cmd = "install -m 644 %s/isolinux.bin " % syslinux_dir
        install_cmd += "%s/isolinux.bin" % isolinux_dir
        exec_cmd(install_cmd)

        install_cmd = "install -m 644 %s/ldlinux.c32 " % syslinux_dir
        install_cmd += "%s/ldlinux.c32" % isolinux_dir
        exec_cmd(install_cmd)

    @staticmethod
    def _install_grub_efi(isodir, kernel_dir):
        bootloader_extra_dir = "%s/bootloader-extra" % kernel_dir

        target_dir = "%s/EFI/BOOT" % isodir
        if os.path.exists(target_dir):
            shutil.rmtree(target_dir)

        os.makedirs(target_dir)

        # Builds bootx64.efi/bootia32.efi if ISODIR didn't exist or
        # didn't contains it
        target_arch = get_bitbake_var("TARGET_SYS")
        if not target_arch:
            raise WicError("Coludn't find target architecture")

        if re.match("x86_64", target_arch):
            grub_src_image = "grub-efi-bootx64.efi"
            grub_dest_image = "bootx64.efi"
        elif re.match('i.86', target_arch):
            grub_src_image = "grub-efi-bootia32.efi"
            grub_dest_image = "bootia32.efi"
        else:
            raise WicError("grub-efi is incompatible with target %s" % target_arch)

        grub_src = "%s/%s" % (kernel_dir, grub_src_image)
        grub_target = "%s/%s" % (target_dir, grub_dest_image)

        grub_cfg_src = "%s/grub.cfg" % (bootloader_extra_dir)
        grub_cfg_target = "%s/grub.cfg" % (target_dir)

        shutil.copy(grub_src, grub_target, follow_symlinks=True)
        shutil.copy(grub_cfg_src, grub_cfg_target, follow_symlinks=True)

    @staticmethod
    def _install_efi_image(isodir, kernel_dir, native_sysroot, source_params, part):
        # Default to 100 blocks of extra space for file system overhead
        esp_extra_blocks = int(source_params.get('esp_extra_blocks', '100'))

        du_cmd = "du -bks %s/EFI" % isodir
        out = exec_cmd(du_cmd)
        blocks = int(out.split()[0])
        blocks += esp_extra_blocks
        logger.debug("Added %d extra blocks to %s to get to %d total blocks",
                     esp_extra_blocks, part.mountpoint, blocks)

        # dosfs image for EFI boot
        bootimg = "%s/efi.img" % isodir

        esp_label = source_params.get('esp_label', 'EFIimg')

        dosfs_cmd = 'mkfs.vfat -n \'%s\' -S 512 -C %s %d' \
                    % (esp_label, bootimg, blocks)
        exec_native_cmd(dosfs_cmd, native_sysroot)

        mmd_cmd = "mmd -i %s ::/EFI" % bootimg
        exec_native_cmd(mmd_cmd, native_sysroot)

        mcopy_cmd = "mcopy -i %s -s %s/EFI/* ::/EFI/" \
                    % (bootimg, isodir)
        exec_native_cmd(mcopy_cmd, native_sysroot)

        chmod_cmd = "chmod 644 %s" % bootimg
        exec_cmd(chmod_cmd)

    @staticmethod
    def _install_kernel(isodir, kernel_dir):
        kernel = "%s/%s" % (kernel_dir, get_bitbake_var("KERNEL_IMAGETYPE"))
        shutil.copy(kernel, isodir, follow_symlinks=True)

    @staticmethod
    def _install_initrd(isodir, kernel_dir):
        machine = get_bitbake_var("MACHINE")
        initrd_name = get_bitbake_var("INITRD")
        initrd = "%s/%s-%s.rootfs.cpio.gz" % (kernel_dir,initrd_name,machine)
        shutil.copy(initrd, isodir + "/initrd", follow_symlinks=True)

    @staticmethod
    def _create_iso_image(isodir, iso_img, native_sysroot, part):
        iso_bootimg = "isolinux/isolinux.bin"
        iso_bootcat = "isolinux/boot.cat"
        efi_img = "efi.img"

        mkisofs_cmd = "mkisofs -V %s " % part.label
        mkisofs_cmd += "-o %s -U " % iso_img
        mkisofs_cmd += "-J -joliet-long -r -iso-level 2 -b %s " % iso_bootimg
        mkisofs_cmd += "-c %s -no-emul-boot -boot-load-size 4 " % iso_bootcat
        mkisofs_cmd += "-boot-info-table -eltorito-alt-boot "
        mkisofs_cmd += "-eltorito-platform 0xEF -eltorito-boot %s " % efi_img
        mkisofs_cmd += "-no-emul-boot %s " % isodir

        logger.debug("running command: %s", mkisofs_cmd)
        exec_native_cmd(mkisofs_cmd, native_sysroot)

        shutil.rmtree(isodir)

    @classmethod
    def do_prepare_partition(cls, part, source_params, creator, cr_workdir,
                             oe_builddir, bootimg_dir, kernel_dir,
                             rootfs_dir, native_sysroot):
        """
        Called to do the actual content population for a partition i.e. it
        'prepares' the partition to be incorporated into the image.
        In this case, prepare content for a bootable ISO image.
        """

        isodir = "%s/ISO" % cr_workdir
        if os.path.exists(isodir):
            shutil.rmtree(isodir)

        cls._install_grub_efi(isodir, kernel_dir)
        cls._install_efi_image(isodir, kernel_dir, native_sysroot, source_params, part)
        cls._install_syslinux(isodir, kernel_dir, bootimg_dir)
        cls._install_kernel(isodir, kernel_dir)
        cls._install_initrd(isodir, kernel_dir)

        iso_img = "%s/tempiso_img.iso" % cr_workdir
        cls._create_iso_image(isodir, iso_img, native_sysroot, part)

        du_cmd = "du -Lbks %s" % iso_img
        out = exec_cmd(du_cmd)
        isoimg_size = int(out.split()[0])

        part.size = isoimg_size
        part.source_file = iso_img

    @classmethod
    def do_install_disk(cls, disk, disk_name, creator, workdir, oe_builddir,
                        bootimg_dir, kernel_dir, native_sysroot):
        """
        Called after all partitions have been prepared and assembled into a
        disk image.  In this case, we insert/modify the MBR using isohybrid
        utility for booting via BIOS from disk storage devices.
        """

        iso_img = "%s.p1" % disk.path
        full_path = creator._full_path(workdir, disk_name, "direct")
        full_path_iso = creator._full_path(workdir, disk_name, "iso")

        isohybrid_cmd = "isohybrid -u %s" % iso_img
        logger.debug("running command: %s", isohybrid_cmd)
        exec_native_cmd(isohybrid_cmd, native_sysroot)

        # Replace the image created by direct plugin with the one created by
        # mkisofs command. This is necessary because the iso image created by
        # mkisofs has a very specific MBR is system area of the ISO image, and
        # direct plugin adds and configures an another MBR.
        logger.debug("Replacing the image created by direct plugin\n")

        os.remove(disk.path)
        shutil.copy2(iso_img, full_path_iso)
        shutil.copy2(full_path_iso, full_path)
