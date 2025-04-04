#!/bin/env bash

choice=$(printf "Lock\nLogout\nSuspend\nReboot\nShutdown" | rofi -dmenu)
case "$choice" in
  Lock) hyprlock ;;
  Logout) pkill -KILL -u "$USER" ;;
  Suspend) systemctl suspend && hyprlock ;;
  Reboot) systemctl reboot ;;
  Shutdown) systemctl poweroff ;;
esac