#!/bin/bash

# add darwin channel
nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
./result/bin/darwin-installer

# add home-manager channel
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager

# updating channels
nix-channel --update

# installing home-manager
nix-build '<home-manager>' -A installer

# installing darwin
nix-build '<darwin>' -A installer

# installing programs
darwin-rebuild switch -I "darwin-config=$HOME/Projects/bkps/.dotfiles/.nixpkgs/darwin-configuration.nix"

home-manager switch

# node
mkdir "$HOME/.npm-global"
npm config set prefix "$HOME/.npm-global"
export PATH="$HOME"/.npm-global/bin:$PATH
source "$HOME/.profile"

# lunarvim
LV_BRANCH='release-1.2/neovim-0.8' bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh)

# configuring stow
sudo rm -r "$HOME/.config" "$HOME/.nixpkgs"
stow --target="$HOME" --dir="$HOME/Projects/bkps" --stow .dotfiles
