#!/bin/bash

set -e

# nowdir: $PROJECT_ROOT (vyos-bpi-r4)

### vyos-build
# add default and dhcpv4 configuration
cp data/config.boot.default vyos-arm64-build/vyos-build/data/live-build-config/includes.chroot/opt/vyatta/etc/

cd vyos-arm64-build
# fix kernel config
patch --no-backup-if-mismatch -p1 -d vyos-build < ../patches/vyos-build/tmp-from-huihuimoe-vyos-build-001-kernel_config.patch
# sign kernel module but donot sign vmlinuz
patch --no-backup-if-mismatch -p1 -d vyos-build < data/vyos-build-007-no_sbsign.patch
patch --no-backup-if-mismatch -p1 -d vyos-build < data/vyos-build-008-fix_live_boot_initramfs_link.patch
