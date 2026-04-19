#!/bin/bash

# Credits: https://github.com/sentriz

clear=" Clear clipboard..."

if [ -z "$1" ]; then
    echo $clear
    cliphist list
else
    if [ "$1" = "$clear" ]; then
        cliphist wipe
        notify-send -i "dialog-information-symbolic" "Clipboard" "Cleared!" -r 8 -t 2000
    else
        cliphist decode <<<"$1" | wl-copy
    fi
fi
