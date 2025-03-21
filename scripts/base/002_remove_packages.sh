#!/usr/bin/env bash

set -euox pipefail

# Define packages to uninstall
packages=(
  cat
  ffmpeg-free
  firefox
  firefox-langpacks
  libavcodec-free
  libavdevice-free
  libavfilter-free
  libavformat-free
  libavutil-free
  libpostproc-free
  libswresample-free
  libswscale-free
  virtualbox-guest-additions
)

# Function to uninstall packages
uninstall_packages() {
  rpm-ostree uninstall "${packages[@]}"
}

# Call the function to uninstall the packages
uninstall_packages
