#!/bin/bash

if [ -L $0 ]
then
    BASE_DIR=`dirname $(readlink $0)`
else
    BASE_DIR=`dirname $0`
fi
basepath=$(cd $BASE_DIR; pwd)
echo ${basepath}

echo "Stopping network services..."
service dhcpcd stop
service dnsmasq stop

echo "Adding uap0 interface to wlan0..."
ip link ls up | grep -q 'uap0' &> /dev/null
if [ $? == 0 ]; then
    iw dev uap0 del
fi
iw dev wlan0 interface add uap0 type __ap

echo "Set ip to uap0..."
ifconfig uap0 up 192.168.50.1/24

echo "ln dnsmasq and hostapd conf..."
ln -s ${basepath}/dnsmasq.conf /etc/dnsmasq.d/raspap.conf
ln -s ${basepath}/hostapd.conf /etc/hostapd/raspap.conf

echo "Enable ip forward..."
sysctl -w net.ipv4.ip_forward=1

echo "Setting iptables..."
iptables -t nat -A POSTROUTING -j MASQUERADE

echo "Starting AP..."
hostapd -B /etc/hostapd/raspap.conf
sleep 3

echo "Starting network services..."
service dnsmasq start
sleep 3
service dhcpcd start
sleep 3
