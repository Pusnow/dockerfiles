FROM  ghcr.io/linuxserver/code-server:latest
LABEL maintainer="wonsup@pusnow.com"
LABEL org.opencontainers.image.source https://github.com/Pusnow/dockerfiles

RUN apt-get update \
    && apt-get install -y \
    htop \
    nload \
    build-essential \
    gdb \
    cmake \
    ninja-build \
    clang-format \
    python3 \
    python3-pip \
    python3-venv \
    vim \
    shellcheck \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/apt/

RUN sed -i 's/archive.ubuntu.com/mirror.kakao.com/' /etc/apt/sources.list