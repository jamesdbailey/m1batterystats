#!/bin/sh
~/bin/batterystatus.sh \
|sed -E -e 's/"InstantAmperage" = //' \
|egrep -x -e '^[0-9]+' \
|bitwise -wd -od
