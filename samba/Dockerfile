FROM alpine:latest
LABEL maintainer="wonsup@pusnow.com"
LABEL org.opencontainers.image.source https://github.com/Pusnow/dockerfiles

RUN apk add --no-cache \
    samba

EXPOSE 445

RUN chmod -R 777 /var/log/samba

VOLUME [ "/data", "/config" ]
CMD ["/usr/sbin/smbd", "-F", "--no-process-group", "-S", "-s", "/config/smbd.conf"]
