#!/bin/bash

set -euox pipefail

for repo in \
  /etc/yum.repos.d/_copr:copr.fedorainfracloud.org:phracek:PyCharm.repo \
  /etc/yum.repos.d/fedora-cisco-openh264.repo \
  /etc/yum.repos.d/google-chrome.repo \
  /etc/yum.repos.d/rpmfusion-nonfree-nvidia-driver.repo \
  /etc/yum.repos.d/rpmfusion-nonfree-steam.repo; do
  if [ -f "$repo" ]; then
    sed -i 's/enabled=1/enabled=0/' "$repo"
  fi
done
