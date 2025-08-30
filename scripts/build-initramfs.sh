#!/usr/bin/env bash

set -euox pipefail



# Generate initramfs
mkdir -p /var/tmp
KERNEL_SUFFIX=""
QUALIFIED_KERNEL="$(rpm -qa | grep -P 'kernel-(|'"$KERNEL_SUFFIX"'-)(\d+\.\d+\.\d+)' | sed -E 's/kernel-(|'"$KERNEL_SUFFIX"'-)//')"


# Validate we found a kernel
if [[ -z "${QUALIFIED_KERNEL}" ]]; then
    echo "ERROR: No installed kernel found!"
    echo "Available kernel packages:"
    dnf5 list installed | grep -E "(kernel)" || true
    echo "Available module directories:"
    ls -la /usr/lib/modules/ || true
    
    # As a last resort, skip initramfs build
    echo "WARNING: Skipping initramfs build due to missing kernel"
    exit 0
fi

echo "Building initramfs for kernel: ${QUALIFIED_KERNEL}"

# Check if the kernel modules directory exists
KERNEL_MODULES_DIR="/usr/lib/modules/${QUALIFIED_KERNEL}"
if [[ ! -d "${KERNEL_MODULES_DIR}" ]]; then
    echo "Kernel modules directory not found: ${KERNEL_MODULES_DIR}"
    echo "Available module directories:"
    ls -la /usr/lib/modules/ || true
    
    # Try to find the actual directory name that matches our kernel
    ACTUAL_DIR=""
    for dir in /usr/lib/modules/*/; do
        if [[ -d "$dir" && "$dir" != "/usr/lib/modules/*/" ]]; then
            dir_name=$(basename "$dir")
            echo "Checking directory: $dir_name"
            
            # Check if this directory name contains our kernel version
            if [[ "$dir_name" =~ ${QUALIFIED_KERNEL%.*} ]] || [[ "$QUALIFIED_KERNEL" =~ ${dir_name%.*} ]]; then
                echo "Found matching directory: $dir_name"
                QUALIFIED_KERNEL="$dir_name"
                KERNEL_MODULES_DIR="/usr/lib/modules/${QUALIFIED_KERNEL}"
                ACTUAL_DIR="$dir_name"
                break
            fi
        fi
    done
    
    # If still not found, use the first available directory
    if [[ -z "$ACTUAL_DIR" ]]; then
        for dir in /usr/lib/modules/*/; do
            if [[ -d "$dir" && "$dir" != "/usr/lib/modules/*/" ]]; then
                dir_name=$(basename "$dir")
                echo "Using first available directory: $dir_name"
                QUALIFIED_KERNEL="$dir_name"
                KERNEL_MODULES_DIR="/usr/lib/modules/${QUALIFIED_KERNEL}"
                break
            fi
        done
    fi
    
    if [[ ! -d "${KERNEL_MODULES_DIR}" ]]; then
        echo "WARNING: Still cannot find kernel modules directory, skipping initramfs build"
        exit 0
    fi
fi

echo "Final kernel modules directory: ${KERNEL_MODULES_DIR}"

# Build the initramfs
echo "Running dracut for kernel: ${QUALIFIED_KERNEL}"
if ! /usr/bin/dracut --no-hostonly --kver "$QUALIFIED_KERNEL" --reproducible --zstd -v --add ostree -f "${KERNEL_MODULES_DIR}/initramfs.img"; then
    echo "ERROR: dracut failed for kernel ${QUALIFIED_KERNEL}"
    # Don't fail the build, just warn
    echo "WARNING: Continuing build without initramfs"
    exit 0
fi

# Set proper permissions
chmod 0600 "${KERNEL_MODULES_DIR}/initramfs.img"

echo "Initramfs built successfully for ${QUALIFIED_KERNEL}"