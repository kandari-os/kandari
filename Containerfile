ARG FEDORA_RELEASE="${FEDORA_RELEASE:-40}"
ARG BASE_IMAGE="${BASE_IMAGE:-silverblue}"
ARG IMAGE_REGISTRY=quay.io/fedora-ostree-desktops
ARG FEDORA_IMAGE=${IMAGE_REGISTRY}/${BASE_IMAGE}:${FEDORA_RELEASE}

# Inheriting main image from Fedora source
FROM ${FEDORA_IMAGE} as base

ARG FEDORA_RELEASE
ARG BASE_IMAGE

# Copying system files to image
COPY system-files/base /
COPY system-files/${BASE_IMAGE} /

# Copying scripts to tmp
COPY --chmod=0755 scripts /tmp/scripts

RUN /tmp/scripts/setup.sh --version ${FEDORA_RELEASE} --base ${BASE_IMAGE} && \
    /tmp/scripts/build-initramfs.sh --version ${FEDORA_RELEASE} --base ${BASE_IMAGE} && \
    dnf clean all && \
    rm -rf /var/cache/dnf /var/lib/dnf /tmp/* /var/tmp/* \
    ostree container commit
