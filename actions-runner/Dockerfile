ARG PS_DEBIAN_TAG="bullseye"
FROM ghcr.io/pusnow/qemu:${PS_DEBIAN_TAG}
ARG PS_DEBIAN_TAG
LABEL maintainer="wonsup@pusnow.com"
LABEL org.opencontainers.image.source https://github.com/Pusnow/dockerfiles

COPY main.qcow2 /runner/main.qcow2
COPY cloud-init.yaml /runner/cloud-init.yaml
COPY actions-runner-init.sh /init.d/00-actions-runner-init.sh

ENV QEMU_DISK=/runner/main.qcow2
ENV QEMU_CLOUD_INIT=/runner/cloud-init.yaml