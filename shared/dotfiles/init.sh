#!/usr/bin/env bash

export EDITOR="nvim"
export GIT_EDITOR="nvim"
export SUDO_EDITOR="nvim"
export VISUAL="nvim"

SYSTEM=$(uname -av|awk '{print $1;}')

if [[ $SYSTEM  == "Linux" ]]; then
    export TERM="kitty"
else
    export TERM="xterm-256color"
fi

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
