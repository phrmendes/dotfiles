#!/usr/bin/env bash

export EDITOR="nvim"
export GIT_EDITOR="nvim"
export SUDO_EDITOR="nvim"
export TERM="wezterm"
export VISUAL="nvim"

path+=(
    "$HOME"/.local/bin
    /etc/profiles/per-user/"$USER"/bin
    /run/current-system/sw/bin
)

function gh_repo_ref() {
    gh_repo="$1"
    branch="$2"
    git ls-remote "https://github.com/$gh_repo" "$branch" | cut -f1
}
