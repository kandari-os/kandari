#!/bin/bash

set -euox pipefail

# Nvidia driver not shoing in setting page 
# https://www.reddit.com/r/Fedora/comments/1ir59gd/comment/md675aa/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
rpm-ostree install vulkan-loader-devel 