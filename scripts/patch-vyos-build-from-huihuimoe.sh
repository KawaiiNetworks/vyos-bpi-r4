#!/bin/bash

set -e

# nowdir: $PROJECT_ROOT (vyos-bpi-r4)

### vyos-build
# add default and dhcpv4 configuration
cp data/config.boot.default vyos-arm64-build/vyos-build/data/live-build-config/includes.chroot/opt/vyatta/etc/

cd vyos-arm64-build
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