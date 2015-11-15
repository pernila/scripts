#!/bin/sh
#
echo 'Get HW info and collect all the logs (that are not empty) to an index'

mkdir -p  ~/logs_hw
LOGS=~/logs_hw
#rm $LOGS/*.log

echo 'Desktop/server/Laptop hardware info /n /n ' > $LOGS/hardware_info.txt

#cpu
grep CPU: /var/run/dmesg.boot > $LOGS/cpu_info.log

#gpu
#Optimus / dual gpu setup?
#check for all gpus seen by kernel
grep -i 'vga\|agp' /var/run/dmesg.boot >  $LOGS/gpu_info.log

#xrandr
xrandr  > $LOGS/xrandr.log

#Get information about system model and manufacturer
grep -i smbio /var/log/bsdinstall_log > $LOGS/model_manufacturer.log

#Fill up HW info file
echo 'Model  /n /n ' > $LOGS/hardware_info.txt
cat $LOGS/model_manufacturer.log > $LOGS/hardware_info.txt

echo 'GPU /n /n ' > $LOGS/hardware_info.txt
cat $LOGS/gpu_info.log > $LOGS/hardware_info.txt

echo 'CPU /n /n ' > $LOGS/hardware_info.txt
cat $LOGS/cpu_info.log > $LOGS/hardware_info.txt

echo 'xrandr /n /n ' > $LOGS/hardware_info.txt
cat $LOGS/xrandr.log > $LOGS/hardware_info.txt

#echo ' /n /n ' > $LOGS/hardware_info.txt
#cat $LOGS/ > $LOGS/hardware_info.txt

echo 'Done '
