#!/bin/bash

#                                                        _____ __   
#     ____  ____ _      _____  _____   ____  _________  / __(_) /__ 
#    / __ \/ __ \ | /| / / _ \/ ___/  / __ \/ ___/ __ \/ /_/ / / _ \
#   / /_/ / /_/ / |/ |/ /  __/ /     / /_/ / /  / /_/ / __/ / /  __/
#  / .___/\____/|__/|__/\___/_/     / .___/_/   \____/_/ /_/_/\___/ 
# /_/____/ /_  ____ _____  ____ ___/_/_____                         
#  / ___/ __ \/ __ `/ __ \/ __ `/ _ \/ ___/                         
# / /__/ / / / /_/ / / / / /_/ /  __/ /                             
# \___/_/ /_/\__,_/_/ /_/\__, /\___/_/                              
#                       /____/                                      
# 
# credits: ai bot
# edited by: wasomi

CURRENT_PROFILE=$(powerprofilesctl get)

choice=$(printf "Performance\nBalanced\nPower Saver" | rofi -dmenu -p "[$CURRENT_PROFILE] Select Power Profile")

if [ -n "$choice" ]; then
  case "$choice" in
    Performance)
      powerprofilesctl set performance
      notify-send -i emblem-information "Power Profile" "Performance mode activated" ;;
    Balanced)
      powerprofilesctl set balanced
      notify-send -i emblem-information "Power Profile" "Balanced mode activated" ;;
    "Power Saver")
      powerprofilesctl set power-saver
      notify-send -i emblem-information "Power Profile" "Power Saver mode activated" ;;
  esac
fi