#!/usr/bin/env bash

# gnome shortcuts
dconf load /org/gnome/settings-daemon/plugins/media-keys/ <"$HOME/Project/bkps/gnome-custom-keybindings.txt"
dconf load /org/gnome/desktop/wm/keybindings/ <"$HOME/Projects/bkps/gnome-keybindings.txt"
