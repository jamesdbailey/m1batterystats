#!/bin/sh
stats=`ioreg -f -r -c AppleSmartBattery \
|tr ',' '\n' \
|sed -E 's/^ *//g'`
famcode=`echo $stats |sed -E -e 's/.*"FamilyCode"=([0-9]+).*/\1/' |bitwise -ww -od`
if [ $famcode -ne 0 ]; then
	echo "Adapter Connected"
else
	echo "Adapter Disconnected"
fi