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

WALL_DIR="$HOME/Pictures/Wallpapers"
CWD="$(pwd)"

cd "$WALL_DIR" || exit

SELECTED_WALL=$(for a in *.jpg *.png; do echo -en "$a\0icon\x1f$a\n" ; done | rofi -dmenu -show-icons -config ~/.dotfiles/.config/rofi/styles/wallpaperChanger.rasi)
THEME="adw-gtk3-dark"
ICONS="Papirus-Dark"
FONT="CodeNewRoman Nerd Font Mono 12"
CURSOR="Bibata-Modern-Classic"

if [ -n "$SELECTED_WALL" ]; then

    matugen image "$SELECTED_WALL" -m "dark"

    gsettings set org.gnome.desktop.interface gtk-theme ""
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

    notify-send -i checkmark "Theme applied" "Wallpaper and theme updated successfully!" -r 8 -t 1000
fi

cd "$CWD" || exit
