FROM alpine:latest
LABEL maintainer="wonsup@pusnow.com"
LABEL org.opencontainers.image.source https://github.com/Pusnow/dockerfiles

RUN apk add --no-cache \
    borgbackup

ADD entrypoint.sh /

VOLUME [ "/key" ]
ENTRYPOINT [ "/entrypoint.sh" ]