#!/bin/sh

aur=$(checkupdates-with-aur | wc -l)
pacman=$(checkupdates | wc -l)
total=$(($aur+$pacman))
[ "$total" -gt 0 ] && echo "$total" || exit 1