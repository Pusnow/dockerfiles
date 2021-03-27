FROM debian:buster-slim
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
    virt-manager \
    ssh \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /opt/novnc \
    && curl -SL https://github.com/novnc/noVNC/archive/$NOVNC_VERSION.tar.gz \
    | tar -xz -C /opt/novnc --strip-components=1 
RUN mkdir -p /opt/novnc/utils/websockify \
    && curl -SL https://github.com/novnc/websockify/archive/$WEBSOCKIFY_VERSION.tar.gz \
    | tar -xz -C /opt/novnc/utils/websockify --strip-components=1 

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf


EXPOSE 8080

VOLUME [ "/root" ]

CMD ["/usr/bin/supervisord"]
