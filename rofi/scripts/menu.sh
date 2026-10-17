#!/usr/bin/env bash

# -----------------------------
# Config
# -----------------------------

THEME_DIR="$HOME/.config/rofi/menu"
DEFAULT_THEME="asuka_menu"

# Allow theme override:
# powermenu.sh eva02
THEME="${1:-$DEFAULT_THEME}"
[[ "$THEME" != *.rasi ]] && THEME="$THEME.rasi"

THEME_PATH="$THEME_DIR/$THEME"

# -----------------------------
# Menu entries
# -----------------------------

OPTION1="SWAY"
OPTION2="I3"
OPTION3="HYPRLAND"
OPTION4="WAYBAR"
OPTION5="KITTY"
OPTION6="ROFI"
OPTION7="DUNST"
OPTION8="SWAYNC"

options=("$OPTION1" "$OPTION2" "$OPTION3" "$OPTION4" "$OPTION5" "$OPTION6" "$OPTION7" "$OPTION8")

# -----------------------------
# Launch rofi
# -----------------------------

chosen=$(printf '%s\n' "${options[@]}" | rofi -dmenu -p \
  -theme "$THEME_PATH")


case "$chosen" in
  "$OPTION1") kitty kate "/home/stefan/.config/sway/config" ;;
  "$OPTION2") kitty kate "/home/stefan/.config/i3/config" ;;
  "$OPTION3") kitty kate "/home/stefan/.config/hypr/hyprland.conf" ;;
  "$OPTION4") kitty kate "/home/stefan/.config/waybar/config.jsonc" ;;
  "$OPTION5") kitty kate "/home/stefan/.config/kitty/kitty.conf" ;;
  "$OPTION6") kitty kate "/home/stefan/.config/rofi/config.rasi" ;;
  "$OPTION7") kitty kate "/home/stefan/.config/dunst" ;;
  "$OPTION8") kitty kate "/home/stefan/.config/swaync/style.css" ;;
esac
