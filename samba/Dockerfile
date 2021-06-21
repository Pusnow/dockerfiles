FROM alpine:latest
LABEL maintainer="wonsup@pusnow.com"
LABEL org.opencontainers.image.source https://github.com/Pusnow/dockerfiles

RUN apk add --no-cache \
    samba

EXPOSE 445

VOLUME ["/config", "/db"]
CMD ["/usr/sbin/smbd", "-F", "--no-process-group", "-S", "-s", "/config/smbd.conf"]
