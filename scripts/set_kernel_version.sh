#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "${SCRIPT_DIR}/../build.conf"
FILE_PATH="$VYOS_BUILD_ROOT/data/defaults.toml"
echo "Setting kernel_version to ${kernel_version} in ${FILE_PATH} ..."
sed -i "s/^kernel_version = \".*\"/kernel_version = \"${kernel_version}\"/" $FILE_PATH