FROM alpine:latest
LABEL maintainer="wonsup@pusnow.com"
LABEL org.opencontainers.image.source https://github.com/Pusnow/dockerfiles

RUN apk add --no-cache \
    samba

COPY run.sh /run.sh

EXPOSE 445

VOLUME [ "/data", "/config" ]
CMD ["/run.sh"]
