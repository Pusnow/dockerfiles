FROM debian:bullseye-slim
LABEL maintainer="wonsup@pusnow.com"
LABEL org.opencontainers.image.source https://github.com/Pusnow/dockerfiles

RUN apt-get update && apt-get install -y \
    borgbackup \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/apt/

ENTRYPOINT [ "/usr/bin/borg" ]
