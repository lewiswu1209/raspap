#!/bin/bash

apt update
apt upgrade -y
apt install hostapd dnsmasq -y

if [ -L $0 ]
then
    BASE_DIR=`dirname $(readlink $0)`
else
    BASE_DIR=`dirname $0`
fi
basepath=$(cd $BASE_DIR; pwd)

sed -i '/exit/i\'"$basepath"'/start.sh' /etc/rc.local
