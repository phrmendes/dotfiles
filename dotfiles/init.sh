#!/usr/bin/env bash

export EDITOR="nvim";
export GIT_EDITOR="nvim";
export SUDO_EDITOR="nvim";
export VISUAL="nvim";

if [[ $HOST  != "desktop" ]]; then
    export PATH="/opt/homebrew/sbin:$PATH"
    export PATH="/opt/homebrew/bin:$PATH"
    export PATH="$HOME/.pyenv/bin:$PATH"

    eval "$(pyenv init -)"
fi

export PATH="$HOME/.local/bin:$PATH"
export PATH="/etc/profiles/per-user/$USER/bin:$PATH"
export PATH="/run/current-system/sw/bin:$PATH"
export PATH="/run/wrappers/bin:$PATH"

function gc() {
    sudo nix-collect-garbage --delete-older-than 1d
    nix-collect-garbage --delete-older-than 1d
    nix-store --optimise
}

function update() {
    if [[ $HOST  == "desktop" ]]; then
        sudo nixos-rebuild switch --flake "$HOME/Projects/dotfiles"
    else
        nix run nix-darwin -- switch --flake "$HOME/Projects/dotfiles"
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
