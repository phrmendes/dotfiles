#!/usr/bin/env bash

nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
echo 'export NIX_PATH=$HOME/.nix-defexpr/channels:/nix/var/nix/profiles/per-user/root/channels${NIX_PATH:+:$NIX_PATH}' >> "$HOME/.profile"
source "$HOME/.profile"
nix-shell '<home-manager>' -A install

stow --target="$HOME" --dir="$HOME/bkps" --stow .dotfiles

git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.emacs.d
"$HOME/.emacs.d/bin/doom" install
"$HOME/.emacs.d/bin/doom" sync

home-manager switch
