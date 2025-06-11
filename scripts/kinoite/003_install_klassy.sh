#!/usr/bin/env bash

dnf config-manager addrepo --from-repofile=https://download.opensuse.org/repositories/home:paul4us/Fedora_42/home:paul4us.repo
dnf install klassy