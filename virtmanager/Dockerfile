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
    virt-manager \
    openssh \
    paper-icon-theme \
    paper-gtk-theme \
    font-noto

ADD run.sh /run.sh
ADD supervisord.conf /etc/supervisor/supervisord.conf

EXPOSE 5900

VOLUME [ "/root", "/keys"]

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
