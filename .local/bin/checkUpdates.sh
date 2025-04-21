#!/bin/sh

total=$(checkupdates-with-aur | wc -l)
[ "$total" -gt 0 ] && echo "$total" || exit 1