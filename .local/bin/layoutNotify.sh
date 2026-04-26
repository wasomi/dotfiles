#!/bin/bash

socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do
    if [[ "$line" == activelayout* ]]; then
        
        content="${line#*>>}"
        
        kbd_name="${content%,*}"
        layout="${content#*,}"

        if [ "$kbd_name" == "$settingsKeyboardName" ]; then
            notify-send -t 1000 \
                        -r 8 \
                        -i "input-keyboard-symbolic" \
                        "Layout Changed" \
                        "$layout"
        fi
    fi
done
