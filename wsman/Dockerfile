FROM ubuntu:latest
LABEL maintainer="wonsup@pusnow.com"
LABEL org.opencontainers.image.source https://github.com/Pusnow/dockerfiles

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y \
    wsmancli \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/apt/

COPY run.sh /run.sh
ENV HOST=""
ENV PASSWORD=""
ENV VNC_PASSWORD=""
ENTRYPOINT [ "/run.sh" ]