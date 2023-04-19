#!/usr/bin/env bash

home_manager_config() {
	nix-shell '<home-manager>' -A install
	home-manager switch
}

stow_dotfiles() {
	rm "$HOME/.config/nixpkgs/home.nix"
	rm "$HOME/.profile"
	stow --target="$HOME" --dir="$HOME/Projects/bkps" --stow .dotfiles
}

asdf_config() {
	asdf plugin-add python
	asdf global python 3.11
}

stow_dotfiles
home_manager_config
asdf_config
