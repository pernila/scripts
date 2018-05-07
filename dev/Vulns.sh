#!/bin/sh
#tommi 13.09.201
#Vulns.sh version 0.2.1
#pkg audit -F tool

#Add a note that base-audit doesn't work on CURRENT? or does it?

echo ''
echo 'Vulnerabilities in base version:' $(freebsd-version)
pkg audit -F $(freebsd-version -u | sed 's,^,FreeBSD-,;s,-RELEASE-p,_,;s,-RELEASE$,,')|grep -v 'up-to-date'

#line above does this
#pkg audit -F FreeBSD-11.1_6 |grep -v 'up-to-date'

echo ''
echo 'Vulnerable ports installed:'
pkg audit | grep vulnerable | sort -u | awk '{print $1}'

#just list vulnerable package names nothing else
#pkg audit | grep vulnerable | sort -u | awk '{print $1}'

