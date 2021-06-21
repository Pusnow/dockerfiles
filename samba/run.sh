#!/bin/sh
if [ ! -f "/config/smbd.conf" ] ; then
    touch /config/smbd.conf
fi

/usr/sbin/smbd -F --no-process-group -S -s /config/smbd.conf