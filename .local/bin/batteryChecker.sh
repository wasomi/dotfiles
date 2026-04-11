#!/bin/sh

# Credits: https://github.com/Zproger

# Possible values: NONE, FULL, LOW, CRITICAL
last="NONE"
critical=10
low=25

while true; do
    battery="/sys/class/power_supply/BAT0"
  
    if [ ! -d "$battery" ]; then
        echo "Battery not found. Exiting..."
        exit 0 # Выход из скрипта, если батарея не обнаружена
    fi

    capacity=$(cat "$battery/capacity")
    status=$(cat "$battery/status")

    if [ "$status" = "Charging" ]; then
        last="NONE"
    fi

    if [ "$last" != "FULL" ] && [ "$status" = "Full" ]; then
        notify-send -i "battery-full-symbolic" "Battery full" -r 8 -t 2000 
        last="FULL"
    fi

    if [ "$last" != "LOW" ] && [ "$last" != "CRITICAL" ] && \
    [ "$status" = "Discharging" ] && [ "$capacity" -le "$low" ]; then
        notify-send -i "battery-low-symbolic" "Battery low" "Capacity: $capacity%" -r 8 -t 5000 
        last="LOW"
    fi

    if [ "$last" != "CRITICAL" ] && [ "$status" = "Discharging" ] && \
    [ "$capacity" -le "$critical" ]; then
        notify-send -u critical -i "battery-empty-symbolic" "Battery critical" "Capacity: $capacity%" -r 8
        last="CRITICAL"
    fi
  
    sleep 60
done
