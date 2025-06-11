#!/usr/bin/env bash

RELEASE=$(rpm -E %fedora)

curl -fsSL -o /tmp/home-paul4us-fedora-"${RELEASE}".repo \
"https://download.opensuse.org/repositories/home:paul4us/Fedora_${RELEASE}/home:paul4us.repo"

sudo mv /tmp/home-paul4us-fedora-"${RELEASE}".repo \
/etc/yum.repos.d/home:paul4us.repo

# Install klassy from the repository
rpm-ostree install klassy

# Remove the repository file after installation
rm -f /etc/yum.repos.d/home:paul4us.repo


