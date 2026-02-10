#!/usr/bin/env bash

sessions_raw=$(zellij list-sessions --no-formatting 2>/dev/null)
mapfile -t sessions <<< "$sessions_raw"
sessions=("${sessions[@]/#[[:space:]]/}")

if [[ ${#sessions[@]} -le 1 ]]; then
    zellij attach --create "default"
    exit 0
fi

for session in "${sessions[@]}"; do
    name=${session%% *}
    if [[ "$session" == *"EXITED"* ]]; then
        formatted_sessions+=("$name [󰚌]")
    else
        formatted_sessions+=("$name")
    fi
done

selected=$(printf '%s\n' "${formatted_sessions[@]}" | fzf \
    --height=6 \
    --layout=reverse \
    --border=rounded \
    --prompt=" Select session: " \
    --info=inline)

[[ -n "$selected" ]] && zellij attach "${selected%% *}"
