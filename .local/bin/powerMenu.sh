#!/bin/bash
                                                                
#                                     __  ___                              __  
#      ____  ____ _      _____  _____/  |/  /__  ____  __  __        _____/ /_ 
#     / __ \/ __ \ | /| / / _ \/ ___/ /|_/ / _ \/ __ \/ / / /       / ___/ __ \
#    / /_/ / /_/ / |/ |/ /  __/ /  / /  / /  __/ / / / /_/ /  _    (__  ) / / /
#   / .___/\____/|__/|__/\___/_/  /_/  /_/\___/_/ /_/\__,_/  (_)  /____/_/ /_/ 
#  /_/                                                                                                                                                                                      
# 
# credits: https://github.com/Zproger
# edited by: wasomi

uptime="`uptime -p | sed -e 's/up //g'`"
choice=$(printf "\n󰤄\n󰩈\n\n" | rofi -dmenu -mesg "Uptime: $uptime" -config ~/.dotfiles/.config/rofi/styles/powerMenu.rasi)

case "$choice" in
    "") loginctl lock-session ;;
    "󰤄") systemctl suspend;;
    "󰩈") pkill -KILL -u "$USER" ;;
    "") systemctl reboot ;;
    "") systemctl poweroff ;;
esac
