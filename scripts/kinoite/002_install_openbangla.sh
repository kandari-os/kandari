#!/usr/bin/env bash

set -euox pipefail

RELEASE="$(rpm -E %fedora)"

curl -fsSL -o /tmp/badshah-openbangla-keyboard-fedora-"${RELEASE}".repo \
https://copr.fedorainfracloud.org/coprs/badshah/openbangla-keyboard/repo/fedora-"${RELEASE}"/badshah-openbangla-keyboard-fedora-"${RELEASE}".repo

mv /tmp/badshah-openbangla-keyboard-fedora-"${RELEASE}".repo \
/etc/yum.repos.d/_copr:copr.fedorainfracloud.org:badshah:openbangla-keyboard.repo

dnf install -y fcitx-openbangla

rm -f /etc/yum.repos.d/_copr:copr.fedorainfracloud.org:badshah:openbangla-keyboard.repo