#!/bin/sh
set -ex
VM_CPUS=${VM_CPUS:-1}
VM_MEMORY=${VM_MEMORY:-1G}
VM_ROOT_SIZE=${VM_ROOT_SIZE:-256G}

if [ ! -f /volumes/root.qcow2 ]; then
  qemu-img create -f qcow2 /volumes/root.qcow2 ${VM_ROOT_SIZE}
fi

if [ ! -f /volumes/sshd.qcow2 ]; then
  qemu-img create -f qcow2 /volumes/sshd.qcow2 1G
fi

HOSTFWD_PARAM="hostfwd=tcp::8022-:22"

for port in $(echo "$VM_TCP_PORTS" | tr ';' ' '); do
  HOSTFWD_PARAM="${HOSTFWD_PARAM},hostfwd=tcp::${port}-:${port}"
done
for port in $(echo "$VM_UDP_PORTS" | tr ';' ' '); do
  HOSTFWD_PARAM="${HOSTFWD_PARAM},hostfwd=udp::${port}-:${port}"
done

GH_USER_PARAM=""
if [ ! -z "${VM_GH_USER}" ]; then
  GH_USER_PARAM=" -fw_cfg name=opt/github,string=${VM_GH_USER} "
fi

HOSTNAME_PARAM=""
if [ ! -z "${VM_HOSTNAME}" ]; then
  HOSTNAME_PARAM=" -fw_cfg name=opt/hostname,string=${VM_HOSTNAME} "
fi

term_handler() {
  stdbuf -i0 -o0 -e0 echo '{ "execute": "guest-shutdown" }' | nc local:/var/run/vm-qga.sock
}

trap 'term_handler' TERM

touch /var/log/vm.log
tail -f /var/log/vm.log &

qemu-system-x86_64 \
  -pidfile /var/run/vm.pid \
  -nodefaults -no-user-config -no-reboot -nographic \
  -rtc clock=host \
  -machine q35,accel=kvm -cpu host -smp ${VM_CPUS} -m ${VM_MEMORY} \
  -kernel /vm/vmlinuz -initrd /vm/initrd.img -append "console=ttyS0 rootfstype=ext4 root=/dev/vda net.ifnames=0" \
  -device virtio-serial-pci \
  -chardev socket,path=/var/run/vm-qga.sock,server=on,wait=off,id=qga0 \
  -device virtserialport,chardev=qga0,name=org.qemu.guest_agent.0 \
  -chardev socket,path=/var/run/vm-console.sock,server=on,wait=off,logfile=/var/log/vm.log,id=console0 \
  -serial chardev:console0 \
  -device virtio-balloon-pci \
  -netdev user,id=user0,${HOSTFWD_PARAM} -device virtio-net-pci,netdev=user0 \
  -drive id=rootfs,file=/vm/rootfs.qcow2,format=qcow2,if=none -device virtio-blk-pci,drive=rootfs \
  -drive id=root,file=/volumes/root.qcow2,format=qcow2,if=none -device virtio-blk-pci,drive=root \
  -drive id=sshd,file=/volumes/sshd.qcow2,format=qcow2,if=none -device virtio-blk-pci,drive=sshd \
  ${GH_USER_PARAM} ${HOSTNAME_PARAM} &


while [ ! -f /var/run/vm.pid ]; do
  sleep 1
done

QEMU_PID="$(cat /var/run/vm.pid)"

while [ -f /var/run/vm.pid ]; do
  wait $QEMU_PID
  echo "Waiting QEMU shutdown..."
done