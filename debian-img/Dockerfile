FROM debian:bullseye-slim

LABEL maintainer="wonsup@pusnow.com"
LABEL org.opencontainers.image.source https://github.com/Pusnow/dockerfiles

ARG DEBIAN_PKG=""
ARG DEBIAN_CMD=""

RUN apt-get update && DEBIAN_FRONTEND=noninteractive \
    apt-get install -y \
    ${DEBIAN_PKGS} \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/apt/

CMD [ "${DEBIAN_CMD}" ]