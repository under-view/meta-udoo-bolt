#
# Copyright 2025, Underview
#
# SPDX-License-Identifier: GPL-2.0-only
#
# DESCRIPTION
# This implements the 'grub_install' source plugin class for 'wic'
# Searches for most files in deploy directory of a given MACHINE.
#
# AUTHORS
# Vincent Davis Jr <vince (at] underview.tech>

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
logger.setLevel(logging.DEBUG)
#logger.setLevel(logging.INFO)

class GrubInstall(SourcePlugin):
    """
    Create a bootable wic image with grub as bootloader

    This plugin populates the output wic image with necessary grub boot
    files, installs boot.img and core.img. Enables caller to boot off
    of either legacy bios or UEFI firmware or both with the disk partition
    table format being either GPT or MBR based.

    ****************** Wic Plugin Depends ******************
    do_image_wic[depends] += "\
        grub-native:do_populate_sysroot \
        grub:do_populate_sysroot \
        grub-efi:do_populate_sysroot\
        "
    ****************** Wic Plugin Depends ******************


    ******************* Example kickstart Legacy Bios Boot *******************
    part bios_boot  --label bios_boot  --fstype none --fixed-size 78M
                    --source grub_install --sourceparams="boot_type=bios"

    part roots --label rootfs --fstype ext4 --source rootfs
    bootloader --ptable msdos --source grub_install
    ******************* Example kickstart Legacy Bios Boot *******************


    ********************* Example kickstart UEFI Boot *********************
    part uefi_boot --label uefi_boot --fstype vfat --fixed-size 78M
                   --part-type C12A7328-F81F-11D2-BA4B-00A0C93EC93B
                   --source grub_install --sourceparams="boot_type=uefi"

    part roots --label rootfs --fstype ext4 --source rootfs
    bootloader --ptable gpt --source grub_install
    ********************* Example kickstart UEFI Boot *********************


    *********** Example kickstart Hybrid Legacy Bios Or Newer UEFI Boot ***********
    part bios_boot  --label bios_boot --fstype none --fixed-size 1M
                    --part-type 21686148-6449-6E6F-744E-656564454649
                    --source grub_install --sourceparams="boot_type=hybrid-bios"

    part efi_system --label efi_system --fstype vfat --fixed-size 48M
                    --part-type C12A7328-F81F-11D2-BA4B-00A0C93EC93B
                    --source grub_install --sourceparams="boot_type=hybrid-uefi"

    part grub_data  --label grub_data --fstype ext4 --fixed-size 78M
                    --part-type 0FC63DAF-8483-4772-8E79-3D69D8477DE4
                    --source grub_install --sourceparams="boot_type=modules"

    part roots      --label rootfs --fstype ext4 --source rootfs
                    --part-type 0FC63DAF-8483-4772-8E79-3D69D8477DE4

    bootloader --ptable gpt --source grub_install
    *********** Example kickstart Hybrid Legacy Bios Or Newer UEFI Boot ***********
    """

    name = 'grub_install'

    core_img = ''

    @staticmethod
    def gen_embed_grub_cfg(kernel_dir, grub_cfg_target_path):
        # Create grub config that's embedded into
        # core.img. So, that core.img knows where
        # to search for grub.cfg and normal.mod.
        if not grub_cfg_target_path:
            grub_cfg_target_path = '/boot/grub/grub.cfg'
        embed_cfg_str = 'search.file %s root\n' % (grub_cfg_target_path)
        embed_cfg_str += 'set prefix=($root)/boot/grub\n'
        embed_cfg_str += 'configfile ($root)%s\n' % (grub_cfg_target_path) 
        with open('%s/embed.cfg' % (kernel_dir), 'w+') as f:
            f.write(embed_cfg_str)

    @staticmethod
    def gen_core_img_pc(kernel_dir, native_sysroot,
                        staging_libdir, mkimage_format):

        builtin_modules = 'boot linux ext2 serial part_msdos part_gpt \
        normal multiboot configfile search loadenv test'

        # Generate core.img or grub stage 1.5
        if not mkimage_format:
            mkimage_format = 'i386-pc'

        grub_mkimage_bios = 'grub-mkimage --prefix=/boot/grub \
        --format=%s --config=%s/embed.cfg --directory=%s/grub/%s \
        --output=%s/grub-bios-core.img %s' % \
        (mkimage_format, kernel_dir, staging_libdir,
        mkimage_format, kernel_dir, builtin_modules)

        exec_native_cmd(grub_mkimage_bios, native_sysroot)

    @staticmethod
    def gen_core_img_efi(kernel_dir, native_sysroot,
                         staging_libdir, mkimage_format):
        builtin_modules = 'boot linux ext2 fat serial part_msdos part_gpt normal \
        normal multiboot efi_gop iso9660 configfile search loadenv test'

        # Generate core.img or grub stage 1.5
        if not mkimage_format:
            mkimage_format = 'x86_64-efi'

        grub_mkimage_bios = 'grub-mkimage --prefix=/boot/grub \
        --format=%s --config=%s/embed.cfg --directory=%s/grub/%s \
        --output=%s/grub-bios-core.img %s' % \
        (mkimage_format, kernel_dir, staging_libdir,
        mkimage_format, kernel_dir, builtin_modules)

        exec_native_cmd(grub_mkimage_bios, native_sysroot)

    @classmethod
    @classmethod
    def do_configure_partition(cls, part, source_params, creator, cr_workdir,
                               oe_builddir, bootimg_dir, kernel_dir,
                               native_sysroot):
        """
        Called before do_prepare_partition(), creates loader-specific config
        """
        boot_type = ''
        boot_types = ['bios', 'uefi', 'hybrid-bios', 'hybrid-uefi', 'modules']

        staging_libdir = get_bitbake_var('STAGING_LIBDIR')

        # Optional variables to look for
        mkimage_format_pc = get_bitbake_var('GRUB_MKIMAGE_FORMAT_PC')
        mkimage_format_efi = get_bitbake_var('GRUB_MKIMAGE_FORMAT_EFI')
        grub_cfg_target_path = get_bitbake_var('GRUB_CONFIG_TARGET_PATH')

        if not source_params['boot_type'] in boot_types:
            raise WicError("grub_install requires a boot_type per partition.\n" \
                           "Examples: %s" % (boot_types))

        boot_type = source_params['boot_type']

        cls.gen_embed_grub_cfg(kernel_dir, grub_cfg_target_path)
        cls.gen_core_img_pc(kernel_dir, native_sysroot,
                            staging_libdir, mkimage_format_pc)
        cls.gen_core_img_efi(kernel_dir, native_sysroot,
                             staging_libdir, mkimage_format_pc)

        raise WicError("Succcess")

    @classmethod
    def do_prepare_partition(cls, part, source_params, creator, cr_workdir,
                             oe_builddir, bootimg_dir, kernel_dir,
                             rootfs_dir, native_sysroot):
        """
        Called to do the actual content population for a partition i.e. it
        'prepares' the partition to be incorporated into the image.
        """

        part_img = ''

        sdir = "%s/sdir" % cr_workdir
        if os.path.exists(sdir):
            shutil.rmtree(sdir)

        du_cmd = "du -Lbks %s" % part_img
        out = exec_cmd(du_cmd)
        part_img_size = int(out.split()[0])

        part.size = part_img_size
        part.source_file = part_img

    @classmethod
    def do_install_disk(cls, disk, disk_name, creator, workdir, oe_builddir,
                        bootimg_dir, kernel_dir, native_sysroot):
        """
        Called after all partitions have been prepared and assembled into a
        disk image.  In this case, we insert/modify the MBR using isohybrid
        utility for booting via BIOS from disk storage devices.
        """

        #iso_img = "%s.p1" % disk.path
        #full_path = creator._full_path(workdir, disk_name, "direct")
        #full_path_iso = creator._full_path(workdir, disk_name, "iso")

        #os.remove(disk.path)
        #shutil.copy2(iso_img, full_path_iso)
        #shutil.copy2(full_path_iso, full_path)
