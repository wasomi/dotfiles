#!/bin/bash
                                                                
#                                                                               __  
#     ____  ____ _      _____  _____   ____ ___  ___  ____  __  __        _____/ /_ 
#    / __ \/ __ \ | /| / / _ \/ ___/  / __ `__ \/ _ \/ __ \/ / / /       / ___/ __ \
#   / /_/ / /_/ / |/ |/ /  __/ /     / / / / / /  __/ / / / /_/ /  _    (__  ) / / /
#  / .___/\____/|__/|__/\___/_/     /_/ /_/ /_/\___/_/ /_/\__,_/  (_)  /____/_/ /_/ 
# /_/                                                                                                                                
# 
# credits: https://github.com/Zproger
# edited by: wasomi

uptime="`uptime -p | sed -e 's/up //g'`"
choice=$(printf "\n󰤄\n󰩈\n\n" | rofi -dmenu -mesg "Uptime: $uptime" -config ~/.dotfiles/.config/rofi/styles/powerMenu.rasi)

case "$choice" in
    "") hyprlock ;;
    "󰤄") systemctl suspend;;
    "󰩈") pkill -KILL -u "$USER" ;;
    "") systemctl reboot ;;
    "") systemctl poweroff ;;
esac
