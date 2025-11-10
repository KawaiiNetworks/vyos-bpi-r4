#!/bin/bash

set -e

# nowdir: $PROJECT_ROOT (vyos-bpi-r4)

cd $VYOS_BUILD_ROOT
patch -p1 < $PROJECT_ROOT/patches/vyos-build/0011-build-linux-package-toml.patch
patch -p1 < $PROJECT_ROOT/patches/vyos-build/0012-build-jool.patch

cd $VYOS_BUILD_ROOT/scripts/package-build/linux-kernel
./build.py --packages linux-firmware jool nat-rtsp ovpn-dco # seems that accel-ppp-ng is not required, I have confirmed jool nat-rtsp ovpn-dco must be built. qat igb ixgbe ixgbevf is important for amd64 but 6.17 will failed
ls -la ./*.deb
mv ./*.deb $VYOS_BUILD_ROOT/packages/