# vyos-bpi-r4

VyOS for BPI-R4

arch/arm64/configs/mt7988a_bpi-r4_defconfig:3759:warning: symbol value '0' invalid for BASE_SMALL not
arch/arm64/configs/mt7988a_bpi-r4_defconfig:9697:warning: symbol value 'm' invalid for FSCACHE y
arch/arm64/configs/mt7988a_bpi-r4_defconfig:10199:warning: symbol value 'm' invalid for CRYPTO_ARCH_HAVE_LIB_CHACHA y
arch/arm64/configs/mt7988a_bpi-r4_defconfig:10206:warning: symbol value 'm' invalid for CRYPTO_ARCH_HAVE_LIB_POLY1305 y

Previous value: .\*=\d
16
vyos 覆盖 bpi 没问题

Previous value: .\*="
5
Previous value: CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug" 不该动
Previous value: CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1" 不该动

Previous value: .\*=y
196

Previous value: .\*=m
15

Previous value: .\* not set
1119

./build-vyos-image \
 --architecture arm64 \
 --build-by "canoziia@projectk.org" \
 --custom-package nexttrace \
 --custom-package vim-tiny \
 --custom-package vnstat \
 --custom-package neofetch \
 --custom-package tree \
 --custom-package btop \
 --custom-package ripgrep \
 --custom-package wget \
 --custom-package ncdu \
 --custom-package fastnetmon \
 --custom-package containernetworking-plugins \
 --custom-package qemu-guest-agent \
 generic

localversion
apt install gcc-aarch64-linux-gnu u-boot-tools bc make gcc ccache libc6-dev libncurses5-dev libssl-dev bison flex

apt-get install -y device-tree-compiler
apt-get install -y libelf-dev kmod

apt-get install -y libdw-dev libdebuginfod-dev systemtap-sdt-dev libunwind-dev libslang2-dev libperl-dev python3-dev python3 llvm-dev libzstd-dev libnuma-dev libbabeltrace-ctf-dev libcapstone-dev libpfm4-dev libtraceevent-dev libtracefs-dev default-jdk clang binutils-dev libcap-dev libbpf-dev asciidoc xmlto

accel-ppp-ng qat igb ixgbe ixgbevf jool nat-rtsp ovpn-dco

sh-5.2# dpkg-query -W -f='${Package} ${Depends}\n' | grep linux-image-6.6.114-vyos
jool linux-image-6.6.114-vyos, libc6 (>= 2.34), libnl-3-200 (>= 3.2.24), libnl-genl-3-200 (>= 3.2.21)
linux-image-6.6.114-vyos
nat-rtsp linux-image-6.6.114-vyos
openvpn-dco linux-image-6.6.114-vyos

cp ./scripts/package-build/linux-kernel/linux-firmware/mediatek/mt7988/\* build/chroot/lib/firmware/mediatek/mt7988/
123 cp ./scripts/package-build/linux-kernel/linux-firmware/mediatek/mt7986_wo_1.bin build/chroot/lib/firmware/mediatek/
124 cp ./scripts/package-build/linux-kernel/linux-firmware/mediatek/mt7986_wo_0.bin build/chroot/lib/firmware/mediatek/
125 cp ./scripts/package-build/linux-kernel/linux-firmware/mediatek/mt7986_wo.bin build/chroot/lib/firmware/mediatek/
126 cp ./scripts/package-build/linux-kernel/linux-firmware/mediatek/mt7981_wo.bin build/chroot/lib/firmware/mediatek/

persistence.conf

最好复制整个 linux-firmware/mediatek 过去

EPHEMERAL_KEY="/tmp/ephemeral.key"
EPHEMERAL_PEM="/tmp/ephemeral.pem"
EPHEMERAL_KERNEL_KEY=$(grep -E "^CONFIG_MODULE_SIG_KEY=" ${KERNEL_SRC}/$KERNEL_CONFIG | awk -F= '{print $2}' | tr -d \")
if test -f "${EPHEMERAL_KEY}"; then
rm -f ${EPHEMERAL_KEY}
fi
if test -f "${EPHEMERAL_PEM}"; then
rm -f ${EPHEMERAL_PEM}
fi
if test -f "${KERNEL_SRC}/${EPHEMERAL_KERNEL_KEY}"; then
    openssl rsa -in ${KERNEL_SRC}/${EPHEMERAL_KERNEL_KEY} -out ${EPHEMERAL_KEY}
    openssl x509 -in ${KERNEL_SRC}/${EPHEMERAL_KERNEL_KEY} -out ${EPHEMERAL_PEM}
fi

setcap cap_net_raw,cap_net_admin+eip ${your_nexttrace_path}/nexttrace

mount -t proc /proc chroot/proc
mount -t sysfs /sys chroot/sys
mount -o bind /dev chroot/dev
mount -o bind /dev/pts chroot/dev/pts

umount chroot/proc
umount chroot/sys
umount chroot/dev/pts
umount chroot/dev

live 是因为不是用 iso 解包的 chroot
bl2file fipfile

https://gist.github.com/BtbN/9e5878d83816fb49d51d1f76c42d7945
grub-install --no-floppy --recheck --target=arm64-efi --force-extra-removable --boot-directory=/lib/live/mount/persistence/boot/ --efi-directory=/lib/live/mount/persistence/boot/efi --bootloader-id="VyOS"

grub-install --no-floppy --recheck --target=arm64-efi --force-extra-removable --boot-directory=/lib/live/mount/persistence/1/boot/ --efi-directory=/lib/live/mount/persistence/1/boot/efi --bootloader-id="VyOS"

rename git branch to -vyos

mkimage -A arm64 -T ramdisk -C none -d initrd.img uInitrd
