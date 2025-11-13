#!/usr/bin/env bash

set -euo pipefail  # Exit on error, undefined variables, and pipe failures

# Constants
readonly CACHE_DIR="${HOME}/wallpaper-cached/rofi"
readonly WIDTH=1260
readonly HEIGHT=660
readonly BLUR_REGION="70x${HEIGHT}+0+0"
readonly BLUR_STRENGTH="0x3"

# Create cache directory if it doesn't exist
[[ -d "$CACHE_DIR" ]] || mkdir -p "$CACHE_DIR"

# Get current wallpaper from swww
WALLPAPER=$(swww query | grep -oP '(?<=image: ).*' | head -n1) || {
    echo "Error: Could not query swww" >&2
    exit 1
}

# Validate wallpaper file exists
[[ -f "$WALLPAPER" ]] || {
    echo "Error: Wallpaper file not found: $WALLPAPER" >&2
    exit 1
}

# Generate hash using built-in approach
WALLPAPER_HASH=$(md5sum "$WALLPAPER")
WALLPAPER_HASH=${WALLPAPER_HASH%% *}  # Extract hash without awk

# Define output paths
readonly THUMB_OUTPUT="${CACHE_DIR}/${WALLPAPER_HASH}_thumb.png"
readonly BLUR_OUTPUT="${CACHE_DIR}/${WALLPAPER_HASH}_blur.png"
readonly THUMB_LINK="${CACHE_DIR}/wall.thmb"
readonly BLUR_LINK="${CACHE_DIR}/wall.blur"

# Check cache and update symlinks if cached versions exist
if [[ -f "$THUMB_OUTPUT" && -f "$BLUR_OUTPUT" ]]; then
    ln -sf "$THUMB_OUTPUT" "$THUMB_LINK"
    ln -sf "$BLUR_OUTPUT" "$BLUR_LINK"
    exit 0
fi

# Generate new wallpaper images
magick "$WALLPAPER" \
    -resize "${WIDTH}x${HEIGHT}^" \
    -gravity center \
    -extent "${WIDTH}x${HEIGHT}" \
    "$THUMB_OUTPUT"

magick "$THUMB_OUTPUT" \
    -region "$BLUR_REGION" \
    -blur "$BLUR_STRENGTH" \
    "$BLUR_OUTPUT"

# Create symlinks
ln -sf "$THUMB_OUTPUT" "$THUMB_LINK"
ln -sf "$BLUR_OUTPUT" "$BLUR_LINK"
