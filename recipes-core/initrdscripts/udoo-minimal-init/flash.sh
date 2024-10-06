#!/bin/sh

count=0
rootdev_found=0

efi_dir="/tmp/efi"
data_dir="/tmp/data"
grub_modules="normal part_msdos part_gpt multiboot"

mkdir -p "${efi_dir}"
mkdir -p "${data_dir}"

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

partprobe

efi_boot="$(blkid --match-token PARTLABEL="efi_system" -o device)"
grub_data="$(blkid --match-token PARTLABEL="grub_data" -o device)"

mount -v "${efi_boot}" "${efi_dir}" || \
{
	echo "[x] mount ${efi_boot} -> ${efi_dir} failed!"
	exec sh
}

mount -v "${grub_data}" "${data_dir}" || \
{
	echo "[x] mount ${grub_data} -> ${data_dir} failed!"
	umount "${efi_dir}"
	exec sh
}

# Install grub uefi
"${liveusb_mnt}/grub-efi"/grub-install \
	--target="x86_64-efi" \
	--bootloader-id="GRUB" \
	--no-nvram \
	--directory="${liveusb_mnt}/grub-efi/grub-core" \
	--efi-directory="${efi_dir}" \
	--modules="${grub_modules}" \
	--root-directory="${data_dir}" \
	--no-floppy "${rootdev}" || \
{
	echo "[x] grub-install: Failed to install UEFI grub!"
	umount "${efi_dir}"
	umount "${data_dir}"
	exec sh
}

# Install grub bios
"${liveusb_mnt}/grub-bios"/grub-install \
	--target="i386-pc" \
	--directory="${liveusb_mnt}/grub-bios/grub-core" \
	--root-directory="${data_dir}" \
	--modules="${grub_modules}" \
	--no-floppy "${rootdev}" || \
{
	echo "[x] grub-install: Failed to install BIOS grub!"
	umount "${efi_dir}"
	umount "${data_dir}"
	exec sh
}

mkdir -p "${efi_dir}/EFI/BOOT"
mkdir -p "${data_dir}/boot/grub"

cp -av "${efi_dir}/EFI/GRUB/grubx64.efi" "${efi_dir}/EFI/BOOT/BOOTX64.EFI"
cp -av "${liveusb_mnt}/image-boot-files/grub.cfg" "${data_dir}/boot/grub/grub.cfg"

umount "${efi_dir}"
umount "${data_dir}"
