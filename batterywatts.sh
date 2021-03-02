#!/bin/sh
stats=`ioreg -f -r -c AppleSmartBattery \
|tr ',' '\n' \
|sed -E 's/^ *//g'`

amps=`echo $stats \
|sed -E -e 's/.*"InstantAmperage" = ([0-9]*).*/\1/g' \
|bitwise -od -wd`
#echo $amps
if [ $amps -ge 0 ]; then
	if [ $amps -eq 0 ]; then
		charging=`echo "Connected at "`
	else
		charging=`echo "Charging with "`
	fi
else 
	charging=`echo "Discharging with "`
fi

volts=`echo $stats \
|sed -E -e 's/.*"AppleRawBatteryVoltage" = ([0-9]*).*/\1/g'`
#echo $volts

echo $charging `echo "scale=3;("$volts"/1000 * "$amps")/1000" \
|bc -l \
|sed -E -e 's/.*/& Watts/'`

