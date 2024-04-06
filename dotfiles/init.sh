#!/usr/bin/env bash

export EDITOR="nvim";
export GIT_EDITOR="nvim";
export SUDO_EDITOR="nvim";
export VISUAL="nvim";
export DOTFILES="$HOME/Projects/dotfiles";

path+=(
    "$HOME"/.local/bin
    /etc/profiles/per-user/"$USER"/bin
    /run/current-system/sw/bin
    /opt/homebrew/bin
)

function gc() {
    sudo nix-collect-garbage --delete-older-than 1d
    nix-collect-garbage --delete-older-than 1d
    nix-store --optimise
}

function update() {
    if [[ $HOST  == "desktop" ]]; then
        sudo nixos-rebuild switch --flake "$DOTFILES"
    else
        nix run nix-darwin -- switch --flake "$DOTFILES"
    fi
}

function yy() {
	local TMP

    TMP="$(mktemp -t "yazi-cwd.XXXXXX")"

	yazi "$@" --cwd-file="$TMP"

	if CWD="$(cat -- "$TMP")" && [ "$CWD" != "" ] && [ "$CWD" != "$PWD" ]; then
		cd -- "$CWD" || return
	fi

	rm -f -- "$TMP"
}
