#!/bin/bash

# Credits: ai

critical=10
low=25

bat_path=$(upower -e | grep -m 1 'battery')

if [ -z "$bat_path" ]; then
    exit 0
fi

last_level="NONE" # NONE, LOW, CRITICAL, FULL
last_status=""    # charging, discharging, fully-charged

check_battery() {
    local info capacity status

    info=$(upower -i "$bat_path")
    capacity=$(echo "$info" | awk '/percentage:/ {print $2}' | tr -d '%')
    status=$(echo "$info" | awk '/state:/ {print $2}')
    capacity=${capacity%.*}

    if [ -z "$last_status" ]; then
        last_status="$status"
    fi

    if [ "$status" != "$last_status" ]; then
        if [ "$status" = "charging" ]; then
            notify-send -i "battery-good-charging-symbolic" "Charging" "Adapter plugged in ($capacity%)" -r 9 -t 3000 &
            last_level="NONE" # Сбрасываем флаги низкого заряда
        elif [ "$status" = "discharging" ]; then
            notify-send -i "battery-good-symbolic" "Discharging" "Adapter unplugged ($capacity%)" -r 9 -t 3000 &
        fi
        last_status="$status"
    fi

    if [ "$last_level" != "FULL" ] && [ "$status" = "fully-charged" ]; then
        notify-send -i "battery-full-symbolic" "Battery full" -r 9 -t 2000 &
        last_level="FULL"
    fi

    if [ "$last_level" != "LOW" ] && [ "$last_level" != "CRITICAL" ] && \
       [ "$status" = "discharging" ] && [ "$capacity" -le "$low" ]; then
        notify-send -i "battery-low-symbolic" "Battery low" "Capacity: $capacity%" -r 9 -t 5000 &
        last_level="LOW"
    fi

    if [ "$last_level" != "CRITICAL" ] && [ "$status" = "discharging" ] && \
       [ "$capacity" -le "$critical" ]; then
        notify-send -u critical -i "battery-empty-symbolic" "Battery critical" "Capacity: $capacity%" -r 9 &
        last_level="CRITICAL"
    fi
}

check_battery

upower --monitor | grep --line-buffered "$bat_path" | while read -r _; do
    check_battery
done
