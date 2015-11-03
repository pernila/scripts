#!/bin/sh
#
echo 'This script collects logs and configs from the system and stores them in ~/logs folder '

mkdir -p  ~/logs2
LOGS=~/logs2

#dmesg from boot
cat /var/run/dmesg.boot > $LOGS/dmesg_boot.log
echo 'boot dmesg logged '

#kldload i915kms
#output of that needs to be stored
#
#in case of a hang, timeout for 30 sec and reboot/upload configs ?

#is X installed?
#if not install with
#pkg install xorg-minimal

#no config for xorg?
#create a basic config with (you may want to edit it a bit)
#Xorg -configure
#Adding for example the section below. It allows killing X with ctrl+alt+
#
# Section "ServerFlags"
#	Option		"DontZap" "false"
# EndSection
#
#Xorg -configure

cat /etc/X11/xorg.conf > $LOGS/xorg.conf.log
cat /usr/local/etc/X11/xorg.conf > $LOGS/xorg.conf.2.log
cat /usr/local/etc/X11/xorg.conf.d/xorg.conf > $LOGS/xorg.conf.3.log
cat /usr/local/etc/X11/xorg.conf.d/* > $LOGS/xorg.conf.4.log
echo 'xorg.conf logged '

cat /var/log/Xorg.0.log > $LOGS/Xorg.0.log
echo 'Xorg logs logged '

#startx
#Maybe first as root?
#
#output stored to /var/log/Xorg.0.log
#
#in case of a hang, timeout for 30 sec and reboot/upload configs ?

#Check the video group (for user?)
ls -la /dev/dri > $LOGS/dri_permissions.log
cat /etc/groups > $LOGS/groups.log
echo 'groups logged '

#if getting complaints about permissions try to fix it with
#pw groupmod video -m <your user>

#Check kernel version
uname -a > $LOGS/kernel_version.log
echo 'kernel version logged '

#Check userland version
freebsd-version -uk > $LOGS/freebsd_version.log
echo 'freebsd_version logged '

cat /boot/loader.conf > $LOGS/loader.conf.log
echo 'loader.conf logged '

cat /etc/sysctl.conf > $LOGS/sysctl.conf.log
echo 'sysctl.conf logged '

cat /var/log/messages > $LOGS/messages.log
echo 'messages logged '

pkg info > $LOGS/list_of_pkgs.log
echo 'installed pkgs logged '

#Examples of test cases to be tried
#Use script TODO name? to load i915kms or to startx to enable loggin on the background

#Arto Pekkanens test scenario 1#
# startx with normal user
# 

#Arto Pekkanens test scenario 2#
# boot with loader drm.debug=3 and i915kms_load="YES"
# startx as a normal user
#

#Arto Pekkanens test scenario 3#
# boot with loader drm.debug=3 and do NOT load i915kms
# switch to a non-console TTY
# test suspend to RAM (acpciconf -s 3) and resume
#  test video playback afgter suspend 
# test suspend & resume via X11 session
#  test video playback afgter suspend 
# test suspend & resume with additional monitor
#  test video playback afgter suspend 
#
#


#Arto Pekkanens test scenario 4#
# boot with loader drm.debug=3 and do NOT load i915kms
# switch to a non-console TTY
# test suspend to RAM (acpciconf -s 3) and resume
#  test video playback afgter suspend 
# test suspend & resume via X11 session
#  test video playback afgter suspend 
# test suspend & resume with additional monitor

echo 'Done '
