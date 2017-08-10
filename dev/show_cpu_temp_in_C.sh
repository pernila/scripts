#!/bin/sh
#show CPU core temperature in celcius
sysctl hw.acpi.thermal.tz0.temperature | awk '{print $2;}'

