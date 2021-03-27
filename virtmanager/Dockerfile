FROM debian:testing
LABEL maintainer="wonsup@pusnow.com"
LABEL org.opencontainers.image.source https://github.com/Pusnow/dockerfiles

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:0.0
ENV NOVNC_VERSION v1.1.0
ENV WEBSOCKIFY_VERSION v0.9.0

RUN apt-get update && apt-get install -y \
    software-properties-common \
    xvfb \
    x11vnc \
    supervisor \
    fluxbox \
    curl \
    procps \
    net-tools \
    novnc \
    virt-manager \
    ssh \
    && rm -rf /var/lib/apt/lists/*

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD install-ssh.sh /install-ssh.sh

EXPOSE 8080

VOLUME [ "/root", "/keys"]

CMD ["/usr/bin/supervisord"]
