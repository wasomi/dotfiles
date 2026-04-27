#!/bin/bash

# Credits: ai

red=$(tput setaf 1; tput bold)
yellow=$(tput setaf 3; tput bold)
green=$(tput setaf 2; tput bold)
reset=$(tput sgr0)

echo -e "${yellow}::${reset} Starting system update..."
echo

if paru -Syu --noconfirm; then
    echo -e "\n${green}::${reset} System update completed successfully!"
    notify-send -i "dialog-information-symbolic" "System Update" "Packages updated successfully!" -h string:x-canonical-private-synchronous:system_update -t 2000

    echo
    echo -en "${yellow}::${reset} Do you want to reboot now? (y/N): "
    read -r response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        echo -e "${red}::${reset} Rebooting system..."
        sleep 1
        systemctl reboot
    fi
else
    echo -e "\n${red}::${reset} System update failed..."
    notify-send -i "dialog-error-symbolic" -u critical "System Update" "An error occurred during update..." -h string:x-canonical-private-synchronous:system_update
fi

if pgrep -x waybar >/dev/null; then
    pkill -SIGRTMIN+8 waybar
fi

echo -e "${yellow}::${reset} Press Enter to exit..."
read
