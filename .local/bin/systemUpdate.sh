#!/bin/sh

#                     __                                    __      __                    __  
#    _______  _______/ /____  ____ ___     __  ______  ____/ /___ _/ /____          _____/ /_ 
#   / ___/ / / / ___/ __/ _ \/ __ `__ \   / / / / __ \/ __  / __ `/ __/ _ \        / ___/ __ \
#  (__  ) /_/ (__  ) /_/  __/ / / / / /  / /_/ / /_/ / /_/ / /_/ / /_/  __/  _    (__  ) / / /
# /____/\__, /____/\__/\___/_/ /_/ /_/   \__,_/ .___/\__,_/\__,_/\__/\___/  (_)  /____/_/ /_/ 
#      /____/                                /_/                                              

RED="\e[1;31m"
YELLOW="\e[1;34m"
ENDCOLOR="\e[0m"

echo -e "${YELLOW}::${ENDCOLOR} System update started"
echo

if paru -Syu; then
    echo -e "\n${YELLOW}::${ENDCOLOR} System update completed successfully"
else
    echo -e "\n${RED}::${ENDCOLOR} System update failed"
fi

echo -e "${YELLOW}::${ENDCOLOR} Press enter to exit..."
read

pkill -SIGRTMIN+8 waybar 2>/dev/null