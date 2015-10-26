#!/bin/sh
#
# This script is not tested. Use at your own risk.
# doesn't work so well

echo ' This script clones FreeBSD 11.0-CURRENT kernel sources '
echo '  that have experimental Intel Haswell support '
echo ' '

mkdir -p  ~/source
cd  ~/source

if [ -e "~/source/freebsd-base-graphics/Makefile" ]
then
	cd ~/source/freebsd-base-graphics
	#git status
	#git pull
	echo 'then'
else
#	git clone -b drm-i915-update-38 https://github.com/freebsd/freebsd-base-graphics.git
echo 'else'
echo ''
fi

#Additional things needed

#make kernel INSTKERNNAME=kernel.i915

#echo 'drm.debug=3' >> /boot/loader.conf

#echo 'debug.debugger_on_panic=0' >> /etc/sysctl.conf

#Set the next booting kernel to be kernel.i915
#nextboot -k kernel.i915

echo 'Done '
