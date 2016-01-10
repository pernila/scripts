README for logs

Some testing data from the script.
Here is logs from the same T540p laptop.
https://github.com/pernila/scripts/tree/master/logs

Files 1: run script after boot
1_Dec_kernel_after_boot_Xlogs_2016.01.04_22:51:50.txz
1_Oct_kernel_after_boot_Xlogs_2016.01.04_22:26:40.txz

Files 2: run script after kldload i915kms
2_Dec_kernel_i915kms_loaded_Xlogs_2016.01.04_22:43:52.txz
2_Dec_kernel_i915kms_loaded_Xlogs_2016.01.04_22:47:39.txz
   Double files here for reason that forgot :)
2_Oct_kernel_i915kms_loaded_Xlogs_2016.01.04_22:33:21.txz

Files 3: run script after starting Xorg
3_Dec_kernel_Running_Xserver_Xlogs_2016.01.04_22:52:26.txz
   This version of the kernel just black screened after Xorg started.
   Was able to reproduce many times.
   Ran these commands in VTY2: sleep 5; ./dsfx.sh ; sleep 35 ;reboot
   and then started Xorg from VTY1 to get the logs.
3_Oct_kernel_Running_Xserver_Xlogs_2016.01.04_22:36:00.txz
