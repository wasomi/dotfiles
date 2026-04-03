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
    exit 1
fi
 
selected_wall=$(find -L "$wall_dir" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.png" \) | shuf -n 1)
 
if [ -z "$selected_wall" ]; then
    echo "Error: No wallpapers found in $wall_dir" >&2
    exit 1
fi
 
echo "Selected wallpaper: $(basename "$selected_wall")"

matugen image "$selected_wall" -m "$mode" --source-color-index 0 || { echo "Matugen failed..." >&2; exit 1; }

gsettings set org.gnome.desktop.interface gtk-theme "Adwaita"
sleep 1
gsettings set org.gnome.desktop.interface gtk-theme "$theme"
gsettings set org.gnome.desktop.interface color-scheme prefer-$mode
gsettings set org.gnome.desktop.interface icon-theme "$icons"
gsettings set org.gnome.desktop.interface font-name "$font"
gsettings set org.gnome.desktop.interface cursor-theme "$cursor"

pkill dunst;  dunst & disown
pkill waybar; waybar & disown
pkill polkit-gnome-authentication-agent-1
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 & disown

pgrep kitty > /dev/null && pkill -SIGUSR1 kitty
hyprctl reload

notify-send -i "$icon_dir/package-install.svg" "Theme applied" \
    "Wallpaper and theme updated successfully!" -r 8 -t 1500
