#!/bin/bash

# Credits: ai

waybar_dir="$HOME/.dotfiles/.config/waybar"
styles_dir="$waybar_dir/styles"
target_css="$waybar_dir/style.css"
rofi_config="$HOME/.dotfiles/.config/rofi/styles/schemeChanger.rasi"

if [ ! -d "$styles_dir" ]; then
    echo "Error: Styles directory not found: $styles_dir" >&2
    notify-send -u critical -i "dialog-error-symbolic" "Error" "Styles directory not found..." -r 8
    exit 1
fi

styles=$(ls -1 "$styles_dir" | grep '\.css$')
selected=$(echo "$styles" | rofi -dmenu -p "Color Scheme" -config "$rofi_config")

if [ -z "$selected" ]; then
    exit 0
fi

ln -sf "$styles_dir/$selected" "$target_css"

if pgrep -x "waybar" > /dev/null; then
    killall -SIGUSR2 waybar
    notify-send -i "dialog-information-symbolic" "Waybar style applied" "$selected" -r 8 -t 2000
else
    waybar &
    notify-send -i "dialog-information-symbolic" "Waybar style applied" "$selected" -r 8 -t 2000
fi
