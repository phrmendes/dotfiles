#!/usr/bin/env bash

# home-manager
nix-shell '<home-manager>' -A install
rm "$HOME/.config/nixpkgs/home.nix"
stow --target="$HOME" --dir="$HOME/Projects/bkps" --stow .dotfiles
home-manager switch

# doom emacs
git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.emacs.d
"$HOME/.emacs.d/bin/doom" install
"$HOME/.emacs.d/bin/doom" sync

# r and python packages

micromamba activate
micromamba create --file "$MAIN_DIR/aux_files/config.yml"
