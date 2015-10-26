#!/bin/sh
#
# This script is not tested. Use at your own risk.
# doesn't work so well

echo ' '

mkdir -p  ~/source
cd  ~/source

git clone https://github.com/pernila/scripts.git

#Additional things needed

#make kernel INSTKERNNAME=kernel.i915

#echo 'drm.debug=3' >> /boot/loader.conf

#echo 'debug.debugger_on_panic=0' >> /etc/sysctl.conf

#Set the next booting kernel to be kernel.i915
#nextboot -k kernel.i915

echo 'Done '
