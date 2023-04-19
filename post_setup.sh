#!/usr/bin/env bash

home_manager_config() {
	nix-shell '<home-manager>' -A install
	rm "$HOME/.config/nixpkgs/home.nix"
	rm "$HOME/.profile"
	stow --target="$HOME" --dir="$HOME/Projects/bkps" --stow .dotfiles
	home-manager switch
}

asdf_config() {
	asdf plugin-add python
	asdf global python 3.11
}
home_manager_config
asdf_config
