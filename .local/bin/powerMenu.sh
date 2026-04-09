#!/bin/bash

# Credits: https://github.com/Zproger

# uptime="`uptime -p | sed -e 's/up //g'`"
choice=$(printf "\n󰤄\n󰩈\n\n" | rofi -dmenu -config ~/.dotfiles/.config/rofi/styles/powerMenu.rasi)

case "$choice" in
    "") loginctl lock-session ;;
    "󰤄") systemctl suspend;;
    "󰩈") pkill -KILL -u "$USER" ;;
    "") systemctl reboot ;;
    "") systemctl poweroff ;;
esac
