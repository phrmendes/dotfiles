#!/usr/bin/env bash

path+=(
	"$HOME/.local/bin"
	"$HOME/.local/share/coursier/bin"
	"$HOME/.pyenv/shims"
)

nix_update() {
	home-manager switch -b backup
}

nix_clear() {
	nix-collect-garbage
}

system_update() {
	sudo apt update
	sudo apt full-upgrade
}

system_clear() {
	sudo apt autoremove
	sudo apt autoclean
}
