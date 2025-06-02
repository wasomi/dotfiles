#!/bin/bash

#                  ____                                    __                                             __  
#  _      ______ _/ / /___  ____ _____  ___  _____   _____/ /_  ____ _____  ____ ____  _____        _____/ /_ 
# | | /| / / __ `/ / / __ \/ __ `/ __ \/ _ \/ ___/  / ___/ __ \/ __ `/ __ \/ __ `/ _ \/ ___/       / ___/ __ \
# | |/ |/ / /_/ / / / /_/ / /_/ / /_/ /  __/ /     / /__/ / / / /_/ / / / / /_/ /  __/ /     _    (__  ) / / /
# |__/|__/\__,_/_/_/ .___/\__,_/ .___/\___/_/      \___/_/ /_/\__,_/_/ /_/\__, /\___/_/     (_)  /____/_/ /_/ 
#                 /_/         /_/                                        /____/                               
# 
# credits: https://www.youtube.com/@sane1090x
# edited by: wasomi

WALL_DIR="$HOME/Pictures/Wallpapers"
CWD="$(pwd)"

cd "$WALL_DIR" || exit

IFS=$'\n'
SELECTED_WALL=$(for a in *.jpg *.png; do echo -en "$a\0icon\x1f$a\n" ; done | rofi -dmenu -show-icons -p "select wallpaper" -config ~/.dotfiles/.config/rofi/styles/wallpaperChanger.rasi)
THEME="adw-gtk3-dark"
ICONS="Papirus-Dark"
FONT="CodeNewRoman Nerd Font Mono 12"
CURSOR="Bibata-Modern-Classic"

if [ -n "$SELECTED_WALL" ]; then

    notify-send -i emblem-synchronizing "changing theme" "applying new wallpaper and updating colors, please wait until confirmation..."

    sleep 1

    matugen image "$SELECTED_WALL"

    gsettings set org.gnome.desktop.interface gtk-theme "$THEME"
    gsettings set org.gnome.desktop.interface icon-theme "$ICONS"
    gsettings set org.gnome.desktop.interface font-name "$FONT"
    gsettings set org.gnome.desktop.interface cursor-theme "$CURSOR"

    pkill dunst
    dunst > /dev/null 2>&1 &

    pkill waybar
    waybar > /dev/null 2>&1 &

    pkill -SIGUSR1 kitty

    pkill polkit-gnome-au
    /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 > /dev/null 2>&1 &

    notify-send -i checkmark "theme applied" "wallpaper and theme updated successfully!"
fi

cd "$CWD" || exit
