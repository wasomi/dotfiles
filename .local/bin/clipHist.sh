#!/bin/bash

#          ___       __  ___      __               __  
#    _____/ (_)___  / / / (_)____/ /_        _____/ /_ 
#   / ___/ / / __ \/ /_/ / / ___/ __/       / ___/ __ \
#  / /__/ / / /_/ / __  / (__  ) /_   _    (__  ) / / /
#  \___/_/_/ .___/_/ /_/_/____/\__/  (_)  /____/_/ /_/ 
#         /_/   
#
# Credits: https://github.com/sentriz
# Edited by: wasomi

for cmd in cliphist wl-copy; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "Error: '$cmd' not found..." >&2
        exit 1
    fi
done

if [ -z "$1" ]; then
    cliphist list
else
    cliphist decode <<<"$1" | wl-copy
fi
