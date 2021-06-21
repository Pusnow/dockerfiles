FROM alpine:latest
LABEL maintainer="wonsup@pusnow.com"
LABEL org.opencontainers.image.source https://github.com/Pusnow/dockerfiles

RUN apk add --no-cache \
    samba \
    shadow

EXPOSE 445
ENV UIDS=""

COPY run.sh /run.sh

VOLUME ["/config", "/db"]
CMD ["/run.sh"]
