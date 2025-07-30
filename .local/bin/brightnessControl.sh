#!/bin/bash

#      __         _       __    __                       ______            __             __             __  
#     / /_  _____(_)___ _/ /_  / /_____  ___  __________/ ____/___  ____  / /__________  / /       _____/ /_ 
#    / __ \/ ___/ / __ `/ __ \/ __/ __ \/ _ \/ ___/ ___/ /   / __ \/ __ \/ __/ ___/ __ \/ /       / ___/ __ \
#   / /_/ / /  / / /_/ / / / / /_/ / / /  __(__  |__  ) /___/ /_/ / / / / /_/ /  / /_/ / /  _    (__  ) / / /
#  /_.___/_/  /_/\__, /_/ /_/\__/_/ /_/\___/____/____/\____/\____/_/ /_/\__/_/   \____/_/  (_)  /____/_/ /_/ 
#               /____/                                                                                       

if [ "$#" -lt 1 ]; then
    echo "Usage: $0 [--set|--inc|--dec] [percent]"
    exit 1
fi

ICON_PATH="/usr/share/icons/Papirus/16x16/apps"

ACTION=$1
PERCENT=$2
PERCENT=${PERCENT//%/}

change_brightness() {
    case "$ACTION" in
        --set)
            brightnessctl set "${PERCENT}%"
        ;;
        --inc)
            brightnessctl set "+${PERCENT}%"
        ;;
        --dec)
            brightnessctl set "${PERCENT}%-"
        ;;
    esac

    local max_bright=$(brightnessctl max)
    local current_bright=$(brightnessctl get)
    local new_bright=$(( (current_bright * 100) / max_bright ))

    notify-send -i "$ICON_PATH/brightness.svg" "Brightness" "Level: ${new_bright}%" -h "int:value:${new_bright}" -r 8 -t 800
}

case "$ACTION" in
    --set|--inc|--dec)
        case "$PERCENT" in
            ''|*[!0-9]*)
                echo "Error: percentage must be a number"
                exit 1
                ;;
        esac
        change_brightness
    ;;
    *)
        echo "Invalid flag: $ACTION"
        echo "Valid flags: --set, --inc, --dec"
        exit 1
    ;;
esac
