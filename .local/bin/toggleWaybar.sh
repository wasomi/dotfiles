#!/bin/bash

if pgrep -x "waybar" > /dev/null; then
    pkill waybar
else
    waybar > /dev/null 2>&1 &
fi
