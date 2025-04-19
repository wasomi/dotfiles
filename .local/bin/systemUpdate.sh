#!/bin/sh

clear

echo ":: System update started"
echo

paru -Syu

echo
echo ":: System update complete"
echo ":: Press enter to exit"
read

pkill -SIGRTMIN+8 waybar 2>/dev/null