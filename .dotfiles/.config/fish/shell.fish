#!/usr/bin/env fish

fish_add_path "$HOME/.npm-global/bin"
dconf load /org/gnome/settings-daemon/plugins/media-keys/ < "$HOME/Projects/bkps/gnome-keybindings/custom-keys.txt"
dconf load /org/gnome/desktop/wm/keybindings/ < "$HOME/Projects/bkps/gnome-keybindings/wm-keys.txt"
dconf load /org/gnome/shell/extensions/forge/ < "$HOME/Projects/bkps/gnome-keybindings/forge-keys.txt"
dconf load /org/gnome/shell/keybindings/ < "$HOME/Projects/bkps/gnome-keybindings/keys.txt"

eval "$(micromamba shell hook --shell=fish)"
micromamba deactivate
