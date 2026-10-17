#!/bin/bash

# Wait for awww daemon
until pgrep -x awww-daemon >/dev/null; do
    sleep 1
done

#------------------------------------------------
# WORKSPACE WALLPAPERS
#------------------------------------------------

# Set wallpaper for the current workspace
set_wallpaper() {
    case "$1" in
        "1:アダム") WALL="$HOME/Pictures/neon_genesis_evangelion.jpg";;
        "2:リリス") WALL="$HOME/Pictures/wallpapers/Eva/asuka_unit_02.jpg";;
        "3:ラミエル") WALL="$HOME/Pictures/wallpapers/Eva/asuka_rei_misato.jpg";;
        "4:レリエル") WALL="$HOME/Pictures/wallpapers/Eva/asuka-city.jpg";;
        "5:バルディエル") WALL="$HOME/Pictures/wallpapers/Eva/asuka_shoryu.jpg";;
        "6:ゼルエル") WALL="$HOME/Pictures/wallpapers/Eva/asuka_glitch.jpg";;
        "7:Unit-07") WALL="$HOME/Pictures/wallpapers/Eva/angels.jpg";;
        "8:Unit-08") WALL="$HOME/Pictures/wallpapers/Eva/asuka_dark.jpg";;
        "9:Unit-09") WALL="$HOME/Pictures/wallpapers/Eva/rei_ayanami_1080p.jpg";;
        "10:Unit-10") WALL="$HOME/Pictures/wallpapers/Eva/evangelion_asuka_white.jpg";;
        *) WALL="$HOME/Pictures/neon_genesis_evangelion.jpg";;
        
        
    esac

    awww img "$WALL"
}

# Set initial wallpaper
current_workspace=$(swaymsg -t get_workspaces | jq -r '.[] | select(.focused).name')
set_wallpaper "$current_workspace"

# Listen for Sway workspace changes
swaymsg -t subscribe '["workspace"]' | while read -r event; do
    workspace=$(echo "$event" | jq -r '.current.name')

    set_wallpaper "$workspace"
done
