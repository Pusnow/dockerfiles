FROM alpine:latest
LABEL maintainer="wonsup@pusnow.com"
LABEL org.opencontainers.image.source https://github.com/Pusnow/dockerfiles

RUN apk add --no-cache \
    openssh-client

COPY entrypoint.sh /entrypoint.sh

EXPOSE 1080
VOLUME [ "/root/.ssh" ]
ENTRYPOINT [ "/entrypoint.sh" ]