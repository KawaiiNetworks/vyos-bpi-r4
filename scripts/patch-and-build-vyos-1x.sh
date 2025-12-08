#!/bin/bash

set -e

# nowdir: $PROJECT_ROOT (vyos-bpi-r4)

### vyos-1x
git clone --recursive https://github.com/vyos/vyos-1x -b current --single-branch $VYOS_BUILD_ROOT/scripts/package-build/vyos-1x/vyos-1x

# Error: OCI runtime error: crun: cannot set memory+swap limit less than the memory limit
patch --no-backup-if-mismatch -p1 -d $VYOS_BUILD_ROOT/scripts/package-build/vyos-1x/vyos-1x < $PROJECT_ROOT/patches/vyos-1x/vyos-1x-005-fix_podman_service.patch

cd $VYOS_BUILD_ROOT/scripts/package-build/vyos-1x
./build.py
ls -la *.deb
mv *.deb $VYOS_BUILD_ROOT/packages/