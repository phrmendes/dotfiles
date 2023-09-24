#!/usr/bin/env bash

eval "$(micromamba shell hook --shell=zsh)"

export FLAKE_PATH="$HOME/Projects/bkps/nix#phrmendes"
export FZF_DEFAULT_COMMAND="fd --type f"
export FZF_DEFAULT_OPTS="--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"
export REFERENCES="$HOME/.references.bib"

path+=(
	"$HOME/.local/bin"
	"$HOME/.local/share/coursier/bin"
	"$HOME/.pyenv/shims"
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
}

function enable_droidcam() {
	sudo modprobe v4l2loopback exclusive_caps=1
}

function fzf_preview_file() {
	fzf --preview "bat --theme=catppuccin --color=always --style=header,grid --line-range :400 {}"
}

function fzf_open_with_nvim() {
	if ! command -v nvim &>/dev/null; then
		return
	fi

	selection=$(fzf_preview_file)

	if [ -n "$selection" ]; then
		nvim "$selection"
	fi
}

function get_gh_repo_ref() {
	gh_repo="$1"
	branch="$2"
	git ls-remote "https://github.com/$gh_repo" "$branch" | cut -f1
}
