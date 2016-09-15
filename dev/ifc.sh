#!/bin/sh
#print ipv4, route and dns of a system

echo 'ifconfig'
ifconfig|grep 'inet\ \|fla'

echo 'route'
netstat -rn4 

echo 'dns'
cat /etc/resolv.conf |grep -v \#

echo 'done'
