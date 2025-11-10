#!/bin/bash

set -e

# nowdir: $PROJECT_ROOT (vyos-bpi-r4)
# this script should be run as root

cd $VYOS_BUILD_ROOT
patch -p1 < $PROJECT_ROOT/patches/vyos-build/0015-add-nexttrace-repo-amd64.patch
cp $PROJECT_ROOT/patches/vyos-build/9999-kawaii-networks-custom.chroot data/live-build-config/hooks/live/

export build_version=$(date +"%Y.%m.%d-%H%M-rolling")
echo "Build version: $build_version"
mkdir -p $PROJECT_ROOT/build
echo $build_version > $PROJECT_ROOT/build/vyos_version

#  for china builders
#  --debian-mirror "http://mirrors.pku.edu.cn/debian" \
#  --debian-security-mirror "http://mirrors.pku.edu.cn/debian-security" \

#  --custom-package fastnetmon \
#  --custom-package vnstat \

./build-vyos-image \
 --architecture amd64 \
 --version $build_version \
 --build-by "canoziia@projectk.org" \
 --custom-package bgpq4 \
 --custom-package btop \
 --custom-package containernetworking-plugins \
 --custom-package gdu \
 --custom-package nexttrace \
 --custom-package vim-tiny \
 --custom-package neofetch \
 --custom-package qemu-guest-agent \
 --custom-package ripgrep \
 --custom-package tree \
 --custom-package wget \
 generic

ls -la $VYOS_BUILD_ROOT/build/

mv $VYOS_BUILD_ROOT/build/*.iso $PROJECT_ROOT/build/