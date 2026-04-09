#!/bin/bash

# Credits: https://github.com/sentriz

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
