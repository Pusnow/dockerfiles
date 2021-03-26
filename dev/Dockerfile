FROM debian:buster

RUN apt-get update && apt-get upgrade -y \
    && apt-get install -y \
    build-essential \
    python3 \
    python3-pip \
    ssh \
    htop \
    man \
    git \
    cmake \
    curl \
    wget \
    tar \
    pigz \
    pbzip2 \
    pixz \
    bash-completion \
    clang-tools \
    clang-format \
    clang-tidy \
    doxygen \
    git-lfs \
    jq \
    ninja \
    nload \
    openjdk \
    pandoc \
    shellcheck \
    shfmt \
    vim \
    && rm -rf /var/lib/apt/lists/*

RUN curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | POETRY_HOME=/etc/poetry python3 -

RUN mkdir -p /run/sshd
COPY run.sh /

WORKDIR /root
VOLUME ["/root" , "/etc/ssh"]
CMD [ "/run.sh" ]
