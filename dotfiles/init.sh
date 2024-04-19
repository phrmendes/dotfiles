#!/usr/bin/env bash

export PATH="$HOME/.local/bin:$PATH"
export PATH="/etc/profiles/per-user/$USER/bin:$PATH"
export PATH="/run/current-system/sw/bin:$PATH"
export PATH="/run/wrappers/bin:$PATH"

function yy() {
    local TMP

    TMP="$(mktemp -t "yazi-cwd.XXXXXX")"

    yazi "$@" --cwd-file="$TMP"

    if CWD="$(cat -- "$TMP")" && [ "$CWD" != "" ] && [ "$CWD" != "$PWD" ]; then
	cd -- "$CWD" || return
    fi

    rm -f -- "$TMP"
}

if [[ $HOST  != "desktop" ]]; then
    export PATH="/opt/homebrew/sbin:$PATH"
    export PATH="/opt/homebrew/bin:$PATH"

    function update() {
        nix run nix-darwin -- switch --flake "$HOME/Projects/dotfiles"
    }
fi
