#!/bin/sh

# Credits: ai

official=$(checkupdates 2>/dev/null | wc -l)
aur=$(paru -Qua 2>/dev/null | wc -l)
total=$(( $official + $aur ))

if [ "$total" -gt 0 ]; then
    printf '{"text": "%d", "tooltip": "Official: %d\\nAUR: %d"}\n' "$total" "$official" "$aur"
else
    exit 1
fi
