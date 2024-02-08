#!/usr/bin/env bash

SYSTEM=$(uname -av|awk '{print $1;}')

if [[ $SYSTEM  == "Linux" ]]; then
    export TERM="xterm-kitty"
else
    export TERM="xterm-256color"
    path+=(/opt/homebrew/opt/gnu-sed/libexec/gnubin)
fi

path+=(
    "$HOME"/.local/bin
    "$HOME"/.local/share/coursier/bin
    /etc/profiles/per-user/"$USER"/bin
    /run/current-system/sw/bin
)

function gh_repo_ref() {
    gh_repo="$1"
    branch="$2"
    git ls-remote "https://github.com/$gh_repo" "$branch" | cut -f1
}