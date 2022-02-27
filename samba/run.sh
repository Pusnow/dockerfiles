#!/bin/sh

if [ ! -f "/config/smbd.conf" ] ; then
    cp /etc/samba/smb.conf /config/smbd.conf
fi


useradd -u $UID1 $USER1
useradd -u $UID2 $USER2


exec /usr/sbin/smbd -F --no-process-group -S -s /config/smbd.conf