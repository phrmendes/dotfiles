#!/bin/bash

# exporting darwin env vars
source "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
echo 'export NIX_PATH=darwin-config=$HOME/.nixpkgs/darwin-configuration.nix:$HOME/.nix-defexpr/channels${NIX_PATH:+:}$NIX_PATH' | tee -a ~/.zshrc
echo 'source $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh' | tee -a ~/.zshrc

# placing nix files
ln -s $HOME/Projects/bkps/.dotfiles/.config "$HOME"
ln -s $HOME/Projects/bkps/.dotfiles/.nixpkgs "$HOME"

# updating channels
nix-channel --update

# removing shell settings
sudo rm /etc/shells /etc/zprofile /etc/zshrc

# installing home-manager
nix-build '<home-manager>' -A installer

# installing darwin
nix-build '<darwin>' -A installer

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
