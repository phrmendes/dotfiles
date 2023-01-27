#!/bin/bash

# installing nix darwin
nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
./result/bin/darwin-installer

# copy nix files
rm "$HOME/.nixpkgs/darwin-configuration.nix"
ln -s "$HOME/Projects/bkps/.dotfiles/.nixpkgs/darwin-configuration.nix" "$HOME/.nixpkgs/"
ln -s "$HOME/Projects/bkps/.dotfiles/.nixpkgs/home.nix" "$HOME/.nixpkgs/"

# installing programs
nix-channel --update darwin
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
darwin-rebuild switch

# doom emacs
git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.emacs.d
"$HOME/.emacs.d/bin/doom" install
sudo rm -r "$HOME/.doom.d/*.el"

# configuring stow
sudo rm -r "$HOME/.nixpkgs"
stow --target="$HOME" --dir="$HOME/Projects/bkps" --stow .dotfiles

# iterm2/zsh integration
curl -L https://iterm2.com/shell_integration/zsh -o ~/.iterm2_shell_integration.zsh
