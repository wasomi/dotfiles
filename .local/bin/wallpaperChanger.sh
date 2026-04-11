#!/bin/bash

# Credits: https://www.youtube.com/@sane1090x

wall_dir="$HOME/Pictures/Wallpapers"
rofi_config="$HOME/.dotfiles/.config/rofi/styles/wallpaperChanger.rasi"
mode="dark"
theme="adw-gtk3-$mode"
icons="Papirus"
font="CodeNewRoman Nerd font Mono 12"
cursor="Bibata-Modern-Classic"

if [ ! -d "$wall_dir" ]; then
    echo "Error: Wallpaper directory not found: $wall_dir" >&2
    notify-send -i -u critical "dialog-error-symbolic" "Error" "Wallpaper directory not found..." -r 8
    exit 1
fi

cd "$wall_dir" || exit 1

selected_wall=$(for img in *.jpg *.png; do
    [ -f "$img" ] && echo -en "$img\0icon\x1f$img\n"
done | rofi -dmenu -show-icons -config "$rofi_config")

cd - > /dev/null || exit 1

if [ -n "$selected_wall" ]; then
    wall_path="$wall_dir/$selected_wall"

    matugen image "$wall_path" -m "$mode" --source-color-index 0 || { echo "Matugen failed..." >&2; exit 1; }

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

    notify-send -i "dialog-information-symbolic" "Theme applied" "Wallpaper and theme updated successfully!" -r 8 -t 1500

else
    echo "No wallpaper selected..." >&2
fi
