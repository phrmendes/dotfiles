#!/usr/bin/env bash

eval "$(micromamba shell hook --shell=zsh)"

export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"

export FLAKE_PATH="$HOME/Projects/bkps/nix#phrmendes"

path+=(
	"$HOME/.local/bin"
	"$HOME/.local/share/coursier/bin"
	"$HOME/.pyenv/shims"
)

nix_update() {
    nix run nixpkgs#home-manager -- switch --flake "$FLAKE_PATH"
}

nix_clear() {
	nix-collect-garbage
}

system_update() {
	sudo nala upgrade
	sudo pop-upgrade recovery upgrade from-release
	sudo fwupdmgr get-devices >/dev/null
	sudo fwupdmgr get-updates
	sudo fwupdmgr update
	flatpak update
}

system_clear() {
	sudo nala autopurge
	sudo nala autoremove
	sudo nala clean
}

enable_droidcam() {
	sudo modprobe v4l2loopback exclusive_caps=1
}

fzf_preview_file() {
	fzf --preview "bat --theme=catppuccin --color=always --style=header,grid --line-range :400 {}"
}

fzf_open_with_nvim() {
	nvim_exists=$(which nvim)
	if [ -z "$nvim_exists" ]; then
		return
	fi

    selection=$(fzf_preview_file)
    if [ -z "$selection" ]; then
        return
    else
        nvim "$selection"
    fi
}

get_repo_ref() {
    git ls-remote "$1" "$2" | cut -f1
}
