ARG FEDORA_RELEASE="${FEDORA_RELEASE:-40}"
ARG DESKTOP_ENVIRONMENT="${DESKTOP_ENVIRONMENT:-silverblue}"
ARG IMAGE_REGISTRY=quay.io/fedora-ostree-desktops
ARG FEDORA_IMAGE=${IMAGE_REGISTRY}/${DESKTOP_ENVIRONMENT}:${FEDORA_RELEASE}

# Inheriting main image from Fedora source
FROM ${FEDORA_IMAGE} as base

ARG FEDORA_RELEASE
ARG DESKTOP_ENVIRONMENT

# Copying system files to image
COPY system-files/base /
COPY system-files/${DESKTOP_ENVIRONMENT} /

# Copying scripts to tmp
COPY --chmod=0755 scripts /tmp/scripts

RUN /tmp/scripts/setup.sh --version ${FEDORA_RELEASE} --base ${DESKTOP_ENVIRONMENT} && \
    /tmp/scripts/build-initramfs.sh --version ${FEDORA_RELEASE} --base ${DESKTOP_ENVIRONMENT} && \
    rpm-ostree cleanup -m && \
    rm -rf /tmp/* /var/* && \
    ostree container commit
