#
# Copyright Underview Contributors
#
# SPDX-License-Identifier: GPL-2.0-only
#
# DESCRIPTION
# Given a list of files and directories copy them
# into a partition.
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
#handler = logging.StreamHandler(stream=sys.stdout)
#logger.addHandler(handler)
#logger.setLevel(logging.DEBUG)
#logger.setLevel(logging.INFO)

class CopyDirect(SourcePlugin):
    """
    COPY_DIRECT_ENTRIES = "/path/to/file.txt;/path/to/directory"
    WICVARS:append = " COPY_DIRECT_ENTRIES"
    """

    name = 'copy_direct'

    @classmethod
    def do_prepare_partition(cls, part, source_params, creator, cr_workdir,
                             oe_builddir, bootimg_dir, kernel_dir,
                             rootfs_dir, native_sysroot):
        """
        Called to do the actual content population for a partition i.e. it
        'prepares' the partition to be incorporated into the image.
        """

        wdir = "%s/wdir" % cr_workdir

        copy_direct_entries = get_bitbake_var('COPY_DIRECT_ENTRIES')
        if not copy_direct_entries:
            raise WicError("Must add ';' seperated list of files "
                           "and directories into COPY_DIRECT_ENTRIES")

        copy_direct_entries = copy_direct_entries.replace(' ', '')
        logger.debug('Copy Direct %s', copy_direct_entries)

        entries = copy_direct_entries.split(';')

        os.makedirs(wdir, exist_ok=True)

        for entry in entries:
            if not entry:
                continue
            elif os.path.isfile(entry):
                shutil.copy2(entry, wdir, follow_symlinks=True)
            elif os.path.isdir(entry):
                shutil.copytree(entry, wdir)
            else:
                raise WicError("Invalid option '%s'" % entry)

        logger.debug('Prepare partition using rootfs in %s', wdir)
        part.prepare_rootfs(cr_workdir, oe_builddir, wdir,
                            native_sysroot, False)
