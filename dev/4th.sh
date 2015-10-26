#!/bin/sh
#

echo 'This script gathers all logs and configurations. It then parses them and outputs a text file that has an index of logs and infomation about the system hardware.  '

mkdir -p  ~/logs_parsed
LOGS=~/logs_parsed

#dmesg from boot
cat /var/run/dmesg.boot > $LOGS/dmesg_boot.log
echo 'boot dmesg logged '

id > $LOGS/user_id.log

cat /etc/X11/xorg.conf > $LOGS/xorg.conf.log
cat /usr/local/etc/X11/xorg.conf > $LOGS/xorg.conf.2.log
cat /usr/local/etc/X11/xorg.conf.d/xorg.conf > $LOGS/xorg.conf.3.log
cat /usr/local/etc/X11/xorg.conf.d/* > $LOGS/xorg.conf.4.log
echo 'xorg.conf logged '

cat /var/log/Xorg.0.log > $LOGS/Xorg.0.log
echo 'Xorg logs logged '

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

#Parse files

#

echo 'Done '
grep -i smbio /var/log/bsdinstall_log
