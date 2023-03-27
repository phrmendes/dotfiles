#!/usr/bin/env bash

# gnome shortcuts
dconf load /org/gnome/settings-daemon/plugins/media-keys/ < "$HOME/Project/bkps/gnome-keybindings/custom-keybindings.txt"
dconf load /org/gnome/desktop/wm/keybindings/ < "$HOME/Projects/bkps/gnome-keybindings/keys.txt"
dconf load /org/gnome/shell/extensions/forge/ < "$HOME/Projects/bkps/gnome-keybindings/forge-keys.txt"
