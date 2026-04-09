#!/bin/bash

# Credits: https://wiki.hypr.land/

icon="/usr/share/icons/Papirus/16x16/symbolic/categories/applications-games-symbolic.svg"

if [ "$1" = "start" ]; then
    hyprctl --batch "\
        keyword animations:enabled 0;\
        keyword animation borderangle,0;\
        keyword decoration:shadow:enabled 0;\
        keyword decoration:blur:enabled 0;\
        keyword decoration:fullscreen_opacity 1;\
        keyword general:gaps_in 0;\
        keyword general:gaps_out 0;\
        keyword general:border_size 1;\
        keyword decoration:rounding 0"
    notify-send -i "$icon" "Gamemode" "Enabled" -r 8 -t 1000
    exit 0
elif [ "$1" = "end" ]; then
    hyprctl reload
    notify-send -i "$icon" "Gamemode" "Disabled" -r 8 -t 1000
    exit 0
else
    echo "Usage: $0 [start|end]" >&2
    exit 1
fi
