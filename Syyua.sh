#!/bin/sh
#tommi 24.10.2015
#Syyua.sh version 0,3
#Pacman and yaourt inspired tool

	echo ''
echo 'Syyua implementation'
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
	echo 'portsnap fetch extract'
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
	echo 'PCBSD'
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
	echo 'Newer pkgs from ports:'
	portmaster -L | grep New
	echo ''

elif [ -e "/etc/defaults/trueos" ]
then
	echo ''
	echo 'TrueOS'
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
	echo 'Newer pkgs from ports:'
	portmaster -L | grep New
	echo ''

else
	echo ''
	echo 'FreeBSD'
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
	echo 'Newer pkgs from ports:'
	portmaster -L | grep New
	echo ''
fi

echo ''
echo 'Done'
echo ''
