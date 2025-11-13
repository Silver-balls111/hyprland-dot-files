#!/bin/bash

# Check if any player is active
if playerctl -l 2>/dev/null | grep -q .; then
    STATUS=$(playerctl status 2>/dev/null)
    if [[ "$STATUS" == "Playing" || "$STATUS" == "Paused" ]]; then
        echo "$1"  # Return the icon passed as argument
        exit 0
    fi
fi

echo ""  # Return empty if no player
