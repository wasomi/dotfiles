#!/bin/bash

# Credits: https://github.com/mahaveergurjar

capacity_file="/sys/class/power_supply/BAT0/capacity"
status_file="/sys/class/power_supply/BAT0/status"

if [[ ! -f "$capacity_file" ]]; then
    exit 1
fi

battery_percentage=$(cat "$capacity_file")
battery_status=$(cat "$status_file")

battery_icons=("󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹")
charging_icon="󰂄"

icon_index=$(( battery_percentage / 10 ))

if (( icon_index > 10 )); then icon_index=10; fi
if (( icon_index < 0 )); then icon_index=0; fi

battery_icon=${battery_icons[$icon_index]}

if [[ "$battery_status" == "Charging" ]]; then
    battery_icon="$charging_icon"
fi

echo "$battery_percentage% $battery_icon"
