#!/bin/bash
 
wall_dir="$HOME/Pictures/Wallpapers"
mode="dark"
theme="adw-gtk3-$mode"
icons="Papirus"
font="CodeNewRoman Nerd font Mono 12"
cursor="Bibata-Modern-Classic"
icon_dir="/usr/share/icons/Papirus/16x16/status"
 
if [ ! -d "$wall_dir" ]; then
    echo "Error: Wallpaper directory not found: $wall_dir" >&2
    notify-send -i -u critical "dialog-error-symbolic" "Error" "Wallpaper directory not found..." -r 8
    exit 1
fi
 
selected_wall=$(find -L "$wall_dir" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.png" \) | shuf -n 1)
 
if [ -z "$selected_wall" ]; then
    echo "Error: No wallpapers found in $wall_dir" >&2
    notify-send -i -u critical "dialog-error-symbolic" "Error" "No wallpapers found..." -r 8
    exit 1
fi
 
echo "Selected wallpaper: $(basename "$selected_wall")"

matugen image "$wall_path" -m "$settingsMode" --source-color-index 0 || { echo "Matugen failed..." && notify-send -i "dialog-error-symbolic" "Error" "Matugen failed..." -r 8 >&2; exit 1; }

gsettings set org.gnome.desktop.interface gtk-theme "$settingsTheme"
gsettings set org.gnome.desktop.interface color-scheme prefer-$settingsMode
gsettings set org.gnome.desktop.interface icon-theme "$settingsIcons"
gsettings set org.gnome.desktop.interface font-name "$settingsFont"
gsettings set org.gnome.desktop.interface cursor-theme "$settingsCursor"

envsubst < "$HOME/.dotfiles/.config/waybar/templates/config.jsonc" > "$HOME/.dotfiles/.config/waybar/config.jsonc"
envsubst < "$HOME/.dotfiles/.config/waybar/templates/hyprland-workspaces.jsonc" > "$HOME/.dotfiles/.config/waybar/modules/hyprland-workspaces.jsonc"
envsubst < "$HOME/.dotfiles/.config/waybar/templates/hyprland-language.jsonc" > "$HOME/.dotfiles/.config/waybar/modules/hyprland-language.jsonc"

pkill dunst;  dunst & disown
pkill waybar; waybar & disown
pkill -f polkit-gnome-authentication-agent-1
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 & disown

pgrep kitty > /dev/null && pkill -SIGUSR1 kitty
hyprctl reload

notify-send -i "dialog-information-symbolic" "Random theme applied" "Wallpaper and theme updated successfully!" -r 8 -t 1500
