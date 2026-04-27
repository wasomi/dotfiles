#!/bin/bash

# Credits: ai

path="/sys/class/power_supply/BAT0/charge_control_end_threshold"
askpass="$HOME/.dotfiles/.local/bin/askPassword.sh"
choice=$(printf "󰁿\n󰂁\n󰁹" | rofi -dmenu -config ~/.dotfiles/.config/rofi/styles/powerMenu.rasi)

case "$choice" in
    "󰁿") threshold=60 ;;
    "󰂁") threshold=80 ;;
    "󰁹") threshold=100 ;;
    *) exit 0
esac

if SUDO_ASKPASS="$askpass" sudo -A bash -c "echo $threshold > $path"; then
    notify-send -i "dialog-information-symbolic" "Battery Management" "Charging threshold set to $threshold%" -r 10 -t 2000
else
    notify-send -i -u critical "dialog-error-symbolic" "Battery Management" "Failed to update charging threshold" -r 10
fi
