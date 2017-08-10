#!/bin/sh
#tommi 25.10.2015
#jls_Syyua.sh version 0.2

#This script should be run from the jail host
# script updates the jail (freebsd-update fetch and install)
# 

# todo take a parameter
#asenna paketti X ( tunnista $2 parametrilla ) jailiin Y ( $1 )
# $0 on itse scriptin nimi eli nyt jls_Syyua,sh
# iocage exec $1 pkg install $2

#update / upgrade paketit
#-pkg
# iocage exec ALL pkg update
# iocage exec ALL pkg upgrade

#update paketti
#-portmaster

#or just use the native tools?
#e.g. jexec?

echo 'Syyua implementation for jails'


if [ -e "/usr/sbin/pkg" ]
then
	echo'found pkg'
else
	pkg
fi


iocage exec ALL pkg update
iocage exec ALL pkg upgrade

#if [ -e "/var/db/portsnap/INDEX" ]
#then
#	echo'ports extracted'
#else
#	portsnap fetch extract
#fi
#
#if [ -e "/usr/local/sbin/portmaster" ]
#then
#	echo'portmaster installed'
#else
#	pkg install portmaster
#fi




#	echo 'FreeBSD'
#        freebsd-update fetch
#	freebsd-update install
#
#	pkg update
#	pkg upgrade
#
#	portsnap fetch update
#	portmaster -L | grep New
#

echo 'Done'

