#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "${SCRIPT_DIR}/../build.conf"

KERNEL_VERSION=$kernel_version
KERNEL_SUFFIX=-vyos
KERNEL_DIR="${SCRIPT_DIR}/../vyos-arm64-build/vyos-build/scripts/package-build/linux-kernel/build"
KERNEL_DIR=$(realpath ${KERNEL_DIR})
EPHEMERAL_KEY="/tmp/ephemeral.key"
EPHEMERAL_CERT="/tmp/ephemeral.pem"

# 输出到 kernel-vars
cat > $KERNEL_DIR/../kernel-vars <<EOF
KERNEL_VERSION=$KERNEL_VERSION
KERNEL_SUFFIX=$KERNEL_SUFFIX
KERNEL_DIR=$KERNEL_DIR
EPHEMERAL_KEY=$EPHEMERAL_KEY
EPHEMERAL_CERT=$EPHEMERAL_CERT
EOF
