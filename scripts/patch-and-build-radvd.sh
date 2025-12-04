#!/bin/bash

set -e

# nowdir: $PROJECT_ROOT (vyos-bpi-r4)

cd vyos-arm64-build/vyos-build/scripts/package-build/radvd
./build.py
ls -la *.deb
mv *.deb $PROJECT_ROOT/vyos-arm64-build/vyos-build/packages/