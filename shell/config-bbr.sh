#!/bin/bash 

set -e

if `lsmod |grep bbr`;
then
    echo 'mod bbr inserted'
else
    modprobe tcp_bbr
    echo "tcp_bbr" >> /etc/modules-load.d/modules.conf
fi

echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf

sysctl -p

if `sysctl net.ipv4.tcp_available_congestion_control|grep bbr`;
then
    echo 'tcp_available_congestion_control success'
else
    echo 'tcp_available_congestion_control fail'
fi
if `sysctl net.ipv4.tcp_congestion_control|grep bbr`;
then
    echo 'tcp_congestion_control success'
else
    echo 'tcp_congestion_control fail'
fi


if `lsmod |grep bbr`;
then
    echo 'bbr enable success'
else
    echo 'bbr enable fail'
fi


