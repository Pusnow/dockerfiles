#!/bin/bash
set -e

if [ -z "${VNC_PASSWORD} "]
    VNC_PASSWORD=$(head -c 10000 /dev/urandom | LC_CTYPE=C  tr -dc A-Z | head -c 1)
    VNC_PASSWORD=$VNC_PASSWORD$(head -c 10000 /dev/urandom | LC_CTYPE=C  tr -dc a-z | head -c 1)
    VNC_PASSWORD=$VNC_PASSWORD$(head -c 10000 /dev/urandom | LC_CTYPE=C  tr -dc 0-9 | head -c 1)
    VNC_PASSWORD=$VNC_PASSWORD$(head -c 10000 /dev/urandom | LC_CTYPE=C  tr -dc @%^ | head -c 1)
    VNC_PASSWORD=$VNC_PASSWORD$(head -c 10000 /dev/urandom | LC_CTYPE=C  tr -dc A-Za-z0-9@%^ | head -c 4)
    VNC_PASSWORD=$(echo "$VNC_PASSWORD" | fold -w1 | shuf | tr -d '\n')
fi

echo "VNC_PASSWORD: ${VNC_PASSWORD}"

# Enable VNC Password
echo "Enable VNC Password"
wsman put http://intel.com/wbem/wscim/1/ips-schema/1/IPS_KVMRedirectionSettingData -h "${HOST}" -P 16992 -u admin -p "${PASSWORD}" -k "RFBPassword=${VNC_PASSWORD}" > /tmp/wsman.log
echo "Enable VNC Password: OK"

# Enable KVM redirection to port 5900
echo "Enable KVM redirection to port 5900"
wsman put http://intel.com/wbem/wscim/1/ips-schema/1/IPS_KVMRedirectionSettingData -h "${HOST}" -P 16992 -u admin -p "${PASSWORD}" -k Is5900PortEnabled=true > /tmp/wsman.log
echo "Enable KVM redirection to port 5900: OK"

# Disable opt-in policy
echo "Disable opt-in policy"
wsman put http://intel.com/wbem/wscim/1/ips-schema/1/IPS_KVMRedirectionSettingData -h "${HOST}" -P 16992 -u admin -p "${PASSWORD}" -k OptInPolicy=false > /tmp/wsman.log
echo "Disable opt-in policy: OK"

# Disable session timeout
echo "Disable session timeout"
wsman put http://intel.com/wbem/wscim/1/ips-schema/1/IPS_KVMRedirectionSettingData -h "${HOST}" -P 16992 -u admin -p "${PASSWORD}" -k SessionTimeout=0 > /tmp/wsman.log
echo "Disable session timeout: OK"

# Enable KVM
echo "Enable KVM"
wsman invoke -a RequestStateChange http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_KVMRedirectionSAP -h "${HOST}" -P 16992 -u admin -p "${PASSWORD}" -k RequestedState=2  > /tmp/wsman.log
echo "Enable KVM: OK"

echo "VNC_PASSWORD: ${VNC_PASSWORD}"