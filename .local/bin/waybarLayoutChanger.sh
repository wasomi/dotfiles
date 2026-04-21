#!/bin/bash

# Credits: ai

waybar_dir="$HOME/.dotfiles/.config/waybar"
templates_dir="$waybar_dir/templates"
styles_dir="$waybar_dir/styles"
target_css="$waybar_dir/style.css"
target_config="$waybar_dir/config.jsonc"
rofi_config="$HOME/.dotfiles/.config/rofi/styles/waybarLayoutChanger.rasi"
state_file="$waybar_dir/current_template"

options="Default\nMinimal\nFloating\nIsland\nMinimal Island"

selected=$(echo -e "$options" | rofi -dmenu -config "$rofi_config")

if [ -z "$selected" ]; then
    exit 0
fi

case "$selected" in
    "Default")
        style_file="default.css"
        config_template="default.jsonc"
        ;;
    "Minimal")
        style_file="minimal.css"
        config_template="minimal.jsonc"
        ;;
    "Floating")
        style_file="floating.css"
        config_template="default.jsonc"
        ;;
    "Island")
        style_file="island.css"
        config_template="island.jsonc"
        ;;
    "Minimal Island")
        style_file="island.css"
        config_template="minimal island.jsonc"
        ;;
    *)
        notify-send -u critical "Error" "Unknown layout..." -r 8
        exit 1
        ;;
esac

echo "$config_template" > "$state_file"

ln -sf "$styles_dir/$style_file" "$target_css"

envsubst < "$templates_dir/$config_template" > "$target_config" 
envsubst < "$HOME/.dotfiles/.config/waybar/templates/modules/hyprland-workspaces.jsonc" > "$HOME/.dotfiles/.config/waybar/modules/hyprland-workspaces.jsonc"
envsubst < "$HOME/.dotfiles/.config/waybar/templates/modules/hyprland-language.jsonc" > "$HOME/.dotfiles/.config/waybar/modules/hyprland-language.jsonc"

notify-send -i "dialog-information-symbolic" "Waybar updated" "Layout: $selected" -r 8 -t 2000

if pgrep -x "waybar" > /dev/null; then
    pkill -SIGUSR2 waybar
else
    waybar & disown
fi
