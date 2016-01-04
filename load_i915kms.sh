#!/bin/sh
#
echo 'This script loads the kernel module i915kms'


#dmesg from boot

kldload i915kms &

