#!/bin/bash

result=$(cliphist list | rofi -dmenu -display-columns 2 -config ~/.dotfiles/.config/rofi/styles/clipboardHistory.rasi)

if [ -n "$result" ]; then
    echo "$result" | cliphist decode | wl-copy
fi
