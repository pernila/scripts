#!/bin/sh
#print ipv4, route and dns of a system

echo ''
echo 'ifconfig'
ifconfig|grep 'inet\ \|fla'

echo ''
echo 'route'
netstat -rn4 

echo ''
echo 'dns'
cat /etc/resolv.conf |grep -v \#

echo 'done'
echo ''
