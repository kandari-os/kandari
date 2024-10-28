#!/usr/bin/env bash

set -euox pipefail

mkdir -p /var/lib/flatpak/runtime/org.gtk.Gtk3theme.Breeze/x86_64/3.22/active/files/assets/

cp -r /usr/share/themes/Breeze-Dark/assets/* /var/lib/flatpak/runtime/org.gtk.Gtk3theme.Breeze/x86_64/3.22/active/files/assets/