#!/usr/bin/env bash

# home-manager
nix-shell '<home-manager>' -A install
rm "$HOME/.config/nixpkgs/home.nix"
stow --target="$HOME" --dir="$HOME/Projects/bkps" --stow .dotfiles
home-manager switch

# alacritty
nix-channel --add https://github.com/guibou/nixGL/archive/main.tar.gz nixgl && nix-channel --update

# doom emacs
git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.emacs.d
"$HOME/.emacs.d/bin/doom" install
"$HOME/.emacs.d/bin/doom" sync
