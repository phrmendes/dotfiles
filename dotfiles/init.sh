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

function ta() {
    DIR_BASENAME=$(basename "$PWD")

    if [[ -z $TMUX ]]; then
	tmux new-session -A -s "$DIR_BASENAME"
    else
	tmux new-session -d -s "$DIR_BASENAME"
	tmux switch-client -t "$DIR_BASENAME"
    fi
}

function tf() {
    echo "Local or global configuration? (local/global)"
    read -r CONFIGURATION

    DIR_BASENAME=$(basename "$PWD")
    TMUXP_DIR="$HOME/.config/tmuxp"

    if [[ $CONFIGURATION == "local" ]]; then
	tmuxp freeze -y -f yaml -o .tmuxp.yaml
    else
	tmuxp freeze -y -f yaml -o "$TMUXP_DIR/$DIR_BASENAME.yaml"
    fi
}

function tl() {
    DIR_BASENAME=$(basename "$PWD")
    TMUXP_DIR="$HOME/.config/tmuxp"

    if [[ -e ./.tmuxp.yaml ]]; then
	tmuxp load -a ./.tmuxp.yaml
    elif [[ -e "$TMUXP_DIR/$DIR_BASENAME.yaml" ]]; then
	tmuxp load -a "$DIR_BASENAME"
    else
	tmuxp load -a "$(fd . "$TMUXP_DIR" | fzf --delimiter / \
	    --with-nth -1 \
	    --height 40% \
	    --reverse \
	    --preview "bat --color=always {}" \
	    --bind ctrl-u:preview-up,ctrl-d:preview-down)"
    fi
}

function connect_ssh() {
    HOSTS=$(awk '{print $1}' "$HOME"/.ssh/known_hosts | cut -d ',' -f1 | sort -u)

    SELECTED_HOST=$(printf "%s\n" "${HOSTS[@]}" | fzf --prompt="Select SSH host: " \
	--with-nth -1 \
	--height=40% \
	--reverse \
	--bind ctrl-u:preview-up,ctrl-d:preview-down)

    if [ "$SELECTED_HOST" != "" ]; then
      ssh "$SELECTED_HOST"
    else
      echo "No host selected."
    fi
}
