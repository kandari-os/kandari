#!/usr/bin/env bash

set -euox pipefail

#android-udev permission
chmod a+r /usr/etc/udev/rules.d/51-android.rules