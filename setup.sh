#!/bin/bash

# config xcode
xcode-select --install

# install nix
curl -L https://nixos.org/nix/install | sh

# install nix-darwin
if ! grep -q nix-darwin $HOME/.nix-channels; then
  echo "https://github.com/LnL7/nix-darwin/archive/master.tar.gz darwin" >> $HOME/.nix-channels
fi

export NIX_PATH=darwin=$HOME/.nix-defexpr/channels/darwin:$NIX_PATH

# install home-manager
touch $HOME/.nix-channels

if ! grep -q home-manager $HOME/.nix-channels; then
  echo "https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager" >> $HOME/.nix-channels
fi

export NIX_PATH=home-manager=$HOME/.nix-defexpr/channels/home-manager:$NIX_PATH

# placing dotfiles
stow --target="$HOME" --dir="$HOME/Projects/bkps" --stow .dotfiles
ln -s ./.dotfiles/* "$HOME"

# installing programs
darwin-rebuild switch

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
