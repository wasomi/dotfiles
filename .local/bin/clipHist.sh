#!/bin/bash

#          ___       __  ___      __               __  
#    _____/ (_)___  / / / (_)____/ /_        _____/ /_ 
#   / ___/ / / __ \/ /_/ / / ___/ __/       / ___/ __ \
#  / /__/ / / /_/ / __  / (__  ) /_   _    (__  ) / / /
#  \___/_/_/ .___/_/ /_/_/____/\__/  (_)  /____/_/ /_/ 
#         /_/   
#
# Credits: https://github.com/sentriz

for cmd in cliphist wl-copy; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "Error: '$cmd' not found..." >&2
        exit 1
    fi
done

clear=" Clear clipboard..."
icon_dir="/usr/share/icons/Papirus/16x16/status"

if [ -z "$1" ]; then
    echo $clear
    cliphist list
else
    if [ "$1" = "$clear" ]; then
        cliphist wipe
        notify-send -i "$icon_dir/package-install.svg" "Clipboard" "Cleared!" -r 8 -t 2500
    else
        cliphist decode <<<"$1" | wl-copy
    fi
fi
