FROM debian:stable
LABEL maintainer="wonsup@pusnow.com"
LABEL org.opencontainers.image.source https://github.com/Pusnow/dockerfiles


RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get upgrade -y &&\
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y \
    sudo \
    tzdata \
    locales \
    ssh \
    build-essential \
    procps \
    curl \
    file \
    git \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/apt/


RUN useradd -ms /bin/bash pusnow
RUN echo "PasswordAuthentication no" > /etc/ssh/sshd_config.d/no-password-auth.conf
RUN echo "HostKey /ssh/host_key" > /etc/ssh/sshd_config.d/host-key.conf
RUN echo "HostKey /ssh/host_key" > /etc/ssh/sshd_config.d/host-key.conf
RUN echo "pusnow ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/pusnow

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && locale-gen
ENV TZ=Asia/Seoul
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

EXPOSE 22
VOLUME ["/home", "/ssh"]

COPY entrypoint.sh /entrypoint.sh
WORKDIR "/home/pusnow"

ENTRYPOINT /entrypoint.sh
CMD []