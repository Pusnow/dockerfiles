FROM debian:stable-slim

RUN apt-get update && apt-get install -y \
    debootstrap \
    libeatmydata1 \
 && rm -rf /var/lib/apt/lists/*

ARG MIRROR="http://deb.debian.org"
ENV MIRROR=${MIRROR}
VOLUME [ "/data" ]

CMD [ "sh", "-c", "exec 3< /usr/lib/x86_64-linux-gnu/libeatmydata.so; LD_PRELOAD=/proc/$$/fd/3 debootstrap --arch=amd64 --variant=minbase stable /data ${MIRROR}/debian"]