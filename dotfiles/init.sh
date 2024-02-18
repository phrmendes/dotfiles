#!/usr/bin/env bash

if [[ $HOST  == "desktop" ]]; then
    path+=("$HOME"/.local/share/coursier/bin)
fi

if [[ $HOST == "SAO-QQ4FN0YXVT" ]]; then
    path+=(
        /opt/homebrew/opt/gnu-sed/libexec/gnubin
        /opt/homebrew/bin
    )
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
