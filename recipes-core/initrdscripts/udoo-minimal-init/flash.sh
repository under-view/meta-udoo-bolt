#!/bin/sh

count=0
rootdev_found=0

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

bmap_file=$(ls ${liveusb_mnt}/*.wic.bmap)
wic_file=$(ls ${liveusb_mnt}/*.wic.gz)
bmaptool copy --bmap "${bmap_file}" "${wic_file}" "${rootdev}" ||  \
{
	echo "[x] bmaptool: copy ${wic_file} -> ${rootdev} failed"
	exec sh
}
