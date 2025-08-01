#!/bin/bash

#                     __             __                          __                            __  
#     ________  _____/ /_____ ______/ /_   _      ______ ___  __/ /_  ____ ______        _____/ /_ 
#    / ___/ _ \/ ___/ __/ __ `/ ___/ __/  | | /| / / __ `/ / / / __ \/ __ `/ ___/       / ___/ __ \
#   / /  /  __(__  ) /_/ /_/ / /  / /_    | |/ |/ / /_/ / /_/ / /_/ / /_/ / /     _    (__  ) / / /
#  /_/   \___/____/\__/\__,_/_/   \__/    |__/|__/\__,_/\__, /_.___/\__,_/_/     (_)  /____/_/ /_/ 
#                                                      /____/                                      

for cmd in waybar; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "Error: '$cmd' is required but not installed."
        exit 1
    fi
done

if pgrep -x "waybar" > /dev/null; then
    pkill waybar
    waybar > /dev/null 2>&1 &
else
    waybar > /dev/null 2>&1 &
fi
