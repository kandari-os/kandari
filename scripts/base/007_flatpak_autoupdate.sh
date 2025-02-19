#!/usr/bin/env bash

set -euox pipefail


# Enable automatic updates for rpm-ostree
# systemctl enable rpm-ostreed-automatic.timer

systemctl enable flatpak-system-update.timer
systemctl --global enable flatpak-user-update.timer
