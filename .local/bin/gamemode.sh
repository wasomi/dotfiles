#!/bin/bash

#                                                    __   
#    ____ _____ _____ ___  ___  ____ ___  ____  ____/ /__ 
#   / __ `/ __ `/ __ `__ \/ _ \/ __ `__ \/ __ \/ __  / _ \
#  / /_/ / /_/ / / / / / /  __/ / / / / / /_/ / /_/ /  __/
#  \__, /\__,_/_/ /_/ /_/\___/_/ /_/ /_/\____/\__,_/\___/ 
# /____/                                                  
# 
# --------------------------------------------------------

HYPRGAMEMODE=$(hyprctl getoption animations:enabled | awk 'NR==1{print $2}')
if [ "$HYPRGAMEMODE" = 1 ] ; then
    hyprctl --batch "\
        keyword animations:enabled 0;\
        keyword decoration:shadow:enabled 0;\
        keyword decoration:blur:enabled 0;\
        keyword general:gaps_in 0;\
        keyword general:gaps_out 0;\
        keyword general:border_size 1;\
        keyword decoration:rounding 0"
    exit
fi
hyprctl reload