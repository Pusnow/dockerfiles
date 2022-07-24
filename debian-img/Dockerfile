FROM ghcr.io/pusnow/debian-base:bullseye

LABEL maintainer="wonsup@pusnow.com"
LABEL org.opencontainers.image.source https://github.com/Pusnow/dockerfiles

ARG DEBIAN_PKGS=""
ARG DEBIAN_CMD=""

RUN apt-get update && DEBIAN_FRONTEND=noninteractive \
    apt-get install -y \
    ${DEBIAN_PKGS} \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/apt/

CMD [ "${DEBIAN_CMD}" ]