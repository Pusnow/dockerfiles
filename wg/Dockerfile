FROM alpine:latest
LABEL maintainer="wonsup@pusnow.com"
LABEL org.opencontainers.image.source https://github.com/Pusnow/dockerfiles

RUN apk add --no-cache wireguard-tools
COPY run.sh /

VOLUME ["/conf"]
CMD ["/run.sh"]