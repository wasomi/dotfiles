#!/bin/bash
                                       
# Credits: ai

default_step=5

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
    ready_icon="audio-volume-high-symbolic"
    muted_icon="audio-volume-muted-symbolic"
else
    target="@DEFAULT_AUDIO_SOURCE@"
    label="Microphone"
    icon_prefix="microphone-sensitivity"
    ready_icon="mic-volume-high-symbolic"
    muted_icon="mic-volume-muted-symbolic"
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
        echo "$muted_icon"
    elif [[ $vol -le 30 ]]; then
        echo "${icon_prefix}-low-symbolic"
    elif [[ $vol -le 70 ]]; then
        echo "${icon_prefix}-medium-symbolic"
    else
        echo "${icon_prefix}-high-symbolic"
    fi
}

change_volume() {
    case "$action" in
        --set) wpctl set-volume -l 1.0 "$target" "${percent}%" ;;
        --inc) wpctl set-volume -l 1.0 "$target" "${percent}%+" ;;
        --dec) wpctl set-volume -l 1.0 "$target" "${percent}%-" ;;
        *) echo "Invalid action: $action"; exit 1 ;;
    esac

    local new_vol=$(get_volume)
    local icon=$(choose_icon "$new_vol")

    notify-send -i "$icon" "$label" "Level: ${new_vol}%" -h "int:value:$new_vol" -r 8 -t 1000
}

toggle_mute() {
    if [[ "$(get_mute_status)" == "yes" ]]; then
        wpctl set-mute "$target" 0
        notify-send -i "$ready_icon" "$label" "Unmuted" -r 8 -t 1000
    else
        wpctl set-mute "$target" 1
        notify-send -i "$muted_icon" "$label" "Muted" -r 8 -t 1000
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
