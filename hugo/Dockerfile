FROM ghcr.io/pusnow/debian-base:bullseye
LABEL maintainer="wonsup@pusnow.com"
LABEL org.opencontainers.image.source https://github.com/Pusnow/dockerfiles

ARG HUGO_VERSION=0.101.0

RUN apt-get update && DEBIAN_FRONTEND=noninteractive \
    apt-get install -y \
    wget \
    git \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/apt/

RUN wget -O - https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz | \
    tar -xz -f - -C /bin hugo

CMD ["hugo"]