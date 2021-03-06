#!/bin/sh
#

# Basic network information output
# TODO switch to select a specific network interface
# TODO verbose switch without filtering

echo ''
echo 'Host IP:'
ifconfig em0| grep 'em0\|inet'
ifconfig tun0| grep 'tun0\|inet'
ifconfig wlan0| grep 'wlan0\|inet\|ssid\|status\|media'
echo ''

echo 'Routing table:'
route -n show 0.0.0.0|grep \:
echo ''

echo 'DNS:'
grep -v \# /etc/resolv.conf
echo ''
