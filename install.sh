#!/bin/bash

echo -e " *******                                 **     ******* "
echo -e "/**////**                    ******     ****   /**////**"
echo -e "/**   /**   ******    ******/**///**   **//**  /**   /**"
echo -e "/*******   //////**  **//// /**  /**  **  //** /******* "
echo -e "/**///**    ******* //***** /******  **********/**////  "
echo -e "/**  //**  **////**  /////**/**///  /**//////**/**      "
echo -e "/**   //**//******** ****** /**     /**     /**/**      "
echo -e "//     //  //////// //////  //      //      // //       "

echo -e "update && install hostapd & dnsmasq
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

echo -e "make raspap run when boot."
sed -i '/^exit 0/i\'"$basepath"'/start.sh' /etc/rc.local

echo -e "Install Finished, if you want to change the SSID and key, change it in hostapd.conf."
