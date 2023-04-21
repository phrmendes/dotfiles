#!/usr/bin/env bash

home_manager_first_generation() {
	nix-shell '<home-manager>' -A install
}

home_manager_update() {
	home-manager switch
}

stow_dotfiles() {
	rm "$HOME/.config/home-manager/home.nix"
	rm "$HOME/.profile"
	stow --target="$HOME" --dir="$HOME/Projects/bkps" --stow .dotfiles
}

pyenv_setup() {
	curl https://pyenv.run | bash
	"$HOME/.pyenv/bin/pyenv" install 3.11.3
	"$HOME/.pyenv/bin/pyenv" global 3.11.3
}

poetry_setup() {
	poetry config virtualenvs.in-project true
}

home_manager_first_generation
stow_dotfiles
home_manager_update
pyenv_setup
poetry_setup
