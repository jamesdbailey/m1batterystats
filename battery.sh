#!/bin/sh
stats=`ioreg -f -r -c AppleSmartBattery \
|tr ',' '\n' \
|sed -E 's/^ *//g'`

currcharge=`echo $stats \
|sed -E -e 's/.*"AppleRawCurrentCapacity" = ([0-9]*).*/\1/g'`
echo "Current charge "$currcharge" mAh"

maxcapacity=`echo $stats \
|sed -E -e 's/.*"AppleRawMaxCapacity" = ([0-9]*).*/\1/g'`
echo "Full charge capacity "$maxcapacity" mAh"

echo "Charge at "`echo "scale=3;"$currcharge"/"$maxcapacity"*100" |bc -l`"% capacity"

designcapacity=`echo $stats \
|sed -E -e 's/.*"DesignCapacity" = ([0-9]*).*/\1/g'`
echo "Design capacity "$designcapacity" mAh"

echo "Current full charge at "`echo "scale=3;"$maxcapacity"/"$designcapacity"*100" |bc -l`"% design capacity"

cycles=`echo $stats \
|sed -E -e 's/.*"CycleCount" = ([0-9]+).*/\1/g'`
echo "Cycle count is "$cycles

ktemp=`echo $stats \
|sed -E -e 's/.*"Temperature" = ([0-9]+).*/\1/g'`
echo "Battery temperature "`echo "scale=2;("$ktemp"/10-273.15)*(9/5)+32" |bc -l`" °F ("`echo "scale=2;("$ktemp"/10-273.15)" |bc -l`" °C)"

watts=`echo $stats \
|sed -E -e 's/.*"Watts"=([0-9]+).*/\1/'`
if echo $stats |egrep -q "Watts"; then
	echo "Power adapter at "$watts" Watts"
fi

amps=`echo $stats \
|sed -E -e 's/.*"InstantAmperage" = ([0-9]*).*/\1/g' \
|bitwise -od -wd`
echo Instant Amperage $amps mA

if [ $amps -ge 0 ]; then
	if [ $amps -eq 0 ]; then
		charging=`echo "Connected at "`
	else
		charging=`echo "Charging with "`
	fi
else 
	charging=`echo "Discharging with "`
fi
millivolts=`echo $stats \
|sed -E -e 's/.*"AppleRawBatteryVoltage" = ([0-9]*).*/\1/g'`
volts=`echo "scale=2;$millivolts/1000" |bc -l`
echo "Battery voltage "$volts" V"
echo $charging `echo "scale=3;("$volts" * "$amps")/1000" \
|bc -l \
|sed -E -e 's/.*/& Watts/'`

famcode=`echo $stats |sed -E -e 's/.*"FamilyCode"=([0-9]+).*/\1/' |bitwise -ww -od`
if [ $famcode -ne 0 ]; then
	echo "Power adapter connected"
else
	echo "Power adapter disconnected"
fi

currentcapacity=`echo $stats \
|sed -E -e 's/.*"CurrentCapacity" = ([0-9]*).*/\1/g'`
echo "Current capacity "$currentcapacity"%"

stateofcharge=`echo $stats \
|sed -E -e 's/.*"StateOfCharge"=([0-9]*).*/\1/g'`
echo "State of charge "$stateofcharge"%"

if [ $amps -lt 0 ]; then
	remh=` echo "($currcharge/$amps)*-1" |bc -l`
	remih=`echo "scale=0;$remh/1" |bc`
	remmin=`echo "scale=0;(($remh-$remih+0.005)*60)/1" |bc `
	if [ $remmin -lt 10 ]; then
		echo Time Remaining $remih:0$remmin
	else
		echo Time Remaining $remih:$remmin
	fi
fi
