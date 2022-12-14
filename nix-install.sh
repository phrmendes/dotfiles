#!/bin/bash

# install nix
curl -L https://nixos.org/nix/install | sh

# create .nix-channels file
touch $HOME/.nix-channels

# install nix-darwin
if ! grep -q nix-darwin $HOME/.nix-channels; then
  echo "https://github.com/LnL7/nix-darwin/archive/master.tar.gz darwin" >> $HOME/.nix-channels
fi

export NIX_PATH=darwin=$HOME/.nix-defexpr/channels/darwin:$NIX_PATH

# install home-manager
if ! grep -q home-manager $HOME/.nix-channels; then
  echo "https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager" >> $HOME/.nix-channels
fi

export NIX_PATH=home-manager=$HOME/.nix-defexpr/channels/home-manager:$NIX_PATH
