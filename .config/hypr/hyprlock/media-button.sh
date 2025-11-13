#!/bin/bash

# Check if any player is active
playerctl status &>/dev/null || exit 0

STATUS=$(playerctl status 2>/dev/null)
[[ "$STATUS" == "Playing" || "$STATUS" == "Paused" ]] && echo "$1" || echo ""
