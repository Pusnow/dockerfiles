#!/bin/sh

if [ ! -f "/config/smbd.conf" ] ; then
    cp /etc/samba/smb.conf /config/smbd.conf
fi


for UID in $UIDS;do
    useradd -u $UID u$UID
done

/usr/sbin/smbd -F --no-process-group -S -s /config/smbd.conf