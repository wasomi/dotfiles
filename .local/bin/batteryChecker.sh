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
