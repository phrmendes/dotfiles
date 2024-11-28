#!/usr/bin/env bash

export EDITOR="nvim"
export GIT_EDITOR="nvim"
export SUDO_EDITOR="nvim"
export VISUAL="nvim"

export PATH="$HOME/.local/bin:$PATH"
export PATH="/etc/profiles/per-user/$USER/bin:$PATH"
export PATH="/run/current-system/sw/bin:$PATH"
export PATH="/run/wrappers/bin:$PATH"

set -o vi

function yy() {
    local TMP

    TMP="$(mktemp -t "yazi-cwd.XXXXXX")"

    yazi "$@" --cwd-file="$TMP"

    if CWD="$(cat -- "$TMP")" && [ "$CWD" != "" ] && [ "$CWD" != "$PWD" ]; then
	cd -- "$CWD" || return
    fi

    rm -f -- "$TMP"
}

function diff_persist() {
    sudo rsync -amvxx --dry-run --no-links --exclude '/tmp/*' --exclude '/root/*' / persist/ | rg -v '^skipping|/$'
}

function unlock_bw() {
    if [[ -z $BW_SESSION ]]; then
	echo "Unlocking Bitwarden..."

	BW_SESSION="$(bw unlock --raw)"
	export BW_SESSION

	echo "Bitwarden unlocked."
    fi
}

eval "$(just --completions zsh)"
eval "$(uv generate-shell-completion zsh)"
