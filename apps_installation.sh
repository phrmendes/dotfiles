!/bin/bash

# copy nix files
mkdir "$HOME/.nixpkgs"
ln -s "$(pwd)/.dotfiles/.nixpkgs/darwin-configuration.nix" "$HOME/.nixpkgs/"
ln -s "$(pwd)/.dotfiles/.nixpkgs/home.nix" "$HOME/.nixpkgs/"

# add darwin channel
nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
./result/bin/darwin-installer

# installing programs
darwin-rebuild switch

# configuring stow
sudo rm -r "$HOME/.nixpkgs"
stow --target="$HOME" --dir="$HOME/Projects/bkps" --stow .dotfiles

# node
mkdir "$HOME/.npm-global"
npm config set prefix "$HOME/.npm-global"
export PATH="$HOME"/.npm-global/bin:$PATH
source "$HOME/.profile"

# lunarvim
LV_BRANCH='release-1.2/neovim-0.8' bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh)

