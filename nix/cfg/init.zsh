#!/bin/bash

source "$HOME/.nix-profile/share/asdf-vm/asdf.sh"
export WEZTERM_CONFIG_FILE="$HOME/.wezterm.lua"
path+=("$HOME/.local/bin")


nix_update() {
    rm -rf $HOME/.config/gtk-3.0/settings.ini.backup
    rm -rf $HOME/.config/gtk-4.0/settings.ini.backup
    home-manager switch -b backup
}

nix_clear() {
    nix-collect-garbage
}

system_update() {
    sudo apt update
    sudo apt full-upgrade
}

system_clear() {
    sudo apt autoremove
    sudo apt autoclean
}
