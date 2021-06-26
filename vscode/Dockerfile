FROM debian:stable
LABEL maintainer="wonsup@pusnow.com"
LABEL org.opencontainers.image.source https://github.com/Pusnow/dockerfiles

ENV DISPLAY=:0.0

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
    xvfb \
    x11vnc \
    supervisor \
    fluxbox \
    wget \
    gnupg \
    apt-transport-https \
    ca-certificates \
    libasound2 \
    ssh \
    git \
    firefox-esr \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/apt/


RUN wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg &&\
    install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/ &&\
    sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list' &&\
    rm -f packages.microsoft.gpg

RUN apt-get update \
    && apt-get install -y \
    code \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/apt/

EXPOSE 5900

ADD supervisord.conf /etc/supervisor/supervisord.conf

VOLUME ["/root"]

ENV VNC_PASSWORD x11vnc

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
