FROM ghcr.io/pusnow/debian-base:bookworm
LABEL maintainer="wonsup@pusnow.com"
LABEL org.opencontainers.image.source https://github.com/Pusnow/dockerfiles

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y \
    # Esseitial
    locales \
    ssh \
    wget \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/apt/

RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config && \
    echo "HostKey /ssh/host_key" >> /etc/ssh/sshd_config

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && locale-gen

ENV TZ=Asia/Seoul
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

EXPOSE 22
VOLUME ["/root", "/ssh"]
COPY entrypoint.sh /entrypoint.sh
CMD []
