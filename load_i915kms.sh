#!/bin/sh
#
echo 'This script loads the kernel module i915kms and some acpi modules'


#dmesg from boot

kldload acpi_video &
kldload acpi_ibm &
kldload i915kms &

