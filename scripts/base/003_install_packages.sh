#!/usr/bin/env bash

set -euox pipefail

# Define packages to install
packages=(
  bat
  distrobox
  fastfetch
  ffmpeg
  htop
  podman-compose
  trash-cli
  wl-clipboard
  zsh
)

# Function to install packages
install_packages() {
  rpm-ostree install "${packages[@]}"
}

# Call the function to install the packages
install_packages
