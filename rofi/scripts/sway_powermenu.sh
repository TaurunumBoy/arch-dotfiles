#!/usr/bin/env bash

# -----------------------------
# Config
# -----------------------------

THEME_DIR="$HOME/.config/rofi/menu"
DEFAULT_THEME="asuka_sway_pm"

# Allow theme override:
# powermenu.sh eva02
THEME="${1:-$DEFAULT_THEME}"
[[ "$THEME" != *.rasi ]] && THEME="$THEME.rasi"

THEME_PATH="$THEME_DIR/$THEME"

# -----------------------------
# Menu entries (icons only)
# -----------------------------

LOCK="LOCKDOWN"
LOGOUT="DISCONNECT"
REBOOT="RESTART"
SUSPEND="STANDBY"
POWEROFF="TERMINATE"

options=("$POWEROFF" "$REBOOT" "$LOGOUT" "$SUSPEND" "$LOCK")

# -----------------------------
# Launch rofi
# -----------------------------

chosen=$(printf '%s\n' "${options[@]}" | rofi -dmenu \
  -theme "$THEME_PATH")


case "$chosen" in
  "$POWEROFF") systemctl poweroff ;;
  "$REBOOT") systemctl reboot ;;
  "$LOGOUT") i3-msg exit ;;
  "$SUSPEND") systemctl suspend ;;
  "$LOCK") swaylock ;;
esac
