#!/usr/bin/env zsh

function diff-persist() {
    sudo rsync -amvxx --dry-run --no-links --exclude '/tmp/*' --exclude '/root/*' / persist/ | rg -v '^skipping|/$'
}

function oc() {
    GOOGLE_APPLICATION_CREDENTIALS=/run/agenix/claude-service-account.json GOOGLE_CLOUD_PROJECT=rj-ia-desenvolvimento opencode
}

function zz() {
    local sessions_raw=$(zellij list-sessions --no-formatting 2>/dev/null)
    local sessions=()

    while IFS= read -r line; do
        [[ -n "$line" ]] && sessions+=("$line")
    done <<< "$sessions_raw"

    local session_count=${#sessions[@]}

    if [[ $session_count -le 1 ]]; then
        zellij attach --create "default"
    else
        local formatted_sessions=()

        for session in "${sessions[@]}"; do
            local session_name=$(echo "$session" | cut -d' ' -f1)

            if [[ "$session" == *"EXITED"* ]]; then
                formatted_sessions+=("$session_name [󰚌]")
            else
                formatted_sessions+=("$session_name")
            fi
        done

        local selected=$(printf '%s\n' "${formatted_sessions[@]}" | fzf \
            --height=6 \
            --layout=reverse \
            --border=rounded \
            --prompt=" Select session: " \
            --info=inline)

        if [[ -n "$selected" ]]; then
            local session_name=$(echo "$selected" | cut -d' ' -f1)
            zellij attach "$session_name"
        fi
    fi
}
