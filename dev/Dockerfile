FROM  debian:testing
LABEL maintainer="wonsup@pusnow.com"
LABEL org.opencontainers.image.source https://github.com/Pusnow/dockerfiles

RUN apt-get update \
    && apt-get install -y \
    # Esseitial
    locales \
    ssh \
    dnsutils \
    net-tools \
    iputils-ping \
    wget \
    curl \
    rsync \
    git \
    htop \
    nload \
    unzip \
    zip \
    # C/C++
    build-essential \
    gdb \
    cmake \
    meson \
    ninja-build \
    # Python
    python3 \
    python3-pip \
    python3-venv \
    # Shell
    vim \
    shellcheck \
    sloccount \
    # VM
    qemu-utils \
    podman \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/apt/

RUN sed -i 's/deb.debian.org/mirror.kakao.com/' /etc/apt/sources.list
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config && \
    echo "AuthorizedKeysFile     /ssh/authorized_keys" >> /etc/ssh/sshd_config && \
    echo "HostKey /ssh/host_key" >> /etc/ssh/sshd_config

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && locale-gen

ENV TZ=Asia/Seoul
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

COPY entrypoint.sh /entrypoint.sh
EXPOSE 22
VOLUME [ "/root", "/ssh"]
ENTRYPOINT [ "/entrypoint.sh" ]
