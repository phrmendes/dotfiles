#!/usr/bin/env bash

mkdir Projects
nix-shell '<home-manager>' -A install
stow --target="$HOME" --dir="$HOME/bkps" --stow .dotfiles
home-manager switch
git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.emacs.d
"$HOME/.emacs.d/bin/doom" install
"$HOME/.emacs.d/bin/doom" sync
