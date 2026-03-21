#!/bin/bash
 
wall_dir="$HOME/Pictures/Wallpapers"
mode="dark"
theme="adw-gtk3-$mode"
icons="Papirus"
font="CodeNewRoman Nerd font Mono 12"
cursor="Bibata-Modern-Classic"
icon_dir="/usr/share/icons/Papirus/16x16/status"
 
for cmd in matugen dunst waybar kitty; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "Error: '$cmd' not found..." >&2
        exit 1
    fi
done
 
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
 
matugen image "$selected_wall" -m "$mode" --source-color-index 0
 
gsettings set org.gnome.desktop.interface gtk-theme "Adwaita"
sleep 1
gsettings set org.gnome.desktop.interface gtk-theme "$theme"
gsettings set org.gnome.desktop.interface color-scheme prefer-$mode
gsettings set org.gnome.desktop.interface icon-theme "$icons"
gsettings set org.gnome.desktop.interface font-name "$font"
gsettings set org.gnome.desktop.interface cursor-theme "$cursor"
 
killall dunst && dunst & disown
killall waybar && waybar & disown
killall polkit-gnome-authentication-agent-1 && /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 & disown
pkill -SIGUSR1 kitty
 
notify-send -i "$icon_dir/package-install.svg" "Theme applied" \
    "Wallpaper: $(basename "$selected_wall")" -r 8 -t 1500
