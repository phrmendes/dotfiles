#!/usr/bin/env bash

eval "$(micromamba shell hook --shell=zsh)"

export FLAKE_PATH="$HOME"/Projects/bkps/nix#phrmendes

path+=(
	"$HOME"/.local/bin
	"$HOME"/.local/share/coursier/bin
	"$HOME"/.nix-profile/bin
)

function nix_update() {
	nix run nixpkgs#home-manager -- switch --flake "$FLAKE_PATH"
}

function nix_clear() {
	nix-collect-garbage
}

function system_update() {
	sudo nala upgrade
	sudo pop-upgrade recovery upgrade from-release
	flatpak update
}

function system_clear() {
	sudo nala autopurge
	sudo nala autoremove
	sudo nala clean
	flatpak remove --unused
}

function enable_droidcam() {
	sudo modprobe v4l2loopback exclusive_caps=1
}

function get_gh_repo_ref() {
	gh_repo="$1"
	branch="$2"
	git ls-remote "https://github.com/$gh_repo" "$branch" | cut -f1
}

function js() {
	ID="$$"
	mkdir -p /tmp/"$USER"
	OUTPUT_FILE="/tmp/$USER/joshuto-cwd-$ID"
	env joshuto --output-file "$OUTPUT_FILE" "$@"
	exit_code=$?

	case "$exit_code" in
		0)
			;;
		101)
			JOSHUTO_CWD=$(cat "$OUTPUT_FILE")
			cd "$JOSHUTO_CWD" || exit
			;;
		102)
			;;
		*)
			echo "Exit code: $exit_code"
			;;
	esac
}
