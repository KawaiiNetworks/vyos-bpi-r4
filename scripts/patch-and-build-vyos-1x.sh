#!/bin/bash

set -e

# nowdir: $PROJECT_ROOT (vyos-bpi-r4)

cd vyos-arm64-build

### vyos-1x
git clone --recursive https://github.com/vyos/vyos-1x -b current --single-branch vyos-build/scripts/package-build/vyos-1x/vyos-1x
# fixing unknown internal blob file
# i don't know what is this file and why it's not in the repo
# without this file, the build will failed
# https://github.com/vyos/vyos-1x/commit/bab186b493145ee42453196e8ef4670afc71f6f1
# https://github.com/vyos/vyos-1x/commit/dd5f9c19550c1f8ccb5e93bab0b604f9f9e1383e
cp data/reftree.cache vyos-build/scripts/package-build/vyos-1x/vyos-1x/data/reftree.cache
# apply patches
# patch --no-backup-if-mismatch -p1 -d vyos-build/scripts/package-build/vyos-1x/vyos-1x < data/vyos-1x-001-system_console.patch
# patch --no-backup-if-mismatch -p1 -d vyos-build/scripts/package-build/vyos-1x/vyos-1x < data/vyos-1x-002-boot_console.patch
patch --no-backup-if-mismatch -p1 -d vyos-build/scripts/package-build/vyos-1x/vyos-1x < data/vyos-1x-003-increase_vyshim_init_timeout.patch
patch --no-backup-if-mismatch -p1 -d vyos-build/scripts/package-build/vyos-1x/vyos-1x < data/vyos-1x-004-enable_telegraf_support.patch
# Error: OCI runtime error: crun: cannot set memory+swap limit less than the memory limit
patch --no-backup-if-mismatch -p1 -d vyos-build/scripts/package-build/vyos-1x/vyos-1x < data/vyos-1x-005-fix_podman_service.patch
patch --no-backup-if-mismatch -p1 -d vyos-build/scripts/package-build/vyos-1x/vyos-1x < data/vyos-1x-006-install-image-reserve-gap.patch
# https://github.com/vyos/vyos-1x/commit/1478516ae437f19ebeb7d6ff9b83dd74f8e76758
sed -i 's/all: clean copyright/all: clean/' vyos-build/scripts/package-build/vyos-1x/vyos-1x/Makefile

cd vyos-build/scripts/package-build/vyos-1x
./build.py
ls -la *.deb
mv *.deb $PROJECT_ROOT/vyos-arm64-build/vyos-build/packages/