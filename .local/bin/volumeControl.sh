#!/bin/bash

if [ "$#" -lt 2 ]; then
    echo "Usage: $0 [--sound|--mic] [--set|--inc|--dec|--mute] [percent]"
    exit 1
fi

ICON_PATH="/usr/share/icons/Papirus/16x16/panel"

DEVICE=$1
ACTION=$2
PERCENT=$3
PERCENT=${PERCENT//%/}

get_mute_status() {
    if [ "$DEVICE" = "--sound" ]; then
        wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q "MUTED" && echo "yes" || echo "no"
    else
        wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | grep -q "MUTED" && echo "yes" || echo "no"
    fi
}

choose_volume_icon() {
    local vol=$1
    if [ "$(get_mute_status)" = "yes" ] || [ "$vol" -eq 0 ]; then
        if [ "$DEVICE" = "--sound" ]; then
            echo "$ICON_PATH/audio-volume-muted.svg"
        else
            echo "$ICON_PATH/microphone-sensitivity-muted.svg"
        fi
    elif [ "$vol" -le 30 ]; then
        if [ "$DEVICE" = "--sound" ]; then
            echo "$ICON_PATH/audio-volume-low.svg"
        else
            echo "$ICON_PATH/microphone-sensitivity-low.svg"
        fi
    elif [ "$vol" -le 70 ]; then
        if [ "$DEVICE" = "--sound" ]; then
            echo "$ICON_PATH/audio-volume-medium.svg"
        else
            echo "$ICON_PATH/microphone-sensitivity-medium.svg"
        fi
    else
        if [ "$DEVICE" = "--sound" ]; then
            echo "$ICON_PATH/audio-volume-high.svg"
        else
            echo "$ICON_PATH/microphone-sensitivity-high.svg"
        fi
    fi
}

change_volume() {
    local target
    local notification_text
    if [ "$DEVICE" = "--sound" ]; then
        target="@DEFAULT_AUDIO_SINK@"
        notification_text="Volume"
    else
        target="@DEFAULT_AUDIO_SOURCE@"
        notification_text="Microphone Volume"
    fi

    case "$ACTION" in
        --set)
            wpctl set-volume "$target" "${PERCENT}%"
        ;;
        --inc)
            wpctl set-volume "$target" "${PERCENT}%+"
        ;;
        --dec)
            wpctl set-volume "$target" "${PERCENT}%-"
        ;;
    esac

    local new_vol
    if [ "$DEVICE" = "--sound" ]; then
        new_vol=$(wpctl get-volume "$target" | awk '{print int($2 * 100)}')
    else
        new_vol=$(wpctl get-volume "$target" | awk '{print int($2 * 100)}')
    fi
    local icon=$(choose_volume_icon "$new_vol")

    notify-send -i "$icon" "$notification_text" "Level: ${new_vol}%" -h "int:value:${new_vol}" -r 8 -t 8000
}

toggle_mute() {
    local muted=$(get_mute_status)
    local target
    local notification_text
    local icon

    if [ "$DEVICE" = "--sound" ]; then
        target="@DEFAULT_AUDIO_SINK@"
        notification_text="Volume"
    else
        target="@DEFAULT_AUDIO_SOURCE@"
        notification_text="Microphone"
    fi

    if [ "$muted" = "yes" ]; then
        wpctl set-mute "$target" 0
        if [ "$DEVICE" = "--sound" ]; then
            icon="$ICON_PATH/audio-ready.svg"
        else
            icon="$ICON_PATH/mic-ready.svg"
        fi
        notify-send -i "$icon" "$notification_text" "Unmuted" -r 8 -t 8000
    else
        wpctl set-mute "$target" 1
        if [ "$DEVICE" = "--sound" ]; then
            icon="$ICON_PATH/audio-volume-muted.svg"
        else
            icon="$ICON_PATH/mic-volume-muted.svg"
        fi
        notify-send -i "$icon" "$notification_text" "Muted" -r 8 -t 8000
    fi
}

case "$DEVICE" in
    --sound|--mic)
        case "$ACTION" in
            --set|--inc|--dec)
                case "$PERCENT" in
                    ''|*[!0-9]*)
                        echo "Error: percentage must be a number"
                        exit 1
                        ;;
                esac
                change_volume
            ;;
            --mute)
                toggle_mute
            ;;
            *)
                echo "Invalid action: $ACTION"
                echo "Valid actions: --set, --inc, --dec, --mute"
                exit 1
            ;;
        esac
    ;;
    *)
        echo "Invalid device: $DEVICE"
        echo "Valid devices: --sound, --mic"
        exit 1
    ;;
esac
