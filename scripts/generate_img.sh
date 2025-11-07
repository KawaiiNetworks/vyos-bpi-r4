#!/bin/bash

set -e

IMG="bpi-r4_sdmmc.img"
IMGGZ="bpi-r4_sdmmc.img.gz"
IMG_8G_PATCH="bpi-r4_sdmmc_8GB_bl2.img"
MOUNT_P5="p5"
MOUNT_P6="p6"
LABEL_P6="persistence"

mkdir -p $PROJECT_ROOT/build
. build.conf
cd $PROJECT_ROOT/vyos-arm64-build/vyos-build/build
mkdir -p img
cd img

wget https://github.com/KawaiiNetworks/u-boot-bpi-r4/releases/latest/download/bpi-r4_sdmmc.img.gz -O "$IMGGZ"
wget https://github.com/KawaiiNetworks/u-boot-bpi-r4/releases/latest/download/bpi-r4_sdmmc_8GB_bl2.img -O "$IMG_8G_PATCH"

gzip --decompress "$IMGGZ"

export START_P1=$(fdisk -l "$IMG" | awk '/^'"$IMG"'1/ {print $2}')

echo "Partition 1 (bl2) start sector: $START_P1"

kpartx -av "$IMG"
LOOP_DEV=$(losetup -j "$IMG" | cut -d: -f1)
MAPPED_DEV="/dev/mapper/$(basename $LOOP_DEV)"

mkdir -p "$MOUNT_P5" "$MOUNT_P6"
mount "${MAPPED_DEV}p5" "$MOUNT_P5"
mount "${MAPPED_DEV}p6" "$MOUNT_P6"
rm -rf "$MOUNT_P6/lost+found"
mkdir -p "$MOUNT_P6/boot/$build_version"

e2label "${MAPPED_DEV}p6" "$LABEL_P6"

mkdir -p ../iso
mount -o loop ../vyos-$build_version-generic-arm64.iso ../iso
cp -a ../iso/live/filesystem.squashfs "$MOUNT_P6/boot/$build_version/$build_version.squashfs"
umount ../iso
rm -rf ../iso


cp $PROJECT_ROOT/data/uEnv.txt "$MOUNT_P5/"
wget https://github.com/KawaiiNetworks/u-boot-bpi-r4/releases/latest/download/bpi-r4_spim-nand_ubi_8GB_bl2.img -P "$MOUNT_P5/"
wget https://github.com/KawaiiNetworks/u-boot-bpi-r4/releases/latest/download/bpi-r4_spim-nand_ubi_8GB_fip.bin -P "$MOUNT_P5/"
wget https://github.com/KawaiiNetworks/u-boot-bpi-r4/releases/latest/download/bpi-r4_spim-nand_ubi_bl2.img -P "$MOUNT_P5/"
wget https://github.com/KawaiiNetworks/u-boot-bpi-r4/releases/latest/download/bpi-r4_spim-nand_ubi_fip.bin -P "$MOUNT_P5/"

cp $PROJECT_ROOT/data/vyos.txt "$MOUNT_P6/boot/"
echo "vyosversion=$build_version" >> "$MOUNT_P6/boot/vyos.txt"
cp $PROJECT_ROOT/data/persistence.conf "$MOUNT_P6/"
cp -a ../chroot/boot/* "$MOUNT_P6/boot/$build_version/"
mkimage -A arm64 -T ramdisk -C none -d initrd.img-$kernel_version-vyos uInitrd
python3 $PROJECT_ROOT/scripts/install_grub.py

tar -czpvf $PROJECT_ROOT/build/vyos-$build_version.tar.gz -C $MOUNT_P6/boot $build_version

sync
umount "$MOUNT_P5" "$MOUNT_P6"
kpartx -dv "$IMG"
losetup -d "$LOOP_DEV"
kpartx -d "$LOOP_DEV"

IMG_4G=vyos-$build_version-4GBRAM.img
mv "$IMG" "$IMG_4G"
gzip "$IMG_4G" -c > "$IMG_4G.gz"

IMG_8G=vyos-$build_version-8GBRAM.img
cp "$IMG_4G" "$IMG_8G"
dd if="$IMG_8G_PATCH" of="$IMG_8G" seek="$START_P1" conv=notrunc,fsync status=progress
gzip "$IMG_8G" -c > "$IMG_8G.gz"

rm -rf "$IMG_8G"
rm -rf "$IMG_8G_PATCH"
rm -rf "$MOUNT_P5" "$MOUNT_P6"
mv img/*.img.gz $PROJECT_ROOT/build/

echo "Generated images are located in the $PROJECT_ROOT/build/ directory:"
ls -la $PROJECT_ROOT/build/