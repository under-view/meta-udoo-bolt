#!/bin/sh

count=0
rootdev=0
rootdev_found=0
install_type="$(awk -F 'INSTALL=' '{print $2}' /proc/cmdline | cut -d " " -f1)"

echo "Waiting for ${rootdev}..."
while [ $count -ne 10 ]; do
	sleep 0.1

	count=$((count+1))

	# Grab first block device that isn't liveusb
	blocklist="$(lsblk -l -o NAME,LABEL | sed -e '/NAME/d' -e '/LIVEUSB/d' -e '/EFIimg/d')"
	for b in ${blocklist}; do
		rootdev="/dev/${b}"
		test -b "${rootdev}" && { count=10 ; break ; }
	done
done

test -b "${rootdev}"
if [ $? -ne 0 ]; then
	echo "[x] suitable block device not found"
	exec sh
fi

bmap_file=$(ls ${liveusb_mnt}/${install_type}/*.wic.bmap)
wic_file=$(ls ${liveusb_mnt}/${install_type}/*.wic.gz)
bmaptool copy --bmap "${bmap_file}" "${wic_file}" "${rootdev}" ||  \
{
	echo "[x] bmaptool: copy ${wic_file} -> ${rootdev} failed"
	exec sh
}
