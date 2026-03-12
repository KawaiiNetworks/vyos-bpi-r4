#!/bin/bash

set -e

# nowdir: $PROJECT_ROOT (vyos-bpi-r4)

cd $PROJECT_ROOT/vyos-arm64-build/vyos-build/scripts/package-build/linux-kernel/linux
export kernel_version=$(make kernelversion)
cd $PROJECT_ROOT
echo "Kernel version: $kernel_version"

echo "Updating kernel_version in $PROJECT_ROOT/build.conf ..."
sed -i "s/^kernel_version=.*/kernel_version=$kernel_version/" $PROJECT_ROOT/build.conf

bash $PROJECT_ROOT/scripts/set_kernel_version.sh
bash $PROJECT_ROOT/scripts/set_kernel-vars.sh # <- that isn't a typo
bash $PROJECT_ROOT/scripts/genkey.sh

cd $PROJECT_ROOT/vyos-arm64-build/vyos-build
patch -p1 < $PROJECT_ROOT/patches/vyos-build/0004-build-realtek.patch
patch -p1 < $PROJECT_ROOT/patches/vyos-build/0011-build-linux-package-toml.patch
patch -p1 < $PROJECT_ROOT/patches/vyos-build/0012-build-jool.patch
patch -p1 < $PROJECT_ROOT/patches/vyos-build/0013-build-linux-firmware.patch

cd scripts/package-build/linux-kernel
./build.py --packages linux-firmware qat igb ixgbe ixgbevf jool nat-rtsp ovpn-dco realtek-r8152 realtek-r8126 ipt-netflow # seems that accel-ppp-ng is not required, I have confirmed jool nat-rtsp ovpn-dco must be built
ls -la *.deb
mv *.deb $PROJECT_ROOT/vyos-arm64-build/vyos-build/packages/
