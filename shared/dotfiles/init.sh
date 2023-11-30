#!/usr/bin/env bash

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
