#!/bin/bash

#                                                     __                  __  
#     ____ _____ _____ ___  ___  ____ ___  ____  ____/ /__          _____/ /_ 
#    / __ `/ __ `/ __ `__ \/ _ \/ __ `__ \/ __ \/ __  / _ \        / ___/ __ \
#   / /_/ / /_/ / / / / / /  __/ / / / / / /_/ / /_/ /  __/  _    (__  ) / / /
#   \__, /\__,_/_/ /_/ /_/\___/_/ /_/ /_/\____/\__,_/\___/  (_)  /____/_/ /_/ 
#  /____/                                                                        
# 
# Credits: https://wiki.hyprland.org/
# Edited by: wasomi


for cmd in hyprctl; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "Error: '$cmd' not found..." >&2
        exit 1
    fi
done


hyprgamemode=$(hyprctl getoption animations:enabled | awk 'NR==1{print $2}')
icon="/usr/share/icons/Papirus/16x16/symbolic/categories/applications-games-symbolic.svg"

if [ "$hyprgamemode" = 1 ] ; then
    hyprctl --batch "\
        keyword animations:enabled 0 ;\
        keyword decoration:shadow:enabled 0 ;\
        keyword decoration:blur:enabled 0 ;\
        keyword decoration:active_opacity 1 ;\
        keyword decoration:inactive_opacity 1 ;\
        keyword decoration:fullscreen_opacity 1 "

    notify-send -i "$icon" "Gamemode" "Enabled" -r 8 -t 1000

    exit
else
    notify-send -i "$icon" "Gamemode" "Disabled" -r 8 -t 1000
fi
hyprctl reload
