#!/bin/bash

#          ___       __  ___      __               __  
#    _____/ (_)___  / / / (_)____/ /_        _____/ /_ 
#   / ___/ / / __ \/ /_/ / / ___/ __/       / ___/ __ \
#  / /__/ / / /_/ / __  / (__  ) /_   _    (__  ) / / /
#  \___/_/_/ .___/_/ /_/_/____/\__/  (_)  /____/_/ /_/ 
#         /_/   
#
# Credits: idk
# Edited by: wasomi


for cmd in cliphist; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "Error: '$cmd' not found..." >&2
        exit 1
    fi
done


tmp_dir="/tmp/cliphist"
rm -rf "$tmp_dir"

if [[ -n "$1" ]]; then
    cliphist decode <<<"$1" | wl-copy
    exit
fi

mkdir -p "$tmp_dir"

read -r -d '' prog <<EOF
/^[0-9]+\s<meta http-equiv=/ { next }
match(\$0, /^([0-9]+)\s(\[\[\s)?binary.*(jpg|jpeg|png|bmp)/, grp) {
    system("echo " grp[1] "\\\\\t | cliphist decode >$tmp_dir/"grp[1]"."grp[3])
    print \$0"\0icon\x1f$tmp_dir/"grp[1]"."grp[3]
    next
}
1
EOF
cliphist list | gawk "$prog"
