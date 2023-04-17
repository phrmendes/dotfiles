#!/usr/bin/env zsh

path+=("$HOME/.npm-global/bin")

dconf load /org/gnome/settings-daemon/plugins/media-keys/ < "$HOME/.config/gnome-keybindings/custom-keys.txt"
dconf load /org/gnome/desktop/wm/keybindings/ < "$HOME/.config/gnome-keybindings/wm-keys.txt"
dconf load /org/gnome/shell/extensions/forge/ < "$HOME/.config/gnome-keybindings/forge-keys.txt"
dconf load /org/gnome/shell/keybindings/ < "$HOME/.config/gnome-keybindings/keys.txt"
