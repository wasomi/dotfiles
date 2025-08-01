#!/bin/bash

#                __                     ______            __             __             __  
#   _   ______  / /_  ______ ___  ___  / ____/___  ____  / /__________  / /       _____/ /_ 
#  | | / / __ \/ / / / / __ `__ \/ _ \/ /   / __ \/ __ \/ __/ ___/ __ \/ /       / ___/ __ \
#  | |/ / /_/ / / /_/ / / / / / /  __/ /___/ /_/ / / / / /_/ /  / /_/ / /  _    (__  ) / / /
#  |___/\____/_/\__,_/_/ /_/ /_/\___/\____/\____/_/ /_/\__/_/   \____/_/  (_)  /____/_/ /_/ 
#                                                                                                                                                                                    

icon_dir="/usr/share/icons/Papirus/16x16/panel"
default_step=5

for cmd in wpctl; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "Error: '$cmd' is required but not installed."
        exit 1
    fi
done

if [[ $# -lt 2 ]]; then
    echo "Usage: $0 [--sound|--mic] [--set|--inc|--dec|--mute] [percent]"
    exit 1
fi

device="$1"
action="$2"
percent="${3//%/}"
percent="${percent:-$default_step}"

if [[ "$device" == "--sound" ]]; then
    target="@DEFAULT_AUDIO_SINK@"
    label="Volume"
    icon_prefix="audio-volume"
    ready_icon="audio-ready.svg"
    muted_icon="audio-volume-muted.svg"
else
    target="@DEFAULT_AUDIO_SOURCE@"
    label="Microphone"
    icon_prefix="microphone-sensitivity"
    ready_icon="mic-ready.svg"
    muted_icon="mic-volume-muted.svg"
fi

get_volume() {
    wpctl get-volume "$target" | awk '{printf "%.0f", $2 * 100}'
}

get_mute_status() {
    wpctl get-volume "$target" | grep -q MUTED && echo "yes" || echo "no"
}

choose_icon() {
    local vol=$1
    if [[ "$(get_mute_status)" == "yes" || "$vol" -eq 0 ]]; then
        echo "$icon_dir/$muted_icon"
    elif [[ $vol -le 30 ]]; then
        echo "$icon_dir/${icon_prefix}-low.svg"
    elif [[ $vol -le 70 ]]; then
        echo "$icon_dir/${icon_prefix}-medium.svg"
    else
        echo "$icon_dir/${icon_prefix}-high.svg"
    fi
}

change_volume() {
    case "$action" in
        --set) wpctl set-volume "$target" "${percent}%" ;;
        --inc) wpctl set-volume "$target" "${percent}%+" ;;
        --dec) wpctl set-volume "$target" "${percent}%-" ;;
        *) echo "Invalid action: $action"; exit 1 ;;
    esac

    local new_vol=$(get_volume)
    local icon=$(choose_icon "$new_vol")

    notify-send -i "$icon" "$label" "Level: ${new_vol}%" -h "int:value:$new_vol" -r 8 -t 800
}

toggle_mute() {
    if [[ "$(get_mute_status)" == "yes" ]]; then
        wpctl set-mute "$target" 0
        notify-send -i "$icon_dir/$ready_icon" "$label" "Unmuted" -r 8 -t 800
    else
        wpctl set-mute "$target" 1
        notify-send -i "$icon_dir/$muted_icon" "$label" "Muted" -r 8 -t 800
    fi
}

case "$action" in
    --set|--inc|--dec)
        if [[ -z "$percent" || "$percent" =~ [^0-9] ]]; then
            echo "Error: percentage must be a number"
            exit 1
        fi
        change_volume
        ;;
    --mute)
        toggle_mute
        ;;
    *)
        echo "Invalid action: $action"
        echo "Valid actions: --set, --inc, --dec, --mute"
        exit 1
        ;;
esac
