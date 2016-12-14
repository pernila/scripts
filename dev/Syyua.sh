#!/bin/sh
#tommi 24.10.2015
#Syyua.sh version 0.4.0
#Pacman and yaourt inspired tool

#TODO another switch to check for CURRENT, then skip freebsd-update

	echo ''
echo 'Syyua update script'
echo 'inspired by pacman and yaourt'
	echo ''


if [ -e "/usr/sbin/pkg" ]
then
	echo ''
	echo 'found pkg'
	echo ''
else
	echo ''
	echo ' install pkg?'
	echo ''
	pkg
fi

if [ -e "/var/db/portsnap/INDEX" ]
then
	echo ''
	echo 'ports found and they are extracted'
	echo ''
else
	echo ''
	echo 'install portsnap and portst'
	portsnap fetch extract
	echo ''
fi

if [ -e "/usr/local/sbin/portmaster" ]
then
	echo ''
	echo 'portmaster installed'
	echo ''
else
	echo ''
	echo 'install portmaster'
	pkg install portmaster
	echo ''
fi


if [ -e "/etc/defaults/pcbsd" ]
then
	echo ''
	echo 'running PCBSD'
	echo ''
	echo '/usr/local/bin/pc-updatemanager check'
	/usr/local/bin/pc-updatemanager check
	echo ''
	echo '/usr/local/bin/pc-updatemanager pkgcheck'
	/usr/local/bin/pc-updatemanager pkgcheck
	echo ''

	echo ''
	echo 'pkg update'
	pkg update
	echo ''
	echo 'pkg upgrade'
	pkg upgrade
	echo ''

	echo ''
	echo 'portsnap fetch update'
	portsnap fetch update
	echo ''
	echo 'Ports has newer versions of the following software:'
	portmaster -L | grep New
	echo ''

elif [ -e "/etc/defaults/trueos" ]
then
	echo ''
	echo 'running TrueOS'
	echo ''
	echo '/usr/local/bin/pc-updatemanager check'
	/usr/local/bin/pc-updatemanager check
	echo ''
	echo '/usr/local/bin/pc-updatemanager pkgcheck'
	/usr/local/bin/pc-updatemanager pkgcheck
	echo ''	

	echo ''
	echo 'pkg update'
	pkg update
	echo ''
	echo 'pkg upgrade'
	pkg upgrade
	echo ''

	echo ''
	echo 'portsnap fetch update'
	portsnap fetch update
	echo ''
	echo 'Ports has newer versions of the following software:'
	portmaster -L | grep New
	echo ''

else
	echo ''
	echo 'running FreeBSD'
	echo ''
	echo 'freebsd-update fetch'
        freebsd-update fetch
	echo ''
	echo 'freebsd-update install'
	freebsd-update install
	echo ''

echo ''
	echo ''
	echo 'pkg update'
	pkg update
	echo ''
	echo 'pkg upgrade'
	pkg upgrade
	echo ''

	echo ''
	echo 'portsnap fetch update'
	portsnap fetch update
	echo ''
	echo 'Ports has newer versions of the following software:'
	portmaster -L | grep New |awk '{print $5}'
	echo ''
fi

echo ''
#List of locked packages
pkg lock -l
echo ''
echo 'Syyua finished'
echo ''
