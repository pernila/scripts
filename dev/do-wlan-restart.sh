#!/bin/sh
#

echo 'wlan restart with netif restart and restart dhclient for wlan0'
service -v netif restart 
sleep 1
echo ''

echo 'ssid:'
ifconfig wlan0 ssid EWA@GUEST
echo ''

echo 'kill dhclient:'
killall dhclient
echo ''
sleep 1
echo 'dhclient:'
dhclient wlan0
echo ''
sleep 1

echo 'network info:'
basic-network-info.sh
echo ''
echo 'restart script end'
