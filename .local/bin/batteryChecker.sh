#!/bin/sh

# Credits: https://github.com/Zproger

# Possible values: NONE, FULL, LOW, CRITICAL
last="NONE"
critical=10
low=25

while true; do

  battery="/sys/class/power_supply/BAT0"
  icon_dir="/usr/share/icons/Papirus/48x48/status"

  if [ -d $battery ]; then

    capacity=$(cat $battery/capacity)
    status=$(cat $battery/status)

    if [ "$last" != "FULL" ] && [ "$status" = "Full" ]; then
      notify-send -i "$icon_dir/battery-full.svg" "Battery full" -r 8 -t 1000 
      last="FULL"
    fi

    if [ "$last" != "LOW" ] && [ "$last" != "CRITICAL" ]  && \
       [ "$status" = "Discharging" ] && [ $capacity -le $low ]; then
      notify-send -i "$icon_dir/battery-caution.svg" "Battery low" "Capacity: $capacity%" -r 8 -t 1000 
      last="LOW"
	fi

	if [ "$last" = "LOW" ] && [ "$status" = "Discharging" ] && \
	   [ $capacity -le $critical ]; then
      notify-send -i "$icon_dir/battery-empty.svg" "Battery critical" "Capacity: $capacity%" -r 8 -t 1000 
      last="CRITICAL"
    fi
  fi
  sleep 60

done
