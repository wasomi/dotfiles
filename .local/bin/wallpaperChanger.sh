#!/bin/bash

# Credits: https://www.youtube.com/@sane1090x & ai

wall_dir="$HOME/Pictures/Wallpapers"
wallpaper_rofi_config="$HOME/.dotfiles/.config/rofi/styles/wallpaperChanger.rasi"
scheme_rofi_config="$HOME/.dotfiles/.config/rofi/styles/schemeChanger.rasi"
random_opt="random"

if [ ! -d "$wall_dir" ]; then
    echo "Error: Wallpaper directory not found: $wall_dir" >&2
    notify-send -u critical -i "dialog-error-symbolic" "Error" "Wallpaper directory not found..." -r 8
    exit 1
fi

cd "$wall_dir" || exit 1

selected_wall=$( (echo -en "$random_opt\0icon\x1fview-refresh\n"; for img in *.jpg *.png; do
    [ -f "$img" ] && echo -en "$img\0icon\x1f$img\n"
done) | rofi -dmenu -show-icons -p "Wallpaper" -config "$wallpaper_rofi_config")

if [ -z "$selected_wall" ]; then
    echo "No wallpaper selected..." >&2
    notify-send -u critical -i "dialog-error-symbolic" "Error" "No wallpaper selected..." -r 8
    exit 0
fi

if [ "$selected_wall" = "$random_opt" ]; then
    selected_wall=$(ls *.jpg *.png 2>/dev/null | shuf -n 1)
fi

cd - > /dev/null || exit 1
wall_path="$wall_dir/$selected_wall"

schemes="Neutral\nTonal Spot\nContent\nMonochrome\nExpressive\nFidelity\nFruit Salad\nRainbow\nVibrant"
choice=$(echo -e "$schemes" | rofi -dmenu -p "Color Scheme" -config "$scheme_rofi_config")

case "$choice" in
    "Neutral")     selected_scheme="scheme-neutral"     ;;
    "Tonal Spot")  selected_scheme="scheme-tonal-spot"  ;;
    "Content")     selected_scheme="scheme-content"     ;;
    "Monochrome")  selected_scheme="scheme-monochrome"  ;;
    "Expressive")  selected_scheme="scheme-expressive"  ;;
    "Fidelity")    selected_scheme="scheme-fidelity"    ;;
    "Fruit Salad") selected_scheme="scheme-fruit-salad" ;;
    "Rainbow")     selected_scheme="scheme-rainbow"     ;;
    "Vibrant")     selected_scheme="scheme-vibrant"     ;;
    *)             selected_scheme="scheme-neutral"     ;;
esac

matugen image "$wall_path" -m "$settingsMode" -t "$selected_scheme" --source-color-index 0 || { echo "Matugen failed..." && notify-send -u critical -i "dialog-error-symbolic" "Error" "Matugen failed..." -r 8 >&2; exit 1; }

gsettings set org.gnome.desktop.wm.preferences theme "$settingsTheme"
gsettings set org.gnome.desktop.interface gtk-theme "$settingsTheme"
gsettings set org.gnome.desktop.interface color-scheme prefer-$settingsMode
gsettings set org.gnome.desktop.interface icon-theme "$settingsIcons"
gsettings set org.gnome.desktop.interface font-name "$settingsFont"
gsettings set org.gnome.desktop.interface cursor-theme "$settingsCursor"

envsubst < "$HOME/.dotfiles/.config/waybar/templates/config.jsonc" > "$HOME/.dotfiles/.config/waybar/config.jsonc"
envsubst < "$HOME/.dotfiles/.config/waybar/templates/hyprland-workspaces.jsonc" > "$HOME/.dotfiles/.config/waybar/modules/hyprland-workspaces.jsonc"
envsubst < "$HOME/.dotfiles/.config/waybar/templates/hyprland-language.jsonc" > "$HOME/.dotfiles/.config/waybar/modules/hyprland-language.jsonc"

hyprctl reload
pkill -SIGUSR1 kitty
pkill -SIGUSR2 waybar
dunstctl reload
pkill -f polkit-gnome-authentication-agent-1
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 & disown

notify-send -i "dialog-information-symbolic" "Theme applied" "Wallpaper and theme updated successfully!\nSelected scheme: $choice" -r 8 -t 2000
