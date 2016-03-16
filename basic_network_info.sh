#!/bin/sh
#

# Basic network information output
# TODO switch to select a specific network interface

echo ''
echo 'Host IP:'
ifconfig em0| grep 'em0\|inet'
ifconfig wlan0| grep 'wlan0\|inet'
echo ''

echo 'Routing table:'
route -n show 0.0.0.0|grep \:
echo ''

echo 'DNS:'
grep -v \# /etc/resolv.conf
echo ''
