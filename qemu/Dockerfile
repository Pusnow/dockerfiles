ARG PS_DEBIAN_TAG="bullseye"
FROM ghcr.io/pusnow/debian-base:${PS_DEBIAN_TAG}
ARG PS_DEBIAN_TAG
LABEL maintainer="wonsup@pusnow.com"
LABEL org.opencontainers.image.source https://github.com/Pusnow/dockerfiles


RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    socat \
    colorized-logs \
    xz-utils \
    cloud-utils \
    ovmf \
    qemu-utils \
    qemu-system-x86 \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/apt/

COPY run.sh /

EXPOSE 5900

ENV QEMU_SMP="2"
ENV QEMU_MEMORY="4096M"
ENV QEMU_CPU_OPT=""
ENV QEMU_RTC=""
ENV QEMU_TAP=""
ENV QEMU_VHOST=""
ENV QEMU_MAC=""
# ; separated
ENV QEMU_ISOS=""
ENV QEMU_SNAPSHOT=""
ENV QEMU_SNAPSHOT_IF_EXIST=""
ENV QEMU_SNAPSHOT_RESTART=""
ENV QEMU_DISK_URL=""
ENV QEMU_DISK_INITIALIZE="32G"
ENV QEMU_DISK="/disks/main.qcow2"
ENV QEMU_DISK_AIO="native"
ENV QEMU_DISK_CACHE="none"
ENV QEMU_EXTRA_ARGS=""
# ; separated
ENV QEMU_TCP_PORTS="3389"
# ; separated
ENV QEMU_UDP_PORTS=""
ENV QEMU_VNC=""
ENV QEMU_VNC_PW=""
ENV QEMU_UEFI=""
ENV QEMU_UEFI_SECURE=""
ENV QEMU_TPM=""
ENV QEMU_CONSOLE=""
ENV QEMU_CLOUD_INIT=""
ENV QEMU_INPUT="tablet"

VOLUME [ "/disks" ]
CMD ["/run.sh"]
