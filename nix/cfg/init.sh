#!/usr/bin/env bash

OPENAI_API_KEY=$(gpg --decrypt ~/.openai-chatgpt-api-key 2> /dev/null)
export OPENAI_API_KEY

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
	sudo nala upgrade
	flatpak update
}

system_clear() {
	sudo nala autopurge
	sudo nala autoremove
	sudo nala clean
}
