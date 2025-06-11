#!/usr/bin/env bash

dnf config-manager --add-repo "https://download.opensuse.org/repositories/home:paul4us/Fedora_$(rpm -E %fedora)/home:paul4us.repo"
dnf install klassy -y
