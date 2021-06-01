FROM ghcr.io/pusnow/alpine-gui:latest
LABEL maintainer="wonsup@pusnow.com"
LABEL org.opencontainers.image.source https://github.com/Pusnow/dockerfiles

ENV DISPLAY=:0.0

RUN apk add --no-cache \
    virt-manager \
    openssh 

ADD run.sh /run.sh
ADD supervisord.conf /etc/supervisor/supervisord.conf

EXPOSE 5900

VOLUME [ "/root", "/keys"]

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
