#!/bin/bash

# Setup cache directory
CACHE_DIR="$HOME/.cache/wlogout_blurred"
mkdir -p "$CACHE_DIR"

# Get wallpaper path and exit if not found
WALLPAPER=$(swww query | grep -oP '(?<=image: ).*') || exit 1

# Generate cached blur filename using MD5 hash
BLURRED_CACHE="$CACHE_DIR/$(echo -n "$WALLPAPER" | md5sum | cut -d' ' -f1).png"

# Create blurred version if not cached
[[ ! -f "$BLURRED_CACHE" ]] && magick "$WALLPAPER" -blur 0x5 -brightness-contrast -35 "$BLURRED_CACHE"

# Generate CSS and launch wlogout
cat > ~/.cache/wlogout_dynamic.css << EOF
window {
    background-image: url("file://${BLURRED_CACHE}");
    background-size: cover;
    background-position: center;
    font-family: Rubik Regular;
    font-size: 16pt;
    color: #ffffff;
}

button {
    background-repeat: no-repeat;
    background-position: center;
    background-size: 20%;
    background-color: rgba(255, 255, 255, 0.05);
    border: 2px solid transparent;
    border-radius: 36px;
    margin: 10px;
    outline: none;
    transition: all 0.3s ease-in;
    box-shadow: 0 0 10px 2px transparent;
}

button:focus {
    background-color: rgba(255, 255, 255, 0.2);
    background-size: 30%;
    border-color: rgba(255, 255, 255, 0.6);
    box-shadow: 0 0 20px 4px rgba(255, 255, 255, 0.3);
}

button:hover, button:focus:hover {
    background-color: rgba(255, 255, 255, 0.2);
    background-size: 30%;
    border-color: rgba(255, 255, 255, 0.6);
    box-shadow: 0 0 20px 4px rgba(255, 255, 255, 0.3);
}

#lock {
    background-image: url("$HOME/.config/wlogout/icons/lock_white.png");
}

#logout {
    background-image: url("$HOME/.config/wlogout/icons/logout_white.png");
}

#suspend {
    background-image: url("$HOME/.config/wlogout/icons/suspend_white.png");
}

#hibernate {
    background-image: url("$HOME/.config/wlogout/icons/hibernate_white.png");
}

#reboot {
    background-image: url("$HOME/.config/wlogout/icons/reboot_white.png");
}

#shutdown {
    background-image: url("$HOME/.config/wlogout/icons/shutdown_white.png");
}

EOF

# Clean cache older than 7 days (unused wallpapers)
find "$CACHE_DIR" -type f -mtime +7 -delete

# Keep only 10 most recent cached blurs
cd "$CACHE_DIR" && ls -t | tail -n +11 | xargs -r rm --

# Launch wlogout
wlogout -l ~/.config/wlogout/layout --css ~/.cache/wlogout_dynamic.css
