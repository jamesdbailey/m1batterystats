#!/bin/sh
~/bin/batterystatus.sh \
|sed -E -e 's/"AppleRawBatteryVoltage" = //' \
|egrep -x -e '^[0-9]+' \
|bitwise -wd -od
