#!/usr/bin/env bash

set -euox pipefail

# Define packages to install
packages=(
  adw-gtk3-theme
  ffmpegthumbnailer
  gnome-shell-extension-appindicator
  gnome-tweaks
)

# Function to install packages
install_packages() {
  dnf install "${packages[@]}"
}

# Call the function to install the packages
install_packages
