#!/bin/sh

#          __              __   __  __          __      __                         __  
#    _____/ /_  ___  _____/ /__/ / / /___  ____/ /___ _/ /____  _____        _____/ /_ 
#   / ___/ __ \/ _ \/ ___/ //_/ / / / __ \/ __  / __ `/ __/ _ \/ ___/       / ___/ __ \
#  / /__/ / / /  __/ /__/ ,< / /_/ / /_/ / /_/ / /_/ / /_/  __(__  )  _    (__  ) / / /
#  \___/_/ /_/\___/\___/_/|_|\____/ .___/\__,_/\__,_/\__/\___/____/  (_)  /____/_/ /_/ 
#                                /_/                                                   
#
# credits: ai
# edited by: wasomi

for cmd in checkupdates-with-aur; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "Error: '$cmd' not found..." >&2
        exit 1
    fi
done


total=$(checkupdates-with-aur | wc -l)
[ "$total" -gt 0 ] && echo "$total" || exit 1
