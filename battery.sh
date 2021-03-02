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

echo "Charge at "`echo "scale=3;"$currcharge"/"$maxcapacity"*100" |bc -l`"% capacity"

designcapacity=`echo $stats \
|sed -E -e 's/.*"DesignCapacity" = ([0-9]*).*/\1/g'`
echo "Design capacity "$designcapacity

echo "Current full charge at "`echo "scale=3;"$maxcapacity"/"$designcapacity"*100" |bc -l`"% design capacity"

cycles=`echo $stats \
|sed -E -e 's/.*"CycleCount" = ([0-9]+).*/\1/g'`
echo "Cycle count is "$cycles

ktemp=`echo $stats \
|sed -E -e 's/.*"Temperature" = ([0-9]+).*/\1/g'`
echo "Battery temperature "`echo "scale=3;("$ktemp"/10-273.15)*(9/5)+32" |bc -l`

watts=`echo $stats \
|sed -E -e 's/.*"Watts"=([0-9]+).*/\1/'`
if echo $stats |egrep -q "Watts"; then
	echo "Power adapter at "$watts" Watts"
fi

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

famcode=`echo $stats |sed -E -e 's/.*"FamilyCode"=([0-9]+).*/\1/' |bitwise -ww -od`
if [ $famcode -ne 0 ]; then
	echo "Power adapter connected"
else
	echo "Power adapter Disconnected"
fi