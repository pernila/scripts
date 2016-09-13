#!/bin/sh
#tommi 13.09.2016
#Vulns.sh version 0.1
#pkg audit -F tool

echo 'Vulnerable packges that are currently installed:'
pkg audit -F | grep vulnerable | sort -u | awk '{print $1}'

