FROM ghcr.io/pusnow/debian-base:bookworm
LABEL maintainer="wonsup@pusnow.com"
LABEL org.opencontainers.image.source https://github.com/Pusnow/dockerfiles

ENV DISPLAY=:0.0
ENV NOVNC_VERSION v1.1.0
ENV WEBSOCKIFY_VERSION v0.9.0


RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y \
    software-properties-common \
	xvfb \
	x11vnc \
	supervisor \
    dbus-x11 \
	xfce4 \
    xfce4-goodies \
    curl \
    procps \
    novnc \
    websockify \
    screen \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/apt/

EXPOSE 5900
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 8080

VOLUME [ "/root" ]

CMD ["/usr/bin/supervisord"]