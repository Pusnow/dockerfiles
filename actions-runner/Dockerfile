FROM myoung34/github-runner:debian-bullseye
LABEL maintainer="wonsup@pusnow.com"
LABEL org.opencontainers.image.source https://github.com/Pusnow/dockerfiles

RUN apt-get update && apt-get install -y \
    buildah \
    curl \
    cmake \
    meson \
    ninja-build \
    clang-format \
    clang-tidy \
    python3 \
    python3-pip \
    python3-venv \
    shellcheck \
    sloccount \
    zip \
    unzip \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/apt/



RUN sed -i 's/deb.debian.org/mirror.kakao.com/' /etc/apt/sources.list
