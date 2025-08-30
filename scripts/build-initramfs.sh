#!/usr/bin/bash

set -oue pipefail

# No need for rpm-ostree cliwrap, dracut is available directly
KERNEL_SUFFIX=""

# Find installed kernel version
QUALIFIED_KERNEL="$(rpm -qa | grep -P "kernel(|${KERNEL_SUFFIX})(-\d+\.\d+\.\d+)" | sed -E "s/kernel(|${KERNEL_SUFFIX})-//")"

# Generate initramfs for that kernel
dracut --no-hostonly --kver "$QUALIFIED_KERNEL" --reproducible -v -f "/lib/modules/$QUALIFIED_KERNEL/initramfs.img"

# Secure permissions
chmod 0600 "/lib/modules/$QUALIFIED_KERNEL/initramfs.img"
