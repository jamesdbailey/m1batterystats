#!/bin/sh
ioreg -f -r -c AppleSmartBattery \
|tr ',' '\n' \
|sed -E 's/^ *//g' \
|egrep '\b"AppleRawCurrentCapacity"|"AppleRawMaxCapacity"|"DesignCapacity"|"IsCharging"|"Watts"|"CycleCount"|"VirtualTemperature"|"Serial"|"CycleCount"|"AppleRawBatteryVoltage"|"InstantAmperage"|"CurrentCapacity"|"TimeRemaining|"StateOfCharge' \
|sed -E -e 's/(\".*\")=/\1 = /g' -e 's/(\".*\") =\"/\1 = \"/g' -e 's/ = \({/ = \(\n{/g' \
|sort |uniq
