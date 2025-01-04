#!/usr/bin/env bash

set -euox pipefail

# Define packages to install
packages=(
  distrobox
  fastfetch
  ffmpeg
  ffmpeg-libs
  htop
  podman-compose
  trash-cli
  zsh
)

# Function to install packages
install_packages() {
  rpm-ostree install "${packages[@]}"
}

# Call the function to install the packages
install_packages
