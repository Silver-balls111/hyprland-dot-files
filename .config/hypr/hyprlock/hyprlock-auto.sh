#!/bin/bash

# Extract wallpaper path
WALLPAPER=$(swww query | grep -oP '(?<=image: ).*')

# Generate temporary config
cat > /tmp/hyprlock_dynamic.conf <<EOF
background {
    path = $WALLPAPER
    blur_passes = 2
    blur_size = 5
}
EOF

# Include your other hyprlock settings (optional)
cat ~/.config/hypr/hyprlock.conf >> /tmp/hyprlock_dynamic.conf

# Run hyprlock with this config
hyprlock -c /tmp/hyprlock_dynamic.conf
