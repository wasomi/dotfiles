#!/bin/bash

if pgrep -x "waybar" > /dev/null; then
    pkill waybar
    waybar > /dev/null 2>&1 &
else
    waybar > /dev/null 2>&1 &
fi
