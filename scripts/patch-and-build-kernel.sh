#!/bin/bash

# nowdir: $PROJECT_ROOT (vyos-bpi-r4)

# patches from huihuimoe/vyos-arm64-build
bash scripts/patch-vyos-build-from-huihuimoe.sh

# clone kernel
cd vyos-arm64-build/vyos-build/scripts/package-build/linux-kernel
git clone --branch 6.17-main --single-branch https://github.com/frank-w/BPI-Router-Linux linux
cd linux
git branch -m 6.17-vyos

# apply patches

# these 4 patches are from vyos/vyos-build and have been modified to fit the current kernel version
patch -p1 < $PROJECT_ROOT/patches/vyos-build/0001-linkstate-ip-device-attribute.patch
patch -p1 < $PROJECT_ROOT/patches/vyos-build/0002-inotify-support-for-stackable-filesystems.patch
patch -p1 < $PROJECT_ROOT/patches/vyos-build/0003-build-linux-perf-package.patch
patch -p1 < $PROJECT_ROOT/vyos-arm64-build/vyos-build/scripts/package-build/linux-kernel/patches/kernel/v4-0001-nft_ct-Added-nfct_seqadj_ext_add-for-DNAT-ed-conn.patch


# these patches are authored by kawaii networks
patch -p1 < $PROJECT_ROOT/patches/BPI-Router-Linux/0001-bpi-r4-eth-name.patch
patch -p1 < $PROJECT_ROOT/patches/BPI-Router-Linux/0002-change-build-device-to-bpi-r4.patch
cp $PROJECT_ROOT/patches/mt7988a_bpi-r4_defconfig arch/arm64/configs/mt7988a_bpi-r4_defconfig

bash build.sh importconfig
bash build.sh build
bash build.sh pack_debs
bash build.sh pack
ls -la ../*.deb
mv ../*.deb $PROJECT_ROOT/vyos-arm64-build/vyos-build/packages/