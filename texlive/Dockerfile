FROM texlive/texlive:latest
LABEL maintainer="wonsup@pusnow.com"
LABEL org.opencontainers.image.source https://github.com/Pusnow/dockerfiles

RUN apt-get update \
    && apt-get install -y \
    ssh \
    curl \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/apt/

RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config && \
    echo "AuthorizedKeysFile     /ssh/authorized_keys" >> /etc/ssh/sshd_config && \
    echo "HostKey /ssh/host_key" >> /etc/ssh/sshd_config

COPY entrypoint.sh /entrypoint.sh

EXPOSE 22
VOLUME [ "/root", "/ssh"]
ENTRYPOINT [ "/entrypoint.sh" ]
