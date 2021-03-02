#!/bin/sh
temp=`ioreg -r -c AppleSmartBattery \
|egrep -e '"Temperature" = [0-9]*?' \
|sed -E -e 's/.*"Temperature" = ([0-9]+).*/\1/'`
echo "scale=3;("$temp"/10-273.15)*(9/5)+32" |bc -l
