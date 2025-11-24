#!/usr/bin/env bash
# Toggle $mainMod between ALT and SUPER
# Works for config lines like: $mainMod = ALT

CONF="$HOME/.config/hypr/config/keybindings.conf"

if grep -q '^\s*\$mainMod\s*=\s*ALT' "$CONF"; then
    # Switch ALT → SUPER
    sed -E -i 's/^\s*\$mainMod\s*=\s*ALT/$mainMod = SUPER/' "$CONF"
    notify-send "Switched mainMod to SUPER"
else
    # Switch SUPER → ALT
    sed -E -i 's/^\s*\$mainMod\s*=\s*SUPER/$mainMod = ALT/' "$CONF"
    notify-send "Switched mainMod to ALT"
fi

# Apply changes
hyprctl reload
