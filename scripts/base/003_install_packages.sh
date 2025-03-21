#!/usr/bin/env bash

set -euox pipefail

# Define packages to install
packages=(
  bat
  distrobox
  eza
  fastfetch
  ffmpeg
  ffmpeg-libs
  htop
  mesa-va-drivers-freeworld
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
