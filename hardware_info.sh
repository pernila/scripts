#!/bin/sh
#
echo '  ' 
echo 'Get HW info and collect all the logs (that are not empty) to an index'
echo '  ' 

mkdir -p  ~/logs_hw
LOGS=~/logs_hw
rm $LOGS/*.log
rm $LOGS/*.txt

echo ' ~~~  ' >> $LOGS/hardware_info.txt
echo 'Desktop/server/Laptop hardware info ' >> $LOGS/hardware_info.txt
echo ' ~~~  ' >> $LOGS/hardware_info.txt

#cpu
grep CPU: /var/run/dmesg.boot > $LOGS/cpu_info.log

#gpu
#Optimus / dual gpu setup?
#check for all gpus seen by kernel
grep -i 'vga\|agp' /var/run/dmesg.boot >  $LOGS/gpu_info.log

#xrandr
echo 'xrandr: will give an error Cant open display here'
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

echo 'xrandr:  ' >> $LOGS/hardware_info.txt
cat $LOGS/xrandr.log >> $LOGS/hardware_info.txt
echo '   ' >> $LOGS/hardware_info.txt
echo '   ' >> $LOGS/hardware_info.txt

#echo ' /n /n ' > $LOGS/hardware_info.txt
#cat $LOGS/ > $LOGS/hardware_info.txt

echo '  ' 
echo 'Done '
echo '  ' 
