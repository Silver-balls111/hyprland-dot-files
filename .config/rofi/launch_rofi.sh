#!/usr/bin/env bash

# Generate wallpaper cache in background (won't delay rofi launch)
~/.config/rofi/generate_blur.sh 

# Launch rofi immediately
rofi -show drun
