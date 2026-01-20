#!/bin/sh

#     __          __  __                  ________              __                          __  
#    / /_  ____ _/ /_/ /____  _______  __/ ____/ /_  ___  _____/ /_____  _____        _____/ /_ 
#   / __ \/ __ `/ __/ __/ _ \/ ___/ / / / /   / __ \/ _ \/ ___/ //_/ _ \/ ___/       / ___/ __ \
#  / /_/ / /_/ / /_/ /_/  __/ /  / /_/ / /___/ / / /  __/ /__/ ,< /  __/ /     _    (__  ) / / /
# /_.___/\__,_/\__/\__/\___/_/   \__, /\____/_/ /_/\___/\___/_/|_|\___/_/     (_)  /____/_/ /_/ 
#                               /____/                                                          
#
# Credits: https://github.com/Zproger

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
