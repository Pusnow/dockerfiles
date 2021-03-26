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
    && rm -rf /var/lib/apt/lists/*

RUN curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python3 -

RUN mkdir -p /run/sshd
COPY run.sh /

WORKDIR /work
VOLUME ["/work" , "/etc/ssh"]
CMD [ "/run.sh" ]