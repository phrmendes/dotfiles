#!/usr/bin/env bash

eval "$(micromamba shell hook --shell=zsh)"

export FLAKE_PATH="$HOME"/Projects/bkps#phrmendes

path+=(
	"$HOME"/.local/bin
	"$HOME"/.local/share/coursier/bin
	"$HOME"/.nix-profile/bin
)

function nix_update() {
	nix flake update
	sudo nixos-rebuild switch --flake "$FLAKE_PATH"
}

function nix_clear() {
	nix store gc --debug
}

function dcam() {
	sudo modprobe v4l2loopback exclusive_caps=1
	droidcam
}

function get_gh_repo_ref() {
	gh_repo="$1"
	branch="$2"
	git ls-remote "https://github.com/$gh_repo" "$branch" | cut -f1
}
