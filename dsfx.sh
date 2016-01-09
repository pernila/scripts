#!/bin/sh
#
echo '  ' 
echo ' dsfx.sh - a Debugging Script For things relating to Xorg ' 
echo ' versio 0.3 ' 
echo ' Gathers hardware information and collects all relevant logs'
echo ' to the folder ~/Xlogs_<date>'
echo ' then tars everything to a single xlogs_<date>.txz file to the ~-folder' 
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
xrandr  > $LOGS/xrandr.log 2>&1

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

id -ur > $LOGS/script_run_as_user_id.log

echo 'Is Xorg installed on the system?'
echo 'If not install with'
echo ' pkg install xorg-minimal'

echo ' '
echo 'No config for Xorg?'
echo 'Create a basic config with (which you may want to edit a bit)'
echo ' Xorg -configure'
echo ' '
echo 'For example add the section below.'
echo 'It allows killing Xorg with ctrl+alt+del'
echo ' Section    "ServerFlags" '
echo ' Option     "DontZap" "false"'
echo ' EndSection'

cat /etc/X11/xorg.conf > $LOGS/xorg.conf.log 2>&1
cat /usr/local/etc/X11/xorg.conf > $LOGS/xorg.conf.2.log 2>&1
cat /usr/local/etc/X11/xorg.conf.d/xorg.conf > $LOGS/xorg.conf.3.log 2>&1
cat /usr/local/etc/X11/xorg.conf.d/* > $LOGS/xorg.conf.4.log 2>&1
echo 'xorg.conf(s) logged '

cat /var/log/Xorg.0.log > $LOGS/Xorg.0.log 2>&1
echo 'Xorg logs logged '
echo ' '
Xorg -version > $LOGS/Xorg_version.log 2>&1
echo 'Xorg version logged '

#Check the video group
#(this caused some issues mixing 10.x and 11.0 userland and kernel)
ls -la /dev/dri > $LOGS/dri_permissions.log 2>&1
cat /etc/group > $LOGS/group.log
echo 'users groups logged '

#if getting complaints about permissions try to fix it with
#pw groupmod video -m <your user>

#Check uname
uname -a > $LOGS/uname_a.log
echo 'uname -a logged '

cat /etc/rc.conf > $LOGS/rc.conf.log
echo 'rc.conf logged '
cat /etc/loader.conf > $LOGS/loader.conf.log 2>&1
echo 'loader.conf logged '

#Check the userland version
echo 'freebsd_version -u' > $LOGS/freebsd_version.log
freebsd-version -u >> $LOGS/freebsd_version.log
echo 'freebsd_version -k' >> $LOGS/freebsd_version.log
freebsd-version -k >> $LOGS/freebsd_version.log
echo 'freebsd_version logged '

cat /boot/loader.conf > $LOGS/loader.conf.log
echo 'loader.conf logged '
cat /etc/sysctl.conf > $LOGS/sysctl.conf.log
echo 'sysctl.conf logged '
pciconf -lv > $LOGS/pciconf_lv.log
echo 'pciconf -lv output logged '
cat /var/log/messages > $LOGS/messages.log
echo 'messages logged '
pkg info > $LOGS/list_of_pkgs.log
echo 'installed pkgs logged '

cat /etc/pkg/* > $LOGS/repositories.conf.log
echo 'used repositories logged '
echo ''

echo 'Vanilla FreeBSD check'
if [ -e "/etc/defaults/pcbsd" ]
then
	echo 'Seem to be running PCBSD'
	echo 'Seem to be running PCBSD' > $LOGS/not_vanilla.info

elif [ -e "/etc/defaults/trueos" ]
then
	echo 'Seem to be running TrueOS'
	echo 'Seem to be running TrueOS' > $LOGS/not_vanilla.info
else 
	echo 'Seem to be running vanilla'
fi

echo ''
echo 'Done gathering the data'
#echo ' '
#echo 'Changing username to <user>' TODO
#echo 'and the hostname to <host>' TODO 

echo ' '
echo 'Tarring the data'
TARVAR=xlogs_"$TIMESTAMP".txz
tar -cJf $TARVAR -C $LOGS .
echo 'Done tarring the data'
echo ' '
echo 'Please submit your results to freebsd-x11@freebsd.org mailing list'
echo 'Upload the results to https://gist.github.com or a similar service '
echo ' '
echo '  If the driver is working in normal usage'
echo '  Try doing something more demanding'

echo ' '
echo '  In the end of this .sh file'
echo '  there is four different test scenarios.'

#Examples of test cases
#run this script after each scenario
#to gather the relevant logs

#Arto Pekkanen's test scenario 1#
# startx with normal user
# 

#Arto Pekkanen's test scenario 2#
# boot with loader drm.debug=3 and i915kms_load="YES"
# startx as a normal user
#

#Arto Pekkanen's test scenario 3#
# boot with loader drm.debug=3 and do NOT load i915kms
# switch to a non-console TTY
# test suspend to RAM (acpciconf -s 3) and resume
#  test video playback afgter suspend 
# test suspend & resume via X11 session
#  test video playback afgter suspend 
# test suspend & resume with additional monitor
#  test video playback afgter suspend 


#Arto Pekkanen's test scenario 4#
# boot with loader drm.debug=3 and do NOT load i915kms
# switch to a non-console TTY
# test suspend to RAM (acpciconf -s 3) and resume
#  test video playback afgter suspend 
# test suspend & resume via X11 session
#  test video playback afgter suspend 
# test suspend & resume with additional monitor

