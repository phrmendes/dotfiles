#!/usr/bin/env bash

# home-manager
nix-shell '<home-manager>' -A install
rm "$HOME/.config/nixpkgs/home.nix"
rm "$HOME/.profile"
stow --target="$HOME" --dir="$HOME/Projects/bkps" --stow .dotfiles
home-manager switch

# node
mkdir "$HOME/.npm-global"
npm config set prefix '~/.npm-global'
export PATH="$HOME"/.npm-global/bin:$PATH
source .profile

# lvim
LV_BRANCH='release-1.2/neovim-0.8' bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh)
