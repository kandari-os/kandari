#!/bin/bash

set -ouex pipefail

mkdir -p /etc/flatpak/remotes.d
curl -Lo /etc/flatpak/remotes.d/flathub.flatpakrepo https://dl.flathub.org/repo/flathub.flatpakrepo
