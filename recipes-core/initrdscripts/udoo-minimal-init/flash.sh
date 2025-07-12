#!/bin/sh

count=0
rootdev_found=0

efi_dir="/tmp/efi"
data_dir="/tmp/data"
grub_modules="normal part_msdos part_gpt multiboot"

if [ ! -b "${rootdev}" ]; then
	echo "Waiting for ${rootdev}..."
	while [ $count -ne 10 ]; do
		test -b "${rootdev}" && { rootdev_found=1 ; break ; }
		sleep 0.1
		count=$((count+1))
	done

	# If the desired block device not found
	# grab first one that isn't liveusb
	if [ "${rootdev_found}" -eq 0 ]; then
		blocklist="$(lsblk -l -o NAME,LABEL | sed -e '/NAME/d' -e '/LIVEUSB/d' -e '/EFIimg/d')"
		for b in ${blocklist}; do
			rootdev="/dev/${b}"
			test -b "${rootdev}" && { break ; }
		done
	fi
fi

bmaptool copy --bmap "${liveusb_mnt}/emmc-wic-udoo-bolt-emmc.rootfs.wic.bmap" \
		     "${liveusb_mnt}/emmc-wic-udoo-bolt-emmc.rootfs.wic.gz" \
		     "${rootdev}" || \
{
	echo "[x] bmaptool: copy ${liveusb_mnt}/emmc-wic-udoo-bolt-emmc.rootfs.wic.gz -> ${rootdev} failed"
	exec sh
}
