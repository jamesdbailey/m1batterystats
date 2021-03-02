#!/bin/sh
temp=`ioreg -r -c AppleSmartBattery \
|egrep -e '"VirtualTemperature" = [0-9]*?' \
|sed -E -e 's/.*"VirtualTemperature" = ([0-9]+).*/\1/'`
echo "scale=3;("$temp"/100)*(9/5)+32" |bc -l
