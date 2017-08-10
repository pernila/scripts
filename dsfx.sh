#!/bin/sh
#

# dsfx.sh - a Debugging Script For things relating to Xorg
VERSION=' version 0.4.3 ' 
# Gathers hardware information and collects all relevant logs
# to the folder ~/Xlogs_<date>.'
# Then tars everything to a single <date>_xlogs.txz file to the ~-folder.

TIMESTAMP=$(date +"%Y.%m.%d_%H-%M-%S")

while (($# > 0)); do
	if [ "$1" == "-V" -o "-Version" == "$1" -o "$1" == "--Version" ]; then
		shift;
		echo $VERSION
		exit;

	elif [ "$1" == "-v" -o "-verbose" == "$1" -o "$1" == "--verbose" ]; then
		shift;
		DEBUG='ON'

	elif [ "$1" == "-t" -o "-tips" == "$1" -o "$1" == "--tips" ]; then
		shift;

echo 'Some tips for getting Xorg running correctly:    '
echo ' '
echo 'if X is not running on the computer'
echo '           xrandr will give an error "Cant open display"'
echo '           Try starting X with >startx '
echo ' '
echo 'Is Xorg installed on the system?'
echo '           If not install with'
echo '            #pkg install xorg'
echo ' '
echo 'No config for Xorg?'
echo '           Create a basic config with'
echo '            >Xorg -configure'
echo ''
echo '           afterwards you may want to edit it a bit'
echo '           eg. adding this to your xorg.conf'
echo '           allows killing Xorg with ctrl+alt+del'
echo ' '
echo '			Section    "ServerFlags" '
echo '		  	Option     "DontZap" "false"'
echo '      		EndSection'
echo ' '
echo 'if getting complaints about drm permissions '
echo '  e.g. libGL error: failed to open drm device: Permission denied'
echo '       libGL error: failed to load driver: <driver>'
echo 'fix with adding your username to the video group'
echo ' >pw groupmod video -m <your username>'
echo ' '
	exit;

	elif [ "$1" == "-h" -o "-help" == "$1" -o "$1" == "--help" ]; then
		shift;
	
echo "
dsfx.sh - a Debugging Script For things relating to Xorg 
version $VERSION

This script gathers hardware information and collects all relevant logs to the folder ~/Xlogs_<date>.
Then tars everything to a single xlogs_<date>.txz file to the ~ folder.

Available arguments:

-a		--add-comment
--add-comment	Add a custom comment to the txz file.
		e.g. -a kernel_r296116 would create:
		<date>_xlogs_kernel_r296116.txz

-u		--usecases
--usecases	Prints out use cases to stress the GPU and it's driver

-h		--help
--help		This printout

-t		--tips
--tips		Prints some tips for getting Xorg running correctly

-v		--verbose
--verbose	Enables verbose mode

-V		--Version
--Version	Prints the script version
"
		exit;

	elif [ "$1" == "-u" -o "-usecases" == "$1" -o "$1" == "--usecases" ]; then
		shift;
		echo "
Examples of test cases
Run this script after each scenario to gather the relevant logs

Arto Pekkanen\'s test scenario 1#
 startx with normal user
 
Arto Pekkanen\'s test scenario 2#
 boot with loader.conf drm.debug=3 and i915kms_load=\"YES\"
 startx as a normal user

Arto Pekkanen\'s test scenario 3#
 boot with loader.conf drm.debug=3
 switch to a non-console TTY
 test suspend to RAM (acpciconf -s 3) and resume
  test video playback afgter suspend 
 test suspend & resume via X11 session
  test video playback afgter suspend 
 test suspend & resume with additional monitor
  test video playback afgter suspend 


Arto Pekkanen\'s test scenario 4#
 boot with loader.conf drm.debug=3
 switch to a non-console TTY
 test suspend to RAM (acpciconf -s 3) and resume

  test video playback after suspend 

 test suspend & resume via X11 session

  test video playback after suspend 

 test suspend & resume with additional monitor
"
		exit;
	
	elif [ "$1" == "-a" -o "-add-comment" == "$1" -o "$1" == "--add-comment" ]; then
		COMMENT=$2
		COMMENTFLAG=ON
		echo 'comment argument is ' $COMMENT
		shift;
	else
		#if argument is any other, skip it.
		shift;
	fi
done

if [ -d ~/Xlogs ]
then 
	if [ "$DEBUG" = ON ]; then
		echo ' Xlogs directory already found '
		echo ''
	fi

	mkdir -p  ~/Xlogs_"$TIMESTAMP"
	LOGS=~/Xlogs_"$TIMESTAMP"
	echo $TIMESTAMP > $LOGS/date.info

	if [ "$DEBUG" = ON ]; then
		echo 'Creating a new folder: ' "$LOGS"
		echo ' '
	fi
else
	mkdir -p  ~/Xlogs
	LOGS=~/Xlogs

	if [ "$DEBUG" = ON ]; then
		echo 'Creating a new folder: ' "$LOGS"
	fi

	echo $TIMESTAMP > $LOGS/date.info
	echo $VERSION > $LOGS/dsfx.sh_version.info
	echo ' '
fi

echo 'Computer hardware info ' >> $LOGS/hardware_info.txt
echo ' ~~~  ' >> $LOGS/hardware_info.txt

#cpu
grep CPU: /var/run/dmesg.boot > $LOGS/cpu_info.log 2>&1

#gpu
#check for all gpus seen by kernel
grep -i 'vga\|agp' /var/run/dmesg.boot > $LOGS/gpu_info.log 2>&1

xrandr  > $LOGS/xrandr.log 2>&1
xrandr --verbose > $LOGS/xrandr_verbose.log 2>&1

#Get information about system model and manufacturer
grep -i smbio /var/log/bsdinstall_log > $LOGS/model_manufacturer.log 2>&1
#cat /var/log/bsdinstall_log > $LOGS/bsdinstall.log 2>&1
#cat /root/pc-sysinstall.log > $LOGS/pc-sysinstall.log 2>&1

#Fill up HW info files
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


if [ "$DEBUG" = ON ]; then
	echo 'xorg.conf(s) logged '
fi

cat /var/log/Xorg.0.log > $LOGS/Xorg.0.log 2>&1
if [ "$DEBUG" = ON ]; then
	echo 'Xorg logs logged '
fi

Xorg -version > $LOGS/Xorg_version.log 2>&1
if [ "$DEBUG" = ON ]; then
	echo 'Xorg version logged '
fi

#Check the video group
#(this caused some issues mixing 10.x and 11.0 userland and kernel)
echo 'ls -la /dev/dri ' > $LOGS/dri.permissions.log
ls -la /dev/dri >> $LOGS/dri_permissions.log 2>&1
cat /etc/group > $LOGS/group.log 2>&1
if [ "$DEBUG" = ON ]; then
	echo 'users groups logged '
fi

#dmesg from boot
cat /var/run/dmesg.boot > $LOGS/dmesg_boot.log 2>&1
if [ "$DEBUG" = ON ]; then
	echo 'dmesg from boot logged '
fi

id -ur > $LOGS/script_run_as_user_id.log 2>&1
echo ' ' >> $LOGS/script_run_as_user_id.log 2>&1
echo 'user id 0 means the root user' >> $LOGS/script_run_as_user_id.log 2>&1
if [ "$DEBUG" = ON ]; then
	echo 'user id number running the script logged '
fi

#Check uname
uname -a > $LOGS/uname_a.log 2>&1

if [ "$DEBUG" = ON ]; then
	echo 'uname -a logged '
fi

cat /etc/rc.conf > $LOGS/rc.conf.log 2>&1

if [ "$DEBUG" = ON ]; then
	echo 'rc.conf logged '
fi

cat /etc/loader.conf > $LOGS/loader.conf.log 2>&1

if [ "$DEBUG" = ON ]; then
	echo 'loader.conf logged '
fi

#Check the userland version
echo 'freebsd_version -u = userland version' > $LOGS/freebsd_version.log
freebsd-version -u >> $LOGS/freebsd_version.log 2>&1
echo 'freebsd_version -k = kernel version' >> $LOGS/freebsd_version.log
freebsd-version -k >> $LOGS/freebsd_version.log 2>&1
if [ "$DEBUG" = ON ]; then
echo 'freebsd_version logged '
fi

cat /boot/loader.conf > $LOGS/loader.conf.log 2>&1
if [ "$DEBUG" = ON ]; then
echo 'loader.conf logged '
fi

cat /etc/sysctl.conf > $LOGS/sysctl.conf.log 2>&1
if [ "$DEBUG" = ON ]; then
echo 'sysctl.conf logged '
fi

pciconf -lvbce > $LOGS/pciconf_lvbce.log 2>&1
if [ "$DEBUG" = ON ]; then
echo 'pciconf -lvbce output logged '
fi

devinfo -vr > $LOGS/devinfo_vr.log 2>&1
if [ "$DEBUG" = ON ]; then
echo 'devinf -vr output logged '
fi

cat /var/log/messages > $LOGS/var_log_messages.log  2>&1
echo 'grep ":\[drm\[:]]"' > $LOGS/var_log_messages_grep_drm.log 2>&1
cat /var/log/messages |grep '\[drm' >> $LOGS/var_log_messages_grep_drm.log 2>&1
if [ "$DEBUG" = ON ]; then
echo '/var/log/messages logged '
fi

pkg info > $LOGS/list_of_pkgs.log  2>&1
if [ "$DEBUG" = ON ]; then
echo 'installed pkgs logged '
fi

cat /etc/pkg/* > $LOGS/repositories.conf.log 2>&1
cat /usr/local/etc/pkg/repos/* > $LOGS/repositories_usr_local.conf.log 2>&1
if [ "$DEBUG" = ON ]; then
echo 'used pkg repositories logged '
echo ''
fi

if [ "$DEBUG" = ON ]; then
echo 'Vanilla FreeBSD check'
fi

if [ -e "/etc/defaults/pcbsd" ]
then
		if [ "$DEBUG" = ON ]; then
			echo ' You seem to be running PCBSD'
		fi
	echo 'System seems to be running PCBSD' > $LOGS/not_vanilla.info

elif [ -e "/etc/defaults/trueos" ]; then

		if [ "$DEBUG" = ON ]; then
			echo ' You seem to be running TrueOS'
		fi
	echo 'System seems to be running TrueOS' > $LOGS/not_vanilla.info
else 
		if [ "$DEBUG" = ON ]; then
			echo ' You seem to be running vanilla'
	echo 'System seems to be running FreeBSD' > $LOGS/vanilla.info
		fi
fi

if [ "$DEBUG" = ON ]; then
	echo 'Done gathering the data'
echo ''
fi

echo ' '
if [ "$DEBUG" = ON ]; then
echo 'Tarring the data'
fi

if [ "$COMMENTFLAG" = ON ]; then
	TARVAR="$TIMESTAMP"_xlogs_"$COMMENT".txz
else
	TARVAR="$TIMESTAMP"_xlogs.txz
fi

tar -cJf $TARVAR -C $LOGS ~/Xlogs 2>&1

if [ "$DEBUG" = ON ]; then
echo 'Done tarring the data'
echo ' '
fi

if [ "$DEBUG" = ON ]; then
echo ' Please submit your results to freebsd-x11@freebsd.org mailing list'
echo ' eg. Upload the results to https://gist.github.com or a similar service '
echo ' '
echo '  If the driver is working in normal usage'
echo '  Try doing something more demanding'
fi

#TODO tar error
#TODO cat var
#TODO llvm related issues. E.g. check binary compilers, older installed llvm packages
#TODO Changing all usernames to <user> TODO
# and the hostname to <host> TODO 
#TODO problem being if these strings are located elsewhere in the logs
#TODO gather installed DRM and GPU driver versions to a new file

#TODO add these debuggin info outputs. 
# memcontrol list
# vidcontrol -i mode
# vidcontrol -i adapter
