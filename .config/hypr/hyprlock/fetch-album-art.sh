#!/bin/bash

THUMB="/tmp/hyprlock-album-art.png"
ART_INFO="/tmp/hyprlock-album-art.inf"

# Function to cleanup all cache files
cleanup() {
    rm -f "$THUMB" "$ART_INFO"
    # Force hyprlock to reload
    pkill -USR2 hyprlock 2>/dev/null
}

# Check if any player is active
if ! playerctl -l 2>/dev/null | grep -q .; then
    cleanup
    exit 0
fi

# Get status
STATUS=$(playerctl status 2>/dev/null)

# If nothing is playing/paused, cleanup and exit
if [[ "$STATUS" != "Playing" && "$STATUS" != "Paused" ]]; then
    cleanup
    exit 0
fi

# Get album art URL
artUrl=$(playerctl metadata mpris:artUrl 2>/dev/null)

# If no art URL, cleanup and exit
if [[ -z "$artUrl" ]]; then
    cleanup
    exit 0
fi

# Check if URL has changed
if [[ -f "$ART_INFO" && "$(cat "$ART_INFO")" == "$artUrl" && -f "$THUMB" ]]; then
    # URL hasn't changed and file exists, just return the path
    echo "$THUMB"
    exit 0
fi

# Save new URL
echo "$artUrl" > "$ART_INFO"

# Download/copy album art
if [[ "$artUrl" == file://* ]]; then
    # Local file
    cp "${artUrl#file://}" "$THUMB" 2>/dev/null
elif [[ "$artUrl" == http* ]]; then
    # Download from URL
    curl -sS "$artUrl" -o "$THUMB" --max-time 3 2>/dev/null
fi

# Check if download/copy succeeded
if [[ -f "$THUMB" && -s "$THUMB" ]]; then
    # Force hyprlock to reload the image
    pkill -USR2 hyprlock 2>/dev/null
    echo "$THUMB"
else
    cleanup
fi
