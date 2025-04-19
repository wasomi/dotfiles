#!/bin/bash

#                  ____                           
#  _      ______ _/ / /___  ____ _____  ___  _____
# | | /| / / __ `/ / / __ \/ __ `/ __ \/ _ \/ ___/
# | |/ |/ / /_/ / / / /_/ / /_/ / /_/ /  __/ /    
# |__/|__/\__,_/_/_/ .___/\__,_/ .___/\___/_/     
#   _____/ /_  ___/_/____  ___/_/___  _____       
#  / ___/ __ \/ __ `/ __ \/ __ `/ _ \/ ___/       
# / /__/ / / / /_/ / / / / /_/ /  __/ /           
# \___/_/ /_/\__,_/_/ /_/\__, /\___/_/            
#                       /____/                    
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
    notify-send "Changing Theme" "Applying new wallpaper and updating colors, please wait until confirmation..."

    # use Matugen to generate Material You colors
    matugen image "$SELECTED_WALL"

    # refresh swaync
    pkill swaync
    swaync -c "~/.dotfiles/.config/swaync/config.jsonc" -s "~/.dotfiles/.config/swaync/style.css" > /dev/null 2>&1 &

    # refresh waybar
    pkill waybar
    waybar > /dev/null 2>&1 &

    # refresh kitty
    # kitty @ set-colors --all ~/.dotfiles/.config/kitty/colors.conf

    notify-send "Theme Applied" "Wallpaper and theme updated successfully!"
fi

# go back to where you came from
cd "$CWD" || exit