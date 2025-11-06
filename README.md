# vyos-bpi-r4

本项目为个人学习项目，主要目的是将 VyOS 系统移植到 BPI-R4 开发板上使用。

项目依赖：

-   [vyos-1x](https://github.com/vyos/vyos-1x)
-   [vyos-build](https://github.com/vyos/vyos-build)
-   [vyos-arm64-build](https://github.com/huihuimoe/vyos-arm64-build)
-   [vyos-arm64-autobuild](https://github.com/KawaiiNetworks/vyos-arm64-autobuild)
-   [BPI-Router-Linux](https://github.com/frank-w/BPI-Router-Linux)
-   [u-boot for banana pi](https://github.com/frank-w/u-boot)

## 构建环境准备

```bash
git clone https://github.com/huihuimoe/vyos-arm64-build
docker run -it --privileged --sysctl net.ipv6.conf.lo.disable_ipv6=0 -v $(pwd):/vyos -w /vyos ghcr.io/huihuimoe/vyos-arm64-build/vyos-builder:current-arm64 bash
apt-get install -y gcc-aarch64-linux-gnu u-boot-tools bc make gcc ccache libc6-dev libncurses5-dev libssl-dev bison flex device-tree-compiler libelf-dev kmod libdw-dev libdebuginfod-dev systemtap-sdt-dev libunwind-dev libslang2-dev libperl-dev python3-dev python3 llvm-dev libzstd-dev libnuma-dev libbabeltrace-ctf-dev libcapstone-dev libpfm4-dev libtraceevent-dev libtracefs-dev default-jdk clang binutils-dev libcap-dev libbpf-dev asciidoc xmlto
cd vyos-arm64-build
git clone https://github.com/vyos/vyos-build
bash ../scripts/set_kernel_version.sh
```

## patch vyos-1x/vyos-build 并构建 vyos-1x

说明：本部分介绍几乎完全摘录于 vyos-arm64-build 的 github workflows

Patch

```bash
### vyos-1x
git clone --recursive https://github.com/vyos/vyos-1x -b current --single-branch vyos-build/scripts/package-build/vyos-1x/vyos-1x
# fixing unknown internal blob file
# i don't know what is this file and why it's not in the repo
# without this file, the build will failed
# https://github.com/vyos/vyos-1x/commit/bab186b493145ee42453196e8ef4670afc71f6f1
# https://github.com/vyos/vyos-1x/commit/dd5f9c19550c1f8ccb5e93bab0b604f9f9e1383e
cp data/reftree.cache vyos-build/scripts/package-build/vyos-1x/vyos-1x/data/reftree.cache
# apply patches
patch --no-backup-if-mismatch -p1 -d vyos-build/scripts/package-build/vyos-1x/vyos-1x < data/vyos-1x-001-system_console.patch
patch --no-backup-if-mismatch -p1 -d vyos-build/scripts/package-build/vyos-1x/vyos-1x < data/vyos-1x-002-boot_console.patch
patch --no-backup-if-mismatch -p1 -d vyos-build/scripts/package-build/vyos-1x/vyos-1x < data/vyos-1x-003-increase_vyshim_init_timeout.patch
patch --no-backup-if-mismatch -p1 -d vyos-build/scripts/package-build/vyos-1x/vyos-1x < data/vyos-1x-004-enable_telegraf_support.patch
# Error: OCI runtime error: crun: cannot set memory+swap limit less than the memory limit
patch --no-backup-if-mismatch -p1 -d vyos-build/scripts/package-build/vyos-1x/vyos-1x < data/vyos-1x-005-fix_podman_service.patch
patch --no-backup-if-mismatch -p1 -d vyos-build/scripts/package-build/vyos-1x/vyos-1x < data/vyos-1x-006-install-image-reserve-gap.patch
# https://github.com/vyos/vyos-1x/commit/1478516ae437f19ebeb7d6ff9b83dd74f8e76758
sed -i 's/all: clean copyright/all: clean/' vyos-build/scripts/package-build/vyos-1x/vyos-1x/Makefile

### vyos-build
# add default and dhcpv4 configuration
cp ../data/config.boot.default vyos-build/data/live-build-config/includes.chroot/opt/vyatta/etc/
# fix kernel config
patch --no-backup-if-mismatch -p1 -d vyos-build < data/vyos-build-001-kernel_config.patch
patch --no-backup-if-mismatch -p1 -d vyos-build < data/vyos-build-002-mksquashfs_universal.patch
patch --no-backup-if-mismatch -p1 -d vyos-build < data/vyos-build-003-fix_hardcoded_x86_64.patch
# fix on https://github.com/vyos/vyos-build/commit/82a40e68c7e4b3ea45fb2bbc4a1a7cff92e41942
#patch --no-backup-if-mismatch -p1 -d vyos-build < data/vyos-build-004-fix_saltproject_package_url.patch
patch --no-backup-if-mismatch -p1 -d vyos-build < data/vyos-build-005-add_vim_link.patch
patch --no-backup-if-mismatch -p1 -d vyos-build < data/vyos-build-006-fix_kernel_sign.patch
# sign kernel module but donot sign vmlinuz
patch --no-backup-if-mismatch -p1 -d vyos-build < data/vyos-build-007-no_sbsign.patch
patch --no-backup-if-mismatch -p1 -d vyos-build < data/vyos-build-008-fix_live_boot_initramfs_link.patch
patch --no-backup-if-mismatch -p1 -d vyos-build < data/vyos-build-009-live_boot_serial_console_device.patch
```

Build vyos-1x

```bash
cd vyos-build/scripts/package-build/vyos-1x
./build.py
ls -la *.deb
mv *.deb ../../../packages/
```

## 构建 Linux Kernel 以及相关模块包

构建 Kernel

```bash
cd ../linux-kernel
git clone --branch 6.17-main --single-branch https://github.com/frank-w/BPI-Router-Linux linux
cd linux
git branch -m 6.17-vyos
# apply patches
# 前三个 patches 来自 vyos-build 并被修改适配当前内核版本
patch -p1 < ../../../../../../patches/vyos-build/0001-linkstate-ip-device-attribute.patch
patch -p1 < ../../../../../../patches/vyos-build/0002-inotify-support-for-stackable-filesystems.patch
patch -p1 < ../../../../../../patches/vyos-build/0003-build-linux-perf-package.patch
patch -p1 < ../patches/kernel/v4-0001-nft_ct-Added-nfct_seqadj_ext_add-for-DNAT-ed-conn.patch
patch -p1 < ../../../../../../patches/BPI-Router-Linux/0001-bpi-r4-eth-name.patch
cp ../../../../../../patches/mt7988a_bpi-r4_defconfig arch/arm64/configs/mt7988a_bpi-r4_defconfig
cd ../../../..
patch -p1 < ../../patches/vyos-build/0011-build-linux-package-toml.patch
patch -p1 < ../../patches/vyos-build/0012-build-jool.patch
patch -p1 < ../../patches/vyos-build/0013-build-linux-firmware.patch
cd scripts/package-build/linux-kernel/linux
bash build.sh importconfig
bash build.sh build
bash build.sh pack_debs
bash build.sh pack
ls -la ../*.deb
```

linux-firmware accel-ppp-ng qat igb ixgbe ixgbevf jool nat-rtsp ovpn-dco

```bash
cd ..
bash ../../../../../scripts/set_kernel-vars.sh
bash ../../../../../scripts/genkey.sh
./build.py --packages linux-firmware accel-ppp-ng qat igb ixgbe ixgbevf jool nat-rtsp ovpn-dco
ls -la *.deb
mv *.deb ../../../packages/
```

## 构建 VyOS 镜像

```bash
cd ../../..
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
```

到这里我们获得了一个 iso 文件，不过 iso 并不能使用，我们需要的只是其中的 filesystem.squashfs 文件。
