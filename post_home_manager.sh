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

poetry() {
	python -m pip install --upgrade pip
	python -m pip install poetry
	"$HOME/.pyenv/shims/poetry" config virtualenvs.in-project true
}

python_debugger() {
	mkdir "$HOME/.virtualenvs"
	cd "$HOME/.virtualenvs" || exit
	python3 -m venv debugpy
	debugpy/bin/python -m pip install debugpy
}

home_manager_first_generation
stow_dotfiles
home_manager_update
poetry
python_debugger
