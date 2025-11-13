#!/bin/bash

# Volume control script with swaync OSD integration
# Uses wireplumber for audio control

ICON_DIR="/home/anuj/.config/swaync/icons"

# Get current volume and mute status
get_volume() {
    wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100)}'
}

get_mute_status() {
    wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q "MUTED" && echo "muted" || echo "unmuted"
}

# Get appropriate icon based on volume level
get_volume_icon() {
    local volume=$1
    local mute_status=$2
    
    if [ "$mute_status" = "muted" ]; then
        echo "$ICON_DIR/volume-mute.png"
    elif [ "$volume" -eq 0 ]; then
        echo "$ICON_DIR/volume-mute.png"
    elif [ "$volume" -le 33 ]; then
        echo "$ICON_DIR/volume-low.png"
    elif [ "$volume" -le 66 ]; then
        echo "$ICON_DIR/volume-mid.png"
    else
        echo "$ICON_DIR/volume-high.png"
    fi
}

# Send notification via swaync
send_notification() {
    local volume=$1
    local mute_status=$2
    local icon=$(get_volume_icon "$volume" "$mute_status")
    
    if [ "$mute_status" = "muted" ]; then
        notify-send -e -h string:x-canonical-private-synchronous:volume \
                    -h int:value:"$volume" \
                    -i "$icon" \
                    "Volume: Muted"
    else
        notify-send -e -h string:x-canonical-private-synchronous:volume \
                    -h int:value:"$volume" \
                    -i "$icon" \
                    "Volume: ${volume}%"
    fi
}

# Main control logic
case "$1" in
    --inc|--increase)
        wpctl set-volume -l 2.0 @DEFAULT_AUDIO_SINK@ 5%+
        wpctl set-mute @DEFAULT_AUDIO_SINK@ 0
        ;;
    --dec|--decrease)
        wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
        ;;
    --toggle|--mute)
        wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
        ;;
    --toggle-mic)
        MIC_MUTE=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | grep -q "MUTED" && echo "unmuted" || echo "muted")
        wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
        notify-send -e -h string:x-canonical-private-synchronous:microphone \
                    -i "$ICON_DIR/microphone-${MIC_MUTE}.png" \
                    "Microphone: ${MIC_MUTE^}"
        exit 0
        ;;
    *)
        echo "Usage: $0 {--inc|--dec|--toggle|--toggle-mic}"
        exit 1
        ;;
esac

# Send notification for volume changes
VOLUME=$(get_volume)
MUTE_STATUS=$(get_mute_status)
send_notification "$VOLUME" "$MUTE_STATUS"
