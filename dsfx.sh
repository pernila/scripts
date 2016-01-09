#!/bin/sh
#
echo '  ' 
echo ' dsfx.sh - a Debugging Script For things relating to X ' 
echo ' versio 0.3 ' 
echo ' Gathers hardware information and collects all relevant logs to a folder ~/Xlogs_<date>'
echo 'Finally it creates a xlogs_<date>.txz file of all of the logs to ~-folder ' 
echo '  ' 

TIMESTAMP=$(date +"%Y.%m.%d_%H:%M:%S")

if [ -d ~/Xlogs ]
then 
	echo 'Xlogs directory already found '
	echo 'Creating a new folder'
	mkdir -p  ~/Xlogs_"$TIMESTAMP"
	LOGS=~/Xlogs_"$TIMESTAMP"
	echo $TIMESTAMP > $LOGS/date.info
	echo ' '
else
	echo 'Creating Xlogs directory'
	mkdir -p  ~/Xlogs
	LOGS=~/Xlogs
#	rm $LOGS/*.log #debugging
#	rm $LOGS/*.info #debugging
#	rm $LOGS/*.txt #debugging
	echo $TIMESTAMP > $LOGS/date.info
	echo ' '
fi

echo 'Computer hardware info ' >> $LOGS/hardware_info.txt
echo ' ~~~  ' >> $LOGS/hardware_info.txt

#cpu
grep CPU: /var/run/dmesg.boot > $LOGS/cpu_info.log

#gpu
#Optimus / dual gpu setup?
#check for all gpus seen by kernel
grep -i 'vga\|agp' /var/run/dmesg.boot > $LOGS/gpu_info.log

#xrandr
echo 'xrandr: will give an error Cant open display here'
echo 'if X is not running on the computer.'
echo 'Try running startx '
xrandr  > $LOGS/xrandr.log

#Get information about system model and manufacturer
grep -i smbio /var/log/bsdinstall_log > $LOGS/model_manufacturer.log

#Fill up HW info file
echo '   ' >> $LOGS/hardware_info.txt
echo 'System model and type:   ' >> $LOGS/hardware_info.txt
awk 'NR > 1 {print $1}' RS='[' FS=']' $LOGS/model_manufacturer.log >> $LOGS/hardware_info.txt
echo '   ' >> $LOGS/hardware_info.txt

echo 'GPU:  ' >> $LOGS/hardware_info.txt
cat $LOGS/gpu_info.log >> $LOGS/hardware_info.txt
echo '   ' >> $LOGS/hardware_info.txt

echo 'CPU:  ' >> $LOGS/hardware_info.txt
cat $LOGS/cpu_info.log >> $LOGS/hardware_info.txt
echo '   ' >> $LOGS/hardware_info.txt

echo 'xrandr  ' >> $LOGS/hardware_info.txt
cat $LOGS/xrandr.log >> $LOGS/hardware_info.txt
echo '   ' >> $LOGS/hardware_info.txt
echo '   ' >> $LOGS/hardware_info.txt
echo '  ' 

#dmesg from boot
cat /var/run/dmesg.boot > $LOGS/dmesg_boot.log
echo 'boot dmesg logged '


id > $LOGS/user_id.log

#is X installed?
#if not install with
#pkg install xorg-minimal

#no config for xorg?
#create a basic config with (you may want to edit it a bit)
#Xorg -configure
#Adding for example the section below. It allows killing X with ctrl+alt+del

#
# Section "ServerFlags"
#	Option		"DontZap" "false"
# EndSection
#

cat /etc/X11/xorg.conf > $LOGS/xorg.conf.log
cat /usr/local/etc/X11/xorg.conf > $LOGS/xorg.conf.2.log
cat /usr/local/etc/X11/xorg.conf.d/xorg.conf > $LOGS/xorg.conf.3.log
cat /usr/local/etc/X11/xorg.conf.d/* > $LOGS/xorg.conf.4.log
echo 'xorg.conf logged '

cat /var/log/Xorg.0.log > $LOGS/Xorg.0.log
echo 'Xorg logs logged '

xrandr  > $LOGS/xrandr.log
echo 'xrandr output logged '
#

#Check the video group (for user?)
ls -la /dev/dri > $LOGS/dri_permissions.log
cat /etc/group > $LOGS/group.log
echo 'users groups logged '

#if getting complaints about permissions try to fix it with
#pw groupmod video -m <your user>

#Check uname
uname -a > $LOGS/uname.log
echo 'uname -a logged '

#Check rc.conf
cat /etc/rc.conf > $LOGS/rc.conf.log
echo 'rc.conf logged '

#Check userland versiona

echo 'freebsd_version -u' > $LOGS/freebsd_version.log
freebsd-version -u >> $LOGS/freebsd_version.log
echo 'freebsd_version -k' >> $LOGS/freebsd_version.log
freebsd-version -k >> $LOGS/freebsd_version.log

echo 'freebsd_version logged '

cat /boot/loader.conf > $LOGS/loader.conf.log
echo 'loader.conf logged '

cat /etc/sysctl.conf > $LOGS/sysctl.conf.log
echo 'sysctl.conf logged '

cat /var/log/messages > $LOGS/messages.log
echo 'messages logged '

pkg info > $LOGS/list_of_pkgs.log
echo 'installed pkgs logged '

#cd ~/source/freebsd-base-graphics
#git show > $LOGS/git_show.log
#echo 'git show logged '


#Examples of test cases
#run this script after each scenario
#to gather the relevant logs

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


#Arto Pekkanens test scenario 4#
# boot with loader drm.debug=3 and do NOT load i915kms
# switch to a non-console TTY
# test suspend to RAM (acpciconf -s 3) and resume
#  test video playback afgter suspend 
# test suspend & resume via X11 session
#  test video playback afgter suspend 
# test suspend & resume with additional monitor

echo 'Done gathering the data'
echo ' '
echo 'Tarring the data'
TARVAR=xlogs_"$TIMESTAMP".txz
TARDIR="$LOGS"/*
tar -cJf $TARVAR -C $LOGS .
echo 'Done tarring the data'
echo ' '
echo 'Please submit your results to freebsd-x11@freebsd.org mailinglist'
echo 'Upload the results to https://gist.github.com or any similar service '

