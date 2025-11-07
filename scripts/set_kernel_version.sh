#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "${SCRIPT_DIR}/../build.conf"
FILE_PATH="${SCRIPT_DIR}/../vyos-arm64-build/vyos-build/data/defaults.toml"
sed -i "s/^kernel_version = \".*\"/kernel_version = \"${kernel_version}\"/" $FILE_PATH