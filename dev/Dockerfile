FROM ghcr.io/pusnow/debian-base:bookworm
LABEL maintainer="wonsup@pusnow.com"
LABEL org.opencontainers.image.source https://github.com/Pusnow/dockerfiles

ARG GVPROXY_VERSION=0.3.0

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y \
    # Esseitial
    locales \
    ssh \
    dnsutils \
    net-tools \
    iputils-ping \
    wget \
    curl \
    git \
    htop \
    nload \
    unzip \
    zip \
    aria2 \
    screen \
    jq \
    # C/C++
    build-essential \
    gdb \
    # Python
    python3 \
    python3-pip \
    python3-venv \
    # Shell
    shellcheck \
    # VM
    qemu-utils \
    podman \
    && apt install --no-install-recommends -y \
    qemu-system-x86 \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/apt/

RUN mkdir -p /usr/local/lib/podman && \
 wget -O /usr/local/lib/podman/gvproxy https://github.com/containers/gvisor-tap-vsock/releases/download/v${GVPROXY_VERSION}/gvproxy-linux && \
 chmod +x /usr/local/lib/podman/gvproxy

RUN sed -i 's/deb.debian.org/mirror.kakao.com/' /etc/apt/sources.list
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config && \
    echo "HostKey /ssh/host_key" >> /etc/ssh/sshd_config

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && locale-gen

ENV TZ=Asia/Seoul
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

COPY entrypoint.sh /entrypoint.sh
EXPOSE 22
VOLUME [ "/root", "/ssh", "/etc/containers"]
ENTRYPOINT [ "/entrypoint.sh" ]
