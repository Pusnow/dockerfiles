#!/bin/bash
# shellcheck disable=SC2039
# shellcheck disable=SC2153
# shellcheck disable=SC2154

set -e

QEMU_UEFI_ARG=""
if [ -n "${QEMU_UEFI}" ]; then
    if [ -z "${QEMU_UEFI_SECURE}" ]; then
        QEMU_UEFI_ARG="-drive if=pflash,format=raw,readonly=on,file=/usr/share/OVMF/OVMF_CODE_4M.fd"
        QEMU_UEFI_ARG="${QEMU_UEFI_ARG} -drive if=pflash,format=raw,file=/usr/share/OVMF/OVMF_VARS_4M.fd"
    else
        QEMU_UEFI_ARG="-drive if=pflash,format=raw,readonly=on,file=/usr/share/OVMF/OVMF_CODE_4M.secboot.fd"
        QEMU_UEFI_ARG="${QEMU_UEFI_ARG} -drive if=pflash,format=raw,file=/usr/share/OVMF/OVMF_VARS_4M.fd"
    fi
fi
QEMU_VGA_ARGS="-vga virtio"

QEMU_RTC_ARG=""
if [ -n "${QEMU_RTC}" ]; then
    QEMU_RTC_ARG="-rtc base=${QEMU_RTC}"
fi

if [ ! -f "${QEMU_DISK}" ] && [ -n "${QEMU_DISK_INITIALIZE}" ]; then
    if [ -n "${QEMU_DISK_URL}" ]; then
        if [[ "${QEMU_DISK_URL}" = *.qcow2.xz ]]; then
            echo "Downloading ${QEMU_DISK_URL}"
            wget -q -O "${QEMU_DISK}.xz" "${QEMU_DISK_URL}"
            xz -d "${QEMU_DISK}.xz"
        else
            echo "Downloading ${QEMU_DISK_URL}"
            wget -q -O "${QEMU_DISK}" "${QEMU_DISK_URL}"
        fi
        qemu-img resize "${QEMU_DISK}" "${QEMU_DISK_INITIALIZE}"
    else
        qemu-img create -f qcow2 "${QEMU_DISK}" "${QEMU_DISK_INITIALIZE}"
    fi
    qemu-img info "${QEMU_DISK}"
fi

if [ ! -f "${QEMU_DISK2}" ] && [ -n "${QEMU_DISK2_INITIALIZE}" ]; then
    if [ -n "${QEMU_DISK2_URL}" ]; then
        echo "Downloading ${QEMU_DISK2_URL}"
        wget -q -O "${QEMU_DISK2}" "${QEMU_DISK2_URL}"
        qemu-img resize "${QEMU_DISK2}" "${QEMU_DISK2_INITIALIZE}"
    else
        qemu-img create -f qcow2 "${QEMU_DISK2}" "${QEMU_DISK2_INITIALIZE}"
    fi
    qemu-img info "${QEMU_DISK2}"
fi
QEMU_DISK_ARG=""
if [ -f "${QEMU_DISK}" ] && [ -n "${QEMU_DISK}" ]; then
    QEMU_DISK_ARG="-drive file=${QEMU_DISK},if=virtio,cache=writeback,cache.direct=on,aio=native,format=qcow2"
fi
QEMU_DISK2_ARG=""
if [ -f "${QEMU_DISK2}" ] && [ -n "${QEMU_DISK2}" ]; then
    QEMU_DISK2_ARG="-drive file=${QEMU_DISK2},if=virtio,cache=writeback,cache.direct=on,aio=native,format=qcow2"
fi

QEMU_ISO_ARG=""
for ISO in ${QEMU_ISOS//;/ }; do
    QEMU_ISO_ARG="${QEMU_ISO_ARG} -drive file=${ISO},media=cdrom"
done

QEMU_MAC_ARGS=""
if [ -n "${QEMU_MAC}" ]; then
    QEMU_MAC_ARGS=",mac=${QEMU_MAC}"
fi

QEMU_NET_HOSTFWD=""
for TCP_PORT in ${QEMU_TCP_PORTS//;/ }; do
    QEMU_NET_HOSTFWD="${QEMU_NET_HOSTFWD},hostfwd=tcp::${TCP_PORT}-:${TCP_PORT}"
done

for UDP_PORT in ${QEMU_UDP_PORTS//;/ }; do
    QEMU_NET_HOSTFWD="${QEMU_NET_HOSTFWD},hostfwd=udp::${UDP_PORT}-:${UDP_PORT}"
done

QEMU_VHOST_ARGS=""
if [ -n "${QEMU_VHOST}" ]; then
    QEMU_VHOST_ARGS=",vhost=${QEMU_VHOST}"
fi

QEMU_NET_ARGS=""
if [ -n "${QEMU_TAP}" ]; then
    QEMU_NET_ARGS="-nic tap,script=no,downscript=no,ifname=${QEMU_TAP},model=virtio-net-pci${QEMU_MAC_ARGS}${QEMU_VHOST_ARGS}"
else
    QEMU_NET_ARGS="-nic user,model=virtio-net-pci${QEMU_MAC_ARGS}${QEMU_NET_HOSTFWD}"
fi

QEMU_VNC_ARG=""
if [ -n "${QEMU_VNC}" ]; then
    QEMU_VNC_ARG="-display vnc=${QEMU_VNC}"
else
    QEMU_VNC_ARG="-display vnc=0.0.0.0:0"
fi

QEMU_CLOUD_INIT_ARG=""
if [ -n "${QEMU_CLOUD_INIT}" ] && [ -f "${QEMU_CLOUD_INIT}" ]; then
    cloud-localds /var/run/seed.img "${QEMU_CLOUD_INIT}"
    QEMU_CLOUD_INIT_ARG="-drive file=/var/run/seed.img,if=virtio,format=raw"
fi

QEMU_CONSOLE_ARG=""
if [ -n "${QEMU_CONSOLE}" ]; then
    touch /var/run/console.log
    tail -f /var/run/console.log | ansi2txt &
    QEMU_CONSOLE_ARG="${QEMU_CONSOLE_ARG} -device virtio-serial-pci"
    QEMU_CONSOLE_ARG="${QEMU_CONSOLE_ARG} -chardev socket,path=/var/run/console.sock,server=on,wait=off,logfile=/var/run/console.log,id=console0"
    QEMU_CONSOLE_ARG="${QEMU_CONSOLE_ARG} -serial chardev:console0"
fi

QEMU_TPM_ARG=""
if [ -n "${QEMU_TPM}" ]; then
    mkdir -p /run/tpm
    swtpm socket -d \
        --tpmstate dir=/run/tpm \
        --ctrl type=unixio,path=/run/tpm.sock \
        --tpm2 \
        --log level=20
    QEMU_TPM_ARG="-chardev socket,id=chrtpm,path=/run/tpm.sock"
    QEMU_TPM_ARG="${QEMU_TPM_ARG} -tpmdev emulator,id=tpm0,chardev=chrtpm"
    QEMU_TPM_ARG="${QEMU_TPM_ARG} -device tpm-tis,tpmdev=tpm0"
fi

term_handler() {
    stdbuf -i0 -o0 -e0 echo '{ "execute": "qmp_capabilities" }{"execute": "system_powerdown"}' | socat UNIX-CONNECT:/var/run/qmp.sock -
}
trap 'term_handler' TERM

# shellcheck disable=SC2086
qemu-system-x86_64 \
    -pidfile /var/run/qemu.pid \
    -qmp unix:/var/run/qmp.sock,server,nowait \
    -machine q35,accel=kvm \
    -cpu "host${QEMU_CPU_OPT}" -smp "${QEMU_SMP},sockets=1,cores=${QEMU_SMP},threads=1" \
    -m "${QEMU_MEMORY}" \
    ${QEMU_VNC_ARG} \
    ${QEMU_VGA_ARGS} \
    ${QEMU_UEFI_ARG} \
    ${QEMU_RTC_ARG} \
    ${QEMU_TPM_ARG} \
    -device virtio-tablet-pci \
    -device virtio-keyboard-pci \
    -device virtio-balloon-pci \
    -device virtio-rng-pci \
    ${QEMU_CONSOLE_ARG} \
    ${QEMU_NET_ARGS} \
    ${QEMU_DISK_ARG} \
    ${QEMU_DISK2_ARG} \
    ${QEMU_ISO_ARG} \
    ${QEMU_CLOUD_INIT_ARG} \
    ${QEMU_EXTRA_ARGS} &

while [ ! -f /var/run/qemu.pid ]; do
    sleep 1
done

QEMU_PID="$(cat /var/run/qemu.pid)"

while [ -f /var/run/qemu.pid ]; do
    wait "${QEMU_PID}"
    echo "Waiting QEMU shutdown..."
done
