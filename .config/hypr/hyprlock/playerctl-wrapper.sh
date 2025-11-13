#!/bin/bash
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus"
/usr/bin/playerctl play-pause
