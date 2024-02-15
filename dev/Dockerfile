FROM ghcr.io/pusnow/fedora-base:39
LABEL maintainer="wonsup@pusnow.com"
LABEL org.opencontainers.image.source https://github.com/Pusnow/dockerfiles


RUN dnf -y update && \
    dnf -y groupinstall "Development Tools" "Development Libraries" && \
    dnf -y install \
    meson \
    pipx \
    htop \
    && dnf clean all

VOLUME ["/root"]
WORKDIR "/root"