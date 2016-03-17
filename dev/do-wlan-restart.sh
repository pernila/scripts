#!/bin/sh
#
echo 'wlan restart with netif restart and restart dhclient for wlan0'

service -v netif restart 

sleep 1

killall dhclient

sleep 1

dhclient wlan0

sleep 2

basic-network-info.sh

echo ''
echo 'restart script end'

