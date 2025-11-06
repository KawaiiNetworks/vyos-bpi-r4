#!/bin/bash
. kernel-vars
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