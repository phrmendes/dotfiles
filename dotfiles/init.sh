#!/usr/bin/env bash

eval "$(micromamba shell hook --shell=zsh)"

path+=(
	"$HOME"/.local/bin
	"$HOME"/.local/share/coursier/bin
)

function gh_repo_ref() {
	gh_repo="$1"
	branch="$2"
	git ls-remote "https://github.com/$gh_repo" "$branch" | cut -f1
}
