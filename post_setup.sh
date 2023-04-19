#!/usr/bin/env bash

home_manager_first_generation() {
	home-manager switch
}

home_manager_update() {
	nix-shell '<home-manager>' -A install
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

home_manager_first_generation
stow_dotfiles
home_manager_config
asdf_config