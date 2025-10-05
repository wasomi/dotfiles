#!/bin/sh

#          __              __   __  __          __      __                         __  
#    _____/ /_  ___  _____/ /__/ / / /___  ____/ /___ _/ /____  _____        _____/ /_ 
#   / ___/ __ \/ _ \/ ___/ //_/ / / / __ \/ __  / __ `/ __/ _ \/ ___/       / ___/ __ \
#  / /__/ / / /  __/ /__/ ,< / /_/ / /_/ / /_/ / /_/ / /_/  __(__  )  _    (__  ) / / /
#  \___/_/ /_/\___/\___/_/|_|\____/ .___/\__,_/\__,_/\__/\___/____/  (_)  /____/_/ /_/ 
#                                /_/                                                   
#
# Credits: ai
# Edited by: wasomi

for cmd in paru checkupdates; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "Error: '$cmd' not found..." >&2
        exit 1
    fi
done

total=$(( $(checkupdates | wc -l) + $(paru -Qua | wc -l) ))

if [ "$total" -gt 0 ]; then
    echo "$total"
else
    exit 1
fi
