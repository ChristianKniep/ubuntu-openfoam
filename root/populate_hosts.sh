#!/bin/bash
IP_BASE=10.18.1.
IP_NUM=100
HOSTBASE=$(hostname|egrep -o "[a-z]+")
cp /etc/hosts /tmp/
#sed -i "/.*$(hostname)\$/d" /tmp/hosts
#sed -i -e "s/127.0.0.1\tlocalhost/127.0.0.1   localhost $(hostname)/" /tmp/hosts 

for x in {1..8};do
    if [ "$(grep -c "${HOSTBASE}${x}" /tmp/hosts)" -ne 0 ];then
        continue
    fi

    echo "${IP_BASE}$((${IP_NUM}+${x}))   ${HOSTBASE}${x}" >> /tmp/hosts
done
cp /tmp/hosts /etc/hosts

