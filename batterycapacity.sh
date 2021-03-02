#!/bin/sh
stats=`ioreg -f -r -c AppleSmartBattery \
|tr ',' '\n' \
|sed -E 's/^ *//g'`
currcharge=`echo $stats \
|sed -E -e 's/.*"AppleRawCurrentCapacity" = ([0-9]*).*/\1/g'`
echo "Current charge "$currcharge
maxcapacity=`echo $stats \
|sed -E -e 's/.*"AppleRawMaxCapacity" = ([0-9]*).*/\1/g'`
echo "Full charge capacity "$maxcapacity
designcapacity=`echo $stats \
|sed -E -e 's/.*"DesignCapacity" = ([0-9]*).*/\1/g'`
echo "Design capacity "$designcapacity
