#!/bin/sh
#
echo 'This script set the custom kernel.intel to be next booted up '
echo 'this requiers that there is a kernel with that name in /boot '
nextboot -k kernel.intel
