#!/bin/bash

# Credits: ai

default_step=5

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

# choose_icon() {
#     local brightness=$1

#     if [[ $brightness -le 30 ]]; then
#         echo "notification-display-brightness-low"
#     elif [[ $brightness -le 70 ]]; then
#         echo "notification-display-brightness-medium"
#     else
#         echo "notification-display-brightness-full"
#     fi
# }

change_brightness() {
    case "$action" in
        --set) brightnessctl set "${percent}%" ;;
        --inc) brightnessctl set "+${percent}%" ;;
        --dec) brightnessctl set "${percent}%-" ;;
    esac

    local max=$(brightnessctl max)
    local current=$(brightnessctl get)
    local level=$(awk -v curr="$current" -v max="$max" 'BEGIN { printf "%d", (curr * 100 / max) + 0.5 }')

    # local icon=$(choose_icon "$level")

    notify-send -i "display-brightness-symbolic" "Brightness" "${level}%" -h "int:value:$level" -h string:x-canonical-private-synchronous:osd -t 1000
}

change_brightness
