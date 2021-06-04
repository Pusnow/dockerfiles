#!/bin/sh

if [ ! -z "$QEMU_RTC" ]; then
    QEMU_RTC_ARG="-rtc base=$QEMU_RTC"
fi

if [ ! -f "$QEMU_DISK" ] && [ ! -z "$QEMU_DISK_INITIALIZE" ]; then
    qemu-img create -f qcow2 $QEMU_DISK $QEMU_DISK_INITIALIZE
fi

if [ ! -f "$QEMU_DISK2" ] && [ ! -z "$QEMU_DISK2_INITIALIZE" ]; then
    qemu-img create -f qcow2 $QEMU_DISK2 $QEMU_DISK2_INITIALIZE
fi


if [ -f "$QEMU_DISK" ] && [ ! -z "$QEMU_DISK" ]; then
    QEMU_DISK_ARG="-drive file=$QEMU_DISK,if=virtio,cache=writeback,cache.direct=on,aio=native,format=qcow2"
fi

if [ -f "$QEMU_DISK2" ] && [ ! -z "$QEMU_DISK2" ]; then
    QEMU_DISK2_ARG="-drive file=$QEMU_DISK2,if=virtio,cache=writeback,cache.direct=on,aio=native,format=qcow2"
fi

if [ -f "$QEMU_ISO" ] && [ ! -z "$QEMU_ISO" ]; then
    QEMU_ISO_ARG="-drive file=$QEMU_ISO,media=cdrom"
fi

if [ -f "$QEMU_ISO2" ] && [ ! -z "$QEMU_ISO2" ]; then
    QEMU_ISO2_ARG="-drive file=$QEMU_ISO2,media=cdrom"
fi



qemu-system-x86_64 -machine q35 \
    -smp $QEMU_SMP -m $QEMU_MEMORY \
    -vnc 0.0.0.0:0 \
    $QEMU_RTC_ARG \
    -usb -device usb-tablet \
    -device virtio-keyboard-pci \
    -device virtio-balloon-pci \
    -nic user,model=virtio-net-pci \
    $QEMU_DISK_ARG \
    $QEMU_DISK2_ARG \
    $QEMU_ISO_ARG \
    $QEMU_ISO2_ARG