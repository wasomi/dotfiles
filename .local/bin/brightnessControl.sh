#!/bin/bash

#      __         _       __    __                       ______            __             __             __  
#     / /_  _____(_)___ _/ /_  / /_____  ___  __________/ ____/___  ____  / /__________  / /       _____/ /_ 
#    / __ \/ ___/ / __ `/ __ \/ __/ __ \/ _ \/ ___/ ___/ /   / __ \/ __ \/ __/ ___/ __ \/ /       / ___/ __ \
#   / /_/ / /  / / /_/ / / / / /_/ / / /  __(__  |__  ) /___/ /_/ / / / / /_/ /  / /_/ / /  _    (__  ) / / /
#  /_.___/_/  /_/\__, /_/ /_/\__/_/ /_/\___/____/____/\____/\____/_/ /_/\__/_/   \____/_/  (_)  /____/_/ /_/ 
#               /____/                                                                                       
#
# Credits: ai
# Edited by: wasomi

icon_dir="/usr/share/icons/Papirus/48x48@2x/status"
default_step=5

for cmd in brightnessctl; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "Error: '$cmd' not found..." >&2
        exit 1
    fi
done

action="$1"
percent="${2//%/}"
percent="${percent:-$default_step}"

case "$action" in
    --set|--inc|--dec)
        if ! [[ "$percent" =~ ^[0-9]+$ ]]; then
            echo "Error: percentage must be a number"
            exit 1
        fi
        ;;
    *)
        echo "Usage: $0 [--set|--inc|--dec] [percent]"
        echo "Valid flags: --set, --inc, --dec"
        exit 1
        ;;
esac

choose_icon() {
    local brightness="$1"
    if (( brightness <= 10 )); then
        echo "$icon_dir/notification-display-brightness-low.svg"
    elif (( brightness <= 50 )); then
        echo "$icon_dir/notification-display-brightness-medium.svg"
    else
        echo "$icon_dir/notification-display-brightness-full.svg"
    fi
}

change_brightness() {
    case "$action" in
        --set) brightnessctl set "${percent}%" ;;
        --inc) brightnessctl set "+${percent}%" ;;
        --dec) brightnessctl set "${percent}%-" ;;
    esac

    local max=$(brightnessctl max)
    local current=$(brightnessctl get)
    local level=$(awk -v curr="$current" -v max="$max" 'BEGIN { printf "%d", (curr * 100 / max) + 0.5 }')

    local icon=$(choose_icon "$level")

    notify-send -i "$icon" "Brightness" "Level: ${level}%" -h "int:value:$level" -r 8 -t 800
}

change_brightness
