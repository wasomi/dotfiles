#!/bin/bash

#                   ____                            ________                                             __  
#   _      ______ _/ / /___  ____ _____  ___  _____/ ____/ /_  ____ _____  ____ ____  _____        _____/ /_ 
#  | | /| / / __ `/ / / __ \/ __ `/ __ \/ _ \/ ___/ /   / __ \/ __ `/ __ \/ __ `/ _ \/ ___/       / ___/ __ \
#  | |/ |/ / /_/ / / / /_/ / /_/ / /_/ /  __/ /  / /___/ / / / /_/ / / / / /_/ /  __/ /     _    (__  ) / / /
#  |__/|__/\__,_/_/_/ .___/\__,_/ .___/\___/_/   \____/_/ /_/\__,_/_/ /_/\__, /\___/_/     (_)  /____/_/ /_/ 
#                  /_/         /_/                                      /____/                               
#
# credits: https://www.youtube.com/@sane1090x
# edited by: wasomi

wall_dir="$HOME/Pictures/Wallpapers"
rofi_config="$HOME/.dotfiles/.config/rofi/styles/wallpaperChanger.rasi"
theme="adw-gtk3-dark"
icons="Papirus-Dark"
font="CodeNewRoman Nerd font Mono 12"
cursor="Bibata-Original-Classic"
icon_dir="/usr/share/icons/Papirus/16x16/status"

for cmd in rofi matugen dunst waybar kitty; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "Error: '$cmd' not found." >&2
        exit 1
    fi
done

if [ ! -d "$wall_dir" ]; then
    echo "Error: Wallpaper directory not found: $wall_dir" >&2
    exit 1
fi

cd "$wall_dir" || exit 1

selected_wall=$(for img in *.jpg *.png; do
    [ -f "$img" ] && echo -en "$img\0icon\x1f$img\n"
done | rofi -dmenu -show-icons -config "$rofi_config")

cd - > /dev/null || exit 1

if [ -n "$selected_wall" ]; then
    WALL_PATH="$wall_dir/$selected_wall"

    matugen image "$WALL_PATH" -m "dark"

    gsettings set org.gnome.desktop.interface gtk-theme ""
    gsettings set org.gnome.desktop.interface gtk-theme "$theme"
    gsettings set org.gnome.desktop.interface icon-theme "$icons"
    gsettings set org.gnome.desktop.interface font-name "$font"
    gsettings set org.gnome.desktop.interface cursor-theme "$cursor"

    killall dunst && dunst & disown
    killall waybar && waybar & disown
    pkill -SIGUSR1 kitty

    if pgrep -x polkit-gnome-au >/dev/null; then
        pkill polkit-gnome-au
    fi
    if [ -x /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 ]; then
        /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 & disown
    fi

    notify-send -i "$icon_dir/package-install.svg" "Theme applied" \
        "Wallpaper and theme updated successfully!" -r 8 -t 1000
else
    echo "No wallpaper selected..." >&2
fi
