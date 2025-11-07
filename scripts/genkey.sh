#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KERNEL_DIR="${SCRIPT_DIR}/../vyos-arm64-build/vyos-build/scripts/package-build/linux-kernel/build"
KERNEL_DIR=$(realpath ${KERNEL_DIR})

. $KERNEL_DIR/../kernel-vars

KERNEL_SRC=$KERNEL_DIR
KERNEL_CONFIG=.config
EPHEMERAL_KEY="/tmp/ephemeral.key"
EPHEMERAL_PEM="/tmp/ephemeral.pem"
EPHEMERAL_KERNEL_KEY=$(grep -E "^CONFIG_MODULE_SIG_KEY=" ${KERNEL_SRC}/$KERNEL_CONFIG | awk -F= '{print $2}' | tr -d \")
if test -f "${EPHEMERAL_KEY}"; then
    rm -f ${EPHEMERAL_KEY}
fi
if test -f "${EPHEMERAL_PEM}"; then
    rm -f ${EPHEMERAL_PEM}
fi
if test -f "${KERNEL_SRC}/${EPHEMERAL_KERNEL_KEY}"; then
    openssl rsa -in ${KERNEL_SRC}/${EPHEMERAL_KERNEL_KEY} -out ${EPHEMERAL_KEY}
    openssl x509 -in ${KERNEL_SRC}/${EPHEMERAL_KERNEL_KEY} -out ${EPHEMERAL_PEM}
fi