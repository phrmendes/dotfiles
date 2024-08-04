#!/usr/bin/env bash

options="  Shutdown\n  Restart\n  Suspend\n  Lock"

chosen=$(echo -e "$options" | rofi -theme gruvbox-dark -dmenu -p " " -theme-str 'listview {columns: 1;}')

case "$chosen" in
    "  Shutdown")
        systemctl poweroff
        ;;
    "  Restart")
        systemctl reboot
        ;;
    "  Suspend")
        systemctl suspend
        ;;
    "  Lock")
        swaylock
        ;;
    *)
        ;;
esac
