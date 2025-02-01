#!/usr/bin/env bash

set -euox pipefail

# Define packages to install
packages=(
  fcitx5
  kcm-fcitx5
)

# Function to install packages
install_packages() {
  rpm-ostree install "${packages[@]}"
}

# Call the function to install the packages
install_packages

# fcitx5 is not available in the official Fedora repositories, so we need to download it from Koji
# Define variables
URL="https://kojipkgs.fedoraproject.org//packages/fcitx5/5.1.11/1.fc41/x86_64/fcitx5-5.1.11-1.fc41.x86_64.rpm"
PKG_NAME="fcitx5-5.1.11-1.fc41.x86_64.rpm"
DOWNLOAD_PATH="/tmp/$PKG_NAME"

# Download the package to /tmp using curl
echo "Downloading $PKG_NAME to /tmp..."
curl -L -o "$DOWNLOAD_PATH" "$URL"

# Verify the download
if [ -f "$DOWNLOAD_PATH" ]; then
    echo "Download complete. Installing the package..."
    rpm-ostree install -y "$DOWNLOAD_PATH"
    echo "Package installed successfully."
else
    echo "Download failed. Please check the URL or network connection."
    exit 1
fi
