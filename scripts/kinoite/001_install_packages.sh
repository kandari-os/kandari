#!/usr/bin/env bash

set -euox pipefail

# Define packages to install
packages=(
  fcitx5
  kcm-fcitx5
  maliit-keyboard
)

# Function to install packages
install_packages() {
  rpm-ostree install "${packages[@]}"
}

# Call the function to install the packages
install_packages
