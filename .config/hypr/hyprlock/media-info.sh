#!/bin/bash

# Check if player is active
playerctl status &>/dev/null || exit 0

STATUS=$(playerctl status 2>/dev/null)
[[ "$STATUS" != "Playing" && "$STATUS" != "Paused" ]] && exit 0

# Get metadata
ARTIST=$(playerctl metadata xesam:artist 2>/dev/null)
TITLE=$(playerctl metadata xesam:title 2>/dev/null)

# Maximum length per line
MAX_LENGTH=18

# Truncate artist and title separately
if [[ -n "$ARTIST" ]]; then
    if (( ${#ARTIST} > MAX_LENGTH )); then
        ARTIST="${ARTIST:0:$MAX_LENGTH}..."
    fi
fi

if [[ -n "$TITLE" ]]; then
    if (( ${#TITLE} > MAX_LENGTH )); then
        TITLE="${TITLE:0:$MAX_LENGTH}..."
    fi
fi

# Output with newline between artist and title
if [[ -n "$ARTIST" && -n "$TITLE" ]]; then
    echo -e "$TITLE\n$ARTIST"
elif [[ -n "$TITLE" ]]; then
    echo "$TITLE"
fi
