#!/bin/sh
amps=0
prev=0
while :
do
  stats=`ioreg -f -r -c AppleSmartBattery |tr ',' '\n' |sed -E 's/^ *//g'`
  currcharge=`echo $stats |sed -E -e 's/.*"AppleRawCurrentCapacity" = ([0-9]*).*/\1/g'`
  amps=`echo $stats |sed -E -e 's/.*"InstantAmperage" = ([0-9]*).*/\1/g' |bitwise -od -wd`
  if [[ $amps -lt 0 && $prev -ne $amps ]]; then
    prev=$amps
    remh=` echo "($currcharge/$amps)*-1" |bc -l`
    remih=`echo "scale=0;$remh/1" |bc`
    remmin=`echo "scale=0;(($remh-$remih+0.005)*60)/1" |bc `
    if [ $remmin -lt 10 ]; then
      printf "\rTime Remaining   :   \rTime Remaining %s:0%s  " "$remih" "$remmin"
    else
      printf "\rTime Remaining   :   \rTime Remaining %s:%s  " "$remih" "$remmin"
    fi
  fi
  sleep 10
done
