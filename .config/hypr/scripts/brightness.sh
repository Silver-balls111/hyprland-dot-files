#!/bin/bash

# Brightness control script with swaync OSD integration

ICON_DIR="$HOME/.config/swaync/icons"
MAX_BRIGHTNESS_PERCENT=200

# Get current brightness percentage
get_brightness() {
    brightnessctl get | awk -v max="$(brightnessctl max)" '{print int(($1/max)*100)}'
}

# Get appropriate icon based on brightness level
get_brightness_icon() {
    local brightness=$1
    
    if [ "$brightness" -le 20 ]; then
        echo "$ICON_DIR/brightness-20.png"
    elif [ "$brightness" -le 40 ]; then
        echo "$ICON_DIR/brightness-40.png"
    elif [ "$brightness" -le 60 ]; then
        echo "$ICON_DIR/brightness-60.png"
    elif [ "$brightness" -le 80 ]; then
        echo "$ICON_DIR/brightness-80.png"
    else
        echo "$ICON_DIR/brightness-100.png"
    fi
}
# Send notification via swaync
send_notification() {
    local brightness=$1
    local icon=$(get_brightness_icon "$brightness")
    
    notify-send -e -h string:x-canonical-private-synchronous:brightness \
                -h int:value:"$brightness" \
                -i "file://${icon}" \
                "Brightness: ${brightness}%"
}

# Main control logic
case "$1" in
    --inc|--increase)
        CURRENT=$(get_brightness)
        if [ "$CURRENT" -ge "$MAX_BRIGHTNESS_PERCENT" ]; then
            # Already at max, don't increase
            BRIGHTNESS=$MAX_BRIGHTNESS_PERCENT
        else
            # Calculate new brightness and cap at max
            NEW_BRIGHTNESS=$((CURRENT + 5))
            if [ "$NEW_BRIGHTNESS" -gt "$MAX_BRIGHTNESS_PERCENT" ]; then
                brightnessctl set "${MAX_BRIGHTNESS_PERCENT}%"
            else
                brightnessctl set 5%+
            fi
            BRIGHTNESS=$(get_brightness)
        fi
        ;;
    --dec|--decrease)
        brightnessctl set 5%-
        BRIGHTNESS=$(get_brightness)
        ;;
    *)
        echo "Usage: $0 {--inc|--dec}"
        exit 1
        ;;
esac

# Send notification
send_notification "$BRIGHTNESS"
