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
	sudo nala upgrade
	sudo pop-upgrade recovery upgrade from-release
	sudo fwupdmgr get-devices >/dev/null
	sudo fwupdmgr get-updates
	sudo fwupdmgr update
	flatpak update
}

system_clear() {
	sudo nala autopurge
	sudo nala autoremove
	sudo nala clean
}
