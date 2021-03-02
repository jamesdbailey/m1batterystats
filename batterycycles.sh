#!/bin/sh
cycles=`ioreg -r -c AppleSmartBattery \
|egrep -e '"CycleCount" = [0-9]*?' \
|sed -E -e 's/.*"CycleCount" = ([0-9]+).*/\1/'`
echo "Cycle count is "$cycles
