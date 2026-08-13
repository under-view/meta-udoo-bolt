#!/bin/sh

export PATH=/sbin:/bin:/usr/sbin:/usr/bin
export liveusb rootdev liveusb_mnt

mount -t proc proc -o nosuid,nodev,noexec /proc
mount -t devtmpfs none -o nosuid /dev
mount -t sysfs sysfs -o nosuid,nodev,noexec /sys

rootfs_mnt="/tmp/rootfs-mnt"
liveusb_mnt="/tmp/mnt"

rootdev="$(awk -F 'BOLT_BLOCK_DEVICE=' '{print $2}' /proc/cmdline | cut -d " " -f1)"

mkdir -p "${rootfs_mnt}"
mkdir -p "${liveusb_mnt}"

# Wait for liveusb
echo "Waiting for liveusb..."
while true; do
	liveusb="/dev/$(lsblk -o NAME,LABEL | grep LIVEUSB | head -n1 | awk '{print $1}')"
	test -b "${liveusb}" && { break ; }
	sleep 0.1
done

# Mount liveusb IMAGES partition
liveusb_mnt_part="/dev/$(lsblk -lo NAME,LABEL | grep IMAGES | awk '{print $1}')"
mount -v "${liveusb_mnt_part}" "${liveusb_mnt}" || {
	echo "[x] mount: ${liveusb_mnt_part} ${liveusb_mnt} failed"
	exec sh
}

# Install system image
. /usr/local/bin/flash.sh

echo "Installation finished reboot!"

exec sh
