#!/bin/sh
#
echo '  ' 
echo ' dsfx.sh - a Debugging Script For things relating to Xorg ' 
echo ' versio 0.4.1 ' 
echo ' Gathers hardware information and collects all relevant logs'
echo ' to the folder ~/Xlogs_<date>.'
echo ' Then tars everything to a single xlogs_<date>.txz file to the ~-folder.' 
echo '  ' 
echo '  ' 

TIMESTAMP=$(date +"%Y.%m.%d_%H-%M-%S")

if [ -d ~/Xlogs ]
then 
	echo ' Xlogs directory already found '
	echo ' '
	mkdir -p  ~/Xlogs_"$TIMESTAMP"
	LOGS=~/Xlogs_"$TIMESTAMP"
	echo $TIMESTAMP > $LOGS/date.info
	echo 'Creating a new folder: ' "$LOGS"
	echo ' '
else
	mkdir -p  ~/Xlogs
	LOGS=~/Xlogs
	echo 'Creating a new folder: ' "$LOGS"
#	rm $LOGS/*.log #debugging
#	rm $LOGS/*.info #debugging
#	rm $LOGS/*.txt #debugging
	echo $TIMESTAMP > $LOGS/date.info
	echo ' '
fi

echo 'Computer hardware info ' >> $LOGS/hardware_info.txt
echo ' ~~~  ' >> $LOGS/hardware_info.txt

#cpu
grep CPU: /var/run/dmesg.boot > $LOGS/cpu_info.log 2>&1

#gpu
#Optimus / dual gpu setup?
#check for all gpus seen by kernel
grep -i 'vga\|agp' /var/run/dmesg.boot > $LOGS/gpu_info.log 2>&1

echo '     info: if X is not running on the computer'
echo '           xrandr will give an error "Cant open display"'
echo '           Try running startx '
xrandr  > $LOGS/xrandr.log 2>&1
xrandr --verbose > $LOGS/xrandr_verbose.log 2>&1
echo ' '

#Get information about system model and manufacturer
grep -i smbio /var/log/bsdinstall_log > $LOGS/model_manufacturer.log 2>&1

#Fill up HW info file
echo '   ' >> $LOGS/hardware_info.txt
echo 'System model and type:   ' >> $LOGS/hardware_info.txt
awk 'NR > 1 {print $1}' RS='[' FS=']' $LOGS/model_manufacturer.log >> $LOGS/hardware_info.txt 2>&1
echo '   ' >> $LOGS/hardware_info.txt

echo 'GPU:  ' >> $LOGS/hardware_info.txt
cat $LOGS/gpu_info.log >> $LOGS/hardware_info.txt 2>&1
echo '   ' >> $LOGS/hardware_info.txt

echo 'CPU:  ' >> $LOGS/hardware_info.txt
cat $LOGS/cpu_info.log >> $LOGS/hardware_info.txt 2>&1
echo '   ' >> $LOGS/hardware_info.txt

echo 'xrandr  ' >> $LOGS/hardware_info.txt
cat $LOGS/xrandr.log >> $LOGS/hardware_info.txt 2>&1
echo '   ' >> $LOGS/hardware_info.txt
echo '   ' >> $LOGS/hardware_info.txt

echo '     info: Is Xorg installed on the system?'
echo '           If not install with'
echo '            #pkg install xorg-minimal'

echo ' '
echo '     info: No config for Xorg?'
echo '           Create a basic config with'
echo '            #Xorg -configure'
echo '           afterwards you may want to edit it a bit'
echo ' '
echo '           eg. adding this to your xorg.conf'
echo '           allows killing Xorg with ctrl+alt+del'
echo ' '
echo '      Section    "ServerFlags" '
echo '      Option     "DontZap" "false"'
echo '      EndSection'
echo ' '

echo 'cat /etc/X11/xorg.conf' > $LOGS/xorg.conf.log
cat /etc/X11/xorg.conf >> $LOGS/xorg.conf.log 2>&1
echo 'cat /etc/X11/xorg.conf*' > $LOGS/xorg.conf_star.log
cat /etc/X11/xorg.conf* >> $LOGS/xorg.conf_star.log 2>&1
echo 'cat /usr/local/etc/X11/xorg.conf' > $LOGS/usr_xorg.conf.log
cat /usr/local/etc/X11/xorg.conf >> $LOGS/usr_xorg.conf.log 2>&1
echo 'cat /usr/local/etc/X11/xorg.conf.d/xorg.conf' > $LOGS/usr_xorg.d.conf.log
cat /usr/local/etc/X11/xorg.conf.d/xorg.conf >> $LOGS/usr_xorg.d.conf.log 2>&1
echo 'cat /usr/local/etc/X11/xorg.conf.d/*' > $LOGS/usr_xorg.d_star.log 
cat /usr/local/etc/X11/xorg.conf.d/* >> $LOGS/usr_xorg.d_star.log 2>&1
echo 'xorg.conf(s) logged '

cat /var/log/Xorg.0.log > $LOGS/Xorg.0.log 2>&1
echo 'Xorg logs logged '
Xorg -version > $LOGS/Xorg_version.log 2>&1
echo 'Xorg version logged '

#Check the video group
#(this caused some issues mixing 10.x and 11.0 userland and kernel)
echo 'ls -la /dev/dri ' > $LOGS/dri.permissions.log
ls -la /dev/dri >> $LOGS/dri_permissions.log 2>&1
cat /etc/group > $LOGS/group.log 2>&1
echo 'users groups logged '

#if getting complaints about permissions try to fix it with
#pw groupmod video -m <your user>

#dmesg from boot
cat /var/run/dmesg.boot > $LOGS/dmesg_boot.log 2>&1
echo 'dmesg from boot logged '

id -ur > $LOGS/script_run_as_user_id.log 2>&1
echo 'user id number running the script logged '

#Check uname
uname -a > $LOGS/uname_a.log 2>&1
echo 'uname -a logged '

cat /etc/rc.conf > $LOGS/rc.conf.log 2>&1
echo 'rc.conf logged '
cat /etc/loader.conf > $LOGS/loader.conf.log 2>&1
echo 'loader.conf logged '

#Check the userland version
echo 'freebsd_version -u' > $LOGS/freebsd_version.log
freebsd-version -u >> $LOGS/freebsd_version.log 2>&1
echo 'freebsd_version -k' >> $LOGS/freebsd_version.log
freebsd-version -k >> $LOGS/freebsd_version.log 2>&1
echo 'freebsd_version logged '

cat /boot/loader.conf > $LOGS/loader.conf.log 2>&1
echo 'loader.conf logged '
cat /etc/sysctl.conf > $LOGS/sysctl.conf.log 2>&1
echo 'sysctl.conf logged '
pciconf -lvbce > $LOGS/pciconf_lvbce.log 2>&1
echo 'pciconf -lvbce output logged '
devinfo -vr > $LOGS/devinfo_vr.log 2>&1
echo 'devinf -vr output logged '
cat /var/log/messages > $LOGS/var_log_messages.log  2>&1
echo 'grep ":\[drm\[:]]"' > $LOGS/var_log_messages_grep_drm.log 2>&1
cat /var/log/messages |grep ":\[drm\[:]]" >> $LOGS/var_log_messages_grep_drm.log 2>&1
echo 'messages logged '
pkg info > $LOGS/list_of_pkgs.log  2>&1
echo 'installed pkgs logged '

cat /etc/pkg/* > $LOGS/repositories.conf.log 2>&1
cat /usr/local/etc/pkg/repos/* > $LOGS/repositories_usr_local.conf.log 2>&1
echo 'used pkg repositories logged '
echo ''

echo 'Vanilla FreeBSD check'
if [ -e "/etc/defaults/pcbsd" ]
then
	echo ' You seem to be running PCBSD'
	echo 'System seems to be running PCBSD' > $LOGS/not_vanilla.info

elif [ -e "/etc/defaults/trueos" ]
then
	echo ' You seem to be running TrueOS'
	echo 'System seems to be running TrueOS' > $LOGS/not_vanilla.info
else 
	echo ' You seem to be running vanilla'
fi

echo ''
echo 'Done gathering the data'
#echo ' '
#echo 'Changing username to <user>' TODO
#echo 'and the hostname to <host>' TODO 
#echo 'problem being if these strings are located elsewhere in the logs' TODO 

echo ' '
echo 'Tarring the data'
TARVAR="$TIMESTAMP"_xlogs.txz
tar -cJf $TARVAR -C $LOGS ~/Xlogs 2>&1
echo 'Done tarring the data'
echo ' '
echo ' Please submit your results to freebsd-x11@freebsd.org mailing list'
echo ' eg. Upload the results to https://gist.github.com or a similar service '
echo ' '
echo '  If the driver is working in normal usage'
echo '  Try doing something more demanding'

echo ' '
echo '  At the end of this .sh file'
echo '  there are four different test scenarios.'
echo ' '

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

#
# TODO give a switch -c and add a comment to the end of folder/tgz file
# TODO give a switch -v to add all the current info. Without the switch no output.
# TODO 
#

