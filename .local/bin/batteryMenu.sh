#!/bin/bash

# Credits: ai

icon_dir="/usr/share/icons/Papirus/16x16/status"
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
    notify-send -i "$icon_dir/package-install.svg" "Battery Management" "Charging threshold set to $threshold%" -r 8 -t 1000
else
    notify-send -i "$icon_dir/package-purge.svg" "Battery Management" "Failed to update charging threshold" -r 8 -t 1000
fi
