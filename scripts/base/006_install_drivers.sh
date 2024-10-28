#!/bin/bash

set -euox pipefail

# Define packages to install
packages=(
  libva-intel-driver
)

# Function to install packages
install_packages() {
  rpm-ostree install "${packages[@]}"
}

# Call the function to install the packages
install_packages
