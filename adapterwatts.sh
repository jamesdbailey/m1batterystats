#!/bin/sh
stats=`ioreg -f -r -c AppleSmartBattery \
|tr ',' '\n' \
|sed -E 's/^ *//g'`
watts=`echo $stats \
|sed -E -e 's/.*"Watts"=([0-9]+).*/\1/'`
if echo $stats |egrep -q "Watts"; then
	echo "Power adapter at "$watts" Watts"
fi
