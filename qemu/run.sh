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

QEMU_SNAPSHOT_ARG=""
if [ -n "${QEMU_SNAPSHOT}" ]; then
    QEMU_SNAPSHOT_ARG="-snapshot"
elif [ -f "${QEMU_DISK}" ] && [ -n "${QEMU_SNAPSHOT_IF_EXIST}" ]; then
    QEMU_SNAPSHOT_ARG="-snapshot"
fi

QEMU_DO_RESTART=""
if [ -n "${QEMU_SNAPSHOT_ARG}" ] && [ -n "${QEMU_SNAPSHOT_RESTART}" ]; then
    QEMU_DO_RESTART="1"
fi

if [ ! -f "${QEMU_DISK}" ] && [ -n "${QEMU_DISK_INITIALIZE}" ]; then
    if [ -n "${QEMU_DISK_URL}" ]; then
        if [[ "${QEMU_DISK_URL}" = *.qcow2.xz ]]; then
            echo "Downloading ${QEMU_DISK_URL}"
            curl -fsSL -o "${QEMU_DISK}.xz" "${QEMU_DISK_URL}"
            xz -d "${QEMU_DISK}.xz"
        else
            echo "Downloading ${QEMU_DISK_URL}"
            curl -fsSL -o "${QEMU_DISK}" "${QEMU_DISK_URL}"
        fi
        qemu-img resize "${QEMU_DISK}" "${QEMU_DISK_INITIALIZE}"
    else
        qemu-img create -f qcow2 "${QEMU_DISK}" "${QEMU_DISK_INITIALIZE}"
    fi
    qemu-img info "${QEMU_DISK}"
fi

if [ ! -f "${QEMU_DISK2}" ] && [ -n "${QEMU_DISK2_INITIALIZE}" ]; then
    qemu-img create -f qcow2 "${QEMU_DISK2}" "${QEMU_DISK2_INITIALIZE}"
    qemu-img info "${QEMU_DISK}"
fi

QEMU_DISK_ARG=""
if [ -f "${QEMU_DISK}" ] && [ -n "${QEMU_DISK}" ]; then

    QEMU_DISK_AIO_ARG=""
    if [ -n "${QEMU_DISK_AIO}" ]; then
        QEMU_DISK_AIO_ARG=",aio=${QEMU_DISK_AIO}"
    fi
    QEMU_DISK_CACHE_ARG=""
    if [ -n "${QEMU_DISK_CACHE}" ]; then
        QEMU_DISK_CACHE_ARG=",cache=${QEMU_DISK_CACHE}"
    fi
    QEMU_DISK_ARG="-drive file=${QEMU_DISK},if=virtio${QEMU_DISK_CACHE_ARG}${QEMU_DISK_AIO_ARG},format=qcow2"
fi
if [ -f "${QEMU_DISK2}" ] && [ -n "${QEMU_DISK2}" ]; then

    QEMU_DISK_AIO_ARG=""
    if [ -n "${QEMU_DISK_AIO}" ]; then
        QEMU_DISK_AIO_ARG=",aio=${QEMU_DISK_AIO}"
    fi
    QEMU_DISK_CACHE_ARG=""
    if [ -n "${QEMU_DISK_CACHE}" ]; then
        QEMU_DISK_CACHE_ARG=",cache=${QEMU_DISK_CACHE}"
    fi
    QEMU_DISK_ARG="${QEMU_DISK_ARG} -drive file=${QEMU_DISK2},if=virtio${QEMU_DISK_CACHE_ARG}${QEMU_DISK_AIO_ARG},format=qcow2"
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
elif [ -n "${QEMU_TAP_AUTO}" ]; then
    ip tuntap add tap0 mode tap
    ip addr add 192.168.10.1/24 dev tap0
    ip link set dev tap0 up
    iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
    iptables -A FORWARD -m conntrack --ctstate INVALID -j DROP
    iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
    iptables -A FORWARD -s 192.168.10.0/24 -m conntrack --ctstate NEW -j ACCEPT
    iptables -A FORWARD -j RETURN
    iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

    HOST_IP=$(hostname --ip-address)

    for TCP_PORT in ${QEMU_TCP_PORTS//;/ }; do
        iptables -t nat -I PREROUTING -p tcp -d "${HOST_IP}" --dport ${TCP_PORT} -j DNAT --to-destination 192.168.10.2:${TCP_PORT}
    done

    for UDP_PORT in ${QEMU_UDP_PORTS//;/ }; do
        iptables -t nat -I PREROUTING -p udp -d "${HOST_IP}" --dport ${UDP_PORT} -j DNAT --to-destination 192.168.10.2:${UDP_PORT}
    done

    QEMU_NET_ARGS="-nic tap,script=no,downscript=no,ifname=tap0,model=virtio-net-pci${QEMU_MAC_ARGS}${QEMU_VHOST_ARGS}"
else
    QEMU_NET_ARGS="-nic user,model=virtio-net-pci${QEMU_MAC_ARGS}${QEMU_NET_HOSTFWD}"
fi

QEMU_VNC_ARG="-display"
if [ -n "${QEMU_VNC}" ]; then
    QEMU_VNC_ARG="${QEMU_VNC_ARG} vnc=${QEMU_VNC}"
else
    QEMU_VNC_ARG="${QEMU_VNC_ARG} vnc=0.0.0.0:0"
fi

if [ -n "${QEMU_VNC_PW}" ]; then
    QEMU_VNC_ARG="${QEMU_VNC_ARG},password=on"
fi

QEMU_AUDIO_ARG=""
if [ -n "${QEMU_AUDIO}" ]; then
    QEMU_AUDIO_ARG="${QEMU_AUDIO_ARG} -audiodev none,id=audiodev"
    QEMU_AUDIO_ARG="${QEMU_AUDIO_ARG} -device ich9-intel-hda -device hda-duplex,audiodev=audiodev"
    QEMU_VNC_ARG="${QEMU_VNC_ARG},audiodev=audiodev"
fi

QEMU_CLOUD_INIT_ARG=""
if [ -n "${QEMU_CLOUD_INIT}" ]; then
    if [ -f "${QEMU_CLOUD_INIT}" ]; then
        cloud-localds -v /var/run/seed.img "${QEMU_CLOUD_INIT}"
        QEMU_CLOUD_INIT_ARG="-drive file=/var/run/seed.img,if=virtio,format=raw"
    elif [ -d "${QEMU_CLOUD_INIT}" ]; then
        CLOUD_LOCALDS_NETWORK_ARGS=""
        CLOUD_LOCALDS_META_ARGS=""

        if [ -f "${QEMU_CLOUD_INIT}/user-data.yaml" ]; then
            CLOUD_LOCALDS_META_ARGS="${QEMU_CLOUD_INIT}/user-data.yaml"
        fi

        if [ -f "${QEMU_CLOUD_INIT}/network-config-v2.yaml" ]; then
            CLOUD_LOCALDS_NETWORK_ARGS="--network-config=${QEMU_CLOUD_INIT}/network-config-v2.yaml"
        fi

        echo cloud-localds -v ${CLOUD_LOCALDS_NETWORK_ARGS} /var/run/seed.img "${QEMU_CLOUD_INIT}/user-data.yaml" ${CLOUD_LOCALDS_META_ARGS}
        cloud-localds -v ${CLOUD_LOCALDS_NETWORK_ARGS} /var/run/seed.img "${QEMU_CLOUD_INIT}/user-data.yaml" ${CLOUD_LOCALDS_META_ARGS}
        QEMU_CLOUD_INIT_ARG="-drive file=/var/run/seed.img,if=virtio,format=raw"
    fi
fi

QEMU_CONSOLE_ARG=""
QEMU_CLIPBOARD_ARG=""
if [ -n "${QEMU_CONSOLE}" ] || [ -n "${QEMU_CLIPBOARD}" ]; then
    QEMU_CONSOLE_ARG="${QEMU_CONSOLE_ARG} -device virtio-serial-pci"
fi
if [ -n "${QEMU_CONSOLE}" ]; then
    QEMU_CONSOLE_ARG="${QEMU_CONSOLE_ARG} -chardev socket,path=/var/run/console.sock,server=on,wait=off,logfile=/dev/stdout,id=console0"
    QEMU_CONSOLE_ARG="${QEMU_CONSOLE_ARG} -serial chardev:console0"
fi
if [ -n "${QEMU_CLIPBOARD}" ]; then
    QEMU_CLIPBOARD_ARG="${QEMU_CLIPBOARD_ARG} -chardev qemu-vdagent,id=clipboard0,name=vdagent,clipboard=on"
    QEMU_CLIPBOARD_ARG="${QEMU_CLIPBOARD_ARG} -device virtserialport,chardev=clipboard0,id=clipboard0,name=com.redhat.spice.0"
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

QEMU_PID=""

term_handler() {
    QEMU_DO_RESTART=""
    stdbuf -i0 -o0 -e0 echo 'system_powerdown' | socat UNIX-CONNECT:/var/run/monitor.sock -

    if [ -n "${QEMU_PID}" ]; then
        wait "${QEMU_PID}"
    fi

}
trap 'term_handler' TERM
trap 'term_handler' INT

exec_qemu() {
    # shellcheck disable=SC2086
    stdbuf -i0 -o0 -e0 \
        qemu-system-x86_64 \
        -pidfile /var/run/qemu.pid \
        -monitor unix:/var/run/monitor.sock,server,nowait \
        -machine q35,accel=kvm \
        -cpu "host${QEMU_CPU_OPT}" -smp "${QEMU_SMP},sockets=1,cores=${QEMU_SMP},threads=1" \
        -m "${QEMU_MEMORY}" \
        ${QEMU_VNC_ARG} \
        ${QEMU_AUDIO_ARG} \
        ${QEMU_VGA_ARGS} \
        ${QEMU_UEFI_ARG} \
        ${QEMU_RTC_ARG} \
        ${QEMU_TPM_ARG} \
        -device "virtio-${QEMU_INPUT}-pci" \
        -device virtio-keyboard-pci \
        -device virtio-balloon-pci \
        -device virtio-rng-pci \
        ${QEMU_CONSOLE_ARG} \
        ${QEMU_CLIPBOARD_ARG} \
        ${QEMU_NET_ARGS} \
        ${QEMU_SNAPSHOT_ARG} \
        ${QEMU_DISK_ARG} \
        ${QEMU_ISO_ARG} \
        ${QEMU_CLOUD_INIT_ARG} \
        ${QEMU_EXTRA_ARGS} |
        ansi2txt &

    while [ ! -f /var/run/qemu.pid ]; do
        sleep 1
    done

    QEMU_PID="$(cat /var/run/qemu.pid)"

    # Setup VNC password
    if [ -n "${QEMU_VNC_PW}" ]; then
        stdbuf -i0 -o0 -e0 echo "change vnc password ${QEMU_VNC_PW}" | socat UNIX-CONNECT:/var/run/monitor.sock -
    fi

    while [ -f /var/run/qemu.pid ]; do
        wait "${QEMU_PID}"
        echo "Waiting QEMU shutdown..."
    done
}

exec_qemu

while [ -n "${QEMU_DO_RESTART}" ]; do
    exec_qemu
done
