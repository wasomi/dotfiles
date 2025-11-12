#!/bin/bash

#                      __                 __  __          __      __                    __  
#     _______  _______/ /____  ____ ___  / / / /___  ____/ /___ _/ /____          _____/ /_ 
#    / ___/ / / / ___/ __/ _ \/ __ `__ \/ / / / __ \/ __  / __ `/ __/ _ \        / ___/ __ \
#   (__  ) /_/ (__  ) /_/  __/ / / / / / /_/ / /_/ / /_/ / /_/ / /_/  __/  _    (__  ) / / /
#  /____/\__, /____/\__/\___/_/ /_/ /_/\____/ .___/\__,_/\__,_/\__/\___/  (_)  /____/_/ /_/ 
#       /____/                             /_/   
#
# Credits: ai
# Edited by: wasomi

icon_dir="/usr/share/icons/Papirus/16x16/status"

red=$(tput setaf 1; tput bold)
yellow=$(tput setaf 3; tput bold)
green=$(tput setaf 2; tput bold)
reset=$(tput sgr0)

for cmd in paru; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "Error: '$cmd' not found..." >&2
        exit 1
    fi
done

echo -e "${yellow}::${reset} Starting system update..."
echo

if paru -Syu; then
    echo -e "\n${green}::${reset} System update completed successfully!"
    notify-send -i "$icon_dir/package-install.svg" "System Update" "Packages updated successfully!" -r 8 -t 2500 2>/dev/null
else
    echo -e "\n${red}::${reset} System update failed..."
    notify-send -i "$icon_dir/package-purge.svg" "System Update" "An error occurred during update..." -r 8 -t 2500 2>/dev/null
fi

if pgrep -x waybar >/dev/null; then
    pkill -SIGRTMIN+8 waybar
fi

echo -e "${yellow}::${reset} Press Enter to exit..."
read
