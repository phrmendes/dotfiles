#!/usr/bin/env bash

path+=(
	"$HOME/.local/bin"
	"$HOME/.local/share/coursier/bin"
	"$HOME/.pyenv/shims"
)

nix_update() {
	home-manager switch
}

nix_clear() {
	nix-collect-garbage
}

system_update() {
	sudo nala update
	sudo nala full-upgrade
	flatpak update
}

system_clear() {
	sudo nala autopurge
	sudo nala autoremove
	sudo nala clean
	sudo nala fetch
}
