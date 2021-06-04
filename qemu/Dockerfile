FROM alpine:latest
LABEL maintainer="wonsup@pusnow.com"
LABEL org.opencontainers.image.source https://github.com/Pusnow/dockerfiles

RUN apk add --no-cache \
    qemu-img \
    qemu-system-x86_64 

ADD run.sh /

EXPOSE 5900

ENV QEMU_SMP="2"
ENV QEMU_MEMORY="4096M"
ENV QEMU_RTC="localtime"
ENV QEMU_ISO=""
ENV QEMU_ISO2=""
ENV QEMU_DISK_INITIALIZE="32G"
ENV QEMU_DISK="/disks/main.qcow2"
ENV QEMU_DISK2_INITIALIZE=""
ENV QEMU_DISK2=""
ENV QEMU_EXTRA_ARGS=""

VOLUME [ "/disks" ]
CMD ["/run.sh"]