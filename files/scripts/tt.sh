#!/usr/bin/env bash

set -uo pipefail

declare -A ICONS=(
    [new]="󰐕"
    [default]="󰋜"
    [session]=""
    [attached]="󰌷"
    [search]="󰍉"
    [warn]="󰀨"
    [rename]="󰑕"
    [folder]="󰉋"
    [edit]="󰏫"
)

NEW_SESSION="${ICONS[new]} new session"
DEFAULT_SESSION="${ICONS[default]} default"
SESSION_FMT="${ICONS[session]} #{session_name}#{?session_attached, ${ICONS[attached]},}"
FZF_OPTS=(--layout=reverse --border=rounded)

session_exists() {
    tmux has-session -t "=$1" 2>/dev/null
}

sanitize_name() {
    local name="$1"
    name="${name//[#:.]/_}"
    name="${name#-}"
    echo "${name:-default}"
}

extract_session_name() {
    local line="$1"
    line="${line#"${ICONS[session]} "}"
    line="${line%" ${ICONS[attached]}"}"
    echo "$line"
}

fzf_prompt() {
    local prompt="$1"
    printf '' | fzf "${FZF_OPTS[@]}" \
        --height=3 \
        --prompt="$prompt" \
        --print-query \
        --info=hidden | head -1 || true
}

prompt_session_name() {
    local name
    name=$(sanitize_name "$1")
    while session_exists "$name"; do
        name=$(fzf_prompt "${ICONS[warn]} '$name' exists. New name: ")
        [[ -z "$name" ]] && return 1
        name=$(sanitize_name "$name")
    done
    echo "$name"
}

create_session() {
    local name="$1"
    local dir="${2:-}"
    local dir_args=()
    [[ -n "$dir" ]] && dir_args=(-c "$dir")
    if [[ -n "${TMUX:-}" ]]; then
        tmux new-session -d -s "$name" "${dir_args[@]}"
        tmux switch-client -t "=$name"
    else
        tmux new-session -s "$name" "${dir_args[@]}"
    fi
}

attach_session() {
    local name="$1"
    if [[ -n "${TMUX:-}" ]]; then
        tmux switch-client -t "=$name"
    else
        tmux attach -t "=$name"
    fi
}

new_session_menu() {
    local cwd_name="$1"
    local use_cwd="${ICONS[folder]} use current directory ($cwd_name)"
    local custom_name="${ICONS[edit]} custom name"

    local choice
    choice=$(printf '%s\n' "$use_cwd" "$custom_name" | fzf "${FZF_OPTS[@]}" \
        --height=10 \
        --prompt="${ICONS[new]} " \
        --info=inline) || true

    [[ -z "$choice" ]] && return 1

    local name
    case "$choice" in
        "$use_cwd")
            name=$(prompt_session_name "$cwd_name") || return 1
            create_session "$name" "$PWD"
            ;;
        "$custom_name")
            name=$(fzf_prompt "${ICONS[new]} Session name: ")
            [[ -z "$name" ]] && return 1
            name=$(sanitize_name "$name")
            name=$(prompt_session_name "$name") || return 1
            create_session "$name" "$PWD"
            ;;
    esac
}

if [[ "${1:-}" == "--kill" && -n "${2:-}" ]]; then
    name=$(extract_session_name "$2")
    tmux kill-session -t "=$name" 2>/dev/null || true
    exit 0
fi

if [[ "${1:-}" == "--rename" && -n "${2:-}" ]]; then
    name=$(extract_session_name "$2")
    new_name=$(fzf_prompt "${ICONS[rename]} Rename '$name' to: ")
    if [[ -n "$new_name" ]]; then
        new_name=$(sanitize_name "$new_name")
        tmux rename-session -t "=$name" "$new_name" 2>/dev/null || true
    fi
    exec "$0"
fi

cwd_name=$(sanitize_name "$(basename "${PWD:-default}")")
sessions_raw=$(tmux list-sessions -F "$SESSION_FMT" 2>/dev/null) || true
mapfile -t sessions <<< "$sessions_raw"

if [[ -z "${sessions[0]:-}" ]]; then
    options=("$NEW_SESSION" "$DEFAULT_SESSION")
else
    options=("${sessions[@]}" "$NEW_SESSION")
    session_exists "default" || options+=("$DEFAULT_SESSION")
fi

selected=$(printf '%s\n' "${options[@]}" | fzf "${FZF_OPTS[@]}" \
    --height=10 \
    --prompt="${ICONS[search]} " \
    --info=inline \
    --header="ctrl-d: kill | ctrl-r: rename" \
    --bind="ctrl-d:execute-silent($0 --kill {})+reload(tmux list-sessions -F '$SESSION_FMT' 2>/dev/null; echo '$NEW_SESSION')" \
    --bind="ctrl-r:become($0 --rename {})") || true

[[ -z "$selected" ]] && exit 0

case "$selected" in
    "$NEW_SESSION")
        new_session_menu "$cwd_name"
        ;;
    "$DEFAULT_SESSION")
        name=$(prompt_session_name "default") || exit 0
        create_session "$name"
        ;;
    *)
        attach_session "$(extract_session_name "$selected")"
        ;;
esac
