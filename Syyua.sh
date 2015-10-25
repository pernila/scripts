#!/bin/sh
#tommi 24.10.2015
#Syyua.sh version 0,2

echo 'Syyua implementation'


if [ -e "/usr/sbin/pkg" ]
then
	echo'found pkg'
else
	pkg
fi

if [ -e "/var/db/portsnap/INDEX" ]
then
	echo'ports extracted'
else
	portsnap fetch extract
fi

if [ -e "/usr/local/sbin/portmaster" ]
then
	echo'portmaster installed'
else
	pkg install portmaster
fi


if [ -e "/etc/defaults/pcbsd" ]
then
	echo 'PCBSD'
	/usr/local/bin/pc-updatemanager check
	/usr/local/bin/pc-updatemanager pkgcheck

	pkg update
	pkg upgrade

	portsnap fetch update
	portmaster -L | grep New

elif [ -e "/etc/defaults/trueos" ]
then
	echo 'TrueOS'
	/usr/local/bin/pc-updatemanager check
	/usr/local/bin/pc-updatemanager pkgcheck

	pkg update
	pkg upgrade

	portsnap fetch update
	portmaster -L | grep New

else
	echo 'FreeBSD'
        freebsd-update fetch
	freebsd-update install

	pkg update
	pkg upgrade

	portsnap fetch update
	portmaster -L | grep New
fi

echo 'Done'

