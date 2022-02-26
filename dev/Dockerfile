FROM  debian:testing
LABEL maintainer="wonsup@pusnow.com"
LABEL org.opencontainers.image.source https://github.com/Pusnow/dockerfiles

RUN apt-get update \
    && apt-get install -y \
    ssh \
    dnsutils \
    net-tools \
    iputils-ping \
    wget \
    curl \
    git \
    htop \
    nload \
    build-essential \
    gdb \
    cmake \
    meson \
    ninja-build \
    clang-format \
    python3 \
    python3-pip \
    python3-venv \
    neovim \
    shellcheck \
    && apt install --no-install-recommends -y \
    qemu-system-x86 \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/apt/

RUN sed -i 's/deb.debian.org/mirror.kakao.com/' /etc/apt/sources.list
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config && \
    echo "AuthorizedKeysFile     /ssh/authorized_keys" >> /etc/ssh/sshd_config && \
    echo "HostKey /ssh/host_key" >> /etc/ssh/sshd_config

COPY entrypoint.sh /entrypoint.sh
EXPOSE 22
VOLUME [ "/root", "/ssh"]
ENTRYPOINT [ "/entrypoint.sh" ]