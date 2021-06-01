FROM alpine:latest
LABEL maintainer="wonsup@pusnow.com"
LABEL org.opencontainers.image.source https://github.com/Pusnow/dockerfiles

ENV DISPLAY=:0.0

RUN apk add --no-cache \
    xvfb \
    x11vnc \
    supervisor \
    fluxbox \
    curl \
    procps \
    net-tools \
    gnome-icon-theme \
    ttf-opensans