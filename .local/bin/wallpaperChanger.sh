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

# directory containing wallpapers
WALL_DIR="$HOME/Pictures/Wallpapers"

# current directory (to cd back to)
CWD="$(pwd)"

cd "$WALL_DIR" || exit

# handle spaces in filenames
IFS=$'\n'

# grab the user-selected wallpaper
SELECTED_WALL=$(for a in *.jpg *.png; do echo -en "$a\0icon\x1f$a\n" ; done | rofi -dmenu -show-icons -p "Select Wallpaper" -config ~/.dotfiles/.config/rofi/styles/wallpaperChanger.rasi)

# if not empty, pass to backend
if [ -n "$SELECTED_WALL" ]; then

    # send notification
    notify-send -i emblem-synchronizing "Changing Theme" "Applying new wallpaper and updating colors, please wait until confirmation..."

    # use Matugen to generate Material You colors
    matugen image "$SELECTED_WALL"

    # refresh dunst
    pkill dunst
    dunst > /dev/null 2>&1 &

    # refresh waybar
    pkill waybar
    waybar > /dev/null 2>&1 &

    # refresh kitty
    # kitty @ set-colors --all ~/.dotfiles/.config/kitty/colors.conf

    notify-send -i checkmark "Theme Applied" "Wallpaper and theme updated successfully!"
fi

# go back to where you came from
cd "$CWD" || exit