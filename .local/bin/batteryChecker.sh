#!/bin/sh

# Possible values: NONE, FULL, LOW, CRITICAL
last="NONE"
critical=10
low=25

while true; do

  battery="/sys/class/power_supply/BAT0"
  if [ -d $battery ]; then

    capacity=$(cat $battery/capacity)
    status=$(cat $battery/status)

    if [ "$last" != "FULL" ] && [ "$status" = "Full" ]; then
      notify-send "Battery full"
      last="FULL"
    fi

    if [ "$last" != "LOW" ] && [ "$last" != "CRITICAL" ]  && \
       [ "$status" = "Discharging" ] && [ $capacity -le $low ]; then
      notify-send "Battery low: $capacity%"
      last="LOW"
	fi

	if [ "$last" = "LOW" ] && [ "$status" = "Discharging" ] && \
	   [ $capacity -le $critical ]; then
	  notify-send "Battery critical: $capacity%"
      last="CRITICAL"
    fi
  fi
  sleep 60

done
