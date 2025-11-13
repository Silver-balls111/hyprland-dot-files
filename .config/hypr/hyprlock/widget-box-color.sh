#!/bin/bash

# Check if any player is active
if playerctl status &>/dev/null 2>&1; then
    STATUS=$(playerctl status 2>/dev/null)
    if [[ "$STATUS" == "Playing" || "$STATUS" == "Paused" ]]; then
        # Return visible color (adjust these to match your theme)
        echo "rgba(17, 17, 27, 0.8)"
        exit 0
    fi
fi

# Return transparent when no media
echo "rgba(0, 0, 0, 0)"
