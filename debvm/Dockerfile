FROM alpine:latest

RUN apk add --no-cache qemu-system-x86_64 qemu-img coreutils

COPY build/rootfs.qcow2 /vm/rootfs.qcow2
COPY build/vmlinuz /vm/vmlinuz
COPY build/initrd.img /vm/initrd.img
COPY entrypoint.sh /entrypoint.sh

VOLUME ["/volumes"]

ENV VM_CPUS 1
ENV VM_MEMORY 1024M
ENV VM_ROOT_SIZE "256G"
ENV VM_HOSTNAME "vm"

EXPOSE 8022
ENTRYPOINT [ "/entrypoint.sh" ]