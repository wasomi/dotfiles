#!/bin/bash
                                                                
#                                                                               __  
#     ____  ____ _      _____  _____   ____ ___  ___  ____  __  __        _____/ /_ 
#    / __ \/ __ \ | /| / / _ \/ ___/  / __ `__ \/ _ \/ __ \/ / / /       / ___/ __ \
#   / /_/ / /_/ / |/ |/ /  __/ /     / / / / / /  __/ / / / /_/ /  _    (__  ) / / /
#  / .___/\____/|__/|__/\___/_/     /_/ /_/ /_/\___/_/ /_/\__,_/  (_)  /____/_/ /_/ 
# /_/                                                                                                                                
# 
# credits: https://github.com/Zproger

choice=$(printf "Lock\nSuspend\nReboot\nShutdown" | rofi -dmenu -p "Power Menu" -config ~/.dotfiles/.config/rofi/styles/powerMenu.rasi)

case "$choice" in
  Lock) hyprlock ;;
  # Logout) pkill -KILL -u "$USER" ;;
  Suspend) systemctl suspend;;
  Reboot) systemctl reboot ;;
  Shutdown) systemctl poweroff ;;
esac