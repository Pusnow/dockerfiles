FROM texlive/texlive:latest
LABEL maintainer="wonsup@pusnow.com"
LABEL org.opencontainers.image.source https://github.com/Pusnow/dockerfiles

RUN apt-get update \
    && apt-get install -y \
    ssh \
    curl \
    locales \
    wget \
    vim \
    git \
    ghostscript \
    poppler-utils \
    libyaml-tiny-perl \
    libfile-homedir-perl \
    libunicode-linebreak-perl \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/apt/

RUN tlmgr update --all --self

RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config && \
    echo "AuthorizedKeysFile     /ssh/authorized_keys" >> /etc/ssh/sshd_config && \
    echo "HostKey /ssh/host_key" >> /etc/ssh/sshd_config

COPY entrypoint.sh /entrypoint.sh
RUN for d in /usr/local/texlive/*/bin/x86_64-linux; do echo "export PATH=\"${d}:\${PATH}\"" >> /etc/profile; done

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && locale-gen

ENV TZ=Asia/Seoul
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

EXPOSE 22
VOLUME [ "/root", "/ssh"]
ENTRYPOINT [ "/entrypoint.sh" ]
