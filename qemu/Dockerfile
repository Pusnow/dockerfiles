FROM ghcr.io/pusnow/debian-base:latest
LABEL maintainer="wonsup@pusnow.com"
LABEL org.opencontainers.image.source https://github.com/Pusnow/dockerfiles


RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
    ovmf \
    qemu-utils \
    qemu-system-x86\
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/apt/

ADD run.sh /

EXPOSE 5900

ENV QEMU_SMP="2"
ENV QEMU_MEMORY="4096M"
ENV QEMU_CPU_OPT=""
ENV QEMU_RTC=""
ENV QEMU_TAP=""
ENV QEMU_VHOST=""
ENV QEMU_MAC=""
ENV QEMU_ISO=""
ENV QEMU_ISO2=""
ENV QEMU_DISK_URL=""
ENV QEMU_DISK_INITIALIZE="32G"
ENV QEMU_DISK="/disks/main.qcow2"
ENV QEMU_DISK2_URL=""
ENV QEMU_DISK2_INITIALIZE=""
ENV QEMU_DISK2=""
ENV QEMU_EXTRA_ARGS=""
ENV QEMU_PORT_1="3389"
ENV QEMU_PORT_2=""
ENV QEMU_PORT_3=""
ENV QEMU_VNC=""
ENV QEMU_UEFI=""
ENV QEMU_UEFI_SECURE=""
ENV QEMU_TPM=""

VOLUME [ "/disks" ]
CMD ["/run.sh"]
